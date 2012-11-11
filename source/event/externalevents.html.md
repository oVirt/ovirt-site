---
title: ExternalEvents
category: event
authors: emesika, mkenneth
wiki_title: Features/ExternalEvents
wiki_revision_count: 14
wiki_last_updated: 2015-01-13
---

# External Events

## Adding External Events to Audit Log

### Summary

Currently all events audited in system are internal events. That means that all events are inserted to the Audit Log by the application.
This document described a requirement to enable injection of External Events to the system via API.

### Owner

*   Name: [ Miki Kenneth](User:MyUser)

<!-- -->

*   Email: mkenneth@redhat.com

### Current status

Application stores, display and searches only internal events.

*   Last updated date: Nov 8, 2012

### Detailed Description

The Audit Log module enables insertions of internal events.
Events are classified as NORMAL , WARNING or ERROR and UI will display different icon according to that.
A new command should be exposed to the API in order to enable addition of external events
The Events should be attached to the relevant internal objects (DataCenetr, Cluster, Host, VM etc. where relevant).
All Events should be classified as Internal/External.
All Events (internal and externals) should be filtered by the relevant fields displayed on the Events tab.
Those events should be displayed in the Events tab in UI and may be searched as any other event.
As Events and Alerts use a similiar mechanism, external ALERTS should be enabled as well and displayed in the ALERTS TAB.
Global External Events should be displayed in the Global Events TAB while External Events that occurred on a specific entity/entities should be displayed when this entity is selected.

### Benefit to oVirt

Enable external plug-ins to inject events into the application database, for auditing and alerting.
Sample use-cases:
*External specific HW manfactuare monitors the the Host Hardware, and would like to alert the user on fan problem and temperture rising on a specific Host.*
*External anti-virus appliance scan to inject an event a VM has a virus.*

### Dependencies / Related Features

See also UI-Pluggins

### Documentation / External references

[RFE](https://bugzilla.redhat.com/show_bug.cgi?id=873223)

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to <Talk:ExternalEvents>

<Category:Feature> <Category:Template>
