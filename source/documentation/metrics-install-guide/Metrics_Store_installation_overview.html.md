---
title: Introduction
---

# Installing Metrics Store for oVirt


## Abstract
A comprehensive guide to installing and configuring Metrics Store for oVirt. Metrics Store collects logs and metrics for oVirt 4.2 and later.

## Chapter 1. Metrics Store installation overview

The Metrics Store installation involves the following key steps:

1. [Creating the Metrics Store virtual machines]
2. [Deploying OpenShift and Metrics Store services on the virtual machines]
3. [Deploying Collectd and Rsyslog on the hosts]
4. [Verifying the Metrics Store installation]

## Metrics Store architecture and workflow

The Metrics Store architecture is based on the [OpenShift EFK logging](https://docs.openshift.com/container-platform/3.11/install_config/aggregate_logging.html) stack, running on [OpenShift Container Platform 3.11](https://docs.okd.io/3.11).

The workflow involves the following steps and services, running on the hosts or the Metrics Store virtual machines:

1. [Collectd](https://collectd.org/) (hosts) collects metrics from hosts, virtual machines, and databases in the oVirt environment.
2. [Rsyslog](https://www.rsyslog.com/) (hosts version 4.3 and above) gathers the metrics and log data, enriches the data with metadata, and sends the enriched data to Elasticsearch.
3. [Fluentd](https://www.fluentd.org/) (hosts version 4.2) gathers the metrics and log data, enriches the data with metadata, and sends the enriched data to Elasticsearch.
4. [Elasticsearch](https://www.elastic.co/) (Metrics Store virtual machine) stores and indexes the data.
5. [Kibana](https://www.elastic.co/products/kibana) (Metrics Store virtual machine) provides dashboards, charts, and data analysis.

**Next:** [Chapter 2. Installing Metrics Store](Installing_Metrics_Store)

[Adapted from RHV 4.3 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.3/html-single/metrics_store_installation_guide/index#Metrics_store_installation_overview)
