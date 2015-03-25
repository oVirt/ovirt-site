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

For each LUN, the engine will send to all hosts in Data Center a "refresh device" command. If all hosts return the same size, the engine will send to SPM a "resize PV" command. The DB will be updated with new sizes if needed. Finally the engine will send to all other hosts in DC command a "refresh PV" command

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

#### Engine

A new command will be added:

*   RefreshLunSize

input : a list of LUN GUIDs

output : status of operation

action : send to all hosts in Data Center a "refresh device" command. If all hosts return the same size, the engine will send to SPM a "resize PV" command. The DB will be updated with new sizes if needed. Finally the engine will send to all other hosts in DC command a "refresh PV" command

#### REST

The user will able to perform LUN resize using the REST API of update Storage Domain. [TBD]

### Dependencies / Related Features and Projects

What other packages depend on this package? Are there changes outside the developers' control on which completion of this feature depends? In other words, completion of another feature owned by someone else and might cause you to not be able to finish on time or that you would need to coordinate? Other Features that might get affected by this feature?

Add a link to the feature description for relevant features. Does this feature effect other oVirt projects? Other projects?

### Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

### Comments and Discussion

Add a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

### Open Issues

How to handle host that was down when this operation has been performed? Should we refresh luns when the host is coming out of maintenance ?

[LUN_Resize](Category:Feature) [LUN_Resize](Category:oVirt 3.6 Proposed Feature)
