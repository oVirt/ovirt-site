---
title: Nagios Integration
category: feature
authors: kmayilsa, nthomas, rnahcimu, sahina
wiki_category: Feature
wiki_title: Features/Nagios Integration
wiki_revision_count: 76
wiki_last_updated: 2014-06-27
---

# Nagios Integration

## Summary

An administrator want managed nodes to be capable of being monitored using Nagios - an open IT infrastructure monitoring framework (http://www.nagios.org/) - to monitor the system/Gluster resources and services.

## Owner

*   Feature owner: Nishanth Thomas <nthomas@redhat.com>

## Current Status

*   Status: Design
*   Last updated date: ,

## Detailed Description

Monitoring the system resources and services includes:

*   Monitoring of critical entities such as servers, networking, volumes, clusters and services
*   Alerting when critical infrastructure components fail and recover, providing administrators with notice of important events. Alerts can be delivered via email, SMS or SNMP.
*   Reports providing a historical record of outages, events, notifications, and alert response for later review.
*   Trending and capacity planning graphs and reports that allow for infrastructure upgrades before failures occur.

**The diagram below provides an overview about the proposed architecture**

![](Setup.png "Setup.png")

*   Ovirt will talk to the Nagios server through UI Monitoring plugin
*   Nagios core with the help of addons and plugins , collect the monitoring data from the remote nodes(eg. Gluster Node)
*   Nagios server executes checks on remote Nodes(Active checks)
*   Remote Nodes send alerts to the Nagios server in case of any status change(Passive checks)
*   Nagios server can send alerts(SNMP, e-mail, SMS) to Ovirt or any third party management applications(Tivoli, HP OpenView, BMC, CA Insight etc )

## Dependencies / Related Features

*   Nagios Core
*   Nagios Addons - NRPE , NSCA, MK Livestatus, PNP4Nagios etc
*   Nagios pluggins
*   Ovirt UI Monitoring Plugin

## Productization and Packaging

*   Nagios core will not be packaged and installed along with Ovirt
*   Nagios addons and plugins will not be packaged and installed. This needs to taken done separately on the the monitoring nodes and the server

## User Flows

### Auto Configuration

*   Nagios works with configuration files. It uses configuration files to schedule the jobs to execute the checks(to collect monitoring data), send alerts and for everything.
*   The configuration files spread over multiple files and directories.
*   Nagios configuration needs to be updated when there is any addition/deletion/modification of any logical or physical entities from Ovirt.
*   This needs to be handled smoothly without any manual intervention from the user.

### Active Checks on Remote Nodes

![](active.png "active.png")

*   Active checks are initiated by the Nagios and run on a regularly scheduled basis.
*   To execute active checks on gluster nodes, NRPE add-on will be used
    -   NRPE will execute plug-ins to monitor local resources/attributes like disk usage, CPU load, memory usage, etc. on the gluster nodes
*   Check results will be send back to the Nagios server and if there is a service state change, alerts/traps will be send based on the configuration.

### Passive checks on Remote Nodes

![](passive.png "passive.png")

*   Passive checks are initiated and performed external applications/processes and results are submitted to Nagios for processing
*   To execute passive checks on gluster nodes, NSCA add-on will be used
    -   An external application(crontab / application hook / syslog monitor ) checks the status of a host or service.
    -   The external application passes the results to the NSCA client, which in turn send it to the NSCA server on the monitoring monitoring server.
*   Nagios server will process the service check result and execute the the specific action if configured.

### Generating SNMP Traps/Alerts From Nagios Server

![](trap.png "trap.png")

*   External Program/script/cron jobs or Application hooks monitor the status of specific resources/services.
*   The results are passed on to the NSCA client which in turn pass the results to NSCA server on the monitoring server.
*   Nagios server will process the result and invokes the event handler script configured for generating the SNMP traps.
*   Event handler script generate the SNMP traps with the help of the SNMP trap generator(Netsnmp or anything similar).
*   If there is a service state change, Nagios will send alerts(SMS, Email) based on the configuration.

*Alternatively Traps/alerts can be generated based on the result of an active check*

### Generating traps/alerts Based on the Syslog Entries

![](syslog.png "syslog.png")

*   Nagios server initiates the check by invoking the NRPE client.
*   NRPE client passes the information to NRPE server running on the remote host, which in turn executes the check_logfiles plugin.
*   If there is any matching pattern :
    1.  Configured action scripts get executed, which will send traps/alerts to the Nagios server
    2.  Status will be returned back to Nagios server.
*   Nagios server will process the alerts/traps and invokes the event handler script to perform additional actions(SNMP traps, SMS, E-mail etc.).

*'Alternatively check_logfiles plugin can be executed from an external program as a passive check*

## Plugins

*   Nagios plugins needs to be developed to monitor specific scenarios of interest for Ovirt
*   Nagios/External applications will execute these plugins periodically(Active/Passive checks) and update the status of monitored resources/services/operations

### Resources to be Monitored

*   List of Physical Resources that need to be monitored :
    1.  Hosts (Servers)
    2.  CPU
    3.  Memory/Swap
    4.  Network
    5.  Disks

<!-- -->

*   List of Logical Resources that need to be monitored :
    1.  Cluster(Gluster specific)
    2.  Volume(Gluster specific)
    3.  Brick(Gluster specific)
    4.  LVM

<!-- -->

*   Parameters that should be monitored for logical and physical resources :
    1.  Operational Status
    2.  Utilization
    3.  Capacity
    4.  Usage

## Services/Operations to be monitored

*   Monitoring of Access Services such as:
    1.  NFS
    2.  Swift/Object
    3.  SMB
    4.  CTDB

<!-- -->

*   Monitoring of background operations such as:
    1.  Remove Brick(Gluster specific)
    2.  Re-balance(Gluster specific)
    3.  Self-Heal(Gluster specific)
    4.  Geo-Replication(Gluster specific)
    5.  Replace Brick(Gluster specific)

<!-- -->

*   Alerting mechanisms needed for spilt-brain

## Detailed Design

TO DO

<Category:Feature>
