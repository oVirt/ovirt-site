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

### Project Repository

<https://github.com/matobet/doctor-rest>

### Engine Patches

<https://gerrit.ovirt.org/#/c/45740/>

<https://gerrit.ovirt.org/#/c/45233/>

### Owner

*   Name: [ Martin Betak](User:Mbetak)
*   Email: <mbetak@redhat.com>
