---
title: Refresh LUN Size
category: feature
authors:
  - frolland
  - nsoffer
---

# Refresh LUN Size

## Summary

Support dynamic increase of data domain LUNs in oVirt.

## Owner

*   Fred Rolland (<frolland@redhat.com>)
*   Nir Soffer (<nsoffer@redhat.com>)

## Detailed Description

Users need the ability to increase storage space available in oVirt data domains without increasing the number of LUNs presented to it.

A storage admin resizes a LUN using some administrative tool. (This is out of our scope)
The oVirt admin will be able to perform a UI action on specific LUNs in a storage domain so that the new size will be refreshed.

The engine will send to all hosts in Data Center a "GetDeviceList" command with the required LUNs only.
If all hosts return the same size, the engine will send to SPM a "resize PV" command.
The DB will be updated with new sizes if needed.
 In the case when a host was in maintenance or not reachable when this operation has been performed, the host will rescan and resize the LUNs as part of the Connect Storage Server verb. The Connect Storage Server verb is called in engine command InitVdsOnUpCommand whenever a host comes back from a non up state.

### User Experience

In the "Edit Domain" window, a new column "Additional Size" will be available. If the LUN can be expanded , a toggle button with the additional size available will appear in the column. The user can choose to select the button on the LUN he wants to refresh and then click OK.

![](/images/wiki/DomainRefreshLun.png)

### Vdsm

The following verbs will be added:
\* Resize PV

input : a single LUN GUID

output : size of PV

action : call pvresize and return the size of the PV

The following verb will be updated:
\* Get Device List - Rescan and resize of devices will be added
* Additional fields will be added:

Capacity of path in the path status section

Size of PV

*   Connect Storage server

* Rescan and resize of devices will be added

### Engine

A new command will be added:

*   RefreshLunSize

input : a list of LUN GUIDs

output : status of operation

action : send to all hosts in Data Center a "getDeviceList" command with the epecific devices. If all hosts return the same size, the engine will send to SPM a "resize PV" command. The DB will be updated with new sizes if needed.

### REST

The user will able to perform LUN resize using the REST API of Storage Domain.
A new action named "refresh_luns" will be added.
    
    POST /api/storagedomains/zzz/refreshluns
    <action>
      <logical_units>
        <logical_unit id='xxx'/>
        <logical_unit id='yyy'/>
      </logical_units>
    </action>

## Open Issues

What if the host used for getDeviceList do not see the new LUN size? Currently in Edit Domain , the "Use Host" is disabled and the user cannot choose a different one.
Consider revisit Device Visibility command to check if all the hosts are aware of the same PV sizes.

