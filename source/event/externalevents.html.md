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
Those events should be displayed in the Events tab in UI and may be searched as any other event.
I addition, external ALERTS should be enabled as well and displayed in the ALERTS TAB
Global External Events should be displayed in the Global Events TAB while External Events that occurred on a specific entity/entities should be displayed when this entity is selected.

### Benefit to oVirt

Enable running plug-in to inject events to the application.

### Dependencies / Related Features

### Documentation / External references

[RFE](https://bugzilla.redhat.com/show_bug.cgi?id=873223)

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to <Talk:ExternalEvents>

<Category:Feature> <Category:Template>
