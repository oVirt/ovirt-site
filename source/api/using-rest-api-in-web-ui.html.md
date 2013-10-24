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

oVirt web applications (i.e. WebAdmin and UserPortal) currently rely on GWT RPC mechanism to invoke operations and communicate with Engine backend. The exact RPC implementation in use, Direct-Eval RPC aka deRPC, [isn't officially supported anymore](http://www.gwtproject.org/doc/latest/DevGuideServerCommunication.html#DevGuideDeRPC); in fact, it never left "experimental" stage and is currently discouraged by GWT team.

Up to now, oVirt web UI used deRPC because it seemed to be the only GWT RPC implementation to fully support the kind of (Java) objects transferred between client and server. We've encountered [problems](http://gerrit.ovirt.org/#/c/19122/) when trying to use [standard GWT RPC implementation](http://www.gwtproject.org/doc/latest/DevGuideServerCommunication.html#DevGuideCreatingServices), some of them occuring at runtime and others occuring during GWT compilation phase.

More generally, oVirt web UI used GWT RPC mechanism because it allowed sharing same (Java) business entities and related objects between client and server. While seemingly convenient and easy at first, it led us into situation where client and server are coupled together by means of shared objects. GWT client code and its RPC implementation aim for JavaScript runtime environment (i.e. web browser) and therefore impose various restrictions to such shared objects, which in turn hinders the flexibility of Engine backend.

In addition to client/server coupling, the concept of using backend business entities in client code carries additional limitations, such as:

*   cloning existing entity objects on client (manually copying all properties) whenever we need separate entity instance to work with
*   tricking GWT compiler into thinking that all shared code is live (i.e. shouldn't be pruned from generated JavaScript output) to avoid deserialization errors on server
*   inability to introduce additional logic into entity objects beyond basic getters/setters and simple operations, considering both client and server perspective

Conceptually, data displayed (or otherwise acted upon) by client is different than data managed by server; each one is used to achieve different goals. For example, from backend perspective, a "Host" business entity might hold data (and possibly additional logic) to represent host machine entity as a whole, cohesive object with well-defined purpose and responsibility. On the other hand, from client perspective, displaying data such as "Host name and number of running VMs on that host" would naturally lead to creating different kinds of entity representations suitable for client to display (or otherwise act upon); reusing backend business entities like "Host" or "VM" therefore doesn't seem appropriate from client perspective.

Simply put, client and server each serve different purposes, so the underlying data representations should reflect their purposes as much as possible. Sharing data representations (entities) between client and server restricts both client and server; in our case, server drives entity design and client makes best effort to adapt to that design. This typically leads to problems such as client requesting data updates and having to deserialize "heavy" objects just to display a small subset of received data to the user.

The primary goal of utilizing [Engine REST API](REST-Api) in oVirt web UI is to decouple client from server while reusing standard API to invoke operations and communicate with Engine backend. In addition, this should bring following positive side effects:

*   server having full control over backend business entities and related objects, unconstrained and independent from any client
*   client having the freedom to use whatever data representation is suitable, i.e. representation that overlays raw data returned by Engine REST API
*   less shared code means less code for GWT client to compile, improving compile times and reducing generated JavaScript footprint
*   no need for GWT-specific hacks, such as tricking GWT compiler into thinking that all shared code is live
*   not using Java `BackendLocal` interface directly, i.e. abstract away from query/action concept used internally by Engine backend

The secondary goal of this effort is to provide implementation utilizing Engine REST API in a way that allows reuse by any JavaScript-based web application, be it oVirt web UI, [[Features/UIPlugins|UI plugins] or any other application.

### Design Proposal

Engine REST API is described by `rsdl_metadata.yaml` (RESTful operations) and `api.xsd` (resource types) within `restapi-definition` module.

**Engine JavaScript SDK** would be a separate module containing JavaScript code to interact with Engine REST API. To keep JavaScript SDK in sync with REST API, code inside this module would be auto-generated as part of Engine build process. JavaScript SDK file(s) would be served through Engine server itself, i.e. accessible via HTTP protocol. Using JavaScript SDK in a web application would be as simple as adding following code into its HTML page:

    <script type='text/javascript' src='http://engine-server/ovirt-engine/engine-sdk.js'></script>

Placing the `script` element in HTML `head` section and actual code utilizing JavaScript SDK in HTML `body` section would always ensure that SDK gets loaded before invoking actual code.

**TODO finalize design proposal**

*   using DDD approach - JS objects that overlay resource representations and provide methods to work with them
*   consume JSON if possible, otherwise need to add XML to/from JSON mapping layer into SDK

### Comments and discussion

*   Refer to [design discussion page](Talk:Features/Design/Using_REST_API_In_Web_UI).
