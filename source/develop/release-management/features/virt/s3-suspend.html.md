---
title: S3 suspend
category: feature
authors: fkobzik
---

# S4/S3 suspend

## Summary

*   Allow S3 and S4 power management options to be controlled per VM in addition to current suspend function
*   Support this feature in webadmin, power user portal, REST API and CLI
*   Still keep the current suspend type as default. Later the suspend type can be set automatically based on guest OS type (not all guest may support S3/S4)

## Owner

*   Name: Frantisek Kobzik (FKobzik)
*   Email: <fkobzik@redhat.com>
*   PM Requirements : Andrew Cathrow (ACathrow)
*   Email: <acathrow@redhat.com>

## Current status

## Detailed Description

### Affected roles

Roles that can manipulate the suspend options for following entities:

1.  VM, Template, VM Pool
    -   SuperUser, PowerUser, ClusterAdmin, DataCenterAdmin.

2.  VM
    -   ad 1,
    -   UserVmManager, VmCreator.

3.  Template
    -   ad 1,
    -   TemplateAdmin, TemplateCreator, TemplateOwner.

4.  VM Pool
    -   ad 1,
    -   VmPoolAdmin.

### Webadmin/Power User Portal

Affected dialogs

*   New/edit VM dialog
*   New/edit VM pool dialog
*   Edit template dialog

Changes

*   New subtab in affected dialogs with suspend options represented by three radio buttons (S3, S4, or standard "old" suspend)
*   Admin/power user is able to change suspend function behavior for given VM/pool/template by selecting one of the radio buttons
*   Default value should be still standard suspend.

Behavior

*   The suspend function (e.g.triggered by "pause button") will perform chosen type of suspend

### REST API

Need new element suspend_type of following resources:

*   Virtual machine
*   Template

### VDSM

the support for hibernation has been already added, see <http://gerrit.ovirt.org/#/c/1121/>

## Documentation / External references

