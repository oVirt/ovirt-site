---
title: libvdsm
category: vdsm
authors: aglitke
wiki_category: Feature
wiki_title: Features/libvdsm
wiki_revision_count: 2
wiki_last_updated: 2012-10-25
---

# libvdsm (preview)

### Summary

libvdsm is the next-generation vdsm API. All available commands and data types are defined by a schema. The API is remotely accessible via Json-RPC. A C library provides native support for clients written in C. Python bindings are available through gobject-introspection.

### Owner

*   Name: [ Adam Litke](User:Aglitke)

<!-- -->

*   Email: <agl@us.ibm.com>

### Current status

*   Patches awaiting review on gerrit: <http://gerrit.ovirt.org/#/q/status:open+project:vdsm+branch:master+topic:libvdsm,n,z>
*   Last updated date: Oct 25, 2012

### Detailed Description

### Benefit to oVirt

Libvdsm aims to stabilize the current vdsm API so that it can evolve in an orderly and backwards-compatible manner. This is important because: we would like to expose the API for use by entities other than oVirt-engine, create out of tree vdsm connectors (Rest API, AMQP broker, etc), enable third-party access to the node-level API (for vendor plugins, etc), and have the ability to use vdsm in a standalone configuration. Libvdsm benefits ovirt-engine as well because it formalizes the API and makes it easier to write against.

### Dependencies / Related Features

None

### Documentation / External references

The patch commit messages contain a lot of useful information on the design.

<http://gerrit.ovirt.org/#/q/status:open+project:vdsm+branch:master+topic:libvdsm,n,z>

### Comments and Discussion

*   Refer to <Talk:Features/libvdsm>

<Category:Feature>
