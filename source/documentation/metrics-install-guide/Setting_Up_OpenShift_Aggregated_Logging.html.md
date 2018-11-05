---
title: Setting Up OpenShift Aggregated Logging
---

# Setting Up OpenShift Aggregated Logging

## Configuring Ansible Prerequisites

You must be able to log into the machine using an SSH keypair. The following instructions assume you are running Ansible on the same machine that you will be running OpenShift Aggregated Logging.

**Configure Ansible Prerequisites**

1. Assign the machine an FQDN and IP address so that it can be reached from another machine.
   These are the `public_hostname` and `public_ip` parameters.

2. Use the root user or create a user account. This user will be referred to below as $USER.    If you do not use the root user, you must update *ansible_ssh_user*  and *ansible_become* in *vars.yaml*, which is saved to the **/root** directory on the Metrics Store machine by default.

3. Create an SSH public key for this user account using the `ssh-keygen` command.

       # ssh-keygen

4. Add the SSH public key to the user account *$HOME/.ssh/authorized_keys*:

       # cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys

5. Add the SSH hostkey for localhost to your SSH known_hosts:

       # ssh-keyscan -H localhost >> $HOME/.ssh/known_hosts

6. Add the SSH hostkey for public_hostname to your SSH known_hosts:

       # ssh-keyscan -H public_hostname >> $HOME/.ssh/known_hosts

7. If you _not_ using the root user, enable passwordless sudo by adding `$USER ALL=(ALL) NOPASSWD: ALL` to */etc/sudoers*.

8. Verify that passwordless SSH works, and that you do not get prompted to accept host verification, by running:

       # ssh localhost 'ls -al'
       # ssh public_hostname 'ls -al'

   Ensure that you are not prompted to provide a password or to accept host verification.

    **Note:** openshift-ansible may attempt to SSH to localhost. This is the expected behavior.

## Opening Ports

The TCP ports listed below are required by OpenShift Container Platform. Ensure that they are open on your network and configured to allow access between hosts.

Use iptables to open ports. The following example opens port **22**:


        # iptables OS_FIREWALL_ALLOW -p tcp -m state --state NEW -m tcp \
         --dport 22 -j ACCEPT

**Required Ports**

* **22** Required for SSH by the installer or system administrator.

* **443** For use by Kibana.

* **8443** For use by the OpenShift Container Platform web console, shared with the API server. This enables Metrics users to access the OpenShift Management user interface.

* **9200** For Elasticsearch API use. Required to be internally open on any infrastructure nodes to enable Kibana to retrieve logs. It can be externally opened for direct access to Elasticsearch by means of a route. The route can be created using `oc expose`.

## Configuring Sudo

**Configure sudo not to require a tty**

Create a file under */etc/sudoers.d/*, for example *999-cloud-init-requiretty*, and add `Defaults !requiretty` to the file.

For example:

        # cat /etc/sudoers.d/999-cloud-init-requiretty
        Defaults !requiretty

## Installing OpenShift Aggregated Logging Packages

The installer for OpenShift Container Platform is provided by the `atomic-openshift-utils` package.

In order to install it on CentOS you'll need to enable a few repositories:

        # yum install centos-release-openshift-origin310
        # yum install centos-release-ovirt42

Note that centos-release-ovirt42 is needed only for getting an updated ansible runtime.


Install the OpenShift Container Platform package:

        # yum -y install wget git net-tools bind-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct
        # yum -y update
        # yum -y install openshift-ansible
        # yum -y install docker

## Configuring Persistent Storage for Elasticsearch

Elasticsearch requires persistent storage for the database. By default, Elasticsearch uses ephemeral storage, and therefore you need to manually configure persistent storage.

   **Important:** Before proceeding, ensure you have set up the storage according to the instructions in [Introduction](../Introduction).

**Configuring Persistent Storage for Elasticsearch**

1. Create the `/lib/elasticsearch` directory that will be used for persistent storage using the `/var` mounted storage partition you created in [Introduction](../Introduction):

       # mkdir -p /var/lib/elasticsearch

2. Change the group ownership of the directory to 65534:

       # chgrp 65534 /var/lib/elasticsearch

3. Make this directory writable by the group:

       # chmod -R 0770 /var/lib/elasticsearch

4. Run the following commands:

       # semanage fcontext -a -t container_file_t "/var/lib/elasticsearch(/.\*)?"
       # restorecon -R -v /var/lib/elasticsearch

## Running Ansible

Prior to running Ansible, verify that the value for hostname and IP address that you defined in the DNS matches the values Ansible will use.

**Running Ansible**

1. To check the host’s FQDN:

       # ansible -m setup localhost -a 'filter=ansible_fqdn'

2. To check the host's IP address:

       # ansible -m setup localhost -a 'filter=ansible_default_ipv4'

3. Run Ansible using the `prerequisites.yml` playbook to ensure the machine is configured correctly:

       # cd /usr/share/ansible/openshift-ansible
       # ANSIBLE_LOG_PATH=/tmp/ansible-prereq.log ansible-playbook -vvv -e @/root/vars.yaml -i /root/ansible-inventory-ocp-39-aio playbooks/prerequisites.yml

4. Run Ansible using the `openshift-node/network_manager.yml` playbook to ensure that the networking and the NetworkManager are configured correctly:

       # cd /usr/share/ansible/openshift-ansible
       # ANSIBLE_LOG_PATH=/tmp/ansible-network.log ansible-playbook -vvv -e @/root/vars.yaml -i /root/ansible-inventory-ocp-39-aio playbooks/openshift-node/network_manager.yml

5. Run Ansible using the `deploy_cluster.yml` playbook to install both OpenShift and the OpenShift Logging components:

       # cd /usr/share/ansible/openshift-ansible
       # ANSIBLE_LOG_PATH=/tmp/ansible.log ansible-playbook -vvv -e @/root/vars.yaml -i /root/ansible-inventory-ocp-39-aio playbooks/deploy_cluster.yml

6. Check `/tmp/ansible.log` to ensure that no errors occurred.
   If there are errors, fix the machine's definitions and/or `vars.yaml` and run Ansible again.

    **Note:** If the installation fails, inspect the Ansible log files in `/var/log/ovirt-engine/ansible/`, fix the issue, and run the installation again.

## Enabling Elasticsearch to Mount the Directory

After the installation, the Elasticsearch service will not be able to run until granted permission to mount that directory.

**Enabling Elasticsearch to Mount the Directory**

Run the following:

        # oc project logging
        # oadm policy add-scc-to-user hostmount-anyuid \
          system:serviceaccount:logging:aggregated-logging-elasticsearch

        # oc rollout cancel $( oc get -n logging dc -l component=es -o name )
        # oc rollout latest $( oc get -n logging dc -l component=es -o name )
        # oc rollout status -w $( oc get -n logging dc -l component=es -o name )

## Verifying the OpenShift Aggregated Logging Installation

The following procedures verify that all pods and services are running, and that the hostname, IPs, and routes are correctly configured.

**Verifying the OpenShift Aggregated Logging Installation**

1. Log into the project:

       # oc project logging

2. To confirm that Elasticsearch, Curator, and Kibana pods are running, run:

       # oc get pods

3. Check that the **STATUS** is `Running`.

4. To confirm that the Elasticsearch and Kibana services are running, run:

       # oc get svc

5. Ensure  that the **EXTERNAL-IP**  and  **PORT(S)** fields are correct.

6. To confirm that there are routes for Elasticsearch and Kibana, run:

       #  oc get routes

7. Ensure that the value of **HOST/PORT** is correct.

## Configuring Collectd and Fluentd

Deploy and configure collectd and fluentd to send the metrics and logs to OpenShift Aggregated Logging.

**Configuring Collectd and Fluentd**

On the Engine machine, run the following:

        # /usr/share/ovirt-engine-metrics/setup/ansible/configure_ovirt_machines_for_metrics.sh

   **Note:** Deploying additional hosts after running this script does *not* require running the script again; the Manager configures the hosts automatically.

**Prev:** [Chapter 2: Setting Up the oVirt Engine and Hosts](../Setting_Up_the_oVirt_Engine_and_Hosts)<br>
**Next:** [Chapter 4: Verifying the Installation](../Verifying_the_Installation)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/metrics_store_installation_guide/chap-setting_up_openshift_aggregated_logging)
