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

Replace current GWT RPC mechanism with implementation utilizing oVirt REST API.

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

*The primary goal* of utilizing [oVirt REST API](REST-Api) in web UI is to decouple client from server while using standard API to communicate with Engine backend. In addition, this should bring following positive side effects:

*   server having full control over backend business entities and related objects, unconstrained and independent from any client
*   client having the freedom to use whatever data representation is suitable, i.e. representation that overlays raw data returned by REST API
*   less shared code means less code for GWT client to compile, improving compile times and reducing generated JavaScript footprint
*   no need for GWT-specific hacks, such as tricking GWT compiler into thinking that all shared code is live
*   not using Java `BackendLocal` interface directly, i.e. abstract away from query/action concept used internally by Engine backend

*The secondary goal* of this effort is to provide implementation utilizing REST API in a way that allows reuse by any JavaScript-based application, be it oVirt web UI, [UI plugins](Features/UIPlugins) or any other web application. This means the REST API will be used by more clients; considering the added potential for change requests driven by client-specific requirements, this should result in overall improvement of REST API itself.

*Note:* due to deRPC "experimental" status, any further GWT SDK upgrade has potential to introduce regressions to deRPC implementation, including semantics of custom field serializers and rules for serializable user-defined types. In oVirt UI, we should therefore consider upgrading GWT SDK only after having a well-defined migration path to REST API.

### Analysis of Java SDK

[oVirt Java SDK](Java-sdk) maintained by [Michael Pasternak](mailto:mpastern@redhat.com) has its code auto-generated from REST API definition. There are two Java modules in [ovirt-engine-sdk-java](git://gerrit.ovirt.org/ovirt-engine-sdk-java) repository:

*   `ovirt-engine-sdk-java-codegen` - responsible for generating:
    -   API entities from XSD schema
        1.  fetch XSD schema from **running Engine** via HTTP (`/api/?schema`) and persist it into local file
        2.  invoke Java `xjc` tool to generate source files into `ovirt-engine-sdk-java` module's `src/main/java` directory (package `org.ovirt.engine.sdk.entities`)
    -   decorators for API entities and entity collections from [RSDL](http://en.wikipedia.org/wiki/RSDL) definition
        1.  fetch RSDL definition from **running Engine** via HTTP (`/api/?rsdl`) and unmarshal it into `RSDL` class (which is part of XSD schema)
        2.  walk through RSDL definition by iterating over its `DetailedLink` instances, generating decorator per each resource and collection
    -   SDK entry point (`Api` class) providing access to resources and collections accessible from REST API root URL

<!-- -->

*   `ovirt-engine-sdk-java` - target of code generation:
    -   everything under `src/main/java` is cleaned and re-created as part of `ovirt-engine-sdk-java-codegen` build
    -   building this module produces the SDK distro (JAR file) and related artifacts (RPM package)

### Design Proposal

Before proceeding any further, we should consider improving the process for gathering REST API definition:

*   building [Java SDK](#Analysis_of_Java_SDK) requires running Engine, this isn't optimal from build automation perspective
*   complete REST API definition reflecting the state of API for given Engine version (including possibly multiple API versions) can be generated in a standard format during the Engine build
*   Java SDK could use the generated REST API definition as input for code generation, instead of using running Engine (up to Java SDK maintainers to consider)
*   any other SDK could use the generated REST API definition as input for code generation

Simply put, the API resolution logic currently implemented in Java SDK (i.e. taking XSD schema and RSDL definition to produce input for subsequent code generation) should be standardized and implemented as part of the Engine build. This will ease the maintenance of all SDKs and allow SDK authors to focus on code generation itself.

**oVirt JavaScript SDK** would be an umbrella term for two different projects:

*   [REST API JavaScript Binding](#REST_API_JavaScript_Binding) - part of oVirt Engine repository
*   [oVirt.js](#oVirt.js) - part of oVirt web UI repository (assuming the UI will be decoupled from Engine backend in terms of source repository and related aspects such as build process and z-stream)

#### REST API JavaScript Binding

The purpose of this project is to generate JavaScript binding for given Engine version and expose this binding via Engine server, for example:

    http://example:8080/ovirt-engine/files/restapi-js/v1.js

There would be a JavaScript binding per each supported API version, assuming REST API might introduce the notion of multiple API versions for given Engine version. JavaScript binding file(s) would be generated as part of Engine build, producing (optional) RPM package that installs its content under `${ENGINE_USR}/files` directory. This means the user would have to install REST API JavaScript Binding RPM package in order to expose its files via Engine server.

The JavaScript binding would be essentially a low-level SDK targetting specific Engine version / API version permutation. It would contain everything currently offered by existing Java SDK:

*   API entity and collection proxies, represented as JavaScript objects decorated with relevant functionality (i.e. conceptually similar to decorators in Java SDK)
*   SDK entry point providing access to resources and collections accessible from REST API root URL

Proposed technologies and tools for development:

*   Java - integrate with existing Engine build
*   small and fast Java template engine

#### oVirt.js

The purpose of this project is to provide standard library (high-level SDK) for working with oVirt Engine in JavaScript runtime environment, i.e. arbitrary web application running in browser. Using oVirt.js would be as simple as adding following code into application's HTML page:

    <script type='text/javascript' src='http://path/to/oVirt.js'></script>

The oVirt.js library would be maintained within the oVirt web UI repository (i.e. alongside WebAdmin and UserPortal) and therefore unrelated to Engine build process. oVirt.js file would be generated as part of web UI build, assuming the build environment meets oVirt.js build time dependencies. Since oVirt.js could be used with any Engine version / API version combination and therefore should be Engine-agnostic, it doesn't necessarily have to ship as RPM package, i.e. the oVirt.js file alone is perfectly usable by web applications. Unlike the [JavaScript Binding](#REST_API_JavaScript_Binding), oVirt.js code would be maintained directly.

Core functionality offered by oVirt.js would include:

*   *JavaScript Binding bootstrap mechanism* - given the URL of running Engine and preferred API version, detect and load appropriate JavaScript Binding
*   *common and useful functionality on top of JavaScript Binding* - including any workarounds or functionality desired but not supported by REST API
*   *dynamic API error detection* - detect errors when delegating calls to JavaScript Binding and report them to client (i.e. client attempts to use operation or entity that's not supported by given Engine version / API version combination)

For web UI that relies on Java / GWT technology, this would imply following changes:

*   from Java build perspective, oVirt.js would be packaged as JAR file managed via Maven dependency mechanism
*   before GWT compilation phase, oVirt.js would be extracted into application's resources, i.e. `target/generated-gwt/webadmin/oVirt.js`
*   oVirt.js would be declared as external JavaScript in [GWT module descriptor](http://www.gwtproject.org/doc/latest/DevGuideOrganizingProjects.html#DevGuideModuleXml), i.e. `<script src='oVirt.js' />`
*   GWT code would contain [JSNI](http://www.gwtproject.org/doc/latest/DevGuideCodingBasicsJSNI.html) bindings to oVirt.js which are subject to code analysis during GWT compilation

As for backward compatibility, oVirt.js would just delegate to specific JavaScript Binding and report any errors back to client. The client is therefore responsible for using oVirt.js together with appropriate Engine version / API version combination. This is similar to using Java SDK, with oVirt.js acting as library with useful functionality above the "bare minimum" SDK.

Proposed technologies and tools for development:

*   [Node.js](http://nodejs.org/) platform to invoke tools suitable for JavaScript development:
    -   [Grunt](http://gruntjs.com/) to automate task execution, such as running tests and producing output JavaScript
    -   [Karma](http://karma-runner.github.io/) to establish productive testing environment where a code change yields instant feedback
    -   [UglifyJS](http://lisperator.net/uglifyjs/) to optimize and minify output JavaScript
    -   [JSDoc](https://github.com/jsdoc3/jsdoc) to generate SDK API documentation from source code
*   *Source Option A* - CoffeeScript
    -   [CoffeeScript](http://coffeescript.org/) to avoid intricacies of JavaScript language (CoffeeScript compiles to JavaScript)
    -   [CoffeeLint](http://www.coffeelint.org/) to detect problems and enforce common code conventions
*   *Source Option B* - vanilla JavaScript
    -   [JSHint](http://www.jshint.com/) to detect problems and enforce common code conventions

### Comments and discussion

*   Refer to [design discussion page](Talk:Features/Design/Using_REST_API_In_Web_UI).
