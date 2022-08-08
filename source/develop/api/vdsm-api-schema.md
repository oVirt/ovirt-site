---
title: Vdsm API Schema
category: api
authors: aglitke
---

# Vdsm API Schema

I recently took on the large task of fully describing the vdsm API in a schema language.
I used the QAPI schema format that is currently used by Qemu. This schema allows us to do some pretty cool things.

* Produce an API document with full cross-referenced type information
* Automatically generate source code that can be built into libvdsm (C bindings for the official API)
* Formalize the API

Here is a sample of the API documentation we can produce from the schema <https://github.com/oVirt/vdsm/releases/download/v4.50.1.1/vdsm-api.html>
