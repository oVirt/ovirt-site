---
title: configuration-event-subscribers
category: event
authors: moolit
---

# configuration-event-subscribers

## oVirt Engine Notifier Configuration Subscribers

See also [Features/engine-snmp](/develop/release-management/features/infra/engine-snmp.html).

### Summary

An ovirt-engine-notifier feature defining a generic way of subscribing to audit log events in configuration files using a simple first match include/exclude algorithm.

### Owner

*   Name: Mooli Tayer (mtayer)
*   Email: <mtayer@redhat.com>

### Current status

*   Target Release: 3.4
*   Status: Post
*   Last updated: ,

### Benefit to oVirt

Allows ovirt-engine-notifier users to subscribe to events using configuration.

### Detailed Description

A new 'Event Filter' section is now available in the notifier's configuration file under
/share/ovirt-engine/services/ovirt-engine-notifier/ovirt-engine-notifier.conf
(It's advisable to leave that file as is and define override file[s] under etc/ovirt-engine/notifier/notifier.conf.d/)
Lets take a look;

      #--------------#
      # Event Filter #
      #--------------#
      # Filter logic.
      #
      # First match algorithm for include/exclude messages.
      # Entry is message|*(subscriber|*)
      # * = all messages/all subscribers.
      # * as a subscriber should be used only for exclude.
      #
      # examples:
      # FILTER="include:VDC_START(smtp:mail@example.com) ${FILTER}"
      # FILTER="exclude:VDC_START include:*(smtp:mail1@gmail.com) ${FILTER}"
      #
      # The final filter list contains FILTER  as well as 'event_subscriber' table records.
      # database record are considered first.
      FILTER="exclude:*"

### DB v.s Configuration

The final Filter is read uniformly from both the database (available in web admin) and configuration. DB records are of higher precedence and they are all of the include kind.

There are a few things to note:

*   While the UI only permits subscription to a subset of selected events the configuration enables subscription to them all.
*   UI/DB subscribers subscribe to "event_up_name" events and get notifications on their matching "event_down_name" according to the 'event_map' table.

       To allow better granularity configuration subscribers must register to both.

*   There is a current limitation in the UI allowing only email subscription. this might change in the future.

### Available Events

For a list of available events see: /share/doc/ovirt-engine/AuditLogMessages.properties
