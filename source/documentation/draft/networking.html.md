---
title: Networking
category: draft-documentation
authors: amuller, danken, fabiand, lpeer
wiki_category: Draft documentation
wiki_title: Networking
wiki_revision_count: 20
wiki_last_updated: 2014-01-21
---

# Networking

This page is for captuaring Networking related features we would like to have in oVirt going forward.

## Features

*   SR-IOV support - Available via VDSM hook
*   IPV6 support
*   network SLA - VM QoS in 3.3, Host QoS in 3.4
*   user defined networks (vlan ranges)
*   IP allocations (melange in openstack, but forman has support as well) - 3.4 via Neutron integration
*   security groups - 3.4 via Neutron integration
*   permissions on networks (control who may attach what to which network)
*   open vSwitch
*   GRE tunneling (VPC - virtual private network) - 3.3 via Neutron integration
*   Network roles (storage / live migration network etc.) - Migration in 3.3
*   Sniff guest IP and report to the engine without guest tools
*   Anti-spoofing layer two/three
*   network groups
*   dynamic network
*   network lables - Available in 3.4
*   Support nested vlans. (QinQ)

## Technologies / Stuff

*   UCS integration
*   Blade Harmony
*   quantum/neutron integration - Available in 3.3, extended in 3.4
*   'network-manager' architecture - looking into re-designing the engine networking code.
*   open flow
*   Using Network manager vs. using scripts (VDSM level)

We'll open a wiki page for each of the above lines.

[Category:Draft documentation](Category:Draft documentation)
