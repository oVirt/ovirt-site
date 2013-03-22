---
title: Engine Adding Messages
category: draft-documentation
authors: amureini, asaf, ecohen, moti, msalem, ofrenkel, tsaban
wiki_category: Draft documentation
wiki_title: Engine Adding Messages
wiki_revision_count: 15
wiki_last_updated: 2015-06-01
---

# Engine Adding Messages

### Introduction

This page contains instructions how to add new messages to oVirt engine.

This document contains information how to handle both *Backend* and *Frontend* modules with regards to messages in order to keep them synchronized.

In order to add/edit a message in oVirt, please follow **all** instructions below in both *Backend* and *Frontend* sections.

## Audit Log Messages

*   For any Audit Log message:
    -   A corresponding key should be added to AuditLogType enum.
    -   A corresponding key should be added to VdcActionType enum.
    -   Need to add a severity for the message in AuditLogDirector.
    -   Add the message to *OVIRT_ENGINE/backend/manager/modules/dal/src/main/resources/bundles/AuditLogMessages.properties*.

## Other Messages

### Backend

*   Any message that shall be exposed by the backend internal API (RunQuery / RunAction) must be delcared as a key/value pair in *OVIRT_ENGINE/backend/manager/modules/dal/src/main/resources/bundles/AppErrors.properties*.

      * A corresponding key should be added to VdcBllMessages enum

*   For VDSM errors, every message must be declared as a key/value pair in *OVIRT_ENGINE/backend/manager/modules/dal/src/main/resources/bundles/VdsmErrors.properties*.

      * A corresponding key should be added to VdcBllErrors enum

### Frontend

For every key/value pair that was added to Backend's *AppErrors* and *VdsmErrors*, the following changes **must** be done for the *WebAdmin* and *UserPortal* projects:

#### AppErrors.properties

*   Another entry must be added to:
    -   *frontend/webadmin/modules/webadmin/src/main/resources/org/ovirt/engine/ui/frontend/AppErrors.properties*
    -   *frontend/webadmin/modules/userportal-gwtp/src/main/resources/org/ovirt/engine/ui/frontend/AppErrors.properties*

The key must be the same as the key that was added to backend file, the message may be different.

#### VdsmErrors.properties

*   Another entry must be added to:
    -   *frontend/webadmin/modules/webadmin/src/main/resources/org/ovirt/engine/ui/frontend/VdsmErrors.properties*
    -   *frontend/webadmin/modules/userportal-gwtp/src/main/resources/org/ovirt/engine/ui/frontend/VdsmErrors.properties*

The key must be the same as the key that was added to backend file, the message may be different.

#### UI Resource

While backend manages it's resource files as properties files only, the UI module requires that the key will also be added to a java interface as well:

*   An interface signature must be added to *frontend/webadmin/modules/frontend/src/main/java/org/ovirt/engine/ui/frontend/AppErrors.java* (or VdsmErrors.java), the method signature must consist of the message key with '();' suffix a return type of type String, here's an example:

For a message key:

      VM_NAME_CANNOT_BE_EMPTY

the method signature in **AppErrors.java** will be:

      String VM_NAME_CANNOT_BE_EMPTY();

### Notes

Please consider the following notes:

*   For UI modules, a different message description can be specified per project.
*   Keys must be UPPERCASE (Only [A-Z][0-9] should be used!), words must be separated by underscore (i.e VM_CANNOT_RUN_STATELESS_HA).
*   Particularly a dot(".") and space(" ") characters are forbidden.
*   For messages that are split across multiple lines, a line break can be added by using \\n\\.
*   It is recommended to build the entire project after adding new messages to make sure the UI modules pass compilation (this is done by adding *gwt-user* & *gwt-admin* Maven profiles to the build command)
*   When changing messages, do not change the translation files (e.g., AppErrors_es.properties), just the original English files. The translated files are handled in bulk before each release.

[Category:Draft documentation](Category:Draft documentation) <Category:Engine> [Category:How to](Category:How to)
