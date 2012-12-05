---
title: DetailedReportingVnicInformation
category: template
authors: moti
wiki_category: Template
wiki_title: Feature/DetailedReportingVnicInformation
wiki_revision_count: 24
wiki_last_updated: 2012-12-17
---

# Detailed Reporting Vnic Information

## Reporting vNIC information reported by Guest Agent Detailed Design

### Summary

The Guest Agent reports the vNic details:

*   IP addresses (both IPv4 and IPv6).
*   vNic internal name

[http://wiki.ovirt.org/wiki/Feature/ReportingVnicImplementation Reporting vNIC implementation reported by Guest Agent Feature Page](http://wiki.ovirt.org/wiki/Feature/ReportingVnicImplementation Reporting vNIC implementation reported by Guest Agent Feature Page)

### Owner

*   Name: Moti Asayag
*   Email: masayag@redhat.com

### Current status

*   Target Release: 3.2
*   Status: Design
*   Last updated date: Nov 12 2012

### Detailed Description

The internal vNic implementation details are reported by VDSM by verbs *getVmStats* and *getAllVmStats*.

         netIfaces = [{'name': 'eth8', 'inet6': ['fe80::21a:4aff:fe16:1ac'], 'inet': ['10.35.17.36'], 'hw': '00:1a:4a:16:01:ac'}, 
                      {'name': 'eth9', 'inet6': ['fe80::21a:4aff:fe16:160','fe80::21a:4aff:fe16:161'], 'inet': ['10.35.1.254'], 'hw': '00:1a:4a:16:01:60'}, 
                      {'name': 'eth7', 'inet6': ['fe80::21a:4aff:fe16:1af'], 'inet': ['10.35.18.69'], 'hw': '00:1a:4a:16:01:af'}]

The vNic device data from the guest contains interface name, IPv4 addresses, IPv6 addresses and MAC Address.

#### Engine

<span style="color:Teal">**VM_GUEST_AGENT_INTERFACE**</span> a new satellite table of vm, contains the vNic configuration reported by the guest agent
{|class="wikitable sortable" !border="1"| Column Name ||Column Type ||Null? / Default ||Definition |- |vm_id ||UUID ||not null ||The VM's ID |- |interface_name ||VARCHAR(50) ||null ||The vNic's name within the VM |- |mac_address ||VARCHAR(59) ||null ||The vNic's MAC address within the VM |- |ipv4_addresses ||text ||null ||The vNic's IPv4 addresses |- |ipv6_addresses ||text ||null ||The vNic's IPv6 addresses |- |}

The IP addresses columns might contain multiple addresses per vNic and will be stored concatenated by comma.
The table will be updated only when a change is detected by the reported data from VDSM.

<span style="color:Teal">**VmGuestAgentInterface**</span> a new class for representing the data reported by the guest agent:

        Guid vmId - VM's ID
        String name - the internal nic's name
        String macAddress - the internal nic's macAddress
        List`<String>` ipv4Addresses - the vNic's IPv4 addresses
        List`<String>` ipv6Addresses - the vNic's IPv6 addresses

<span style="color:Teal">**VmGuestAgentInterfaceDao**</span> new DAO will serve as the interface of the VmGuestAgentInterface entity database related actions. VmGuestAgentInterface is stored to the database only as part of refresh VMs.

#### Engine Flows

<span style="color:Teal">**GetVmGuestAgentInterfaceForVmQuery**</span> - A query to return the vNic's data for a specific vm by the VM's ID.
 <span style="color:Teal">**VdsUpdateRunTimeInfo.refreshVms**</span> - will refresh the vnic's data (as an optimization only if the data was changed). Update should be performed as a mass-operation.

#### VDSM API

No changes for VDSM API.

#### Upgrade DB

1.  Add the new table **VM_GUEST_AGENT_INTERFACE** and related stored-procedure for save/update/delete/get.

### Dependencies / Related Features and Projects

### Open Issues

NA

<Category:Template> <Category:Feature>
