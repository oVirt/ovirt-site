---
title: Deploying Collectd and Rsyslog
---

# 3. Deploying collectd and rsyslog

Deploy collectd and rsyslog on the Red Hat Virtualization hosts to collect logs and metrics.

**NOTE** You do not need to repeat this procedure if you create new hosts. The Manager configures the hosts automatically.

## Procedure

1. Log in to the Manager machine using SSH.
2. Copy `config.yml.example` to create `config.yml`:

```
# cp /etc/ovirt-engine-metrics/config.yml.example /etc/ovirt-engine-metrics/config.yml.d/config.yml
```

3. Edit the `ovirt_env_name` and `elasticsearch_host` parameters in config.yml and save the file. These parameters are mandatory and are documented in the file.
4. Deploy Collectd and Rsyslog on the hosts:

```
# /usr/share/ovirt-engine-metrics/setup/ansible/configure_ovirt_machines_for_metrics.sh
```
**NOTE** Fluentd has beed replaced by Rsyslog for hosts version 4.3 and above, due to better performance.

**Prev:** [Chapter 2: Installing Metrics Store](Installing_Metrics_Store)<br>
**Next:** [Chapter 4: Verifying the Installation](Verifying_the_Installation)

[Adapted from RHV 4.3 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.3/html-single/metrics_store_installation_guide/index#Verifying_the_metrics_store_installation)
