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
This will be done by adding a new *AddExternalEvent* command and expose it to teh REST API
External events should be displayed in displayed in the Events tab in UI and may be searched as any other event.
External Events are classified as application events as NORMAL, WARNING ERROR or ALERT
This classification is displayed in UI by using a different icon for each
It is recommended to add clones of existing icons for NORMAL, WARNING ERROR or ALERT with a different look to make it easy to distinguish visually between an application event and External Event.

### CRUD

Adding is_external boolean field to audit_log with a default value of *false*
Update relevant views to return the is_external flag.
 Adding a new configuration value that is exposed to engine-config named ExternalEventAgingThreashold
This value controls when old events are deleted from the audit_log table and is defaulted to 30 days.

#### DAO

Adding is_external to AuditLog BE
Handling is_external in AuditLogDAODbFacadeImpl
Modify DeleteAuditLogOlderThenDate sp to get also event type parameter (application/external)

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
        EXTERNAL_EVENT_ALERT

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

TBD

### User Experience

User should be able to use the keyword is_external when searching for events
Event Tab display External Events using a new set of icons for NORMAL, WARNING ERROR and ALERT

### Installation/Upgrade

#### User work-flows

### Enforcement

### Dependencies / Related Features and Projects

#### Affected oVirt projects

### Documentation / External references

[Features/ExternalEvents](Features/ExternalEvents)

### Open Issues

Should the new External Event types be exposed to the engine-notification tool?

[Category: Feature](Category: Feature)
