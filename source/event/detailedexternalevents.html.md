---
title: DetailedExternalEvents
category: event
authors: emesika, yair zaslavsky
wiki_category: Feature
wiki_title: Features/Design/DetailedExternalEvents
wiki_revision_count: 86
wiki_last_updated: 2012-12-16
wiki_warnings: list-item?
---

# Detailed External Events

## Adding External Events to Audit Log

### Summary

Currently all events audited in system are internal events. That means that all events are inserted to the Audit Log by the application.
This document describes a requirement to enable injection of External Events to the system via API.

### Owner

*   Feature owner: [ Eli Mesika](User:emesika)

    * GUI Component owner: [ Eli Mesika](User:emesika)

    * REST Component owner: [ Eli Mesika](User:emesika)

    * Engine Component owner: [ Eli Mesika](User:emesika)

    * QA Owner: [ Yaniv Kaul](User:ykaul)

*   Email: emesika@redhat.com

### Current status

*   Target Release: 3.2
*   Status: Design
*   Last updated date: Nov 8 2012

### Detailed Description

Enable plug-ins to inject their own events to the system using API
This will be done by adding a new *AddExternalEvent* command and expose it to the REST API
External events should be displayed in the Events tab in UI and may be searched as any other event.
External Events are classified as application events based on severity values of NORMAL, WARNING ERROR or ALERT
Alerts that are deleted from the system are only marked as deleted in the *audit_log* table and not removed permanently from the database
External Events can not use application variables, therefore no '$' expressions should appear in the Event/Alert free message text

### CRUD

Adding *deleted* boolean field to audit_log with a default value of *false*
Adding *source* varchar field to audit_log with a default value of *oVirt* [1]
Adding *custom_event_id* integer field to audit_log with a default value of *-1* [2]
Adding *event_flood_in_sec* integer field to audit_log with a default value of *30* [3]
Adding *custom_data* text field to audit_log with a default value of empty string [4]
 [1] *source* is a unique string that identifies the source adding an event
[2] *custom_event_id* is a sequential number that identifies the event/alert instance
[3] *event_flood_in_sec* value will not affect application events
[4] *custom data* value will be used to store any data about the event, (for example {a=xxx,b=12})
 Update relevant views to return the additional fields.

#### DAO

Adding additional fields to AuditLog BE
Handling additional fields in AuditLogDAODbFacadeImpl

#### Metadata

Modifying AuditLogDAOTest to include the added fields
Adding additional fields to fixtures.xml

### Business Logic

Adding additional fields to *AuditLog* BE
 Adding the following types to AuditLogType

        EXTERNAL_EVENT_NORMAL  
        EXTERNAL_EVENT_WARNING 
        EXTERNAL_EVENT_ERROR   
        EXTERNAL_ALERT

Adding severities for the new types in AuditLogDirector
Adding AddExternalEvent command
Adding AddExternalEventParameters with the following fields

        AuditLogSeverity [Mandatory]
        Message [Mandatory]
        Source  [Mandatory]
        CustomEventId [Mandatory]
        CustomData [Mandatory]
        EventFloodInSec[[Optional] -- 30 sec if not defined
        UserId [Optional]
        DataCenterId [Optional]
        StorageDomainId [Optional]
        ClusterId [Optional]
        HostId [Optional]
        VmId [Optional]
        TemplateId [Optional]
        GlusterVolumeId [Optional]

### Search Engine

Adding support for searching events by:

       deleted
       source
       custom_event_id

External Events can be filtered using *source != 'oVirt*'

### Flow

*Add Event/Alert* Flow:
Invoke *..api/events/add* API giving at least AuditLogType, Severity, source & CustomEventId
When the Event/Alert is on a specific object, the object instance id should be set.
 *Delete Alert* Flow:
Invoke ..api/events/delete API giving AuditLogId (this id is returned when adding an External Event)
Mark the relevant entry of the Alert in DB with *deleted = true*
Add a NORMAL event on the Alert deletion with all relevant details (user, time etc.)

### Permissions

#### Command Permissions

A new permission to access this command will be added by default only to superuser role. (Admin can add it to other custom roles)

#### Permissions on Entities

Inject with single entity - requires permission for this action on the relevant entity).
Inject with multiple entities - need to check the permission for each entity.
Inject with no entity - requires system level permission to inject.
(this by default would only be in super user role.)

### API

We will use the existing events URL (.../api/events) and the existing Event business-entity in the API and open the possibility to add (POST) a new event or delete an alert (engine will off course impose permissions check on this operation).
 1) Add REST-->Backend mapping in EventMapper (right now only the other direction exists).
2) Add add() method declaration to EventsResource (this is the interface)
3) Add add() method implementation to BackendEvenetsResource (take example of creation implementation in BackendHostsResource)
4) Add delete() method declaration to EventsResource (forced for Alerts only in canDoAction)
5) Add delete() method implementation to BackendEvenetsResource
6) Add signatures to meta-data file (rsdl_metadata_v-3.1.yaml)
7) Add tests
*Note that no update is required.
*

### User Experience

Global External Events will be displayed on the Global Events TAB
Entity instance External Events will be displayed on the Events TAB when selecting the Entity instance
External Alerts will be displayed in the *Alerts* TAB

### Installation/Upgrade

Add additional fields to audit_log table upon upgrade
Add the permission(ActionGroup) to manipulate External Events to other *admin* roles already defined upon upgrade.

#### User work-flows

### Enforcement

### Dependencies / Related Features and Projects

#### Affected oVirt projects

### Documentation / External references

[RFE1](https://bugzilla.redhat.com/show_bug.cgi?id=866123)
[RFE2](https://bugzilla.redhat.com/show_bug.cgi?id=873223)
 [Features/ExternalEvents](Features/ExternalEvents)

### Future directions

External Event types should be exposed to the engine-notification tool in future releases
Gathering Events/Alerts by the History ETL should be considered in future releases
Separate between Events and Alerts in DB/BL/API
Support search on *custom_data*

[Category: Feature](Category: Feature)
