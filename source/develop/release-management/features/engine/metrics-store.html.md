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
*   Last updated: Mon 12 Jun 2017

## Description

In 4.1, Collectd and Fluentd are already installed on the hosts and engine machines.
We have an Ansible script that configures them on all relevant hosts.

We plan to continue adding additional logs and metrics as required, add pre-defined dashboards and aletring that will detect and notify the user in case something goes wrong in his environment, based on SLA events, thresholds etc.

### oVirt Metrics Installation Instructions

**oVirt Metrics Store setup -**

**Note:** Currently it should be installed on a new machine, separate from the engine. 
It can be installed on a dedicated vm. 

Please follow one of these options, adding SSO in optional:
 
  * [Metrics Store setup on Top of OpenShift with oVirt Engine SSO](https://www.ovirt.org/blog/2017/05/openshift-openId-integration-with-engine-sso/)

  OR

  * [Metrics Store setup on Top of OpenShift without oVirt Engine SSO](https://github.com/ViaQ/Main/blob/master/README-mux.md)

[![oVirt Metrics Data Flow](/images/wiki/oVirtMetricsDataFlow.jpg)](images/wiki/oVirtMetricsDataFlow.jpg)

Once you finished this step, you should have:

  * Kibana - <https://kibana.{hostname}>
  * Openshit portal - <https://openshift.{hostname}>


**oVirt Hypervisors and engine setup -**

On upgrade from 4.1.0, oVirt machines already include Fluentd and Collectd packages.
Now we need to deploy and configure Collectd and Fluentd to send the data to the central Metrics store:

1. Install / Upgrade and setup oVirt Engine 4.1 latest.

2. Install / Upgrade and activate one or more hosts, 4.1 latest.

3. Copy the CA certificate, created in step 1 on the metrics store machine, to the engine machine.

   Run on the metrics store machine:

        # scp /path/to/ca/certificate.cert root@<fqdn/of/engine/machine>:/etc/ovirt-engine-metrics

4. Copy  /etc/ovirt-engine-metrics/config.yml.example  to config.yml.

   Run on the oVirt engine machine:

        # cp /etc/ovirt-engine-metrics/config.yml.example /etc/ovirt-engine/config.yml

5. Update on the engine machine the file /etc/ovirt-engine-metrics/config.yml with the following lines:

        # vi /etc/ovirt-engine-metrics/config.yml.example

    Replace:
     
     "fluentd-server.example.com"  -  The fully qualified domain name of the metrics store machine
     
     "my_shared_key" - The shared key configured in Fluentd on the metrics store machine and
     
     "/path/to/fluentd_ca_cert.pem" - The path to the fluentd ca certificate.

6. Run on the engine machine, as root:

        # /usr/share/ovirt-engine-metrics/setup/ansible/configure_ovirt_hosts_for_metrics.sh

It runs the Ansible script that configures Collectd and Fluentd on the oVirt engine and hypervisors.

It should finish without errors.

When finished, you should be able to see statistics in the Kibana console, at the address you configured in step 1,  about your hosts, VMs, etc.

Kibana should be available at <https://kibana.{hostname}>
