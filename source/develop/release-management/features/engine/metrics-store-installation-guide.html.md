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

During the installation in the step [Configuring mux](https://github.com/ViaQ/Main/blob/master/README-mux.md#configuring-mux) , use the following namespaces to create the indexes:

MUX_NAMESPACES="ovirt-metrics-<ovirt_env_name>  ovirt-logs-<ovirt_env_name>"

For example:
If ovirt_env_name= test-engine then the `MUX_NAMESPACES` will be:
MUX_NAMESPACES="ovirt-metrics-test-engine  ovirt-logs-test-engine"

The indexes in elasticsearch will be created with "project." prefix.

Please follow the installation instructions: [Metrics Store setup on top of OpenShift](https://github.com/ViaQ/Main/blob/master/README-mux.md)

In oVirt 4.2 there will be an option to add SSO: [Metrics Store setup on top of OpenShift with oVirt Engine SSO](https://www.ovirt.org/blog/2017/05/openshift-openId-integration-with-engine-sso/)


[![oVirt Metrics data flow](/images/wiki/oVirtMetricsDataFlow.jpg)](images/wiki/oVirtMetricsDataFlow.jpg)
Once you have finished this step, you should have:

  * Kibana - <https://kibana.{hostname}>
  * OpenShift portal - <https://openshift.{hostname}>



### Update Mux Pod Resources

mux (short for multiplex) acts like a multiplexor or manifold,
taking in connections from many collectors, and distributing them to data
stores.

The following procedure describes how to update the mux pod resources:

1. Use SSH to connect to the logging machine and open the command line.

2. Update the deployment configuration of mux pod by running the following command:

           # $ oc edit dc logging-mux

3. Edit the cpu and memory values as follows:

           spec:
            template:
             spec:
              containers:
           ...
               resources:
                limits:
                 cpu: 500m
                  memory: 2Gi

4. CPU usage is measured in millicores (m). 500m means 0.5 cores. To allocate more resources to mux, increase the CPU to 1000m.

5. If mux has utilized all available CPU resources, and the CPU has already been increased to 1000m, scale up to an additional pod.

6. Memory usage is measured in Gi. 2Gi is approximately 2 Gigabytes. Increase as needed.

7. Save the new configuration to automatically trigger a redeployment of all mux pods.

8. To view when mux pod was last redeployed, run:

       # oc get pods -l component=mux

9. If mux pod was not redeployed in the last two minutes, run:

       # oc rollout latest dc/logging-mux

10. To follow the deployment until the new mux pod is rolled out, run:

             # oc rollout status -w dc/logging-mux

* Since ruby isn't multi-threaded, you can also scale up mux to run additional pods:

              # oc scale --replicas=2 dc/logging-mux

* This will create 2 mux pods.



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
         days: 7
          runhour: 0
           runminute: 0


5. Update "ovirt_env_name". **Use the same name you configured earlier**.
6. Run

        # oc rollout latest dc/logging-curator
        # oc rollout status -w dc/logging-curator



## oVirt Hypervisors and Engine Setup ##

oVirt machines on versions 4.1.1 and above include fluentd and collectd packages.
Now we need to deploy and configure collectd and fluentd to send the data to the central Metrics Store:

1. Install / Upgrade and setup oVirt Engine to the latest 4.1.z.

2. Install / Upgrade and activate one or more hosts, latest 4.1.z.

3. Copy the CA certificate - created earlier on in this procedure [(see oVirt Metrics Store Setup)](https://github.com/ViaQ/Main/blob/master/README-mux.md#getting-the-shared_key-and-ca-cert) - to the engine machine.


   On the metrics store machine, run:

        # scp /path/to/ca/certificate.cert root@<fqdn-of-engine-machine>:/etc/ovirt-engine-metrics

4. Copy  /etc/ovirt-engine-metrics/config.yml.example  to config.yml.

   On the oVirt engine machine, run:

        # cp /etc/ovirt-engine-metrics/config.yml.example /etc/ovirt-engine/config.yml

5. Update the file /etc/ovirt-engine-metrics/config.yml located on the engine machine, with the following lines:

        # vi /etc/ovirt-engine-metrics/config.yml.example

    Replace the example values with your specific environment details:

     * "fluentd-server.example.com" - The fully qualified domain name of the metrics store machine

     * "my_shared_key" - The shared key configured in fluentd on the metrics store machine.

     * "/path/to/fluentd_ca_cert.pem" - The path to the fluentd CA certificate

     * "ovirt_env_name" - **Use the same name you configured earlier**.

6. On the engine machine, run as root:

        # /usr/share/ovirt-engine-metrics/setup/ansible/configure_ovirt_hosts_for_metrics.sh

It runs the Ansible script that configures collectd and fluentd on the oVirt engine and hypervisors.

It should finish without errors, collectd and fluentd services should be running.

Once finished, you can view host, VM and other statistics in the Kibana console, at the address configured earlier on in this procedure [(see oVirt Metrics Store Setup)](https://github.com/ViaQ/Main/blob/master/README-mux.md#running-kibana).

Kibana should be available at <https://kibana.{hostname}>
