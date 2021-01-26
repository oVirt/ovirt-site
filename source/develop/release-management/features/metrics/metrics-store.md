---
title: oVirt Metrics Store
category: feature
authors: sradco
---
<div class="alert alert-warning">
  <strong>ATTENTION: This page is no longer up to date. Please follow the link for the updated documentation:</strong>
  <br/>
  * <a href="/documentation/administration_guide/#monitoring_and_observability">Monitoring and observability</a>
</div>

# oVirt Metrics Store

## Summary

This feature will introduce real-time monitoring for the oVirt project.

Real-time monitoring will provide visibility into the user's complete infrastructure.

The oVirt Metrics Store is based on the [OpenShift Logging](https://github.com/openshift/origin-aggregated-logging) stack.
It consists of multiple components abbreviated as the "EFK" stack: Elasticsearch, Rsyslog, Kibana.
You can use either the OpenShift Container Platform (OCP) based on RHEL7, or OpenShift Origin (Origin) based on CentOS7.
[Ansible](https://github.com/openshift/openshift-ansible) is used to install logging using the OpenShift Ansible logging [roles](https://github.com/openshift/openshift-ansible/blob/release-3.11/roles/openshift_logging/README.md).

On the oVirt hosts, Collectd is used to send metrics about the host, engine and vms to a local Rsyslog.
Rsyslog is used to collect Engine, VDSM logs and the Collectd metrics, parse the data and add additional metadata and send the data to the remote metrics store.

Collectd and Rsyslog configurations are deployed using Ansible, that are also run as part of host deploy for every new/reilnstalled host.

## Owner

*   Name: Shirly Radco (sradco)
*   Email: <sradco@redhat.com>

## Current Status

*   Target Release: 4.2
*   Status: Released
*   Last updated: Tue 26 Jun 2018

## Description

Collectd and Fluentd are installed on the hosts and engine machines, since 4.2.
In 4.3 Fluentd was replaced by Rsyslog for better performance.
When upgrading from 4.2.z to 4.3 the Fluentd packages are still installed on the machine, but the servive is stopped and disabled.
We have an Ansible script that configures the service on all relevant hosts.

There are 3 pre-defined dashboards that can be imported into Kibana as part of the installation proicess.

We plan to continue adding additional logs and metrics as required, add pre-defined dashboards and alerting,
that will detect and notify the user when something goes wrong in the environment, based on SLA events, thresholds, etc.

## Installation Guide

Follow the installation guide at:  [Metrics Store - Installation Guide](/develop/release-management/features/metrics/metrics-store-installation.html)

## Collected Data

Follow the list of collected metrics and logs at:  [Metrics Store - Collected Data](/develop/release-management/features/metrics/metrics-store-collected-metrics.html)

## Metrics Schema

Follow the metrics schema, when creating your reports, at: [Metrics Store - Schema](/develop/release-management/features/metrics/metrics-store-schema.html)
