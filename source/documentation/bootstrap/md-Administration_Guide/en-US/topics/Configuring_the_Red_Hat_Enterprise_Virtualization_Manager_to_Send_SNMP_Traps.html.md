# Configuring the Red Hat Virtualization Manager to Send SNMP Traps

Configure your Red Hat Virtualization Manager to send Simple Network Management Protocol traps to one or more external SNMP managers. SNMP traps contain system event information; they are used to monitor your Red Hat Virtualization environment. The number and type of traps sent to the SNMP manager can be defined within the Red Hat Virtualization Manager.

This procedure assumes that you have configured one or more external SNMP managers to receive traps, and that you have the following details:

* The IP addresses or fully qualified domain names of machines that will act as SNMP managers. Optionally, determine the port through which the manager receives trap notifications; by default, this is UDP port 162.

* The SNMP community. Multiple SNMP managers can belong to a single community. Management systems and agents can communicate only if they are within the same community. The default community is `public`.

* The trap object identifier for alerts. The Red Hat Virtualization Manager provides a default OID of 1.3.6.1.4.1.2312.13.1.1. All trap types are sent, appended with event information, to the SNMP manager when this OID is defined. Note that changing the default trap prevents generated traps from complying with the Manager's management information base.

**Note:** The Red Hat Virtualization Manager provides management information bases at `/usr/share/doc/ovirt-engine/mibs/OVIRT-MIB.txt` and `/usr/share/doc/ovirt-engine/mibs/REDHAT-MIB.txt`. Load the MIBs in your SNMP manager before proceeding.

Default SNMP configuration values exist on the Manager in the events notification daemon configuration file `/usr/share/ovirt-engine/services/ovirt-engine-notifier/ovirt-engine-notifier.conf`. The values outlined in the following procedure are based on the default or example values provided in that file. It is recommended that you define an override file, rather than edit the `ovirt-engine-notifier.conf ` file, to persist your configuration options across system changes, like upgrades.

**Configuring SNMP Traps on the Manager**

1. On the Manager, create the SNMP configuration file:

        # vi /etc/ovirt-engine/notifier/notifier.conf.d/20-snmp.conf

2. Specify the SNMP manager(s), the SNMP community, and the OID in the following format:

        SNMP_MANAGERS="manager1.example.com manager2.example.com:162"
        SNMP_COMMUNITY=public
        SNMP_OID=1.3.6.1.4.1.2312.13.1.1

3. Define which events to send to the SNMP manager:

    **Event Examples**

    Send all events to the default SNMP profile:

        FILTER="include:*(snmp:) ${FILTER}"

    Send all events with the severity `ERROR` or `ALERT` to the default SNMP profile:

        FILTER="include:*ERROR(snmp:) ${FILTER}"
        FILTER="include:*ALERT(snmp:) ${FILTER}"

    Send events for `VDC_START` to the specified email address:

        FILTER="include:VDC_START(snmp:mail@example.com) ${FILTER}"

    Send events for everything but `VDC_START` to the default SNMP profile:
        FILTER="exclude:VDC_START include:*(snmp:) ${FILTER}"

    This the default filter defined in `ovirt-engine-notifier.conf`; if you do not disable this filter or apply overriding filters, no notifications will be sent:

        FILTER="exclude:*"

    `VDC_START` is an example of the audit log messages available. A full list of audit log messages can be found in `/usr/share/doc/ovirt-engine/AuditLogMessages.properties`. Alternatively, filter results within your SNMP manager.

4. Save the file.

5. Start the `ovirt-engine-notifier` service, and ensure that this service starts on boot:

        # systemctl start ovirt-engine-notifier.service
        # systemctl enable ovirt-engine-notifier.service

Check your SNMP manager to ensure that traps are being received.

**Note:** `SNMP_MANAGERS`, `MAIL_SERVER`, or both must be properly defined in `/usr/share/ovirt-engine/services/ovirt-engine-notifier/ovirt-engine-notifier.conf ` or in an override file in order for the notifier service to run.
