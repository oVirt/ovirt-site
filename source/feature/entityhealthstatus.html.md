---
title: EntityHealthStatus
category: feature
authors: emesika, ovedo
wiki_category: Feature
wiki_title: Features/EntityHealthStatus
wiki_revision_count: 39
wiki_last_updated: 2015-06-12
---

# Entity Health Status

## Adding External Health Status to Entities

### Summary

Provide a mechanism to set entity health status by plug-ins which will be displayed in the UI as follows

OK (Green) Info (Blue) Warning (Yellow) Critical (Orange) Failure (Red)

The Healt Status sield will be returned as part of the retrieved entity when a call to display the entity is done using the RST API

### Owner

*   Name: [ Eli Mesika](User:MyUser)

<!-- -->

*   Email: emesika@redhat.com

### Current status

Currently oVirt provides only an internal status of the host which is controled internally by oVirt
In order to see problems on an entity, the adminisrator should go and select each entity and then look in the relevant plug-in sub-tab for the entity. There is no visual marker for indicating problems on the entity that were reported by an external system

### Use Case

An external system having a oVirt UI plug-in on a entity managed by ovirt indicates a problem on an entity instance and wants to set its health status such that this status is displayed and visible immediatly to the application administrator in the entity main view withot any need to drill-down

### Detailed Description

The goal is to enable to add each entity a Health Status field which can be set and retrieved using the REST API
The UI should include this field for each such entity main view and displayed it graphically with the appropriate color according to the reported status

This will be achieved by adding a Health Status field to each relevant entity which can be set by a command on the entity instance The command parameters should have parameters that enables oVirt to generate an implicit External Event for the status transition

### Benefit to oVirt

Enabeling to see problems that were reported by external systems in the entity main view at the point in time those problems occur

### Dependencies / Related Features

See also [UI-Pluggins](http://wiki.ovirt.org/wiki/Features/UIPlugins)

### Documentation / External references

[RFE](https://bugzilla.redhat.com/show_bug.cgi?id=866124)

### Comments and Discussion

*   Refer to <Talk:EntityHostStatus>

<Category:Feature> <Category:Template>
