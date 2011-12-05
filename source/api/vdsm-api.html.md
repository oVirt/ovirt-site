---
title: Vdsm API
category: api
authors: aglitke, danken
wiki_category: Vdsm
wiki_title: Vdsm API
wiki_revision_count: 11
wiki_last_updated: 2011-12-06
---

# Vdsm API

The current xmlrpc-based VDSM API needs to be redesigned to accommodate some new use cases. We need a fully-functional and well organized host-level API and an improved mechanism for communicating with ovirt-engine and other vdsm hosts in an ovirt cluster. This document describes the design that the project has decided to implement along with a development plan.

## Design

Any acceptable design must meet the following requirements:

*   Full featured host level API. All vdsm features must be available for consumption.
*   Must support a connection to a message bus architecture (ie. QMF) for cluster-level management.
*   The vdsm API must not be forked between the ovirt-engine and host-only use cases.

Key design points:

*   The API bridge provides the complete set of exported vdsm functionality. Both bindings (QMF and REST) can be written solely by importing the vdsm API Bridge. Direct use of vdsm internals will be prohibited.
*   The QMF agent and REST API are implemented as bindings to the API bridge
*   The xmlrpc interface will be deprecated and may or may not be converted to the API bridge.
*   No business logic will be implemented in the QMF agent or REST API
*   Both QMF and REST are optional components (ie. they are not required for vdsm to function correctly). However at least one of these is needed to enable management.

![](Vdsm-api-architecture.png‎ "Vdsm-api-architecture.png‎")

<Category:Vdsm>
