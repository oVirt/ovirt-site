---
title: oVirt Metrics Store - Hypervisors and Engine Setup
category: feature
authors: sradco
---
<div class="alert alert-warning">
  <strong>ATTENTION: This page is no longer up to date. Please follow the link for the updated documentation:</strong>
  <br/>
  * <a href="/documentation/administration_guide/#monitoring_and_observability">Monitoring and observability</a>
</div>

## oVirt Hypervisors and Engine Setup

Deploy and configure Collectd and Rsyslog to send the data to the central metrics store::

1. This requires installing / upgrading and setting up oVirt Engine latest 4.2.z.

2. This requires installing / upgrading and activating one or more hosts from version 4.2.z.

3. On the engine machine, run as root:

        # /usr/share/ovirt-engine-metrics/setup/ansible/configure_ovirt_machines_for_metrics.sh

It runs the Ansible script that configures Collectd and Rsyslog on the oVirt engine and hypervisors.

It should finish without errors, Collectd and Rsyslog services should be running.

Once finished, you can view host, VM and other statistics, in the Kibana console,
at the address configured earlier on in this procedure [(see oVirt Metrics Store Setup)](https://github.com/ViaQ/Main/blob/master/README-install.md#running-kibana).
