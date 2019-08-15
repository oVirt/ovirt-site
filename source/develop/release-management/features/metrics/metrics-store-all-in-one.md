---
title: oVirt Metrics Store - All In One Installation
category: feature
authors: sradco
---
<div class="alert alert-warning">
  <strong>Please follow the links for the updated documentation:</strong>
  <br/>
  * <a href="/documentation/metrics-install-guide/metrics_store_installation_guide.html">Metrics Installation Guide</a>
  <br/>
  * <a href="/documentation/metrics-user-guide/metrics-user-guide.html">Metrics User Guide</a>
</div>

# oVirt Metrics Store - All In One Installation

## Summary

The oVirt metrics store provides our users with a full real-time monitoring solution
based on the data collected from the oVirt environment and the [OpenShift Logging](https://github.com/openshift/origin-aggregated-logging) stack.

This feature is meant to simplify the oVirt Metrics Store installation.

It will enable the users to both create the oVirt VM/s, based on the OpenShift host prerequisites
and run the OpenShift installation.

By default, it will install the metrics store as all-in-one OpenShift master node on one oVirt VM.

## Owner

*   Name: Shirly Radco (sradco)
*   Email: <sradco@redhat.com>

## Current Status

*   Target Release: 4.3
*   Status: Design
*   Last updated: Thu 15 Nov 2018

## Description

The oVirt metrics store is based on [OpenShift Logging](https://github.com/openshift/origin-aggregated-logging) stack, that consists of multiple components abbreviated as the "EFK" stack: Elasticsearch, Fluentd, Kibana.

It provides the oVirt user a real-time monitoring solution that enables logs analysis, predefined dashboards, custom dashboards and reports.

This feature is meant to simplify the oVirt Metrics Store installation.

This feature will be based on:
 - [oVirt ansible roles](https://github.com/oVirt/ovirt-ansible), Specifically the [oVirt Virtual Machine Infrastructure](https://github.com/oVirt/ovirt-ansible-vm-infra) role,
to create the VM/s for the OpenShift install.
 - [OpenShift oVirt](https://github.com/openshift/openshift-ansible/tree/master/roles/openshift_ovirt) role for installing OpenShift.

By default, it will install the metrics store as all-in-one OpenShift master node on one oVirt VM.
If more than 1 VM is required, the user will need to supply a configuration file to the oVirt metrics role, that defines the number of VMs to configure.
Basic VMs profiles will be available, but can be updated by the user if needed.


## Metrics store current documentation

### [oVirt Metrics Store Installation Guide](https://www.ovirt.org/documentation/metrics-install-guide/metrics-install-guide)
### [oVirt Metrics Store User Guide](https://www.ovirt.org/documentation/metrics-user-guide/metrics-user-guide)
