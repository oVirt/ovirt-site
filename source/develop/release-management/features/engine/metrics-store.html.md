---
title: Metrics Store
category: feature
authors: sradco
feature_name: Add support for modern metrics store, reporting and alerting
feature_modules: engine
feature_status: In Development
---
# Metrics Store

## Summary

This feature will introduce real-time monitoring for the oVirt project.

Real-time monitoring will provide visibility into the user's complete infrastructure.

## Owner

*   Name: Shirly Radco (sradco)
*   Email: <sradco@redhat.com>

## Current status

*   Target Release: 4.1
*   Status: Released
*   Last updated: Mon 24 Jan 2017

## Description

[![oVirt Metrics Store Architecture](/images/wiki/MetricsStoreArchitecture.jpg)](images/wiki/MetricsStoreArchitecture.jpg)

In 4.1, Collectd will be already installed and configured on the hosts.
We plan to further integrate it with external tools to collect, aggregate and visualize metrics and logs.

In the next version, Collectd will be installed and configured with the engine as well.

We also plan on adding Aletring that will detect and notify the user in case something goes wrong in his environment,
based on SLA events, thresholds etc.

## See Also

[oVirt Metrics – EFK](https://sradcoblog.wordpress.com/2016/07/19/ovirt-metrics-elk/)
