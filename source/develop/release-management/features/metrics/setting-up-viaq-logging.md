---
title: oVirt Metrics Store - Setting Up ViaQ Logging
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

Setting Up oVirt metrics store
=======================

Intro
-----

The oVirt metrics store is based on the [OpenShift
Logging](https://github.com/openshift/origin-aggregated-logging) stack.
You can use either the OpenShift Container Platform (OCP) based on RHEL7, or
OpenShift Origin (Origin) based on CentOS7.  Ansible is used to install logging
using the [OpenShift Ansible](https://github.com/openshift/openshift-ansible)
logging [roles](https://github.com/openshift/openshift-ansible/blob/master/roles/openshift_logging/README.md).

Ansible is used to install oVirt metrics store using OpenShift Ansible.
The following packages are required:

### Customizing vars.yaml

In the first playbook you run [Run ovirt-metrics-store-installation playbook](/develop/release-management/features/metrics/metrics-store-installation/#run-ovirt-metrics-store-installation-playbook),
a few files are generated and copied to the metrics store virtual machine.


Running Ansible
---------------

Log into the admin portal and review the metrics store installer virtual machine creation.

Log into the metrics store installer virtual machine
```
  # ssh root@<metrics-store-installer ip or fqdn>
```

Run the ansible plabook that creates the OpenShift vms and deploys OpenShift

```
  # ANSIBLE_ROLES_PATH="/usr/share/ansible/roles/:/usr/share/ansible/openshift-ansible/roles" \
    ANSIBLE_JINJA2_EXTENSIONS="jinja2.ext.do" \
    ansible-playbook -i integ.ini install_okd.yaml -e @vars.yaml
```

4. Check `/tmp/ansible.log` if there are any errors during the run.  If this
hangs, just kill it and run it again - Ansible is (mostly) idempotent.  Same
applies if there are any errors during the run - fix the machine and/or the
`vars.yaml` and run it again.


Enabling Elasticsearch to Mount the Directory
---------------------------------------------
The installation of Elasticsearch will fail because there is currently no way to grant
the Elasticsearch service account permission to mount that directory.
After installation is complete, do the following steps to enable Elasticsearch to mount the directory:


        # oc project logging
        # oc adm policy add-scc-to-user hostmount-anyuid \
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

During the metrics store installation an admin user is created.
The admin user has permissions to access Kibana and view the oVirt metrics and log data and dashboards. 

By default, the password for the user "admin" is "admin".
This can be uodate in the config.yml file, buy updating the "ovirt_metrics_admin_password".

To create additional admin users, Run:

    # oc project logging
    # oc create user $username
    # oc create identity allow_all:$username
    # oc create useridentitymapping allow_all:$username $username
    # oc adm policy add-cluster-role-to-user cluster-admin $username

This will create the user account.  The password is set at the
first login.  To set the password now:

    # oc login --username=$username --password=$userpassword

Creating a "Normal" User
-----------------------
To create an "normal" user that can only view logs in a particular set of
projects, follow the steps above, except do not assign the `cluster-admin`
role, use the following instead:

    # oc project $namespace
    # oc adm policy add-role-to-user view $username

Where `$username` is the name of the user you created instead of `admin`,
and `$namespace` is the name of the project or namespace you wish to allow
the user to have access to the logs of.

For example, to create a user
named `loguser` that can view logs in `ovirt-metrics-engine`:

    # oc create user loguser
    # oc create identity allow_all:loguser
    # oc create useridentitymapping allow_all:loguser loguser
    # oc project ovirt-metrics-engine
    # oc adm policy add-role-to-user view loguser

and to assign the password immediately instead of waiting for the user
to login:

    # oc login --username=loguser --password=loguser
    # oc login --username=system:admin
