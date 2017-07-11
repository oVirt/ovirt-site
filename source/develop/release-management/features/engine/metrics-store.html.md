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

In 4.1, collectd and fluentd are already installed on the hosts and engine machines.
We have an Ansible script that configures them on all relevant hosts.

We plan to continue adding additional logs and metrics as required, add pre-defined dashboards and alerting that will detect and notify the user when something goes wrong in the environment, based on SLA events, thresholds, etc.

### oVirt Metrics Installation Instructions

**oVirt Metrics Store Setup -**

**Note:** Currently it should be installed on a new machine, separate from the engine. 
It can be installed on a dedicated VM. 

Please follow one of these options. Adding SSO is optional:
 
  * [Metrics Store setup on top of OpenShift with oVirt Engine SSO](https://www.ovirt.org/blog/2017/05/openshift-openId-integration-with-engine-sso/)

  OR

  * [Metrics Store setup on top of OpenShift without oVirt Engine SSO](https://github.com/ViaQ/Main/blob/master/README-mux.md)

[![oVirt Metrics data flow](/images/wiki/oVirtMetricsDataFlow.jpg)](images/wiki/oVirtMetricsDataFlow.jpg)

Once you have finished this step, you should have:

  * Kibana - <https://kibana.{hostname}>
  * OpenShift portal - <https://openshift.{hostname}>
  
  

**Update mux pod resources**

1. ssh into the logging machine and use the command line.  
**Note:** You can probably do all of this with the OpenShift UI too - https://logging-machine:8443

2. Run

       # $ oc edit dc logging-mux

Edit the section

      spec:
        template:
          spec:
            containers:
      ...
              resources:
                limits:
                  cpu: 500m
                  memory: 2Gi

   For cpu, units are in millicores.  500m means 0.5 cores.

   If you want mux to use more, use 1000m or even 2000m.

   For memory, 2Gi means 2 Gigabytes.  Increase as needed.

   If you change and save the new config, that should automatically trigger a redeployment of all mux pods.
   


3. Run:

       # oc get pods -l component=mux

This should show that mux recently restarted.  If not, use

       # oc rollout latest dc/logging-mux

and

       # oc rollout status -w dc/logging-mux

to follow the deployment until the new one is rolled out


Since ruby isn't multi-threaded, you can also scale up mux to run additional pods:

      # oc scale --replicas=2 dc/logging-mux

This will create 2 mux pods.  I would suggest that if mux is maxed out of cpu, and you have already increased the mux cpu above to 1000m, you should scale up an additional pod rather than increasing the mux cpu to over 1000m.



**Update curatur pod for metrics index**

This will define the curator pod to delete metrics indexes that are older then 7 days.

1. Update the configmap Run:
Run:
       # oc edit configmap logging-curator

Under 

      config.yaml: |
        .defaults:
          delete:
            days: 7
          runhour: 0
          runminute: 0

Add this section:

        ovirt-metrics-<ovirt_env_name>:
          delete:
            days: 7
          runhour: 0
          runminute: 0
    
**Note:**
You should replace <ovirt_env_name>.

"ovirt_env_name" - The environment name. Can be used to identify data collected in a single central store sent from more than one oVirt engine.
     
It must follow these guidlines - alphanum + "-" character, cannot begin with "-" or a number, and cannot end with a "-", up to 49 characters.

Unfortunately, you cannot set a wildcard pattern to match like ovirt-metrics-*.

2. Run:

        # oc rollout latest dc/logging-curator
        # oc rollout status -w dc/logging-curator



**oVirt Hypervisors and Engine Setup -**

oVirt machines on versions 4.1.1 and above include fluentd and collectd packages.
Now we need to deploy and configure collectd and fluentd to send the data to the central Metrics Store:

1. Install / Upgrade and setup oVirt Engine 4.1.3 and above.

2. Install / Upgrade and activate one or more hosts, 4.1.3 and above.

3. Copy the CA certificate - created earlier on in this procedure [(see oVirt Metrics Store Setup)](https://github.com/ViaQ/Main/blob/master/README-mux.md#getting-the-shared_key-and-ca-cert) - to the engine machine.


   On the metrics store machine, run:

        # scp /path/to/ca/certificate.cert root@<fqdn/of/engine/machine>:/etc/ovirt-engine-metrics

4. Copy  /etc/ovirt-engine-metrics/config.yml.example  to config.yml.

   On the oVirt engine machine, run:

        # cp /etc/ovirt-engine-metrics/config.yml.example /etc/ovirt-engine/config.yml

5. Update the file /etc/ovirt-engine-metrics/config.yml located on the engine machine, with the following lines:

        # vi /etc/ovirt-engine-metrics/config.yml.example

    Replace the example values with your specific environment details:
     
     * "fluentd-server.example.com" - The fully qualified domain name of the metrics store machine
     
     * "my_shared_key" - The shared key configured in fluentd on the metrics store machine.
     
     * "/path/to/fluentd_ca_cert.pem" - The path to the fluentd CA certificate
     
     * "ovirt_env_name" - The environment name. Can be used to identify data collected in a single central store sent from more than one oVirt engine. **Use the same name you configured earlier**.

6. On the engine machine, run as root:

        # /usr/share/ovirt-engine-metrics/setup/ansible/configure_ovirt_hosts_for_metrics.sh

It runs the Ansible script that configures collectd and fluentd on the oVirt engine and hypervisors.

It should finish without errors.

Once finished, you can view host, VM and other statistics in the Kibana console, at the address configured earlier on in this procedure [(see oVirt Metrics Store Setup)](https://github.com/ViaQ/Main/blob/master/README-mux.md#running-kibana).

Kibana should be available at <https://kibana.{hostname}>
