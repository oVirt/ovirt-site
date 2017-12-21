---
title: Monitor Your oVirt Environment with oVirt Metrics Store
author: sradco
tags: oVirt Metrics Store
date: 2017-12-04 09:00:00 CET
---

The oVirt project now includes a unified metrics and logs real-time monitoring solution for the oVirt environment.

Using Elasticsearch - a search and analytics engine - and its native visualization layer, Kibana, we now provide oVirt project users with a fully functional monitoring solution.

READMORE

The solution includes self-service dashboards for creating your own dashboard, reports, and log analysis for both the engine and VDSM logs.

**The Kibana dashboard**
![](/images/Kibana_dashboard.png)

Combining Elasticsearch and kibana - both built on top of the OpenShift Container Platform (OCP) - with the collectd and fluentd client-side daemons, results in a powerful end-to-end solution.

For additional details, including how to set up the oVirt Metrics Store, please see the [oVirt Metrics Store Feature page](/develop/release-management/features/metrics/metrics-store/).
