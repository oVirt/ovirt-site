# Troubleshooting

The following sections explain how to resolve issues that may occur in Metrics Store.

## Information Is Missing from Kibana

If Kibana is not displaying metric or log information as expected, you can use `journalctl` to investigate the collectd and fluentd log files as follows:
 
* If only metrics information is missing, check the collectd log files. 
* If only log information is missing, check the fluentd log files. 
* If both metrics and logs information are missing, check both log files.

**To investigate collectd log files:**

    # journalctl -u collectd 

**To investigate fluentd log files:**

    # journalctl -u fluentd 

**Note:** To learn about the other journalctl options refer to the man page.  
