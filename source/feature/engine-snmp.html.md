---
title: engine-snmp
authors: arthur.berezin, moolit, moti, pbenas
wiki_title: Features/engine-snmp
wiki_revision_count: 39
wiki_last_updated: 2014-10-22
---

# engine-snmp

## oVirt Engine Notifier Configuration Subscribers

See also [configuration-event-subscribers](configuration-event-subscribers).

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
      # MAIL_SUBSCRIBER=admin@example.com
      # MAIL_SUBSCRIBER_MIKE=mike@example.com
      # FILTER="${FILTER} -DATABASE_UNREACHABLE,SYSTEM_VDS_RESTART(MAIL) -DATABASE_UNREACHABLE,SYSTEM_VDS_RESTART(MAIL:MIKE)"
      #
      # 3.) add a new snmp subscriber to all events using default definitions, overriding only the oid.
      # SNMP_OID_DAVE=1.2.3.4
      # FILTER="${FILTER} -(SNMP:DAVE)"
      FILTER=

### Whats in a profile?

A profile defines a target and data associated with it. For MAIL it is simply an email address defined by MAIL_SUBSCRIBER.
For SNMP a profile consists of SNMP_MANAGERS, SNMP_COMMUNITY and SNMP_OID (see snmp feature page for additional info).

### DB v.s Configuration

### Available Events
