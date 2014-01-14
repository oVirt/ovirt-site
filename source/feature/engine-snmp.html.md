---
title: engine-snmp
authors: arthur.berezin, moolit, moti, pbenas
wiki_title: Features/engine-snmp
wiki_revision_count: 39
wiki_last_updated: 2014-10-22
---

# engine-snmp

## oVirt Engine SNMP Traps

### Summary

This feature extends events notifier capabilities and enables it to generate SNMP traps out of system events to integrate oVirt with generic monitoring systems.

### Owner

*   Name: [Mooli Tayer](User:mtayer)
*   Email: <mtayer@redhat.com>

<!-- -->

*   Name: [Arthur Berezin](User:aberezin)
*   Email: <art@redhat.com>

### Current status

*   Target Release: 3.4
*   Status: Post
*   Last updated: ,

### Benefit to oVirt

Allow oVirt users to monitor their virtualization environment with open source or proprietary monitoring systems such as Nagios, BMC Patrol, HP OpenView, etc.

### Detailed Description

This feature extends the capabilities of the event notifier to send all engine events and events' severity via SNMP traps.
SNMP parameters are configured in oVirt event notifier configuration file /etc/ovirt-engine/notifier/notifier.conf
 New parameters in configuration file:
SNMP_SERVER - IP address or DNS name of the SNMP service to receive SNMP traps sent from oVirt event notifier
SNMP_PORT
COMMUNITY_STRING
OID [Default 1.3.6.1.4.1.2312.13.1.#] (each event is sent with OID where # is event ID)
