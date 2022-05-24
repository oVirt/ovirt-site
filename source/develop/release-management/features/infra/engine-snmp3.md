---
title: SNMPv3
category: feature
authors: rnori
feature_name: Add support to send SNMPv3 traps from notifier
feature_modules: engine
feature_status: In Development
---
# engine-snmp

## oVirt Engine SNMPv3 Traps

See also [Features/configuration-event-subscribers](/develop/developer-guide/events/configuration-event-subscribers.html).

### Summary

This feature extends events notifier capabilities and enables it to generate SNMPv3 traps out of system events to integrate oVirt with generic monitoring systems.

### Owner

*   Name: Ravi Nori (rnori)
*   Email: <rnori@redhat.com>

### Current status

*   Target Release: 4.1
*   Status: Post
*   Last updated: 

### Configuration

Add a new configuration file /etc/ovirt-engine/notifier/notifier.conf.d/99-snmp.conf to configure the SNMP.

Configuration for sending SNMPv3 NoAuthNoPriv traps as user 'NoAuthNoPriv'.

      SNMP_MANAGERS=localhost:162
      SNMP_OID=1.3.6.1.4.1.2312.13.1.1
      FILTER="include:*(snmp:)"
      SNMP_VERSION=3
      SNMP_ENGINE_ID="80:00:00:00:01:02:06:06"
      SNMP_USERNAME=NoAuthNoPriv
      SNMP_SECURITY_LEVEL=1

Configuration for sending SNMPv3 AuthNoPriv traps as user 'ovirtengine' with snmp auth passphrase 'authpass'.

      SNMP_MANAGERS=localhost:162
      SNMP_OID=1.3.6.1.4.1.2312.13.1.1
      FILTER="include:*(snmp:)"
      SNMP_VERSION=3
      SNMP_ENGINE_ID="80:00:00:00:01:02:05:05"
      SNMP_USERNAME=ovirtengine
      SNMP_AUTH_PROTOCOL=MD5
      SNMP_AUTH_PASSPHRASE=authpass
      SNMP_SECURITY_LEVEL=2

Configuration for sending SNMPv3 AuthPriv traps as user 'ovirtengine'  with snmp auth passphrase 'authpass' and snmp priv passphrase 'privpass'.

      SNMP_MANAGERS=localhost:162
      SNMP_OID=1.3.6.1.4.1.2312.13.1.1
      FILTER="include:*(snmp:)"
      SNMP_VERSION=3
      SNMP_ENGINE_ID="80:00:00:00:01:02:05:05"
      SNMP_USERNAME=ovirtengine
      SNMP_AUTH_PROTOCOL=MD5
      SNMP_AUTH_PASSPHRASE=authpass
      SNMP_PRIVACY_PROTOCOL=AES128
      SNMP_PRIVACY_PASSPHRASE=privpass
      SNMP_SECURITY_LEVEL=3


### Net-Snmp configuration

#### Stop snmp services

      # service snmpd stop
      # service snmptrapd stop

#### Edit /etc/snmp/snmptrapd.conf to support version 3 traps and log traps to file.

      # version 3 traps: allow user ovirtengine to log,execute,net
      authUser log,execute,net ovirtengine
      
      # version 3 add a user NoAuthnoPriv who can send noAuthNoPriv 
      authUser log,execute,net NoAuthNoPriv noauth
      # Log incoming traps to /var/log/snmptrapd.log
      logOption f /var/log/snmptrapd.log

With latest net-snmp-5.7.3-38.fc28.x86_64 logOption is moved to a library specific directive from an application-level one.
Edit /etc/snmp/snmptrapd.conf to add the library specific directive in front of logOption. 

      # Log incoming traps to /var/log/snmptrapd.log
      [snmp] logOption f /var/log/snmptrapd.log

You will have to change SELinux settings on /var/log/snmptrapd.log in order to get write permissions

chcon -t snmpd_log_t /var/log/snmptrapd.log


#### Create the users

edit /var/lib/net-snmp/snmpd.conf add createUser to support version 3 traps
and 
edit /var/lib/net-snmp/snmptrapd.conf add creatUser to support version 3 traps

      createUser -e 0x8000000001020505 ovirtengine MD5 authpass AES privpass
      createUser -e 0x8000000001020606 NoAuthNoPriv
  
#### Edit /etc/snmp/snmpd.conf

      rwuser ovirtengine
      rwuser NoAuthNoPriv noauth

#### Start the snmp services

      # service snmpd start
      # service snmptrapd start

#### Test by sending SNMPv3 traps

      # snmptrap -v 3 -n "" -l noAuthNoPriv -u NoAuthNoPriv -e 0x8000000001020606 localhost 0 linkUp.0
      # snmptrap -v 3 -n "" -a MD5 -A authpass -l authNoPriv -u ovirtengine -e 0x8000000001020505 localhost 0 linkUp.0
      # snmptrap -v 3 -n "" -a MD5 -A authpass -x AES -X privpass -l authPriv -u ovirtengine -e 0x8000000001020505 localhost 0 linkUp.0


#### See traps in /var/log/snmptrapd.log

      tail -n 40 /var/log/snmptrapd.log


  Notes:

*   SNMP_MANAGER (net-snmp) must be properly installed and configured in order for the notifier to send SNMPv3 traps.
