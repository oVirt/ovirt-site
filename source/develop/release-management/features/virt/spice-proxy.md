---
title: Spice Proxy
category: feature
authors: tjelinek
---

# SPICE Proxy

## Summary

Let the users define a proxy which will be used by SPICE client to connect to the guest. It is useful when the user (e.g. using user portal) is outside of the network where the hypervisors are.

## Client Dependencies

The proxy support for SPICE client has been added in the following versions of the following components:

*   spice-gtk v0.15
*   virt-viewer v0.5.5
*   spice-xpi v2.8.90

## Detailed Description

There are three places where to set the SPICE proxy up:

*   Global Configuration
*   Cluster (overrides the global configuration)
*   VM Pool (overrides global configuration and cluster configuration)
*   Disabling any config per VM

If the proxy is set in any of this places and not disabled it will be filled into the Proxy property of the SPICE client by WebAdmin/UserPortal. If the proxy is not set nothing is filled into this property.

### Global Configuration

The engine-config tool is used to globally configure the SPICE proxy for the whole application. Example:

      engine-config -s SpiceProxyDefault=someProxy
       

To turn the proxy off, just clear it:

      engine-config -s SpiceProxyDefault=""
       

### Cluster

The global configuration can be overridden on cluster level. In webadmin in the newly introduced Console side tab in new/edit cluster dialog. In REST the "clusters" has been enriched by a new property "spice_proxy". If the spice proxy is set in the cluster level, all VMs in this cluster will use this proxy (if not disabled for specific VM).

### VM Pool

The global or cluster configuration can be overridden in the VM Pool level. In webadmin in the new/edit pool dialog in the Console side tab (in advanced mode). In REST the "vmpools" has been enriched by a new property "spice_proxy".

### Disabling any config per VM

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

## SPICE Proxy Form

The proxy has to follow the following form: [protocol://]<host>[:port]

Only the http protocol is currently supported by SPICE clients. If https is specified, the client attempts to connect to the hypervisor and thereby ignores the proxy setting.

