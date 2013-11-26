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

Let the users define a proxy which will be used by SPICE client to connect to the guest. It is useful when the user (e.g. using user portal) is outside of the network where the hypervisors are.

### Detailed Description

There are three places where to set the SPICE proxy up:

*   Global Configuration
*   Cluster (overrides the global configuration)
*   VM Pool (overrides global configuration and cluster configuration)
*   Disabling any config per VM

#### Global Configuration

The engine-config tool is used to globally configure the SPICE proxy for the whole application. Example:

      engine-config -s SpiceProxyDefault=someProxy
       

To turn the proxy off, just clear it:

      engine-config -s SpiceProxyDefault=""
       

If the proxy is set, it will be by default filled into the Proxy property of the SPICE client by WebAdmin/UserPortal. If the proxy is not set, nothing is filled into this property.

#### Cluster

The global configuration can be overridden on cluster level. In webadmin in the newly introduced Console side tab in new/edit cluster dialog. In REST the "clusters" has been enriched by a new property "spice_proxy". If the spice proxy is set in the cluster level, all VMs in this cluster will use this proxy (if not disabled for specific VM).

#### VM Pool

The global or cluster configuration can be overridden in the VM Pool level. In webadmin in the new/edit pool dialog in the Console side tab (in advanced mode). In REST the "vmpools" has been enriched by a new property "spice_proxy".

#### Disabling any config per VM

In User Portal/Web Admin SPICE proxy can be disabled / enabled per VM using the console options popup dialog and this setting will be stored in the local storage (or cookie). The specific behavior:

*   If the SPICE proxy is configured using any way described above, than:
    -   an enabled checkbox with label "Enable SPICE Proxy" will be present
    -   it is by default checked
    -   if checked, the SPICE proxy will be used
    -   if unchecked, the global SPICE proxy configuration will be ignored and the VM will connect directly to the guest
*   If SPICE proxy is not set configured, than:
    -   a disabled and unchecked checkbox will be present with label "Enable SPICE Proxy"
    -   it will have a title: "no SPICE proxy defined"
    -   the SPICE will connect directly to the guest

### SPICE Proxy Form

The proxy has to follow the following form: [protocol://]<host>[:port]

The proxy string may be specified with a protocol:// prefix to specify alternative proxy protocols. If no protocol is specified in the proxy string or if the string doesn't match a supported one, the proxy will be treated as a HTTP proxy.

<Category:Feature> <Category:SPICE>
