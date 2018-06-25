---
title: Event Notifications
---

# Chapter 17: Event Notifications

## Configuring Event Notifications in the Administration Portal

The oVirt Engine can notify designated users via email when specific events occur in the environment that the oVirt Engine manages. To use this functionality, you must set up a mail transfer agent to deliver messages. Only email notifications can be configured through the Administration Portal. SNMP traps must be configured on the Engine machine.

**Configuring Event Notifications**

1. Ensure you have set up the mail transfer agent with the appropriate variables.

2. Use the **Users** resource tab, tree mode, or the search function to find and select the user to which event notifications will be sent.

3. Click the **Event Notifier** tab in the details pane to list the events for which the user will be notified. This list is blank if you have not configured any event notifications for that user.

4. Click **Manage Events** to open the **Add Event Notification** window.

    **The Add Events Notification Window**

    ![](/images/admin-guide/5607.png)

5. Use the **Expand All** button or the subject-specific expansion buttons to view the events.

6. Select the appropriate check boxes.

7. Enter an email address in the **Mail Recipient** field.

8. Click **OK** to save changes and close the window.

9. Add and start the `ovirt-engine-notifier` service on the oVirt Engine. This activates the changes you have made:

        # systemctl daemon-reload
        # systemctl enable ovirt-engine-notifier.service
        # systemctl restart ovirt-engine-notifier.service

**Result**

The specified user now receives emails based on events in the oVirt environment. The selected events display on the **Event Notifier** tab for that user.

# Canceling Event Notifications in the Administration Portal

**Summary**

A user has configured some unnecessary email notifications and wants them canceled.

**Canceling Event Notifications**

1. In the **Users** tab, select the user or the user group.

2. Select the **Event Notifier** tab in the details pane to list events for which the user receives email notifications.

3. Click **Manage Events** to open the **Add Event Notification** window.

4. Use the **Expand All** button, or the subject-specific expansion buttons, to view the events.

5. Clear the appropriate check boxes to remove notification for that event.

6. Click **OK** to save changes and close the window.

**Result**

You have canceled unnecessary event notifications for the user.

## Parameters for Event Notifications in ovirt-engine-notifier.conf

The event notifier configuration file can be found in `/usr/share/ovirt-engine/services/ovirt-engine-notifier/ovirt-engine-notifier.conf`.

**ovirt-engine-notifier.conf variables**

| Variable Name | Default | Remarks |
|-
| SENSITIVE_KEYS | none | A comma-separated list of keys that will not be logged. |
| JBOSS_HOME | /usr/share/jbossas | The location of the JBoss application server used by the Engine. |
| ENGINE_ETC | /etc/ovirt-engine | The location of the `etc` directory used by the Engine. |
| ENGINE_LOG | /var/log/ovirt-engine | The location of the `logs` directory used by the Engine. |
| ENGINE_USR | /usr/share/ovirt-engine | The location of the `usr` directory used by the Engine. |
| ENGINE_JAVA_MODULEPATH | ${ENGINE_USR}/modules | The file path to which the JBoss modules are appended. |
| NOTIFIER_DEBUG_ADDRESS | none | The address of a machine that can be used to perform remote debugging of the Java virtual machine that the notifier uses. |
| NOTIFIER_STOP_TIME | 30 | The time, in seconds, after which the service will time out. |
| NOTIFIER_STOP_INTERVAL | 1 | The time, in seconds, by which the timeout counter will be incremented. |
| INTERVAL_IN_SECONDS | 120 | The interval in seconds between instances of dispatching messages to subscribers. |
| IDLE_INTERVAL | 30 | The interval, in seconds, between which low-priority tasks will be performed. |
| DAYS_TO_KEEP_HISTORY | 0 | This variable sets the number of days dispatched events will be preserved in the history table. If this variable is not set, events remain on the history table indefinitely. |
| FAILED_QUERIES_NOTIFICATION_THRESHOLD | 30 | The number of failed queries after which a notification email is sent. A notification email is sent after the first failure to fetch notifications, and then once every time the number of failures specified by this variable is reached. If you specify a value of `0` or `1`, an email will be sent with each failure. |
| FAILED_QUERIES_NOTIFICATION_RECIPIENTS | none | The email addresses of the recipients to which notification emails will be sent. Email addresses must be separated by a comma. This entry has been deprecated by the `FILTER` variable. |
| DAYS_TO_SEND_ON_STARTUP | 0 | The number of days of old events that will be processed and sent when the notifier starts. |
| FILTER | exclude:* | The algorithm used to determine the triggers for and recipients of email notifications. The value for this variable comprises a combination of `include` or `exclude`, the event, and the recipient. For example, `include:VDC_START(smtp:mail@example.com) ${FILTER}` |
| MAIL_SERVER | none | The SMTP mail server address. Required. |
| MAIL_PORT | 25 | The port used for communication. Possible values include `25` for plain SMTP, `465` for SMTP with SSL, and `587` for SMTP with TLS. |
| MAIL_USER | none | If SSL is enabled to authenticate the user, then this variable must be set. This variable is also used to specify the "from" user address when the MAIL_FROM variable is not set. Some mail servers do not support this functionality. The address is in RFC822 format. |
| SENSITIVE_KEYS | ${SENSITIVE_KEYS},MAIL_PASSWORD | Required to authenticate the user if the mail server requires authentication or if SSL or TLS is enabled. |
| MAIL_PASSWORD | none | Required to authenticate the user if the mail server requires authentication or if SSL or TLS is enabled. |
| MAIL_SMTP_ENCRYPTION | none | The type of encryption to be used in communication. Possible values are `none`, `ssl`, `tls`. |
| HTML_MESSAGE_FORMAT | false | The mail server sends messages in HTML format if this variable is set to `true`. |
| MAIL_FROM | none | This variable specifies a sender address in RFC822 format, if supported by the mail server. |
| MAIL_REPLY_TO | none | This variable specifies reply-to addresses in RFC822 format on sent mail, if supported by the mail server. |
| MAIL_SEND_INTERVAL | 1 | The number of SMTP messages to be sent for each IDLE_INTERVAL |
| MAIL_RETRIES | 4 | The number of times to attempt to send an email before failing. |
| SNMP_MANAGER | none | The IP addresses or fully qualified domain names of machines that will act as the SNMP managers. Entries must be separated by a space and can contain a port number. For example, `manager1.example.com manager2.example.com:164` |
| SNMP_COMMUNITY | public | The default SNMP community. |
| SNMP_OID | 1.3.6.1.4.1.2312.13.1.1 | The default trap object identifiers for alerts. All trap types are sent, appended with event information, to the SNMP manager when this OID is defined. Note that changing the default trap prevents generated traps from complying with the Engine's management information base. |
| ENGINE_INTERVAL_IN_SECONDS | 300 | The interval, in seconds, between monitoring the machine on which the Engine is installed. The interval is measured from the time the monitoring is complete. |
| ENGINE_MONITOR_RETRIES | 3 | The number of times the notifier attempts to monitor the status of the machine on which the Engine is installed in a given interval after a failure. |
| ENGINE_TIMEOUT_IN_SECONDS | 30 | The time, in seconds, to wait before the notifier attempts to monitor the status of the machine on which the Engine is installed in a given interval after a failure. |
| IS_HTTPS_PROTOCOL | false | This entry must be set to `true` if JBoss is being run in secured mode. |
| SSL_PROTOCOL | TLS | The protocol used by JBoss configuration connector when SSL is enabled. |
| SSL_IGNORE_CERTIFICATE_ERRORS | false | This value must be set to `true` if JBoss is running in secure mode and SSL errors is to be ignored. |
| SSL_IGNORE_HOST_VERIFICATION | false | This value must be set to `true` if JBoss is running in secure mode and host name verification is to be ignored. |
| REPEAT_NON_RESPONSIVE_NOTIFICATION | false | This variable specifies whether repeated failure messages will be sent to subscribers if the machine on which the Engine is installed is non-responsive. |
| ENGINE_PID | /var/lib/ovirt-engine/ovirt-engine.pid | The path and file name of the PID of the Engine. |

## Configuring the oVirt Engine to Send SNMP Traps

Configure your oVirt Engine to send Simple Network Management Protocol traps to one or more external SNMP managers. SNMP traps contain system event information; they are used to monitor your oVirt environment. The number and type of traps sent to the SNMP manager can be defined within the oVirt Engine.

This procedure assumes that you have configured one or more external SNMP managers to receive traps, and that you have the following details:

* The IP addresses or fully qualified domain names of machines that will act as SNMP managers. Optionally, determine the port through which the manager receives trap notifications; by default, this is UDP port 162.

* The SNMP community. Multiple SNMP managers can belong to a single community. Management systems and agents can communicate only if they are within the same community. The default community is `public`.

* The trap object identifier for alerts. The oVirt Engine provides a default OID of 1.3.6.1.4.1.2312.13.1.1. All trap types are sent, appended with event information, to the SNMP manager when this OID is defined. Note that changing the default trap prevents generated traps from complying with the Engine's management information base.

**Note:** The oVirt Engine provides management information bases at `/usr/share/doc/ovirt-engine/mibs/OVIRT-MIB.txt` and `/usr/share/doc/ovirt-engine/mibs/REDHAT-MIB.txt`. Load the MIBs in your SNMP manager before proceeding.

Default SNMP configuration values exist on the Engine in the events notification daemon configuration file `/usr/share/ovirt-engine/services/ovirt-engine-notifier/ovirt-engine-notifier.conf`. The values outlined in the following procedure are based on the default or example values provided in that file. It is recommended that you define an override file, rather than edit the `ovirt-engine-notifier.conf ` file, to persist your configuration options across system changes, like upgrades.

**Configuring SNMP Traps on the Engine**

1. On the Engine, create the SNMP configuration file:

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

        FILTER="include:*:ERROR(snmp:) ${FILTER}"
        FILTER="include:*:ALERT(snmp:) ${FILTER}"

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

**Prev:** [Chapter 16: Quotas and Service Level Agreement Policy](../chap-Quotas_and_Service_Level_Agreement_Policy)<br>
**Next:** [Chapter 18: Utilities](../chap-Utilities)
