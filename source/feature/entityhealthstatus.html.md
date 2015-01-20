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

## Adding External Health Status to oVirt Entities

### Summary

Provide a mechanism to set entity health status which will be displayed in the UI as follows

      OK (Green)
      Info (Blue)
      Warning (Yellow)
      Critical (Orange)
      Failure (Red)

The Health Status field will be returned as part of the retrieved entity when a call to display the entity is done using the REST API.

The main use-case for this new status is to provide plugins / external systems the ability to trigger issues, and allow the administrator to clearly see there is an issue through the UI

### Owner

*   Name: [ Eli Mesika](User:MyUser)

<!-- -->

*   Email: emesika@redhat.com

### Current status

Currently oVirt provides only an internal status of the host which is controlled internally by oVirt
In order to see problems on an entity, the administrator should go and select each entity and then look in the relevant plug-in sub-tab for the entity. There is no visual marker for indicating problems on the entity that were reported by an external system

### Use Case

An external system indicates a problem on an entity instance and wants to set its health status such that this status is displayed and visible immediately to the application administrator in the entity main view without any need to drill-down to each and every entity. The administrator will see in the main grid that there is an issue, and pressing on the specific entity he will either be able to look at the events sub-tab to understand what the issue is, or look at custom sub-tab provided by the plugin (if there is indeed a plugin in this specific use-case).

### Detailed Description

The goal is to enable to add each entity a Health Status field which can be set and retrieved using the REST API
The UI should include this field for each such entity main view and displayed it graphically with the appropriate color according to the reported status

This will be achieved by adding a Health Status field to each relevant entity which can be set by a command on the entity instance The command parameters should have parameters that enables oVirt to generate an implicit External Event for the status transition

For the first phase the supported entities will be : Host and Storage Domain vds_dynamic and storage_domain_dynamic tables will have an addition health column DB Facade objects, BEs and tests will be updated accordingly

on REST API those entities will retrieve the health as well , for example a GET on

<dir>
/api/82d9f776-12cf-437a-b686-5958d09f9eb4
results with :

` `<host id=................>
           ......
           ......
`     `<externalstatus>`ok`</externalstatus>
`  `</host>

Setting the status for a entity will be done via the External Events mechanism with an additional externalstatus elemet under the entity For example

` `<event>
`   `<description>`The heat of the host is above 30 Oc`</description>
`   `<severity>`warning`</severity>
`   `<origin>`HP Openview`</origin>
`   `<custom_id>`1`</custom_id>
`   `<flood_rate>`30`</flood_rate>
`   `<host id="82d9f776-12cf-437a-b686-5958d09f9eb4" >
`     `<externalstatus>`warning`<externalstatus>
`   `</host>
` `</event>

### Benefit to oVirt

Enabeling to see problems that were reported by external systems in the entity main view at the point in time those problems occur

### Dependencies / Related Features

See also [UI-Plugins](http://wiki.ovirt.org/wiki/Features/UIPlugins)

### Documentation / External references

### Comments and Discussion

*   Refer to <Talk:EntityHostStatus>

<Category:Feature> <Category:Template>
