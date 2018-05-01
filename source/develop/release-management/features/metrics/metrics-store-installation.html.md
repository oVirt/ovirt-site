---
title: oVirt Metrics Store - Installation Guide
category: feature
authors: sradco
feature_name: oVirt Metrics Store Installation
feature_modules: engine
feature_status: In Development
---
# oVirt Metrics - Installation Guide

[![oVirt Metrics data flow](/images/wiki/oVirtMetricsDataFlow.jpg)](/images/wiki/oVirtMetricsDataFlow.jpg)

## oVirt Metrics Store Setup

**Note:** Currently, the oVirt Metrics Store should be installed on a new machine, separate from the engine.
It can be installed on a dedicated VM.

### Metrics Store Machine Prerequisites

For an oVirt environment with 50 hosts: 
- 4 CPU cores, 16GB RAM memory .
- We recommends using SSD disks.
- CentOS 7.3 or later.
- Preallocated 500GB partition - It will be used for persistent storage. Use a partition other than root (/) to avoid filling up the partition, for example, /var.
- Add the Metrics Store Machine FQDN to your enterprise hostname resolution system, for example, DNS.
Add the following aliases:

    - es.FQDN for Elasticsearch
    - kibana.FQDN for Kibana

    where FQDN is the hostname and domain of the OpenShift Aggregated Logging machine.
- Also please make sure to follow the [OpenShift `masters` prerequisites](https://docs.openshift.org/latest/install_config/install/prerequisites.html#hardware)

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
  
### Configure SSH Key-Based Authentication between engine and metrics store machine

To copy the engine public key to your metrics store machine, run:

    # mytemp=$(mktemp -d)

    # cp /etc/pki/ovirt-engine/keys/engine_id_rsa $mytemp

    # ssh-keygen -y -f $mytemp/engine_id_rsa > $mytemp/engine_id_rsa.pub

    # ssh-copy-id -i $mytemp/engine_id_rsa.pub root@{fluentd_elasticsearch_host}

It should ask for root password (on first attempt), supply it.
After that, run:

    # rm -rf $mytemp

To test that you are able to log into the metrics store machine from the engine, run:

    # ssh -i /etc/pki/ovirt-engine/keys/engine_id_rsa root@{fluentd_elasticsearch_host}

### Run ovirt-metrics-store-installation playbook

This playbook generates the inventory and vars.yml files required for the metrics store installation and copies them
to the metrics store machine.

        # /usr/share/ovirt-engine-metrics/setup/ansible/configure_ovirt_machines_for_metrics.sh \
        --playbook=ovirt-metrics-store-installation.yml

### Metrics Store Installation 

**Note:** When running ansible to configure OpenShift, use the ansible-inventy file based on your OpenShift version and flavor.

To install OpenShift Logging on your machine (Elasticsearch, Kibana, Fluentd, Curator), Please follow the installation instructions: [Metrics Store setup on top of OpenShift](https://www.ovirt.org/develop/release-management/features/metrics/setting-up-viaq-logging/)

Optional in oVirt 4.2, add SSO: [Metrics Store setup on top of OpenShift with oVirt Engine SSO](https://www.ovirt.org/blog/2017/05/openshift-openId-integration-with-engine-sso/)

Once you have finished this step, you should have:

  * Kibana - <https://kibana.{fluentd_elasticsearch_host}>
  * OpenShift portal - <https://{fluentd_elasticsearch_host}:8443>


## oVirt Hypervisors and Engine Setup ##

Deploy and configure collectd and fluentd to send the data to the central metrics store::

1. This requires installing / upgrading and setting up oVirt Engine latest 4.2.z.

2. This requires installing / upgrading and activating one or more hosts from version 4.2.z.

3. On the engine machine, run as root:

        # /usr/share/ovirt-engine-metrics/setup/ansible/configure_ovirt_machines_for_metrics.sh

It runs the Ansible script that configures collectd and fluentd on the oVirt engine and hypervisors.

It should finish without errors, collectd and fluentd services should be running.

Once finished, you can view host, VM and other statistics, in the Kibana console,
at the address configured earlier on in this procedure [(see oVirt Metrics Store Setup)](https://github.com/ViaQ/Main/blob/master/README-install.md#running-kibana).


## Example Dashboards

Kibana should be available at <https://kibana.{fluentd_elasticsearch_host}>

Dashboard examples include `System Dashboard`, `Hosts Dashboard`, `VMs Dashboard`, `Processes Dashboard`.

If you wish to import dashboards example, you will need to import visualization and dashboards manually from the Kibana UI.

1. Copy the /etc/ovirt-engine-metrics/dashboards-examples directory to your local machine.

2. Go to the Kibana UI, to the `setting` tab -> `indices`.

3. Select the `project.ovirt-metrics-<ovirt-env-name>.<uuid>` index.

4. Press the orange button, `Refresh field list`.

5. Do steps 3 and 4 for the `project.ovirt-logs-<ovirt-env-name>.<uuid>` index.

6. In the Kibana UI, go to the `setting` tab -> `objects`.

7. Import the `Searches`.

8. Import the `Visualizations`.

9. Import the `Dashboards`.

You are done! Go to the `Dashboard` tab in the Kibana UI and choose a dashboard.

Currently there are 3 example dashboards:

  * [System Dashboard](https://kibana.{fluentd_elasticsearch_host}/app/kibana#/dashboard/System-Dashboard)

  * [Hosts Dashboard](https://kibana.{fluentd_elasticsearch_host}/app/kibana#/dashboard/Hosts-Dashboard)
  
  * [VMs Dashboard](https://kibana.{fluentd_elasticsearch_host}/app/kibana#/dashboard/VMs-Dashboard)

**Note:** If you get an error while loading the `Visualizations`, check your hosts and make sure Collectd and Fluentd services are running with no errors. After that try loading the `Visualizations` again.
