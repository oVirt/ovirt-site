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

A storage admin resizes a LUN using some administrative tool. (This is out of our scope) The oVirt admin will be able to perform a UI action (TBD) on specific LUNs in a storage domain.

For each LUN, the engine will send to all hosts in Data Center a "rescan device" command. If all hosts return the same size, the engine will send to SPM a "resize PV" command. The DB will be updated with new sizes if needed. Finally the engine will send to all other hosts in DC command a "refresh PV" command

#### User Experience

Describe user experience related issues. For example: We need a wizard for ...., the behaviour is different in the UI because ....., etc. GUI mockups should also be added here to make it more clear

#### Installation/Upgrade

Describe how the feature will effect new installation or existing one.

#### User work-flows

Describe the high-level work-flows relevant to this feature.

#### Events

What events should be reported when using this feature.

### Dependencies / Related Features and Projects

What other packages depend on this package? Are there changes outside the developers' control on which completion of this feature depends? In other words, completion of another feature owned by someone else and might cause you to not be able to finish on time or that you would need to coordinate? Other Features that might get affected by this feature?

Add a link to the feature description for relevant features. Does this feature effect other oVirt projects? Other projects?

### Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

### Comments and Discussion

Add a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

### Open Issues

Issues that we haven't decided how to take care of yet. These are issues that we need to resolve and change this document accordingly.

[LUN_Resize](Category:Feature) [LUN_Resize](Category:oVirt 3.6 Proposed Feature)
