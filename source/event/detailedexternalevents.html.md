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

### CRUD

Adding is_external boolean field to audit_log with a default value of *false*
Update relevant views to return the is_external flag.

#### DAO

Adding is_external to AuditLog BE
Handling is_external in AuditLogDAODbFacadeImpl

#### Metadata

Modifying AuditLogDAOTest to include the added is_external field
Adding is_external to fixtures.xml

### Configuration

Exposing ExternalEventAgingThreashold to engine-config

### Business Logic

Adding the following types to AuditLogType

        EXTERNAL_EVENT_NORMAL  
        EXTERNAL_EVENT_WARNING 
        EXTERNAL_EVENT_ERROR   
        EXTERNAL_ALERT_ON
        EXTERNAL_ALERT_OFF

Adding severities for the new types in AuditLogDirector
Adding AddExternalEvent command
Adding AddExternalEventParameters with the following fields

        AuditLogSeverity [Mandatory]
        Message [Mandatory]
        UserId [Optional]
        DataCenterId [Optional]
        StorageDomainId [Optional]
        ClusterId [Optional]
        HostId [Optional]
        VmId [Optional]
        TemplateId [Optional]
        GlusterVolumeId [Optional]

Adding the is_external keyword to the Search Engine to filter application/external events
 Change AuditLogCleanup logic to handle application & External cleanups

#### Flow

### Permissions

#### Command Permissions

A new permission to access this command will be added by default only to superuser role. (Admin can add it to other custom roles)

#### Permissions on Entities

Inject with single entity - requires permission for this action on the relevant entity).
Inject with multiple entities - need to check the permission for each entity.
Inject with no entity - requires system level permission to inject.
(this by default would only be in super user role.)

### API

We will use the existing events URL (.../api/events) and the existing Event business-entity in the API and open the possibility to add (POST) a new event (engine will off course impose permissions check on this operation).
 1) Add REST-->Backend mapping in EventMapper (right now only the other direction exists).
2) Add add() method declaration to EventsResource (this is the interface)
3) Add add() method implementation to BackendEvenetsResource (take example of creation implementation in BackendHostsResource)
4) Add signatures to meta-data file (rsdl_metadata_v-3.1.yaml)
5) Add tests
*Note that no update or delete are required.
*

### User Experience

User should be able to use the keyword is_external when searching for events
 Global External Events will be displayed on the Global Events TAB
Entity instance External Events will be displayed on the Events TAB when selecting the Entity instance

### Installation/Upgrade

Add is_external field to audit_log table upon upgrade

#### User work-flows

### Enforcement

### Dependencies / Related Features and Projects

#### Affected oVirt projects

### Documentation / External references

[RFE1](https://bugzilla.redhat.com/show_bug.cgi?id=866123)
[RFE2](https://bugzilla.redhat.com/show_bug.cgi?id=873223)
 [Features/ExternalEvents](Features/ExternalEvents)

### Open Issues

#### Notifications

Should the new External Event types be exposed to the engine-notification tool?

#### Resetting an Alert

How an external ALERT disappears from the system after problem is resolved.
Options:
 1) Support EXTERNAL_ALERT_ON EXTERNAL_ALERT_OFF
2) Have a time period for each ALERT and clean the ALERT when this time is passed.

[Category: Feature](Category: Feature)
