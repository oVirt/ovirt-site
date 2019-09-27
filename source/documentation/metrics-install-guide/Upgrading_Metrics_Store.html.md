---
title: Replacing Fluentd with Rsyslog
---

# Chapter 5: Upgrading Metrics from 4.2

In oVirt 4.3 Fluentd was replaced by Rsyslog to gather metrics and logs from the oVirt hosts and engine.

Rsyslog is used to collect and parse Engine, VDSM logs and Collectd metrics, add additional metadata and send the data to the remote metrics store.

**Note**: this does not upgrade the Metrics store but the collectors.

## pre-req

* oVirt 4.3 with working metrics OpenShift deployment.
* oVirt 4.3 which was previously upgraded from 4.2 or 4.3 minor.



## Procedure

1. Log in to the upgraded oVirt Host machine using SSH.
2. Check  `config.yml.example`  and update  `config.yml` if changes are required:
   - Verify that  `ovirt_env_name` and `elasticsearch_host` parameters  exists in config.yml

3. Deploy Collectd and Rsyslog on the hosts:

```
# /usr/share/ovirt-engine-metrics/setup/ansible/configure_ovirt_machines_for_metrics.sh
```

