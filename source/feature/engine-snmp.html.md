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

This feature extends the capabilities of the event notifier to send all engine events and events' data via SNMP traps version 2c.
SNMP parameters are available in oVirt event notifier configuration file /etc/ovirt-engine/notifier/notifier.conf
 New parameters in configuration file:
 SNMP_MANAGER= IP address or DNS name of the SNMP service to receive SNMP traps sent from oVirt event notifier. empty by default. At least one of (SNMP_MANAGER|MAIL_SERVER) must be properly defined in order for the notifier to run. SNMP_PORT= Default is 162.
SNMP_COMMUNITY= A community string to be used in traps. Default is 'public'. SNMP_OID= An Object Identifier identifying ovirt engine SNMP trap messages. Default 1.3.6.1.4.1.2312.13.1 which stands for: 1[iso].3[organization].6[DoD].1[Internet].4[private].1[enterprises].2312[redhat].13[ovirt-engine].1[audit-log] see messages for details.

WHITELIST= a comma separated list of trap generating event names. by default this is commented out BLACKLIST= a comma separated list of ignored events names. by default this is ''.

Note: As you can see from the above, by default all events will generate traps. Note: If both WHITELIST and BLACKLIST are defined, only WHITELIST is considered.
