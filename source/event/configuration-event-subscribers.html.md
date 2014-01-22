---
title: configuration-event-subscribers
category: event
authors: moolit
wiki_title: Features/configuration-event-subscribers
wiki_revision_count: 30
wiki_last_updated: 2014-10-18
---

# configuration-event-subscribers

## oVirt Engine Notifier Configuration Subscribers

See also [Features/engine-snmp](Features/engine-snmp).

### Summary

This feature defines a generic way of subscribing to ovirt-engine-notifier events from configuration files.

### Owner

*   Name: [Mooli Tayer](User:mtayer)
*   Email: <mtayer@redhat.com>

### Current status

*   Target Release: 3.4
*   Status: Post
*   Last updated: ,

### Benefit to oVirt

Allows ovirt-engine-notifier users the ability to subscribe to events under different notification methods and profiles.

### Detailed Description

A new 'Event subscribers' section is now available in the notifier's configuration file under
/share/ovirt-engine/services/ovirt-engine-notifier/ovirt-engine-notifier.conf
(It's advisable to leave that file as is and define override file[s] under etc/ovirt-engine/notifier/notifier.conf.d/) Lets take a look;

      #-------------------#
      # Event subscribers #
      #-------------------#
      # specifies whether to treat event lists as whitelists or blacklits by default,
      # can be overridden per event list.
      # -: notify on all events except for those listed in FILTER.
      # +: notify only on events listed in FILTER.
      #
      # DEFAULT_FILTER_MODE=-|+
      DEFAULT_FILTER_MODE=-
      # A whitespace separated events list.
      # each element contains an event list, an optional notification method, an optional profile and
      # an optional filter mode.
      #
      # Examples:
      # 1.) send VDC START and STOP to all notification methods using their default profiles. assumes default filter is +.
      # FILTER="VDC_START,VDC_STOP"
      #
      # 2.) add notifications on all but 2 events to the default mail subscriber as well as to mike@example.com.
      # MAIL_ADDRESS=admin@example.com
      # MAIL_ADDRESS=mike@example.com
      # FILTER="${FILTER} -DATABASE_UNREACHABLE,SYSTEM_VDS_RESTART(MAIL) -DATABASE_UNREACHABLE,SYSTEM_VDS_RESTART(MAIL:MIKE)"
      #
      # 3.) add a new snmp subscriber to all events using default definitions, overriding only the oid.
      # SNMP_OID_DAVE=1.2.3.4
      # FILTER="${FILTER} -(SNMP:DAVE)"
      FILTER=

### Whats in a profile?

A profile defines a target and data associated with it. For MAIL it is simply an email address defined by MAIL_SUBSCRIBER.
For SNMP a profile consists of SNMP_MANAGERS, SNMP_COMMUNITY and SNMP_OID (see [Features/engine-snmp](Features/engine-snmp) for additional info).
 The important thing to understand about profiles is that each one of it's settings is optional and overrides the default profile. Lets look at a simple example;

      MAIL_ADDRESS=default@example.com
      FILTER="${FILTER} -(MAIL:MATTHEW)"

In the above file the MAIL profile MATTHEW is subscribed to all events while no such profile is defined
That's not a problem thought since for MAIL as well as SNMP any missing profile definitions are taken from the default definitions.

### DB v.s Configuration

While the current list of subscribers is a union of that taken from the configuration and that taken from the DB (and defined in the UI), There are a few things to note:

*   While the UI only permits subscription to a subset of selected events the configuration enables subscription to them all.
*   While UI/DB subscribers subscribe to "event_up_name" events and get notifications on their matching "event_down_name"

according to the 'event_map' configuration subscribers need to register to each individual event to allow better granularity.
The event_map as well as the complete event list is found in the following section to ease accurate subscriptions.

### Available Events
