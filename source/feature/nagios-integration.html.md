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

A storage administrator want Red Hat Storage Server to be capable of being monitored using Nagios - an open IT infrastructure monitoring framework (http://www.nagios.org/) - to monitor the system/Gluster resources and services.

## Owner

*   Feature owner: Nishanth Thomas <nthomas@redhat.com>

## Current Status

*   Status: Feature Requirement Discussion in progress
*   Last updated date: ,

## Detailed Description

Monitoring the system/Gluster resources and services includes:

*   Monitoring of critical entities such as servers, networking, volumes, clusters and services
*   Alerting when critical infrastructure components fail and recover, providing administrators with notice of important events. Alerts can be delivered via email, SMS or SNMP.
*   Reports providing a historical record of outages, events, notifications, and alert response for later review.
*   Trending and capacity planning graphs and reports that allow for infrastructure upgrades before failures occur.

## Dependencies / Related Features

*   Nagios Core
*   Nagios Addons - NRPE , NSCA, MK Livestatus, PNP4Nagios etc
*   Nagios pluggins
*   Ovirt UI Monitoring Plugin

## Productization and Packaging

*   UI Monitoring plugin will be packaged and installed along with Ovirt.
*   Nagios core will not be packaged and installed along with Ovirt
*   Nagios addons and plugins will not be packaged and installed. This needs to taken done separately on the the monitoring nodes and the server

## User Flows

### Overview

![](Setup.png "Setup.png")

*   Ovirt will talk to the Nagios server through UI Monitoring plugin
*   Nagios core with the help of addons and plugins , collect the monitoring data from the remote nodes(eg. Gluster Node)
*   Nagios server executes checks on remote Nodes(Active checks)
*   Remote Nodes send alerts to the Nagios server in case of any status change(Passive checks)
*   Nagios server can send alerts(SNMP, e-mail, SMS) to Ovirt or any third party management applications(Tivoli, HP OpenView, BMC, CA Insight etc )

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

### Passive checks on Remote Nodes

![](passive.png "passive.png")

*   Passive checks are initiated and performed external applications/processes and results are submitted to Nagios for processing
*   To execute passive checks on gluster nodes, NSCA add-on will be used
    -   An external application(crontab / application hook / syslog monitor ) checks the status of a host or service.
    -   The external application passes the results to the NSCA client, which in turn send it to the NSCA server on the monitoring monitoring server.
    -   Nagios server will process the service check result and execute the the specific action if configured.

### Generating SNMP Traps From Nagios Server

![](trap.png "trap.png")

*   External Program/script or cron jobs or Application hooks monitor the status of specific resources/services.
*   The results are passed on to the NSCA client which in turn pass the results to NSCA server on the monitoring server.
*   Nagios server will process the result and invokes the event handler script configured for generating the SNMP traps.
*   Event handler script generate the SNMP traps with the help of the SNMP trap generator(Netsnmp or anything similar).

### Generating traps/alerts Based on the Syslog Entries

![](syslog.png "syslog.png")

*   

## Detailed Design

<Category:Feature>
