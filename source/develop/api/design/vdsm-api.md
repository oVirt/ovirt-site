---
title: Vdsm API
category: api
authors:
  - aglitke
  - danken
---

<!-- TODO: Content review -->

# Vdsm API

The current xmlrpc-based VDSM API needs to be redesigned to accommodate some new use cases. We need a fully-functional and well organized host-level API and an improved mechanism for communicating with ovirt-engine and other vdsm hosts in an ovirt cluster. This document describes the design that the project has decided to implement along with a development plan.

## Design

Any acceptable design must meet the following requirements:

*   Full featured host level API. All vdsm features must be available for consumption.
*   Must support a connection to a message bus architecture (ie. QMF) for cluster-level management.
*   The vdsm API must not be forked between the ovirt-engine and host-only use cases.

Key design points:

*   The API bridge provides the complete set of exported vdsm functionality. Both bindings (QMF and REST) can be written solely by importing the vdsm API Bridge. Direct use of vdsm internals will be prohibited.
*   VDSM will implement a publish/subscribe model for events and provide an API via the bridge.
*   The QMF agent and REST API are implemented as bindings to the API bridge
*   The current xmlrpc interface will be converted to the API bridge, too. It is expected to be deprecated when ovirt-engine uses QMF.
*   No business logic will be implemented in the QMF agent or REST API
*   Both QMF and REST are optional components (ie. they are not required for vdsm to function correctly). However at least one of these is needed to enable management.

![](/images/wiki/Vdsm-api-architecture.png)

## Development plan

*   Create the API Bridge as a python module that the REST API, QMF agent, and xmlrpc interface threads can import
*   Convert clientIF.py not to start a xmlrpc server. Have a different module expose xmlrpc functionality using the API Bridge.
*   Integrate Adam's cherryPy-based REST server into vdsm via the API Bridge
*   Write a vdsmsh tool that provides a host-level command line interface to vdsm via the REST API
*   Create a QMF agent that also integrates via the API Bridge
*   Change ovirt-engine to interact with vdsm via QMF

