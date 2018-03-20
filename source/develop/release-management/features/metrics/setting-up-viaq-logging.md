Setting Up ViaQ Logging
=======================

Intro
-----

ViaQ Logging is based on the [OpenShift
Logging](https://github.com/openshift/origin-aggregated-logging) stack.  You
can use either the OpenShift Container Platform (OCP) based on RHEL7, or
OpenShift Origin (Origin) based on CentOS7.  Ansible is used to install logging
using the [OpenShift Ansible](https://github.com/openshift/openshift-ansible)
logging
[roles](https://github.com/openshift/openshift-ansible/blob/master/roles/openshift_logging/README.md).

Provisioning a machine to run ViaQ
----------------------------------

**WARNING** DO NOT INSTALL `libvirt` on the OpenShift machine!  You will run
  into all sorts of problems related to name resolution and DNS.  For example,
  your pods will not start, will be in the Error state, and will have messages
  like this: `tcp: lookup kubernetes.default.svc.cluster.local: no such host`

ViaQ on OCP requires a RHEL 7.3 or later machine.  ViaQ on Origin requires a
up-to-date CentOS 7 machine.  You must be able to ssh into the machine using an
ssh keypair.  The instructions below assume you are running ansible on the same
machine that you are going to be using to run logging (as an all-in-one or aio
deployment).  You will need to do the following on this machine:

* assign the machine an FQDN and IP address so that it can be reached from
  another machine - these are the **public_hostname** and **public_ip**
* use `root` (or create a user account) - this user will be referred to below
  as `$USER`
* provide an ssh pubkey for this user account (`ssh-keygen`)
* add the ssh pubkey to the user account `$HOME/.ssh/authorized_keys`
  * `cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys`
* add the ssh hostkey for localhost to your SSH `known_hosts`
  * `ssh-keyscan -H localhost >> $HOME/.ssh/known_hosts`
* add the ssh hostkey for **public_hostname** to your SSH `known_hosts`
  * `ssh-keyscan -H **public_hostname** >> $HOME/.ssh/known_hosts`
* This step is only needed if not using root - enable passwordless sudo e.g. in
  sudoers config:
  * `$USER ALL=(ALL) NOPASSWD:ALL`

To verify that passwordless ssh works, and that you do not get prompted to
accept host verification, try this:

    # ssh localhost 'ls -al'
    # ssh **public_hostname** 'ls -al'

Allow connections on the following ports/protocols:
  * tcp ports 22, 80, 443, 8443 (openshift console), 9200 (Elasticsearch)

You should not be prompted for a password nor to accept the host verification.

This will allow you to access the machine via ssh (in order to run Ansible -
see below), to access the external services such as Kibana and to
access the OpenShift UI console. openshift-ansible in some cases will
attempt to ssh to localhost.

ViaQ on OCP requires a RHEL and OCP subscription.  For more information about
RHEL configuration, see
[Host Registration](https://access.redhat.com/documentation/en-us/openshift_container_platform/3.5/html/installation_and_configuration/installing-a-cluster#host-registration)
For RHEL, you must enable the Extras and the rhel-7-fast-datapath-rpms channels
(for docker and ovs, among others).

ViaQ on Origin requires these [Yum Repos](centos7-viaq.repo).
You will need to install the following packages: docker, iptables-services.

    # yum install docker iptables-services

You will need to configure sudo to not require a tty.  For example, create a
file like `/etc/sudoers.d/999-cloud-init-requiretty` with the following contents:

    # cat /etc/sudoers.d/999-cloud-init-requiretty
    Defaults !requiretty

Persistent Storage
------------------

Elasticsearch requires persistent storage for its database.

We recommand 500GB SSD per 50 hosts.

Elasticsearch uses ephemeral storage by default, and so has to be manually
configured to use persistence.

- First, since Elasticsearch can use many GB of disk space, and may fill up the
  partition, you are strongly recommended to use a partition other than root
  `/` to avoid filling up the root partition.
- Find a partition that can easily accomodate many GB of storage.
- Create the directory e.g. `mkdir -p /var/lib/elasticsearch`
- Change the group ownership to the value of your
  `openshift_logging_elasticsearch_storage_group` parameter (default `65534`)
  e.g. `chgrp 65534 /var/lib/elasticsearch`
- make this directory writable by the group `chmod -R g+w /var/lib/elasticsearch`
- add the following selinux policy:

      # semanage fcontext -a -t svirt_sandbox_file_t "/var/lib/elasticsearch(/.*)?"
        
      # restorecon -R -v /var/lib/elasticsearch


Installing ViaQ Packages
------------------------

The setup below is for a an all-in-one machine, running
Ansible in *local* mode to install ViaQ on the same machine as Ansible is
running on.  It also configures the `AllowAllPasswordIdentityProvider` with
`mappingMethod: lookup`, which means the administrator will need to manually
create users.  See below for more information about users.

Ansible is used to install ViaQ and OCP or Origin using OpenShift Ansible.
The following packages are required:

    # yum install openshift-ansible \
      openshift-ansible-callback-plugins openshift-ansible-filter-plugins \
      openshift-ansible-lookup-plugins openshift-ansible-playbooks \
      openshift-ansible-roles


### Customizing vars.yaml

In the first playbook you run [Run ovirt-metrics-store-installation playbook](https://ovirt.org/develop/release-management/features/metrics/metrics-store-installation/#run-ovirt-metrics-store-installation-playbook)
the ansible-inventory and vars.yaml files were generated and copied to the OpenShift machine.
The OpenShift ansible-playbook command is used together with the Ansible inventory file and a vars.yaml file.
All customization can be done via the vars.yaml file.


Running Ansible
---------------

**NOTE**: In the sections that follow, the text that refers to specifc
  hostnames and IP addresses should be changed to the values you set in your
  `vars.yaml` file.
* `10.16.19.171` - replace this with your `openshift_public_ip`
* `192.168.122.4` - replace this with your `openshift_ip`
* `openshift.logging.test` - replace this with your `openshift_public_hostname`
* `kibana.logging.test` - replace this with `openshift_logging_kibana_hostname`

The public hostname should typically be a DNS entry for the
public IP address.

1. Run ansible:

       # cd /usr/share/ansible/openshift-ansible
       # (or wherever you cloned the git repo if using git)
       ANSIBLE_LOG_PATH=/tmp/ansible.log ansible-playbook -vvv -e @/root/vars.yaml -i /root/ansible-inventory-origin-37-aio playbooks/byo/config.yml


2. Check `/tmp/ansible.log` if there are any errors during the run.  If this
hangs, just kill it and run it again - Ansible is (mostly) idempotent.  Same
applies if there are any errors during the run - fix the machine and/or the
`vars.yaml` and run it again.

Note : If the installation hangs, kill it and run it again.

Enabling Elasticsearch to Mount the Directory
---------------------------------------------
The installation of Elasticsearch will fail because there is currently no way to grant
the Elasticsearch service account permission to mount that directory.
After installation is complete, do the following steps to enable Elasticsearch to mount the directory:
       
        # oc project logging
        # oadm policy add-scc-to-user hostmount-anyuid \
          system:serviceaccount:logging:aggregated-logging-elasticsearch

        # oc rollout cancel $( oc get -n logging dc -l component=es -o name )
        # oc rollout latest $( oc get -n logging dc -l component=es -o name )
        # oc rollout status -w $( oc get -n logging dc -l component=es -o name )


Enabling Kopf
-------------
kopf is a simple web administration tool for elasticsearch.

It offers an easy way of performing common tasks on an elasticsearch cluster.
Not every single API is covered by this plugin, but it does offer a REST client
which allows you to explore the full potential of the ElasticSearch API.

See:

https://github.com/openshift/origin-aggregated-logging/tree/master/hack/kopf



### Post-Install Checking ###

1. To confirm that Elasticsearch, Curator, Kibana, and Fluentd pods are running, run:

       # oc project logging
       # oc get pods

2. To confirm that the Elasticsearch and Kibana services are running, run:

       # oc project logging
       # oc get svc

3. To confirm that there are routes for Elasticsearch and Kibana, run:


       # oc project logging
       # oc get routes


### Test Elasticsearch ###

To search Elasticsearch, first get the name of the Elasticsearch pod, then use oc exec to query Elasticsearch.
The example search below will look for all log records in project.logging and will sort them by @timestamp
(which is the timestamp when the record was created at the source) in descending order (that is, latest first):

    # oc project logging
    # espod=`oc get pods -l component=es -o jsonpath='{.items[0].metadata.name}'`
    # oc exec -c elasticsearch $espod -- curl --connect-timeout 1 -s -k \
      --cert /etc/elasticsearch/secret/admin-cert \
      --key /etc/elasticsearch/secret/admin-key \
      'https://localhost:9200/project.logging.*/_search?sort=@timestamp:desc' | \
      python -mjson.tool | more


    {
    "_shards": {
        "failed": 0,
        "successful": 1,
        "total": 1
    },
    "hits": {
        "hits": [
            {
                "_id": "AVi70uBa6F1hLfsBbCQq",
                "_index": "project.logging.42eab680-b7f9-11e6-a793-fa163e8a98f9.2016.12.01",
                "_score": 1.0,
                "_source": {
                    "@timestamp": "2016-12-01T14:09:53.848788-05:00",
                    "docker": {
                        "container_id": "adcf8981baf37f3dab0a659fbd78d6084fde0a2798020d3c567961a993713405"
                    },
                    "hostname": "host-192-168-78-2.openstacklocal",
                    "kubernetes": {
                        "container_name": "deployer",
                        "host": "host-192-168-78-2.openstacklocal",
                        "labels": {
                            "app": "logging-deployer-template",
                            "logging-infra": "deployer",
                            "provider": "openshift"
                        },
                        "namespace_id": "42eab680-b7f9-11e6-a793-fa163e8a98f9",
                        "namespace_name": "logging",
                        "pod_id": "b2806c29-b7f9-11e6-a793-fa163e8a98f9",
                        "pod_name": "logging-deployer-akqwb"
                    },
                    "level": "3",
                    "message": "writing new private key to '/etc/deploy/scratch/system.logging.fluentd.key'",
                    "pipeline_metadata": {
                        "collector": {
                            "inputname": "fluent-plugin-systemd",
                            "ipaddr4": "10.128.0.26",
                            "ipaddr6": "fe80::30e3:7cff:fe55:4134",
                            "name": "fluentd openshift",
                            "received_at": "2016-12-01T14:09:53.848788-05:00",
                            "version": "0.12.29 1.4.0"
                        }
                    }
                },
                "_type": "com.redhat.viaq.common"
            }
        ],
        "max_score": 1.0,
        "total": 1453
    },
    "timed_out": false,
    "took": 15
    }

Creating the Admin User
-----------------------

Manually create an admin OpenShift user to allow access to Kibana to view the RHV metrics and log data. 

**Note:** The "admin" user will be created when running the oVirt metrics playbook in the following steps.

To create an admin user:

    # oc project logging
    # oc create user admin
    # oc create identity allow_all:admin
    # oc create useridentitymapping allow_all:admin admin
    # oadm policy add-cluster-role-to-user cluster-admin admin

This will create the user account.  The password is set at the
first login.  To set the password now:

    # oc login --username=admin --password=admin
    # oc login --username=system:admin
    
Creating a "Normal" User
-----------------------
To create an "normal" user that can only view logs in a particular set of
projects, follow the steps above, except do not assign the `cluster-admin`
role, use the following instead:

    # oc project $namespace
    # oadm policy add-role-to-user view $username

Where `$username` is the name of the user you created instead of `admin`,
and `$namespace` is the name of the project or namespace you wish to allow
the user to have access to the logs of.

For example, to create a user
named `loguser` that can view logs in `ovirt-metrics-engine`:

    # oc create user loguser
    # oc create identity allow_all:loguser
    # oc create useridentitymapping allow_all:loguser loguser
    # oc project ovirt-metrics-engine
    # oadm policy add-role-to-user view loguser

and to assign the password immediately instead of waiting for the user
to login:

    # oc login --username=loguser --password=loguser
    # oc login --username=system:admin

## Appendix 1 CentOS7 ViaQ yum repos

[CentOS 7 ViaQ](centos7-viaq.repo)
