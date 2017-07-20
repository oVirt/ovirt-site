---
title: oVirt Metrics Store
category: feature
authors: sradco
feature_name: oVirt Metrics Store
feature_modules: engine
feature_status: In Development
---
# oVirt Metrics Store

## Summary

This feature will introduce real-time monitoring for the oVirt project.

Real-time monitoring will provide visibility into the user's complete infrastructure.

## Owner

*   Name: Shirly Radco (sradco)
*   Email: <sradco@redhat.com>

## Current status

*   Target Release: 4.1
*   Status: Released
*   Last updated: Mon 12 Jun 2017

## Description

In 4.1, collectd and fluentd are already installed on the hosts and engine machines.
We have an Ansible script that configures them on all relevant hosts.

We plan to continue adding additional logs and metrics as required, add pre-defined dashboards and alerting that will detect and notify the user when something goes wrong in the environment, based on SLA events, thresholds, etc.

## Installtion Guide

Follow the installation guild at - [Metrics Store - Installation Guide](http://www.ovirt.org/develop/release-management/features/engine/metrics-store-installation-guide/)

## Collected Data

Follow the list of collected metrics and logs at - [Metrics Store - Collected Data](http://www.ovirt.org/develop/release-management/features/engine/metrics-store-collected-metrics/)
