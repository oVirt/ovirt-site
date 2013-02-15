---
title: Spice Proxy
category: feature
authors: tjelinek
wiki_category: Feature
wiki_title: Features/Spice Proxy
wiki_revision_count: 12
wiki_last_updated: 2014-01-30
---

# SPICE Proxy

### Summary

Let the users define a proxy which will be used by spice to connect to the guest.

### Detailed Description

Currently, the only possibility to define a SPICE proxy is using the engine-config tool globally for the whole application. Example:

      engine-config -s SpiceProxy=someProxy
       

The proxy has to follow the following form: [protocol://]<host>[:port]

The proxy string may be specified with a protocol:// prefix to specify alternative proxy protocols. If no protocol is specified in the proxy string or if the string doesn't match a supported one, the proxy will be treated as a HTTP proxy.

To turn the proxy off, just clear it:

      engine-config -s SpiceProxy=""
       

If the proxy is set, it will be filled into the Proxy property of the SPICE client by WebAdmin/UserPortal. If the proxy is not set, nothing is filled into this property.

<Category:Feature> <Category:SPICE>
