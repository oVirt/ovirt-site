---
title: engine-snmp
authors:
  - arthur.berezin
  - moolit
  - moti
  - pbenas
---

# engine-snmp

## oVirt Engine SNMP Traps

> ATTENTION:
> This page is no longer up to date as of ovirt-engine-3.5.0 that introduced MIB support at <https://bugzilla.redhat.com/show_bug.cgi?id=1136818>

See also [Features/configuration-event-subscribers](/develop/developer-guide/events/configuration-event-subscribers.html).

### Summary

This feature extends events notifier capabilities and enables it to generate SNMP traps out of system events to integrate oVirt with generic monitoring systems.

### Owner

*   Name: Mooli Tayer (mtayer)
*   Name: Arthur Berezin (aberezin)

### Current status

*   Target Release: 3.4
*   Status: Post

### Benefit to oVirt

Allow oVirt users to monitor their virtualization environment with open source or proprietary monitoring systems such as Nagios, BMC Patrol, HP OpenView, etc.

### Detailed Description

This feature extends the capabilities of the ovirt-engine-notifier to send all engine events and events' data via SNMP traps version 2c.
 A new 'SNMP_TRAP Notifications' section is now available in the notifier's configuration file under
/usr/share/ovirt-engine/services/ovirt-engine-notifier/ovirt-engine-notifier.conf
(It's advisable to leave that file as is and define override file[s] under /etc/ovirt-engine/notifier/notifier.conf.d/) Lets take a look;

      #-------------------------#
      # SNMP_TRAP Notifications #
      #-------------------------#
      # Send v2c snmp notifications
      # Minimum SNMP configuration
      #
      # Create @ENGINE_ETC@/notifier/notifier.conf.d/20-snmp.conf with:
      # SNMP_MANAGERS="host"
      # FILTERS="include:*(snmp:) ${FILTERS}"
      # Default whitespace separated IP/DNS list with optional port, default is 162.
      # SNMP_MANAGERS=manager1.example.com manager2.example.com:164
      SNMP_MANAGERS=
      # Default SNMP Community String.
      SNMP_COMMUNITY=public
      # Default TRAP Object Identifier for alerts.
      #
      # iso.organization.DoD.Internet.private.enterprises.redhat.ovirt-engine.notifications.audit-log
      # 1.3.6.1.4.1.2312.13.1.1
      SNMP_OID=1.3.6.1.4.1.2312.13.1.1
      #
      # SNMP profile support
      #
      # Multiple SNMP profiles are supported.
      # Specify profile settings by using _profile suffix,
      # for example, to define a profile to sent specific
      # message to host3, specify:
      # SNMP_MANAGERS_profile1=host3
      # FILTER="include:VDC_START(snmp:profile1) ${FILTER}"
      #

Notes:

*   At least one of SNMP_MANAGERS & MAIL_SERVER must be properly defined in order for the notifier to run.

### Messages

Using the default value for SNMP_OID (1.3.6.1.4.1.2312.13.1), traps will show up as:

      SNMPv2-MIB::snmpTrapOID.0 = OID: SNMPv2-SMI::enterprises.2312.13.1.0.30    SNMPv2-SMI::enterprises.2312.13.1.0.30.0 = STRING: "User admin@internal logged in." SNMPv2-SMI::enterprises.2312.13.1.0.30.1 = STRING: "NORMAL" SNMPv2-SMI::enterprises.2312.13.1.0.30.2 = STRING: "alertMessage"   SNMPv2-SMI::enterprises.2312.13.1.0.30.3 = STRING: "2014-01-12 07:14:22.576"

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

      # yum install -y net-snmp

Edit the trap daemon configuration file, /etc/snmp/snmptrapd.conf:

      # Example configuration file for snmptrapd
      #
      # No traps are handled by default, you must edit this file!
      #
      authCommunity   log,execute,net public
      # traphandle SNMPv2-MIB::coldStart    /usr/bin/bin/my_great_script cold
      [snmp]
      logOption f /tmp/snmptrapd.log

Start the service:

      # service snmptrapd start

Test service by sending a trap:

      # yum install -y  net-snmp-utils
      $ snmptrap -v 2c -c public localhost "" 1.2 SNMPv2-MIB::sysLocation.0 s "just here"

Incoming traps should now be available in /tmp/snmptrapd.log.

See [fodora instructions for net-snmp](http://docs.fedoraproject.org/en-US/Fedora/16/html/System_Administrators_Guide/sect-System_Monitoring_Tools-Net-SNMP-Configuring.html) and the [net-snmp project page](http://www.net-snmp.org/) for further instructions.
