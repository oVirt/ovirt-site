---
title: ReportingVnicInformation
category: feature
authors: danken, moti, msalem
wiki_category: Feature
wiki_title: Feature/ReportingVnicInformation
wiki_revision_count: 40
wiki_last_updated: 2014-02-03
---

# Reporting Vnic Information

## Reporting vNIC implementation reported by Guest Agent

### Summary

The Guest Agent reports the vNic details:

*   IP addresses (both IPv4 and IPv6).
*   vNic internal name

The retrieved information by the Guest Agent should be reported to the ovirt-engine and to be viewed by its client
Today only the IPv4 addresses are reported to the User, kept on VM level. This feature will maintain the information on vNic level.

### Owner

*   Name: Moti Asayag
*   Email: masayag@redhat.com

### Current status

*   Status: Design Stage
*   Last updated date: Nov 8 2012

### User Experience

#### API Changes

New attributes will be added to VM nics collection /api/vms/yyyy/nics:

*   ipv4_addresses

`  `<ipv4_addresses>
`      `<ip address='1.1.1.1'/>
`      `<ip address='2.2.2.2'/>
`  `</ipv4_addresses>

*   ipv6_addresses

`  `<ipv6_addresses>
`      `<ip address='2001:0db8:85a3:0042:0000:8a2e:0370:7335'/>
`      `<ip address='2001:0db8:85a3:0042:0000:8a2e:0370:7336'/>
`  `</ipv6_addresses>

*   interface_name

`  `<interface_name>`p1p2`</interface_name>

#### UI Changes

Administrator Portal:

*   VM Main-Tab:
    -   On ip address column a single IP address (arbitrary) will be presented instead of IP addresses list
*   VM Network Interface sub-tab:
    -   Add column 'interface name' - presents the internal name of the vNic.
    -   Add column 'IPv4 Address' - presents the IPv4 addresses of the vNic (for multiple addresses per vnic, field includes a comma delimited list).
    -   Add column 'IPv6 Address' - presents the IPv6 addresses of the vNic (for multiple addresses per vnic, field includes a comma delimited list).

User Portal:

*   VM Network Interface sub-tab:
    -   Add column 'interface name' - presents the internal name of the vNic.
    -   Add column 'IPv4 Address' - presents the IPv4 addresses of the vNic (for multiple addresses per vnic, field includes a comma delimited list).
    -   Add column 'IPv6 Address' - presents the IPv6 addresses of the vNic (for multiple addresses per vnic, field includes a comma delimited list).

### Benefit to oVirt

The feature is an enhancement of the oVirt engine vNic management:

*   It allows easily association of the managed vNic on engine side by its name with the the actual guest's vNic (instead of comparing MAC Addresses).
*   It allows to identify the network to which a Virtual Machine is a connected by the reported IP.

### Dependencies / Related Features

Affected oVirt projects:

*   Engine-core
*   API
*   Admin Portal
*   User Portal

### Comments and Discussion

[Category: Feature](Category: Feature)
