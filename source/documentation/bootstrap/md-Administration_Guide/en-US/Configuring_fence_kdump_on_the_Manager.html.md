# Configuring fence_kdump on the Manager

Edit the Manager's kdump configuration. This is only necessary in cases where the default configuration is not sufficient. The current configuration values can be found using:

    # engine-config -g OPTION

**Manually Configuring Kdump with engine-config**

1. Edit kdump's configuration using the `engine-config` command: 

        # engine-config -s OPTION=value

    **Important:** The edited values must also be changed in the fence_kdump listener configuration file as outlined in the `Kdump Configuration Options` table. See [fence kdump listener Configuration](fence_kdump_listener_Configuration).

2. Restart the `ovirt-engine` service:

        # systemctl restart ovirt-engine.service

3. Reinstall all hosts with **Kdump integration** enabled, if required (see the table below).

The following options can be configured using `engine-config`:

**Kdump Configuration Options**

| Variable | Description | Default | Note |
|-
| FenceKdumpDestinationAddress | Defines the hostname(s) or IP address(es) to send fence_kdump messages to. If empty, the Manager's FQDN is used. | Empty string (Manager FQDN is used) | If the value of this parameter is changed, it must match the value of `LISTENER_ADDRESS` in the fence_kdump listener configuration file, and all hosts with **Kdump integration** enabled must be reinstalled. |
| FenceKdumpDestinationPort | Defines the port to send fence_kdump messages to. | 7410 | If the value of this parameter is changed, it must match the value of `LISTENER_PORT` in the fence_kdump listener configuration file, and all hosts with **Kdump integration** enabled must be reinstalled. |
| FenceKdumpMessageInterval | Defines the interval in seconds between messages sent by fence_kdump. | 5 | If the value of this parameter is changed, it must be half the size or smaller than the value of `KDUMP_FINISHED_TIMEOUT` in the fence_kdump listener configuration file, and all hosts with **Kdump integration** enabled must be reinstalled. |
| FenceKdumpListenerTimeout | Defines the maximum timeout in seconds since the last heartbeat to consider the fence_kdump listener alive. | 90 | If the value of this parameter is changed, it must be double the size or higher than the value of `HEARTBEAT_INTERVAL` in the fence_kdump listener configuration file. |
| KdumpStartedTimeout | Defines the maximum timeout in seconds to wait until the first message from the kdumping host is received (to detect that host kdump flow has started). | 30 | If the value of this parameter is changed, it must be double the size or higher than the value of `SESSION_SYNC_INTERVAL` in the fence_kdump listener configuration file, and `FenceKdumpMessageInterval`. |
