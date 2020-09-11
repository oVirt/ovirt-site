---
title: ReportingVnicInformation
category: feature
authors: danken, moti, msalem
---

# Reporting Vnic Information

## Reporting vNIC information reported by Guest Agent

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

[Reporting vNIC implementation reported by Guest Agent Detailed Design](/develop/release-management/features/network/detailedreportingvnicinformation.html)

### User Experience

#### API Changes

New attributes will be added to VM nics collection `/api/vms/{vm:id}/nics`:

```xml
   <nics>
       <nic id="56d6d62f-6af0-4c02-8500-4be041180031">
           <name>nic1</name>
                 ...
           <reported_data>
               <rel="devices" href=/api/vms/{vm:id}/nics/{nic:id}/reporteddevices>
           <reported_data/>
      <nic/>
             ...
   </nics>
```

```
device:id = UUID.fromString(name)
```

```xml
 <network_device id={device:id} href=/api/vms/{vm:id}/reporteddevices/{device:id}>
       <name>p1p2</name>
       <description>guest reported data</description>
       <ips>
           <ip version="v4" address="10.35.1.177"/>
           <ip version="v6" address="fe80::21a:4aff:fe16:151"/>
       </ips>
             <mac address></mac>        
 </network_device>
```

##### Backward compatibility

Note that the existing IPs reported on /api/vms/{vm:id} are left intact, however the IPs addresses are retrieved from the VM's nics.

```xml
  <guest_info>
      <ips>
          <ip address="1.1.1.1"/>
          <ip address="2.2.2.2"/>
      </ips>
  </guest_info>
```

A new link will be added under the VM:

```xml
 <link rel="devices" href="/api/vms/6c56bd4b-ef18-4e50-b182-277ed78e819d/reporteddevices"/>
```

```
device:id = UUID.fromString(name+mac)
```

```xml
 <network_device id={device:id} href=/api/vms/{vm:id}/devices/{device:id}>
       <name>p1p2</name>
       <description>guest reported data</description>
       <ips>
           <ip version="v4" address="10.35.1.177"/>
           <ip version="v6" address="fe80::21a:4aff:fe16:151"/>
       </ips>
             <mac address></mac>        
 </network_device>
```

Populating the VM's **network_devices** element under **guest_info** is implemented by mechanism introduced by ["All-Content Header" patch](http://gerrit.ovirt.org/#/c/9815)
Only if the request header contains the 'All-Content=true', the network's devices information will be populate the for the VM.

#### UI Changes

Administrator Portal:

*   VM Main-Tab - No changes:
    -   On ip address column the entire list of IP addresses will be presented instead (single space delimiter between the IPs)

<!-- -->

*   VM Network Interface sub-tab (both Admin Portal and User Portal):

A split view of the VM's Network Interfaces sub-tab will present the information reported by the Guest Agent:

*   When there is a match by MAC Address between the vNic's definition on management to the reported vNic by the Guest Agent.

![](/images/wiki/VmInterfaceSubTab.png)

*   The Guest Agent only reports devices that are up, therefore we are not able to report vNics that are down.
*   The Guest Agent is not updated upon change, but rather periodically every 2 minutes, therefore user may experience a slight delay when updating/adding a vNic.

### Benefit to oVirt

The feature is an enhancement of the oVirt engine vNic management:

*   It allows easily association of the managed vNic on engine side by its name with the the actual guest's vNic (instead of comparing MAC Addresses).
*   It provides the information required to connect by IP to a specific network.

### Dependencies / Related Features

Affected oVirt projects:

*   Engine-core
*   API
*   Admin Portal
*   User Portal

### Open Issues

**Suggested naming alternatives**:
\* ipv4_addresses --> inet

*   ipv6_addresses --> inet6

