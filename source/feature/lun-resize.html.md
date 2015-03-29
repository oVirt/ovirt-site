---
title: LUN Resize
category: feature
authors: frolland
wiki_category: Feature|LUN_Resize
wiki_title: Features/LUN Resize
wiki_revision_count: 20
wiki_last_updated: 2015-06-14
feature_name: Refresh LUN Size
feature_modules: engine/vdsm
feature_status: Design
---

# LUN Resize

## Refresh LUN Size

### Summary

Support dynamic increase of data domain LUNs in oVirt.

### Owner

*   [ Fred Rolland](User:Frolland) (<frolland@redhat.com>)
*   [Nir Soffer](User:NirSoffer) (<nsoffer@redhat.com>)

### Detailed Description

Users need the ability to increase storage space available in oVirt data domains without increasing the number of LUNs presented to it.

A storage admin resizes a LUN using some administrative tool. (This is out of our scope)
The oVirt admin will be able to perform a UI action on specific LUNs in a storage domain so that the new size will be refreshed.

For each LUN, the engine will send to all hosts in Data Center a "refresh device" command.
If all hosts return the same size, the engine will send to SPM a "resize PV" command.
The DB will be updated with new sizes if needed.
Finally the engine will send to all other hosts in DC command a "refresh PV" command

#### User Experience

In the "Edit Domain" window, a new column "Additional Size" will be available. If the LUN can be expanded , a toggle button with the additional size available will be column. The user can choose to select the button on the LUN he wants to refresh and then click OK.

![](DomainRefreshLun.jpg "DomainRefreshLun.jpg")

#### Vdsm

The following verbs will be added:
\* Refresh Device

input : a single LUN GUID

output : size of LUN

action : call multipath-resize utility and return LUN size

*   Resize PV

input : a single LUN GUID

output : size of LUN

action : call pvresize and return the size of the LUN

*   Refresh PV

input : a single LUN GUID

output : void

action : refresh PV by invalidate PV cache

The following verb will be updated:
\* Get Device List - Additional fields will be added:

Capacity of path in the path status section

Size of PV

#### Engine

A new command will be added:

*   RefreshLunSize

input : a list of LUN GUIDs

output : status of operation

action : send to all hosts in Data Center a "refresh device" command. If all hosts return the same size, the engine will send to SPM a "resize PV" command. The DB will be updated with new sizes if needed. Finally the engine will send to all other hosts in DC command a "refresh PV" command

#### REST

The user will able to perform LUN resize using the REST API of update Storage Domain.
An additional boolean field named "refresh_size" will be added to the "logical_unit".
If the user specify "refresh_size" as "true", the LUN will be resized.

<storage_domain href="/api/storagedomains/d24ebee6-ec30-4270-88a2-a8f38a5a804a" id="d24ebee6-ec30-4270-88a2-a8f38a5a804a">
          ....
`       `<storage>
`           `<type>`iscsi`</type>
`           `<volume_group id="XzNe8X-oH5W-N148-RdSH-1zDv-uV72-FFVezL">
`               `<logical_unit id="360014057fac79f7f7dc4c15b29405f4e">
`                   `<port>`3260`</port>
`                   `<target>`iqn.2015-01.com.rhevuser:444`</target>
                        .....
`                   `<refresh_size>`true`</refresh_size>
`               `</logical_unit>
`           `</volume_group>
`       `</storage>
</storage_domain>

### Open Issues

How to handle a host that was in maintenance when this operation has been performed? Should we refresh luns when the host is coming out of maintenance ?
How to handle a host that was not reachable when the operation was performed ?
What if the host used for getDeviceList do not see the new LUN size? Currently in Edit Domain , the "Use Host" is disabled and the user cannot choose a different one.

[LUN_Resize](Category:Feature) [LUN_Resize](Category:oVirt 3.6 Proposed Feature)
