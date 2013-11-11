---
title: Using REST API In Web UI
category: api
authors: ecohen, vszocs
wiki_title: Features/Design/Using REST API In Web UI
wiki_revision_count: 11
wiki_last_updated: 2014-05-15
---

# Using REST API in web UI

### Summary

Replace current GWT RPC mechanism with implementation utilizing Engine REST API.

### Owner

*   Name: [Vojtech Szocs](User:Vszocs)
*   Email: <vszocs@redhat.com>

### Overview

oVirt web applications (i.e. WebAdmin and UserPortal) currently rely on GWT RPC mechanism to communicate with Engine backend. The exact RPC implementation in use, Direct-Eval RPC aka deRPC, [isn't officially supported anymore](http://www.gwtproject.org/doc/latest/DevGuideServerCommunication.html#DevGuideDeRPC); in fact, it never left "experimental" stage and is currently discouraged by GWT team.

Up to now, oVirt web UI used deRPC because it seemed to be the only GWT RPC implementation to fully support the kind of (Java) objects transferred between client and server. We've encountered [problems](http://gerrit.ovirt.org/#/c/19122/) when trying to use [standard GWT RPC implementation](http://www.gwtproject.org/doc/latest/DevGuideServerCommunication.html#DevGuideCreatingServices), some of them occuring at runtime and others occuring during GWT compilation phase.

More generally, oVirt web UI uses GWT RPC mechanism because it allows sharing (Java) business entities and related objects between client and server. While seemingly convenient and easy at first, it led us into situation where client and server are coupled together by means of shared objects. GWT client code and its RPC implementation aim for JavaScript runtime environment (i.e. web browser) and therefore impose various restrictions to such shared objects, which in turn hinders the flexibility of Engine backend.

In addition to client/server coupling, the concept of using backend business entities in client code carries additional limitations, such as:

*   cloning existing entity objects on client (manually copying all properties) whenever we need separate entity instance to work with
*   tricking GWT compiler into thinking that all shared code is live (i.e. shouldn't be pruned from generated JavaScript output) to avoid deserialization errors on server
*   inability to introduce additional logic into entity objects beyond basic getters/setters and simple operations, considering both client and server perspective

Conceptually, data displayed (or otherwise acted upon) by client is different than data managed by server; each one is used to achieve different goals. For example, from backend perspective, a "Host" business entity might hold data (and possibly additional logic) to represent host machine entity as a whole, cohesive object with well-defined purpose and responsibility. On the other hand, from client perspective, displaying data such as "Host name and number of running VMs on that host" would naturally lead to creating different kinds of entity representations suitable for client to display (or otherwise act upon); reusing backend business entities like "Host" or "VM" therefore doesn't seem appropriate from client perspective.

Simply put, client and server each serve different purposes, so the underlying data representations should reflect their purposes as much as possible. Sharing data representations (entities) between client and server restricts both client and server; in our case, server drives entity design and client makes best effort to adapt to that design. This typically leads to problems such as client requesting data updates and having to deserialize "heavy" objects just to display a small subset of received data to the user.

*The primary goal* of utilizing [Engine REST API](REST-Api) in oVirt web UI is to decouple client from server while using standard API to communicate with Engine backend. In addition, this should bring following positive side effects:

*   server having full control over backend business entities and related objects, unconstrained and independent from any client
*   client having the freedom to use whatever data representation is suitable, i.e. representation that overlays raw data returned by REST API
*   less shared code means less code for GWT client to compile, improving compile times and reducing generated JavaScript footprint
*   no need for GWT-specific hacks, such as tricking GWT compiler into thinking that all shared code is live
*   not using Java `BackendLocal` interface directly, i.e. abstract away from query/action concept used internally by Engine backend

*The secondary goal* of this effort is to provide implementation utilizing REST API in a way that allows reuse by any JavaScript-based application, be it oVirt web UI, [UI plugins](Features/UIPlugins) or any other web application. This means the REST API will be used by more clients; considering the added potential for change requests driven by client-specific requirements, this should result in overall improvement of REST API itself.

*Note:* due to deRPC "experimental" status, any further GWT SDK upgrade has potential to introduce regressions to deRPC implementation, including semantics of custom field serializers and rules for serializable user-defined types. In oVirt UI, we should therefore consider upgrading GWT SDK only after having a well-defined migration path to REST API.

### Design Proposal

Engine REST API is described by `api.xsd` (resource types) and `rsdl_metadata.yaml` (RESTful operations) within the `restapi-definition` module.

**Engine JavaScript SDK** would be a new module containing JavaScript code to interact with REST API. As we plan to separate oVirt web UI from Engine backend in terms of source repository and related aspects (i.e. build process and z-stream), the JavaScript SDK would be managed within the oVirt web UI source repository. In terms of packaging, oVirt web UI `rpm` would have dependency to JavaScript SDK `rpm`, i.e. JavaScript SDK must be installed in order to be used by web applications. Serving JavaScript SDK files via HTTP protocol can be implemented in different ways, one of them is to deploy JavaScript SDK as a separate web application to Engine backend, alongside oVirt web applications.

#### SDK Requirements

*   **simplicity** - above anything else
*   **meaningful conventions** - because things shouldn't be complicated too far beyond their [essential complexity](http://en.wikipedia.org/wiki/Essential_complexity)
*   **backward compatibility** - because SDK should work with older REST API versions too
*   **testability** - employ consistent unit/behavior test convention (excluding any generated parts)
*   **extensibility** - because SDK should evolve and improve over time

#### SDK Structure

JavaScript SDK would consist of two API layers:

*   **low-level API**
    -   essentially a native (JavaScript) binding to REST API in terms of resource types (objects) and RESTful operations (functions)
    -   there would be a namespace per each supported REST API version, i.e. "complete" namespace for lowest version and "delta" namespaces for higher versions
    -   code *could* be generated at build time from REST API descriptor files
    -   code *should* be validated at build time against REST API descriptor files, i.e. make sure the low-level binding reflects supported REST API versions

<!-- -->

*   **high-level API**
    -   uses low-level API in a more abstract way suitable for clients to consume
    -   implements automatic REST API version detection in order to use appropriate low-level API namespace
    -   place for adding common and useful functionality to work with REST API, i.e. logical operations possibly spanning multiple physical REST API requests
    -   place for manual workarounds and any functionality desired but not supported by REST API
    -   code maintained manually
    -   code *should* be validated at build time to detect potential errors

JavaScript SDK would support the notion of backward compatibility with regard to version provided by REST API. In practice, this would mean:

*   SDK version `X` + Engine version `X+1` → rely on backward compatibility of REST API
*   SDK version `X` + Engine version `X-1` → use appropriate low-level API namespace mapping to older REST API version

In both cases mentioned above, web applications using JavaScript SDK should still work.

#### SDK Technology Proposal

Utilize [Node.js](http://nodejs.org/) platform to invoke tools suitable for JavaScript development:

*   **Common Tools**
    -   [Grunt](http://gruntjs.com/) to automate task execution, such as running tests and producing output JavaScript
    -   [Karma](http://karma-runner.github.io/) to establish productive testing environment where a code change yields instant feedback
    -   [UglifyJS](http://lisperator.net/uglifyjs/) to optimize and minify output JavaScript
    -   [JSDoc](https://github.com/jsdoc3/jsdoc) to generate SDK API documentation from source code

<!-- -->

*   **Source Option A** - CoffeeScript
    -   [CoffeeScript](http://coffeescript.org/) to avoid intricacies of JavaScript language (CoffeeScript compiles to JavaScript)
    -   [CoffeeLint](http://www.coffeelint.org/) to detect problems and enforce common code conventions

<!-- -->

*   **Source Option B** - vanilla JavaScript
    -   [JSHint](http://www.jshint.com/) to detect problems and enforce common code conventions

#### Client Consumption

Using JavaScript SDK in web applications would be as simple as adding following code into application's HTML page:

    <script type='text/javascript' src='http://path/to/sdk.js'></script>

Placing the `script` element in HTML `head` and code utilizing the SDK in HTML `body` ensures the SDK gets loaded before use by client code.

### Comments and discussion

*   Refer to [design discussion page](Talk:Features/Design/Using_REST_API_In_Web_UI).
