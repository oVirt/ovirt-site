---
title: Audit Logs and Event Notifications
category: event
authors: shireesh
---

# Audit Logs and Event Notifications

## Introduction

This article explains how to introduce audit logging and email notifications on predefined events in the oVirt engine.

## Audit Logs

### Audit Log Support for a new Entity

You must read this section if you are trying to introduce a new entity, operations on which need to be audited. In case you want to introduce audit logging on new events on an existing entity which is already supported by the audit log framework, you can safely skip to the next section.

In order to log useful information about the event e.g. name of the entity on which the event occurred, it is required to add audit support for the entity. This involves following changes:

*   Upgrade script to add new fields in audit_log table for id and name of the entity

      ''   select fn_db_add_column('audit_log', 'gluster_volume_id', 'uuid');
      ''   select fn_db_add_column('audit_log', 'gluster_volume_name', 'VARCHAR(255)');

*   Modifications in related stored procedures in *backend/manager/dbscripts/audit_log_sp.sql*
*   New variables with getters / setters in *org.ovirt.engine.core.common.businessentities.AuditLog* and *org.ovirt.engine.core.dal.dbbroker.auditloghandling.AuditLogableBase* for these fields e.g.

      ''   private NGuid glusterVolumeId;
      ''   private String glusterVolumeName;
      ''
      ''   public NGuid getGlusterVolumeId() {
      ''       return glusterVolumeId;
      ''   }
      ''
      ''   public void setGlusterVolumeId(NGuid value) {
      ''       glusterVolumeId = value;
      ''   }
      ''
      ''   public String getGlusterVolumeName() {
      ''       return glusterVolumeName;
      ''   }
      ''
      ''   public void setGlusterVolumeName(String value) {
      ''       glusterVolumeName = value;
      ''   }

*   Modify the method *org.ovirt.engine.core.dal.dbbroker.auditloghandling.AuditLogDirector#log* to set the new fields in the *AuditLog* object. e.g.

      ''   tempVar.setGlusterVolumeId(auditLogable.getGlusterVolumeId());
      ''   tempVar.setGlusterVolumeName(auditLogable.getGlusterVolumeName());

*   Modify various methods in *org.ovirt.engine.core.dao.AuditLogDAODbFacadeImpl* to save / retrieve the new fields also. Don't forget to update the test case class as well (*AuditLogDAOTest*)

### Audit Log Types

Introduce the new Audit Log Type(s) in the enum *org.ovirt.engine.core.common.AuditLogType* e.g.

      ''   GLUSTER_VOLUME_CREATE(3000),
      ''   GLUSTER_VOLUME_CREATE_FAILED(3001),
      ''   GLUSTER_VOLUME_DELETE(3002),
      ''   GLUSTER_VOLUME_DELETE_FAILED(3003),

### Audit Log Messages

Add corresponding messages in *backend/manager/modules/dal/target/classes/bundles/AuditLogMessages.properties* e.g.

      ''   GLUSTER_VOLUME_CREATE=Gluster Volume ${glusterVolumeName} created.
      ''   GLUSTER_VOLUME_CREATE_FAILED=Creation of Gluster Volume ${glusterVolumeName} failed.
      ''   GLUSTER_VOLUME_DELETE=Gluster Volume ${glusterVolumeName} deleted.
      ''   GLUSTER_VOLUME_DELETE_FAILED=Gluster Volume ${glusterVolumeName} could not be deleted.

Note that the variable used here **${glusterVolumeName}** is same as the name of the variable added in *org.ovirt.engine.core.dal.dbbroker.auditloghandling.AuditLogableBase*

### Audit Log Severities

Map corresponding severities in *org.ovirt.engine.core.dal.dbbroker.auditloghandling.AuditLogDirector* e.g.

      ''    private static void initGlusterVolumeSeverities() {
      ''       mSeverities.put(AuditLogType.GLUSTER_VOLUME_CREATE, AuditLogSeverity.NORMAL);
      ''       mSeverities.put(AuditLogType.GLUSTER_VOLUME_CREATE_FAILED, AuditLogSeverity.ERROR);
      ''       mSeverities.put(AuditLogType.GLUSTER_VOLUME_DELETE, AuditLogSeverity.NORMAL);
      ''       mSeverities.put(AuditLogType.GLUSTER_VOLUME_DELETE_FAILED, AuditLogSeverity.ERROR);
      ''   }

This makes sure that the log messages will be shown in the UI with appropriate severity icons.

### Enable Audit in command(s) for the event(s)

Implement method *getAuditLogTypeValue* inside the command class to return appropriate enum from *AuditLogType* based on success / failure of the command. e.g.

      ''   @Override
      ''   public AuditLogType getAuditLogTypeValue() {
      ''       if (getSucceeded()) {
      ''           return AuditLogType.GLUSTER_VOLUME_CREATE;
      ''       } else {
      ''           return AuditLogType.GLUSTER_VOLUME_CREATE_FAILED;
      ''       }
      ''   }

At this point, you should see the events getting audited and seen in the "Events" tab in the UI.

## Event Notifications

In order to allow users to subscribe to your audit event types so that they receive email notifications, following steps are required:

### Introduce your new event notification entity

By adding a new entry in the enum *org.ovirt.engine.core.common.EventNotificationEntity*

### Add notification events

In *org.ovirt.engine.core.common.VdcEventNotificationUtils* by mapping them with the corresponding notification entity e.g.

      ''   AddEventNotificationEntry(EventNotificationEntity.GlusterVolume, AuditLogType.GLUSTER_VOLUME_CREATE);
      ''   AddEventNotificationEntry(EventNotificationEntity.GlusterVolume, AuditLogType.GLUSTER_VOLUME_CREATE_FAILED);
      ''   AddEventNotificationEntry(EventNotificationEntity.GlusterVolume, AuditLogType.GLUSTER_VOLUME_DELETE);
      ''   AddEventNotificationEntry(EventNotificationEntity.GlusterVolume, AuditLogType.GLUSTER_VOLUME_DELETE_FAILED);

These events will appear in the the "Add Event Notification" screen that appears when you click on the "Manage Events" button on the "Event Notifier" sub-tab under the "Users" tab. At this point though, you will see the enum name as it is. To get more user friendly descriptions on the UI, refer the following sections.

### Changes in UI (GWT) code

*   Add entries in *org.ovirt.engine.ui.uicompat.Enums* for these audit log types

      ''   String AuditLogType___GLUSTER_VOLUME_CREATE();
      ''   String AuditLogType___GLUSTER_VOLUME_CREATE_FAILED();
      ''   String AuditLogType___GLUSTER_VOLUME_DELETE();
      ''   String AuditLogType___GLUSTER_VOLUME_DELETE_FAILED();

(Note the special syntax starting with **AuditLogType___**)

*   Add corresponding descriptions in *frontend/webadmin/modules/uicompat/src/main/resources/org/ovirt/engine/ui/uicompat/Enums.properties*

      ''   AuditLogType___GLUSTER_VOLUME_CREATE=Gluster Volume Created
      ''   AuditLogType___GLUSTER_VOLUME_CREATE_FAILED=Gluster Volume could not be created
      ''   AuditLogType___GLUSTER_VOLUME_DELETE=Gluster Volume deleted
      ''   AuditLogType___GLUSTER_VOLUME_DELETE_FAILED=Gluster Volume could not be deleted

These descriptions will appear on the event subscription screen.

That's it. Once all these changes are done, and user subscribes to the events, the system will start sending emails of subscribed events to the provided email id.

**`Note:`**` The Notification service must be running for the notifications to be sent.`

<<Details of configuring / running the notification service to be added>>
