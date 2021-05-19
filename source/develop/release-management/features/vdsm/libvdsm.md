---
title: libvdsm
category: feature
authors: aglitke
---

# libvdsm (preview)

## Summary

libvdsm is the next-generation vdsm API. All available commands and data types are defined by a schema. The API is remotely accessible via Json-RPC. A C library provides native support for clients written in C. Python bindings are available through gobject-introspection.

## Owner

*   Name: Adam Litke (Aglitke)

<!-- -->

*   Email: <alitke@redhat.com>

## Current status

*   Patches awaiting review on gerrit: <http://gerrit.ovirt.org/#/q/status:open+project:vdsm+branch:master+topic:libvdsm,n,z>
*   Last updated date: Oct 25, 2012

## Detailed Description

Libvdsm can be broken into three rough pieces:

Schema: The schema defines all data types, functions, and return values. Today, the schema resembles the old API but we intend to evolve the API over time to correct problems.

Server: The API is served by Json-RPC server threads running in vdsmd. Incoming requests are validated against the schema and dispatched to the relavent internal vdsm functions. Results are returned according to the schema. The protocol is intended to be supported and can be used directly by clients without fear of compatibility breakage.

Client(s): Client libraries can be automatically generated from the schema. The current patches generate a C library based on GObjects. This library has Python bindings courtesy of gobject-introspection. In the future, we plan to generate a native Java jar. Additionally, the Json-RPC protocol itself is a supported interface so anyone can write a client directly against the protocol if they wish.

## Benefit to oVirt

Libvdsm aims to stabilize the current vdsm API so that it can evolve in an orderly and backwards-compatible manner. This is important because: we would like to expose the API for use by entities other than oVirt-engine, create out of tree vdsm connectors (Rest API, AMQP broker, etc), enable third-party access to the node-level API (for vendor plugins, etc), and have the ability to use vdsm in a standalone configuration. Libvdsm benefits ovirt-engine as well because it formalizes the API and makes it easier to write against.

## Dependencies / Related Features

None

## Documentation / External references

The patch commit messages contain a lot of useful information on the design.

<http://gerrit.ovirt.org/#/q/status:open+project:vdsm+branch:master+topic:libvdsm,n,z>



