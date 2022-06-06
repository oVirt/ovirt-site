---
title: DetailedReportingVnicInformation
category: feature
authors: moti
---

# Detailed Reporting Vnic Information

## Reporting vNIC information reported by Guest Agent Detailed Design

### Summary

The Guest Agent reports the vNic details:

*   IP addresses (both IPv4 and IPv6).
*   vNic internal name

[Reporting vNIC implementation reported by Guest Agent Feature Page](reportingvnicinformation.html)

### Owner

*   Name: Moti Asayag
*   Email: masayag@redhat.com

### Current status

*   Target Release: 3.2
*   Status: Design
*   Last updated date: Nov 12 2012

### Detailed Description

The internal vNic implementation details are reported by VDSM by verbs `getVmStats` and `getAllVmStats`.

```python
netIfaces = [
    {
        'name': 'eth8',
        'inet6': ['fe80::21a:4aff:fe16:1ac'],
        'inet': ['10.35.17.36'],
        'hw': '00:1a:4a:16:01:ac'
    },
    {
        'name': 'eth9',
        'inet6': ['fe80::21a:4aff:fe16:160','fe80::21a:4aff:fe16:161'],
        'inet': ['10.35.1.254'],
        'hw': '00:1a:4a:16:01:60'
    },
    {
        'name': 'eth7',
        'inet6': ['fe80::21a:4aff:fe16:1af'],
        'inet': ['10.35.18.69'],
        'hw': '00:1a:4a:16:01:af'
    }
]
```
The vNic device data from the guest contains interface name, IPv4 addresses, IPv6 addresses and MAC Address.

#### Engine

`VM_GUEST_AGENT_INTERFACES` a new satellite table of vm, contains the vNic configuration reported by the guest agent

| Column Name   | Column Type | Null? / Default | Definition |
|---------------|-------------|-----------------|------------|
|vm_id          | UUID        | not null        |The VM's ID, **foreign key** to vm_static.vm_guid |
|interface_name | VARCHAR(50) | null            |The vNic's name within the VM                     |
|mac_address    | VARCHAR(59) | null            |The vNic's MAC address within the VM              |
|ipv4_addresses | text        | null            |The vNic's IPv4 addresses                         |
|ipv6_addresses | text        | null            |The vNic's IPv6 addresses                         |
{: .bordered .wikitable .sortable}

The IP addresses columns might contain multiple addresses per vNic and will be stored concatenated by comma.
The table will be updated only when a change is detected by the reported data from VDSM.

`VmGuestAgentInterface` a new class for representing the data reported by the guest agent:

```java
Guid vmId   // VM's ID
String name // the internal nic's name
String macAddress // the internal nic's macAddress
List<String> ipv4Addresses // the vNic's IPv4 addresses
List<String> ipv6Addresses // the vNic's IPv6 addresses
```

`VmGuestAgentInterfaceDao` new DAO will serve as the interface of the `VmGuestAgentInterface` entity database related actions.
`VmGuestAgentInterface` is stored to the database only as part of refresh VMs.

#### Engine Flows

`GetVmGuestAgentInterfacesForVmQuery` - A query to return the vNic's data for a specific vm by the VM's ID.

`VdsUpdateRunTimeInfo.refreshVms` - will refresh the vnic's data (as an optimization only if the data was changed). Update should be performed as a mass-operation.

* Populating the VMs IP addresses and VM guest agent interfaces is done by `getVmStats` and `getAllVmStats`

*   -   When the `netIfaces` element is reported by VDSM, it will be used both for populating the VM's IP addresses list on `vm_dynamic(vm_ip)` as well as the vm guest agent interfaces.
    -   If `netIfaces` is not reported by VDSM (earlier VDSM versions), the VM's IP addresses list will be populate by `guestIPs` as done today.

#### Rest API

Populating the VM's `network_devices` element under `guest_info` is implemented by mechanism introduced by ["All-Content Header" patch](http://gerrit.ovirt.org/#/c/9815)
Rest API will invoke `GetVmGuestAgentInterfacesForVmQuery` from the `populate` method of VM Resource `BackendVmResource` in order to populate the additional information of guest_info.
A mapper should be created as well between `VmGuestAgentInterface` to the equivalent Rest API entity.

On `BackendVmNicResource`, the new properties of the `HostNic` (`interface_name`, `ipv4` and `ipv6`) will be populated by using same query to get relevant data if exists.

#### UI

Changes should be made for both Admin-Portal and User-Portal.
The client will invoke `GetVmGuestAgentInterfacesForVmQuery` for getting the information and will map them on client side by MAC address
for matching the management vNic to the VM interface reported by the guest agent and populating the information on the VM Interface sub-tab.

#### VDSM API

No changes for VDSM API.

#### Upgrade DB

1.  Add the new table `VM_GUEST_AGENT_INTERFACES` and related stored-procedure for save/update/delete/get.

### Dependencies / Related Features and Projects

### Open Issues

NA

