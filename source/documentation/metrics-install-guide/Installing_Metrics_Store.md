---
title: Installing Metrics Store
---

# Chapter 2. Installing oVirt Metrics Store

**Prerequisites**

* Computing resources:

  For metrics store virtual machine:
    * 4 cores
    * 30 GB RAM
    * 650 GB SSD disk

  For metrics store installer virtual machine:
    * 4 cores
    * 8 GB RAM
    * 100 GB SSD disk

**NOTE**
The computing resource requirements are for an all-in-one installation, with a single Metrics Store virtual machine.
The all-in-one installation can collect data from up to ~1000 virtual machines.

* Operating system: Centos 7.6 or later
* Software: oVirt 4.2 or later
* Network configuration:

    * Create a wildcard DNS record `(*.example.com)` for the DNS zone of the Metrics Store virtual machines.
    * Add the hostname of the Metrics Store virtual machines to your DNS server.
    * In all-in-one installation, the metrics store machine FQDN would be master0.example.com, where `example.com` is your `public_hosted_zone`.

## Creating the Metrics Store virtual machines

Creating the Metrics Store virtual machines involves the following steps:

1. Configuring the Metrics Store installation with `metrics-store-config.yml`
2. Creating the following Metrics Store virtual machines:

    * The Metrics Store installer, a temporary virtual machine for deploying OpenShift and services on the Metrics Store virtual machines
    * One or more Metrics Store virtual machines (Currently only one virtual machine is supported)
3. Verifying the Metrics Store virtual machines

### Procedure

1. Log in to the engine machine using SSH.
2. Copy `metrics-store-config.yml.example` to create `metrics-store-config.yml`:

```
# cp /etc/ovirt-engine-metrics/metrics-store-config.yml.example /etc/ovirt-engine-metrics/config.yml.d/metrics-store-config.yml
```
3. Edit the parameters in `metrics-store-config.yml` and save the file. The parameters are documented in the file.

```
# vi /etc/ovirt-engine-metrics/config.yml.d/metrics-store-config.yml
```

4. Copy `secure_vars.yaml.example` to create `secure_vars.yaml`:
```
# cp /etc/ovirt-engine-metrics/secure_vars.yaml.example /etc/ovirt-engine-metrics/secure_vars.yaml
```

5. Edit the parameters in `secure_vars.yaml` and save the file. The parameters are documented in the file.
```
# vi /etc/ovirt-engine-metrics/secure_vars.yaml
```

6. Encrypt secure_vars.yaml file
```
# ansible-vault encrypt /etc/ovirt-engine-metrics/secure_vars.yaml
```

7. Go to the ovirt-engine-metrics directory:

```
# cd /usr/share/ovirt-engine-metrics
```
8. Run the ovirt-metrics-store-installation playbook to create the virtual machines:

```
# ANSIBLE_JINJA2_EXTENSIONS="jinja2.ext.do" ./configure_ovirt_machines_for_metrics.sh \
  --playbook=ovirt-metrics-store-installation.yml --ask-vault-pass
```

9. Log in to the Administration Portal.
10. Click **Compute → Virtual Machines** to verify the successful creation of the `metrics-store-installer` virtual machine and the Metrics Store virtual machines.

## Setup virtual machine static IP and Mac address (Optional)

1. Log in to the Administration Portal.
2. Click **Compute → Virtual Machines** and edit the etrics Store virtual machine.
3. Update the virtual machine mac address and or IP address to your needs, save the changes and reboot it.


## Deploying OpenShift and Metrics Store services

Deploy OpenShift, Elasticsearch, Curator (for managing Elasticsearch indices and snapshots), and Kibana on the Metrics Store virtual machines.

### Procedure

1. Log in to the `metrics-store-installer` virtual machine.
2. Run the install_okd playbook to deploy OpenShift and Metrics Store services to the Metrics Store virtual machines:

```
# ANSIBLE_CONFIG="/usr/share/ansible/openshift-ansible/ansible.cfg" \
  ANSIBLE_ROLES_PATH="/usr/share/ansible/roles/:/usr/share/ansible/openshift-ansible/roles" \
  ansible-playbook -i integ.ini install_okd.yaml -e @vars.yaml -e @secure_vars.yaml --ask-vault-pass
```

3. Verify the deployment by logging in to each Metrics Store virtual machine:

3.1. Log in to the `openshift-logging` project:

```
# oc project openshift-logging
```

3.2. Check that the Elasticsearch, Curator, and Kibana pods are running:

```
# oc get pods
```

If Elasticsearch is not running, see [Troubleshooting related to ElasticSearch](https://docs.okd.io/3.11/install_config/aggregate_logging.html#logging-troubleshooting) in the OpenShift Container Platform 3.11 documentation.

3.3. Check that the Elasticsearch and Kibana services have external IP addresses and ports:

```
# oc get svc
```

3.4. Check the Kibana host name and record it so that you can access the Kibana console in [Section 2.4, “Verifying the Metrics Store installation”](Verifying_the_Installation):

```
# oc get routes
```

4. Log in to the Administration Portal.

5. You can now click **Compute → Virtual Machines** and delete the metrics-store-installer virtual machine.

**IMPORTANT**
Do not delete the `metrics-store-config.yml` file.

**Prev:** [Chapter 1: Metrics Store installation overview](Metrics_Store_installation_overview)<br>
**Next:** [Chapter 3: Verifying the Installation](Verifying_the_Installation)

[Adapted from RHV 4.3 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.3/html-single/metrics_store_installation_guide/index#Installing_metrics_store)
