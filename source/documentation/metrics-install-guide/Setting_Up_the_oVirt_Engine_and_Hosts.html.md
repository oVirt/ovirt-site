---
title: Setting Up the oVirt Engine and Hosts
---

# Chapter 2: Setting Up the oVirt Engine and Hosts

**Prerequisites**

Install a 4.2 environment as described in the _Installation Guide_ or _Self-Hosted Installation Guide_, depending on your environment. Alternatively, upgrade your 4.x environment to 4.2.

## Copying OpenShift Ansible Files

1. On the Engine machine, copy **/etc/ovirt-engine-metrics/config.yml.example** to **config.yml**:

      # cp /etc/ovirt-engine-metrics/config.yml.example /etc/ovirt-engine-metrics/config.yml

2. Update the values of **/etc/ovirt-engine-metrics/config.yml** to match the details of your specific environment:

      # vi /etc/ovirt-engine-metrics/config.yml

   **Important:** All parameters are mandatory.

**config.yml Parameters**

<table>
<thead><tr><th>Name</th><th>Default Value</th><th>Description</th></tr></thead>
<tbody>
<tr>
 <td>ovirt_env_name</td>
 <td>Yes</td>
 <td>
   <p>The environment name. This is used to identify data collected from the Engine for this Red Hat Virtualization environment.</p>
   <p>Use the following conventions:</p>
   <ul>
   <li>Include only alphanumeric characters and hyphens ( "-" ).</li>
   <li>The name cannot begin with a hyphen or a number, or end with a hyphen.</li>
   <li>A maximum of 49 characters can be used.</li>
   <li>Wildcard patterns (for example, ovirt-metrics) cannot be used.</li>
   </ul>
 </td>
</tr>
<tr>
 <td>fluentd_elasticsearch_host</td>
 <td>No</td>
 <td>The address or FQDN of the Elasticsearch server host.</td>
</tr>
</tbody>
</table>

3. Copy the Engine's public key to your Metrics Store machine:

       # mytemp=$(mktemp -d)

       # cp /etc/pki/ovirt-engine/keys/engine_id_rsa $mytemp

       # ssh-keygen -y -f $mytemp/engine_id_rsa > $mytemp/engine_id_rsa.pub

       # ssh-copy-id -i $mytemp/engine_id_rsa.pub root@fluentd_elasticsearch_host

   It should ask for root password (on first attempt), supply it. After that, run:

      # rm -rf $mytemp

   To test that you are able to log into the metrics store machine from the engine, run:

      # ssh -i /etc/pki/ovirt-engine/keys/engine_id_rsa root@fluentd_elasticsearch_host

4. As the root user, run the Ansible script that generates the Ansible inventory and vars.yaml files and copies them to the Metrics Store machine (by default to / (root)):

   # /usr/share/ovirt-engine-metrics/setup/ansible/configure_ovirt_machines_for_metrics.sh \
   --playbook=ovirt-metrics-store-installation.yml

**Prev:** [Chapter 1: Introduction](../Introduction)<br>
**Next:** [Chapter 3: Setting Up OpenShift Aggregated Logging](../Setting_Up_OpenShift_Aggregated_Logging)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/metrics_store_installation_guide/chap-setting_up_rhv_manager_and_hosts)
