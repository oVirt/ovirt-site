---
title: oVirt Metrics Store - Installation Guide
category: feature
authors: sradco
wiki_category: Feature
wiki_title: Metrics Store - Installation Guide
wiki_revision_count: 1
wiki_last_updated: 2017-07-16
feature_name: oVirt Metrics Store Installation
feature_modules: engine
feature_status: In Development
---
# oVirt Metrics - Installation Guide

## oVirt Metrics Store Setup

**Note:** Currently, the oVirt Metrics Store should be installed on a new machine, separate from the engine.
It can be installed on a dedicated VM.

Before starting the installation please choose an environment name ("ovirt_env_name"). It will be used to identify data sent from more than one oVirt engine and collected in a single central store.
The default name for ovirt_env_name is "engine".

   Use the following convention: Only include alphanumeric characters and hyphens ( "-" ). Name cannot begin with a hyphen or a number,
   or end with a hyphen. Maximum of 49 characters. Wildcard patterns (e.g. ovirt-metrics*) cannot be used.

During the installation in the step [Configuring mux](https://github.com/ViaQ/Main/blob/master/README-install.md#configuring-mux) , use the following namespaces to create the indexes:

MUX_NAMESPACES="ovirt-metrics-<ovirt_env_name>  ovirt-logs-<ovirt_env_name>"

For example:
If ovirt_env_name= test-engine then the `MUX_NAMESPACES` will be:
MUX_NAMESPACES="ovirt-metrics-test-engine  ovirt-logs-test-engine"

The indexes in elasticsearch will be created with "project." prefix.

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

### Update Curator Pod for Metrics Index

This procedure will define the curator pod so that it deletes metrics indexes that are older than seven days.

1. Update the configmap. Run:

       # oc edit configmap logging-curator


2. Under:

       config.yaml: |
        .defaults:
          delete:
            days: 7
          runhour: 0
          runminute: 0

4. Add this section:

       ovirt-metrics-<ovirt_env_name>:
        delete:
          days: 3


5. Update <ovirt_env_name>. **Use the same name that you configured earlier**.
6. Run

        # oc rollout latest dc/logging-curator
        # oc rollout status -w dc/logging-curator


## oVirt Hypervisors and Engine Setup ##

Now we need to deploy and configure collectd and fluentd to send the data to the central metrics store::

1. This requires installing / upgrading and setting up oVirt Engine 4.1.8 and above.
   Until version 4.1.8 is available, you can use the You can use the snapshots repository to get the latest ovirt-engine-metrics package.
   http://resources.ovirt.org/pub/ovirt-4.1-snapshot/rpm/

2. This requires installing / upgrading and activating one or more hosts from version 4.1.8 or above.
   Until version 4.1.8 is available, You can use the snapshots repository to get the latest ovirt-engine-metrics package.
   http://resources.ovirt.org/pub/ovirt-4.1-snapshot/rpm/

3. Copy  /etc/ovirt-engine-metrics/config.yml.example  to config.yml.

   On the oVirt engine machine, run:

        # cp /etc/ovirt-engine-metrics/config.yml.example /etc/ovirt-engine-metrics/config.yml

4. Update the file /etc/ovirt-engine-metrics/config.yml located on the engine machine, with the following lines:

        # vi /etc/ovirt-engine-metrics/config.yml

5. Update the values to match the details of your specific environment:


- `ovirt_env_name:` **Use the same name that you configured earlier**.

  Environment name. It can be used to identify data collected in a single central
  store, sent from more than one oVirt engine.

- `fluentd_elasticsearch_host:` (required - no default value)

  Address or hostname (FQDN) of the Elasticsearch server host.

- `ovirt_env_uuid_metrics:` (required - no default value)

  UUID of the project/namespace used to store metrics records.
  This is used to construct the index name in Elasticsearch.
  For example, if you have ovirt_env_name: myenvname,
  then in the central metrics store machine you will have a project named ovirt-metrics-myenvname.
  To get this project's metrics UUID, enter:
  oc get project ovirt-metrics-myenvname -o jsonpath='{.metadata.uid}'

- `ovirt_env_uuid_logs:` (required - no default value)

  UUID of the project/namespace used to store log records.
  This is used to construct the index name in Elasticsearch.
  For example, if you have ovirt_env_name: myenvname,
  then in the central metrics store machine you will have a project named ovirt-logs-myenvname.
  To get this project's logs UUID, enter:
  oc get project ovirt-logs-myenvname -o jsonpath='{.metadata.uid}'

- `fluentd_elasticsearch_ca_cert_path:` (required - no default value)

  The path to the file containing the CA certificate of the CA that issued
  the Elasticsearch SSL server cert.
  Get it from the central metrics store machine like this:
  oc get secret logging-fluentd --template='{{index .data "ca"}}' | base64 -d > fluentd-ca
  and copy the file to the engine machine.

- `fluentd_elasticsearch_client_cert_path:` (required - no default value)

  The path to the file containing the SSL client certificate to use
  with certificate authentication to Elasticsearch.
  Get it from the central metrics store machine like this:
  oc get secret logging-fluentd --template='{{index .data "cert"}}' | base64 -d > fluentd-cert
  and copy the file to the engine machine.

- `fluentd_elasticsearch_client_key_path:` (required - no default value)

  The path to the file containing the SSL client key to use
  with certificate authentication to Elasticsearch.
  Get it from the central metrics store machine like this:
  oc get secret logging-fluentd --template='{{index .data "key"}}' | base64 -d > fluentd-key
  and copy the file to the engine machine.

6. On the engine machine, run as root:

        # /usr/share/ovirt-engine-metrics/setup/ansible/configure_ovirt_hosts_for_metrics.sh

It runs the Ansible script that configures collectd and fluentd on the oVirt engine and hypervisors.

It should finish without errors, collectd and fluentd services should be running.

Once finished, you can view host, VM and other statistics, in the Kibana console,
at the address configured earlier on in this procedure [(see oVirt Metrics Store Setup)](https://github.com/ViaQ/Main/blob/master/README-install.md#running-kibana).

Kibana should be available at <https://kibana.{hostname}>
