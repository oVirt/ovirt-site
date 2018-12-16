---
title: Verifying the Installation
---

# Verifying the Installation

Access the Kibana console to view the logs and statistics about clusters, hosts, virtual machines, and the Manager.

**Verifying the Installation**

1. Access Kibana at https://kibana.*<FQDN>*.

2. In the **Discover** tab, check that you can view the **project.ovirt-logs-_ovirt_env_name_-uuid&#42;** index, where *ovirt_env_name* is the name you defined in [Configuring Collectd and Fluentd](Configuring_Collectd_and_Fluentd).
   See the [Discover](https://www.elastic.co/guide/en/kibana/4.5/discover.html) section in the *Kibana documentation* for more information about working with logs.

3. Use the **Visualization** tab to build visualization for the  **project.ovirt-metrics-_ovirt_env_name_-uuid&#42;**
and the **project.ovirt-logs-_ovirt_env_name_-uuid&#42;** indexes.

See the Metrics User Guide for the available parameters. See the [Visualize](https://www.elastic.co/guide/en/kibana/4.5/visualize.html) section of the *Kibana documentation* for more information about visualizing logs and metrics.

    **Note:** You can access the OpenShift portal at https://*FQDN*:8443.

**Prev:** [Chapter 3: Setting Up OpenShift Aggregated Logging](Setting_Up_OpenShift_Aggregated_Logging)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/metrics_store_installation_guide/verifying_the_installation)
