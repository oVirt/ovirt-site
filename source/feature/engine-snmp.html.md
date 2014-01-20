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
Note that in contrary to email notification added through the UI, where only a subset of events are defined, here all events are sent by edfault.
SNMP parameters are available in ovirt-engine-notifier default configuration file: /share/ovirt-engine/services/ovirt-engine-notifier/ovirt-engine-notifier.conf
(It's advisable to leave that file as is and define an override file under etc/ovirt-engine/notifier/notifier.conf.d/)

      #-------------------------#
      # SNMP_TRAP Notifications #
      #-------------------------#
      # Send v2c snmp notifications
      # A whitespace separated list of IP addresses or DNS names of SNMP managers to receive SNMP traps.
      # Can include an optional port, default is 162
      # SNMP_MANAGERS=manager1.example.com manager2.example.com:164
      SNMP_MANAGERS=
      # Community String
      SNMP_COMMUNITY=public
      # Object Identifier identifying ovirt engine SNMP trap messages.
      SNMP_OID=1.3.6.1.4.1.2312.13.1.1
      # 1[iso].3[organization].6[DoD].1[Internet].4[private].1[enterprises].2312[redhat].13[ovirt-engine].1[notifications].
      # 1[audit-log]
      # exclude: notify on all events except for those listed in SNMP_FILTER.
      # include: notify only on events listed in SNMP_FILTER.
      # SNMP_FILTER_MODE=exclude|include
      SNMP_FILTER_MODE=exclude
      # A whitespace separated events list.
      SNMP_FILTER=

Notes:

*   At least one of (SNMP_MANAGER|MAIL_SERVER) must be properly defined in order for the notifier to run.
*   Since by default WHITELIST is commented out and BLACKLIST is "", if an SNMP_MANAGER is defined all events will generate traps.

### Messages

Using the default value for SNMP_OID (1.3.6.1.4.1.2312.13.1), traps will show up as:

      SNMPv2-MIB::snmpTrapOID.0 = OID: SNMPv2-SMI::enterprises.2312.13.1.0.30    SNMPv2-SMI::enterprises.2312.13.1.0.30.0 = STRING: "User admin@internal logged in." SNMPv2-SMI::enterprises.2312.13.1.0.30.1 = STRING: "NORMAL" SNMPv2-SMI::enterprises.2312.13.1.0.30.2 = STRING: "alertMessage"   SNMPv2-SMI::enterprises.2312.13.1.0.30.3 = STRING: "2014-01-12 07:14:22.576"

*   SNMPv2-MIB::snmpTrapOID represents the trap id for this event. we have our OID appended with 0 (because this is an enterprise specific trap). finally 30 is appended as well. This value is specific to this trap type: USER_VDC_LOGIN.

<!-- -->

*   After that you can see different values associated with this trap:
*   After that you can see different values associated with this trap:

| OID                       | Type   | Value                                      |
|---------------------------|--------|--------------------------------------------|
| SNMPv2-MIB::snmpTrapOID.0 | STRING | event message                              |
| SNMPv2-MIB::snmpTrapOID.1 | STRING | Severity (NORMAL, WARNING or ERROR)        |
| SNMPv2-MIB::snmpTrapOID.2 | STRING | Type (ALERT_MESSAGE or RESOLVED_MESSAGE) |
| SNMPv2-MIB::snmpTrapOID.3 | STRING | Log time                                   |

### Testing

This section contains instructions on setting up an snmp manager capable of receiving traps.
Tested under fedora 20 (please update if it worked for you on a different version).

      # yum install -y net-snmp

Edit the trap daemon configuration file, /etc/snmp/snmptrapd.conf:

      # Example configuration file for snmptrapd
      #
      # No traps are handled by default, you must edit this file!
      #
      authCommunity   log,execute,net public
      # traphandle SNMPv2-MIB::coldStart    /usr/bin/bin/my_great_script cold
      [snmp]
      logOption f /tmp/snmptrapd.log

Start the service:

      # service snmptrapd start

Test service by sending a trap:

      # yum install -y  net-snmp-utils
      $ snmptrap -v 2c -c public localhost '' 1.2 SNMPv2-MIB::sysLocation.0 s "just here"

Incoming traps should now be available in /tmp/snmptrapd.log.
