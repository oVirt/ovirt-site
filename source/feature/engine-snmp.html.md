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

This feature extends the capabilities of the ovirt-engine-notifier to send all engine events and events' data via SNMP traps version 2c.
SNMP parameters are available in ovirt-engine-notifier default configuration file: /share/ovirt-engine/services/ovirt-engine-notifier/ovirt-engine-notifier.conf
(It's advisable to leave that file as is and define an override file under etc/ovirt-engine/notifier/notifier.conf.d/)

      #-------------------------#
      # SNMP_TRAP Notifications #
      #-------------------------#
      # Send v2c snmp notifications
      # IP address or DNS name of an SNMP manager to receive SNMP traps.
      SNMP_MANAGER=
      # The snmp manager's port
      SNMP_PORT=162
      # community string
      SNMP_COMMUNITY=public
      # Object Identifier identifying ovirt engine SNMP trap messages.
      SNMP_OID=1.3.6.1.4.1.2312.13.1
      # comma separated list of event names to notify on.
      #WHITELIST=""
      # notify on all but these comma separated list of events:
      BLACKLIST=""
      # note: if both WHITELIST and BLACKLIST are defined only WHITELIST is considered.

Notes:

*   At least one of (SNMP_MANAGER|MAIL_SERVER) must be properly defined in order for the notifier to run.
*   SNMP_OID stands for :

      1[iso].3[organization].6[DoD].1[Internet].4[private].1[enterprises].2312[redhat].13[ovirt-engine].1[audit-log]

see messages section for details.

*   Since by default WHITELIST is commented out and BLACKLIST is "", if an SNMP_MANAGER is defined all events will generate traps.

### Messages

Using the default value for SNMP_OID (1.3.6.1.4.1.2312.13.1), traps will show up as:

      SNMPv2-MIB::snmpTrapOID.0 = OID: SNMPv2-SMI::enterprises.2312.13.1.0.30    SNMPv2-SMI::enterprises.2312.13.1.0.30.0 = STRING: "User admin@internal logged in." SNMPv2-SMI::enterprises.2312.13.1.0.30.1 = STRING: "NORMAL" SNMPv2-SMI::enterprises.2312.13.1.0.30.2 = STRING: "alertMessage"   SNMPv2-SMI::enterprises.2312.13.1.0.30.3 = STRING: "2014-01-12 07:14:22.576"

2014-01-14 15:17:33 NET-SNMP version 5.7.2 Stopped. Stopping snmptrapd
