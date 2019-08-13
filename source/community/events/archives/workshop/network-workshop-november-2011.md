---
title: Network - oVirt workshop November 2011
category: event/workshop
authors: dannfrazier, quaid
---

# Network - oVirt workshop November 2011

## Work Areas

*   Permissions on networks
*   Bundled network config instead of multiple calls to VDSM to config network
*   Setup networks on multiple hosts in the cluster w/ "one-click" in the GUI (not near term)
*   Managed networks - other than bridging; general notion of network providers
    -   VM-FEX (802.1qbh)
    -   VEPA/VEB (802.1qbg)
    -   Chassis based management - Blade Harmony, etc
    -   openvswitch - kinda on backburner while not upstream, but better place for stuff we currently do in bridge
*   IPv6 "should work", but not tested other than within the guest

Q: have you looked at quantum stuff in openstack? A: recently yes, but not too deeply - we don't want to invent the wheel

[Category: Workshop November 2011](Category: Workshop November 2011)
