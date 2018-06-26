---
title: oVirt Metrics Store
category: feature
authors: sradco
feature_name: oVirt Metrics Store
feature_modules: engine
feature_status: In Production
---
# oVirt Metrics Store

## Summary

This feature will introduce real-time monitoring for the oVirt project.

Real-time monitoring will provide visibility into the user's complete infrastructure.

The oVirt Metrics Store is based on the [OpenShift Logging](https://github.com/openshift/origin-aggregated-logging) stack.
It consists of multiple components abbreviated as the "EFK" stack: Elasticsearch, Fluentd, Kibana.
You can use either the OpenShift Container Platform (OCP) based on RHEL7, or OpenShift Origin (Origin) based on CentOS7. [Ansible](https://github.com/openshift/openshift-ansible) is used to install logging using the OpenShift Ansible logging [roles](https://github.com/openshift/openshift-ansible/blob/master/roles/openshift_logging/README.md).

On the oVirt hosts, Collectd is used to send metrics about the host, engine and vms to a local Fluentd. Fluentd is used to collectd Engine, VDSM logs and the Collectd metrics, parse the data and add additional metadata and send the data to the remote metrics store.

Collectd and Fluentd configurations are deployed using Ansible, that are also run as part of host deploy for every new/reilnstalled host.

## Owner

*   Name: Shirly Radco (sradco)
*   Email: <sradco@redhat.com>

## Current Status

*   Target Release: 4.2
*   Status: Released
*   Last updated: Tue 26 Jun 2018

## Description

Since 4.1, collectd and fluentd are already installed on the hosts and engine machines.
We have an Ansible script that configures them on all relevant hosts.

We plan to continue adding additional logs and metrics as required, add pre-defined dashboards and alerting that will detect and notify the user when something goes wrong in the environment, based on SLA events, thresholds, etc.

## Installation Guide

Follow the installation guide at:  [Metrics Store - Installation Guide](http://www.ovirt.org/develop/release-management/features/metrics/metrics-store-installation/)

## Collected Data

Follow the list of collected metrics and logs at:  [Metrics Store - Collected Data](http://www.ovirt.org/develop/release-management/features/metrics/metrics-store-collected-metrics/)

## Metrics Schema

Follow the metrics schema, when creating your reports, at: [Metrics Store - Schema](http://www.ovirt.org/develop/release-management/features/metrics/metrics-store-schema/)
