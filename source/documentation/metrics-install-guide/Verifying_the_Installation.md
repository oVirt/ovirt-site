---
title: Verifying the Installation
---

# 4. Verifying the Metrics Store installation

Verify the Metrics Store installation using the Kibana console. You can view the collected logs and create data visualizations.

## Procedure

1. Log in to the Kibana console using the URL `(https://kibana.example.com)` that you recorded in [Section 2.2, “Deploying OpenShift and Metrics Store services”]().

Optionally, you can access the OpenShift Container Platform portal at `https://example.com:8443`.

2. In the **Discover** tab, check that you can view the `project.*` or `project.ovirt-logs-ovirt_env_name-uuid` index.

See the [Discover](https://www.elastic.co/guide/en/kibana/5.6/discover.html) section in the Kibana User Guide for information about working with logs.

3. In the **Visualization** tab, you can create data visualizations for the `project.*` for admin user or using the `project.ovirt-metrics-ovirt_env_name-uuid` and the `project.ovirt-logs-ovirt_env_name-uuid` indexes for non-admin user .

The [Metrics Store User Guide](/documentation/metrics-user-guide/metrics-user-guide) describes the available parameters. See the Visualize section of the Kibana User Guide for information about visualizing logs and metrics.

**Prev:** [Chapter 3: Deploying Collectd and Rsyslog](Deploying_Collectd_and_Rsyslog)

[Adapted from RHV 4.3 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.3/html-single/metrics_store_installation_guide/index#Verifying_the_metrics_store_installation)
