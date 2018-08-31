# Configuring Collectd and Fluentd

Deploy and configure collectd and fluentd to send the metrics and logs to OpenShift Aggregated Logging.

**Configuring Collectd and Fluentd**

On the Manager machine, run the following:

```
# /usr/share/ovirt-engine-metrics/setup/ansible/configure_ovirt_machines_for_metrics.sh
```

**Note:** Deploying additional hosts after running this script does *not* require running the script again; the Manager configures the hosts automatically.
