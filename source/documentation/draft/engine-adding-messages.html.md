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

## Introduction

This page contains instructions how to add new messages to oVirt engine, This document contains information how to handle both *Backend* and *Frontend* modules with regards to messages in order to keep them synchronized.

## Backend

*   Any message that shell be exposed by backend internal API (RunQuery / RunAction) must be delcared as a key/value pair in *OVIRT_ENGINE/backend/manager/modules/dal/src/main/resources/bundles/AppErrors.properties*.
*   For VDSM errors, every message must be declared as a key/value pair in *OVIRT_ENGINE/backend/manager/modules/dal/src/main/resources/bundles/VdsmErrors.properties*.

## Frontend

For every key/value pair that was added to Backend's *AppErrors* and *VdsmErrors*, the following changes must be done for the *WebAdmin* and *UserPortal* projects:

### AppErrors.properties

*   Another entry must be added to:
    -   *frontend/webadmin/modules/webadmin/src/main/resources/org/ovirt/engine/ui/frontend/AppErrors.properties*
    -   *frontend/webadmin/modules/userportal/src/main/resources/org/ovirt/engine/ui/frontend/AppErrors.properties*

Key must be equal to the key that was added to backend file, the message may be different.

### VdsmErrors.properties

*   Another entry must be added to:
    -   *frontend/webadmin/modules/webadmin/src/main/resources/org/ovirt/engine/ui/frontend/VdsmErrors.properties*
    -   *frontend/webadmin/modules/userportal/src/main/resources/org/ovirt/engine/ui/frontend/VdsmErrors.properties*

Key must be equal to the key that was added to backend file, the message may be different.

### UI Resource

While backend manages its resource files as properties files only, the UI module requires the key to be added as a java interface as well:

*   An interface signature must be added to *frontend/webadmin/modules/webadmin/src/main/resources/org/ovirt/engine/ui/frontend/AppErrors.java* (or VdsmErrors.java), the method signature must be equal to the message key with '();' postfix and

return a string, here's an example:

For message key

      VM_NAME_CANNOT_BE_EMPTY

the method signature in **AppErrors.java** will be

      String VM_NAME_CANNOT_BE_EMPTY();

## Notes

Please consider the following notes:

*   For UI modules, a different message description can be specified per project.
*   Keys must be UPPERCASE (Only [A-Z][0-9] should be used!), words must be separated by underscore (i.e VM_CANNOT_RUN_STATELESS_HA).
*   Especially Dot(".") and space(" ") characters are not forbidden.
*   For messages that are splitted across multiple lines, each line must be added by \\n\\.
*   It is recommended to build the entire project after adding new messages to make sure the UI modules pass compilation (this is done by adding *gwt-user* & *gwt-admin* maven profiles to the build command)

[Category:Draft documentation](Category:Draft documentation) <Category:Engine> [Category:How to](Category:How to)
