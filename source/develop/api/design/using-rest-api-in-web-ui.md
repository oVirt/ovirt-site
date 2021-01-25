---
title: Using REST API In Web UI
category: api
authors: ecohen, vszocs
---

<!-- TODO: Content review -->

# Using REST API in web UI

## Summary

Replace current GWT RPC mechanism with implementation utilizing oVirt REST API.

## Owner

*   Name: Vojtech Szocs (Vszocs)
*   Email: <vszocs@redhat.com>

## Overview

oVirt web applications (WebAdmin and UserPortal) currently rely on GWT RPC mechanism to communicate with Engine backend. The exact RPC implementation in use, Direct-Eval RPC aka deRPC, [isn't officially supported anymore](http://www.gwtproject.org/doc/latest/DevGuideServerCommunication.html#DevGuideDeRPC); in fact, it never left "experimental" stage and is currently discouraged by GWT team.

Up to now, oVirt web UI used deRPC because it seemed to be the only GWT RPC implementation to fully support the kind of (Java) objects transferred between client and server. We've encountered [problems](http://gerrit.ovirt.org/#/c/19122/) when trying to use [standard GWT RPC implementation](http://www.gwtproject.org/doc/latest/DevGuideServerCommunication.html#DevGuideCreatingServices), some of them occuring at runtime and others occuring during GWT compilation phase.

More generally, oVirt web UI uses GWT RPC mechanism because it allows sharing (Java) business entities and related objects between client and server. While seemingly convenient and easy at first, it led us into situation where client and server are coupled together by means of shared objects. GWT client code and its RPC implementation aim for JavaScript runtime environment (web browser) and therefore impose various restrictions to such shared objects, which in turn hinders the flexibility of Engine backend.

In addition to client/server coupling, the concept of using backend business entities in client code carries additional limitations, such as:

*   cloning existing entity objects on client (manually copying all properties) whenever we need separate entity instance to work with
*   tricking GWT compiler into thinking that all shared code is live (shouldn't be pruned from generated JavaScript output) to avoid deserialization errors on server
*   inability to introduce additional logic into entity objects beyond basic getters/setters and simple operations, considering both client and server perspective

Conceptually, data displayed (or otherwise acted upon) by client is different than data managed by server; each one is used to achieve different goals. For example, from backend perspective, a "Host" business entity might hold data (and possibly additional logic) to represent host machine entity as a whole, cohesive object with well-defined purpose and responsibility. On the other hand, from client perspective, displaying data such as "Host name and number of running VMs on that host" would naturally lead to creating different kinds of entity representations suitable for client to display (or otherwise act upon); reusing existing backend business entities like "Host" or "VM" therefore doesn't seem appropriate from client perspective.

Simply put, client and server each serve different purposes, so the underlying data representations should reflect their purposes as much as possible. Sharing data representations (entities) between client and server restricts both client and server; in our case, server drives entity design and client makes best effort to adapt to that design. This typically leads to problems such as client having to deserialize "heavy" objects just to display a small subset of their data to the user.

*The primary goal* of utilizing [oVirt REST API](/develop/api/rest-api/rest-api.html) in web UI is to decouple client from server while using standard API to communicate with Engine backend. In addition, this should bring following positive side effects:

*   server having full control over backend business entities and related objects, unconstrained and independent from any client
*   client having the freedom to use whatever data representation is suitable, i.e. representation that overlays raw data returned by REST API
*   less shared code means less code for GWT client to compile, improving compile times and reducing generated JavaScript footprint
*   no need for GWT-specific hacks, such as tricking GWT compiler into thinking that all shared code is live
*   not using Java `BackendLocal` interface directly, i.e. abstract away from query/action concept used internally by Engine backend

*The secondary goal* of this effort is to provide implementation utilizing REST API in a way that allows reuse by any JavaScript-based application, be it oVirt web UI, UI plugins or any other web application. This means the REST API will be used by more clients; considering the added potential for change requests driven by client-specific requirements, this should result in overall improvement of REST API itself.

*Note:* due to deRPC "experimental" status, any further GWT SDK upgrade has potential to introduce regressions to deRPC implementation, including semantics of custom field serializers and rules for serializable user-defined types. In oVirt UI, we should therefore consider upgrading GWT SDK only after having a well-defined migration path to REST API.

## Analysis of Java SDK

[oVirt Java SDK](/develop/release-management/features/infra/java-sdk.html) has its code auto-generated from REST API definition. There are two Java modules in [ovirt-engine-sdk-java](git://gerrit.ovirt.org/ovirt-engine-sdk-java) repository:

*   `ovirt-engine-sdk-java-codegen`
    -   fetch local copy of XSD (entities) and RSDL (operations) from running Engine: `mvn validate -Pupdate-metadata`
    -   SDK code generation from XSD and RSDL: `mvn validate -Pupdate-code`
        1.  generate API entities (POJOs with getters and setters) from XSD by running Java `xjc` tool
        2.  generate API entity decorators (subclasses that add behavior) by walking RSDL tree
        3.  generate API entry point providing access to resources and collections accessible from REST API root URL

<!-- -->

*   `ovirt-engine-sdk-java`
    -   target of code generation - files under `src/main/java` are updated each time SDK code is generated
    -   building this module produces the SDK distro (JAR file) and related artifacts (RPM package)

## Design Proposal

Before proceeding any further, we should consider improving the process of gathering REST API definition.

Java SDK currently takes following approach:

*   caching XSD and RSDL that were previously fetched from running Engine, updating these files for given SDK version (for example, after new Engine version is released)
*   Java SDK codegen module performs initial pre-processing (invoking `xjc` tool, parsing RSDL as XML document) before actual code generation takes place

Instead of working with XSD and RSDL directly, there could be some intermediate format serving as REST API definition suitable for consumption by SDK code generators:

*   at Engine build time, XSD and RSDL (full tree) could be generated
*   at Engine build time, single JSON file describing all entities and related operations would be generated from XSD and RSDL
*   SDK generators could simply consume such JSON file as input suitable for (and designed for) code generation

Having such JSON file could simplify maintenance of all SDK code generators:

*   no need for XSD/RSDL processing
*   code generation input in an easy-to-consume format

**oVirt JavaScript SDK** would be an umbrella term for two different projects:

*   [REST API JavaScript Binding](#rest-api-javascript-binding) - part of oVirt Engine repository
*   [oVirt.js](#ovirtjs) - part of oVirt web UI repository (assuming the UI will be decoupled from Engine backend in terms of source repository and related aspects such as build process and z-stream)

### REST API JavaScript Binding

The purpose of this project is to generate JavaScript binding for given Engine version and expose this binding via Engine server, for example:

    http://example:8080/ovirt-engine/files/restapi-js/v1.js

There would be a JavaScript binding per each supported API version, assuming REST API might introduce the notion of multiple API versions for given Engine version. JavaScript binding file(s) would be generated as part of Engine build, producing (optional) RPM package that installs its content under `${ENGINE_USR}/files` directory. This means the user would have to install REST API JavaScript Binding RPM package in order to expose its files via Engine server.

The JavaScript binding would be essentially a low-level SDK targetting specific Engine version / API version permutation. It would contain everything currently offered by existing Java SDK:

*   API entity and collection proxies, represented as JavaScript objects decorated with relevant functionality (i.e. conceptually similar to decorators in Java SDK)
*   SDK entry point providing access to resources and collections accessible from REST API root URL

Proposed technologies and tools for development:

*   Java - integrate with existing Engine build
*   small and fast Java template engine

### oVirt.js

The purpose of this project is to provide standard library (high-level SDK) for working with oVirt Engine in JavaScript runtime environment, i.e. arbitrary web application running in browser. Using oVirt.js would be as simple as adding following code into application's HTML page:

    <script type='text/javascript' src='http://path/to/oVirt.js'></script>

The oVirt.js library would be maintained within the oVirt web UI repository (i.e. alongside WebAdmin and UserPortal) and therefore unrelated to Engine build process. oVirt.js file would be generated as part of web UI build, assuming the build environment meets oVirt.js build time dependencies. Since oVirt.js could be used with any Engine version / API version combination and therefore should be Engine-agnostic, it doesn't necessarily have to ship as RPM package, i.e. the oVirt.js file alone is perfectly usable by web applications. Unlike the [JavaScript Binding](#rest-api-javascript-binding), oVirt.js code would be maintained directly.

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



## Implementation Status

| Phase                                                                                                                  | Task                       | Status |
|------------------------------------------------------------------------------------------------------------------------|----------------------------|--------|
| PoC                                                                                                                    |
| Manually write Data Centers JavaScript SDK, standalone test, GUI integration test                                      | Implementation In Progress |
| Manually write Bookmarks JavaScript SDK, standalone test, GUI integration test                                         |                            |
| Manually write Tags JavaScript SDK, standalone test, GUI integration test                                              |                            |
|                                                                                                                        |
| Infrastructure                                                                                                         |
| Write auto-generated JavaScript binding                                                                                |                            |
| Write high-level JavaScript API (ovirt-engine.js)                                                                      |                            |
| Introduce "hybrid mode" to the application (to allow the GUI to work with the REST API and the legacy API in parallel) |                            |
|                                                                                                                        |
| API Migration                                                                                                          |
| Migrate Bookmarks GUI code to work over REST API (using JavaScript SDK) instead of legacy API                          |                            |
| Migrate Tags GUI code to work over REST API (using JavaScript SDK) instead of legacy API                               |                            |
| ?... [Depends on interdependencies between business entities]                                                          |                            |
