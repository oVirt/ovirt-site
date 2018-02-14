---
title: oVirt Metrics Store - Installation Guide
category: feature
authors: sradco
feature_name: oVirt Metrics Store Installation
feature_modules: engine
feature_status: In Development
---
# oVirt Metrics - Installation Guide

## oVirt Metrics Store Setup

**Note:** Currently, the oVirt Metrics Store should be installed on a new machine, separate from the engine.
It can be installed on a dedicated VM.

### Update config.yml file

1. Copy  /etc/ovirt-engine-metrics/config.yml.example  to config.yml.

   On the oVirt engine machine, run:

        # cp /etc/ovirt-engine-metrics/config.yml.example /etc/ovirt-engine-metrics/config.yml

2. Update the file /etc/ovirt-engine-metrics/config.yml located on the engine machine, with the following lines:

        # vi /etc/ovirt-engine-metrics/config.yml

3. Update the values to match the details of your specific environment:


- `ovirt_env_name:` **Please update this parameter**.

  Environment name. It is used to identify data collected in a single central
  store, sent from more than one oVirt engine.
  
  Use the following convention: 

  - Include only alphanumeric characters and hyphens ( "-" ).
  - Name cannot begin with a hyphen or a number, or end with a hyphen.
  - Maximum of 49 characters. Wildcard patterns (e.g. ovirt-metrics*) cannot be used.

- `fluentd_elasticsearch_host:` (required - no default value)

  Address or hostname (FQDN) of the Elasticsearch server host.

- `viaq_metrics_store:` (required - Default: `true`)

  Use ViaQ Logging metrics store

- `openshift_deployment_type:` (required - no default value)

  Reguired if `viaq_metrics_store` is `true`.
  This repository supports OpenShift Origin and OpenShift Container Platform.
  If you want to install ViaQ Logging you should choose the deployment type.
  Available options: origin, openshift-enterprise.

### Run ovirt-metrics-store-installation playbook

This playbook generates the inventory and vars.yml files required for the metrics store installation and copies them
to the metrics store machine.

        # /usr/share/ovirt-engine-metrics/setup/ansible/configure_ovirt_hosts_for_metrics.sh \
        --playbook=ovirt-metrics-store-installation.yml

### Metrics Store Installation 

Please follow the installation instructions: [Metrics Store setup on top of OpenShift](https://github.com/ViaQ/Main/blob/master/README-install.md)

In oVirt 4.2 there will be an option to add SSO: [Metrics Store setup on top of OpenShift with oVirt Engine SSO](https://www.ovirt.org/blog/2017/05/openshift-openId-integration-with-engine-sso/)


[![oVirt Metrics data flow](/images/wiki/oVirtMetricsDataFlow.jpg)](/images/wiki/oVirtMetricsDataFlow.jpg)

Once you have finished this step, you should have:

  * Kibana - <https://kibana.{hostname}>
  * OpenShift portal - <https://openshift.{hostname}>



### Add an externalIP to the Elasticsearch Service.

1. Run:

       # oc edit svc logging-es

2. Add the `externalIPs:` section and the host IP address below it:

       spec:
         clusterIP: example_cluster_ip
         externalIPs:
         - <host_ip>

Update the `<host_ip>` to reflect the host IP address.

## oVirt Hypervisors and Engine Setup ##

Now we need to deploy and configure collectd and fluentd to send the data to the central metrics store::

1. This requires installing / upgrading and setting up oVirt Engine 4.1.8 and above.
   Until version 4.1.8 is available, you can use the snapshots repository to get the latest ovirt-engine-metrics package.
   http://resources.ovirt.org/pub/ovirt-4.1-snapshot/rpm/

2. This requires installing / upgrading and activating one or more hosts from version 4.1.8 or above.
   Until version 4.1.8 is available, You can use the snapshots repository to get the latest ovirt-engine-metrics package.
   http://resources.ovirt.org/pub/ovirt-4.1-snapshot/rpm/

3. On the engine machine, run as root:

        # /usr/share/ovirt-engine-metrics/setup/ansible/configure_ovirt_hosts_for_metrics.sh

It runs the Ansible script that configures collectd and fluentd on the oVirt engine and hypervisors.

It should finish without errors, collectd and fluentd services should be running.

Once finished, you can view host, VM and other statistics, in the Kibana console,
at the address configured earlier on in this procedure [(see oVirt Metrics Store Setup)](https://github.com/ViaQ/Main/blob/master/README-install.md#running-kibana).

Kibana should be available at <https://kibana.{hostname}>
