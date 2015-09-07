---
title: Doctor REST
authors: mbetak
wiki_title: Features/Doctor REST
wiki_revision_count: 15
wiki_last_updated: 2015-09-07
---

# Doctor REST

## DOCumenT ORiented REST

### Motivation

During the implementation of [Project moVirt](Project moVirt), a client frontend communicating with the oVirt engine purely via REST-API, many shortcomings of this approach surfaced.

Namely:

*   Need for periodic polling: absence of any push notifications (especially bad for monitoring clients whose main purpose is to display current dashboard-like overview of the system.)
*   Even when polling need to issue excessive amounts of HTTP requests, (list of entities and then have to individually query each entity's sub-resources).
*   Very limited and ad-hoc support for data-aggregation (just VMs' statistics/disks/nics and Hosts' statistics)
*   No support for finer grained selection of data client is actually interested in - always have to fetch full VM entitties only when we are actually interested in a few of the fields.

To address the above shortcomings, and improve user experience for our mobile users and of our future frontend, [Doctor REST](https://github.com/matobet/doctor-rest) was created to solve the above concerns in a generic way that is agnostic of any specific data-format or backend architecture so it can be used by anyone who wishes to add Doctor's capabilities to their project.

### Architecture

#### High level overview

On the highest level, Doctor is a separate (micro-)service whose sole purpose is to facilitate optimized (aggregated/filtered/sorted/paginated) **reads** and provide **push** notifications to connected clients.

Doctor contains no business logic on its own. It purely **reactive** in the sense that it relies on external service (or multiple services) to push data into it (in our case that would be oVirt engine) which is then processed as generic JSON documents, so often schema changes pose no problems for Doctor REST. In addition this separation of services can provide useful for largely geographically distributed setups where we can have multiple Doctors in various areas (Brno, Tel-Aviv, ...) to help reduce the percieved end-user latency.

![](Doctor_REST_High_Level.jpg "Doctor_REST_High_Level.jpg")

#### Internal Structure

Initially, Doctor REST started as a push server that would internally poll the engine periodically via REST API, diff the polled data against last cached values and broadcast necessary notifications. Motivation was to replace *many* periodically polling clients with just *one* . This approach was quickly abandoned however, since this required logic at Doctor's side, tight coupling to the data format and would lock us to approach that would still be based on polling.

The key idea was to fully **invert** the data flow. Doctor would essentially do nothing and wait for data to be pushed at it by a privileged entity (oVirt backend, or any number of disparate services with given privilege) - identified as *connector* in [Doctor REST's documentation](https://github.com/matobet/doctor-rest).

The incoming data can come in multiple forms: full dump of entities, individual CRUD operations on entities or partial delta updates of particular entities. In all cases Doctor performs **diff** on incoming JSON documents with last cached value and broadcasts changes only when the data has actually changed. This allows the *connectors* to quickly start by naive periodic dumps of data towards Doctor and gradually transition towards finer grained per-entity event-driven updates (will be especially useful as VDSM events become more prevalent). From Doctor's perspective this transition will be seamless.

Having successfully implemented push notifications, and having a cached copy of all data (necessary for the automatic diffing), we added a simple query language on top of this data and implemented data aggregation, projections, filtering, pagination, sorting, .etc in fully generic way. With these two features combined the clients can listen for changes of entities that interest them, and in reaction to this, they can fetch exactly what has changed (with arbitrary aggregations) in a single HTTP request.

Having the data cached in document-oriented NoSQL store, Doctor is expected to scale to large number of concurrent **reads**; and as more clients choose it as its frontend proxy, more and more load being taken away from the backend PostgreSQL database, thus having increasingly positive impact on the overall system.

![](Doctor_REST_Internals.jpg "Doctor_REST_Internals.jpg")

#### Used Technologies

Internally, Doctor is using the [MongoDB](https://www.mongodb.org/) NoSQL database to cache provided data and the [MQTT protocol](http://mqtt.org/) to notify subscribed clients of changed entities.

MongoDB was chosen thanks to its performance and excellent query capabilities (almost all operations - except aggregations - map natively to MongoDB query primitives). MongoDB has also a wide community and is perhaps the most popular document-oriented NoSQL technology.

When choosing the protocol for push notifications, we wanted it to be consumable from mobile clients (Android/iOS) and also from browser clients. We also wanted a simple and data-efficient protocol (as mobile data can be very expensive) that would support topic based publish/subscribe whereby client could subscribe only on entities it is interested in.

All of those requirements were successfully met by the MQTT protocol. This "Internet-of-Things" messaging protocol provides extremely small per-message overhead (compact binary messages) and has [bindings](http://www.eclipse.org/paho/) for many platforms - including Android and the browser.

### Required Engine Integration

### Project Repository

<https://github.com/matobet/doctor-rest>

### Engine Patches

<https://gerrit.ovirt.org/#/c/45740/>

<https://gerrit.ovirt.org/#/c/45233/>

### Owner

*   Name: [ Martin Betak](User:Mbetak)
*   Email: <mbetak@redhat.com>
