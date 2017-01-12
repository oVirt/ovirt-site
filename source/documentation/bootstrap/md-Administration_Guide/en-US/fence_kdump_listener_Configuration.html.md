# fence_kdump listener Configuration

Edit the configuration of the fence_kdump listener. This is only necessary in cases where the default configuration is not sufficient.

**Manually Configuring the fence_kdump Listener**

1. Create a new file (for example, `my-fence-kdump.conf`) in `/etc/ovirt-engine/ovirt-fence-kdump-listener.conf.d/`

2. Enter your customization with the syntax `OPTION=value` and save the file.

    **Important:** The edited values must also be changed in `engine-config` as outlined in the fence_kdump Listener Configuration Options table in [Configuring fence kdump on the Manager](Configuring_fence_kdump_on_the_Manager).

3. Restart the fence_kdump listener: 

        # systemctl restart ovirt-fence-kdump-listener.service

The following options can be customized if required:

**fence_kdump Listener Configuration Options**

| Variable | Description | Default | Note |
|-
| LISTENER_ADDRESS | Defines the IP address to receive fence_kdump messages on. | 0.0.0.0 | If the value of this parameter is changed, it must match the value of `FenceKdumpDestinationAddress` in `engine-config`. |
| LISTENER_PORT | Defines the port to receive fence_kdump messages on. | 7410 | If the value of this parameter is changed, it must match the value of `FenceKdumpDestinationPort` in `engine-config`. |
| HEARTBEAT_INTERVAL | Defines the interval in seconds of the listener's heartbeat updates. | 30 | If the value of this parameter is changed, it must be half the size or smaller than the value of `FenceKdumpListenerTimeout` in `engine-config`. |
| SESSION_SYNC_INTERVAL | Defines the interval in seconds to synchronize the listener's host kdumping sessions in memory to the database. | 5 | If the value of this parameter is changed, it must be half the size or smaller than the value of `KdumpStartedTimeout` in `engine-config`. |
| REOPEN_DB_CONNECTION_INTERVAL | Defines the interval in seconds to reopen the database connection which was previously unavailable. | 30 | - |
| KDUMP_FINISHED_TIMEOUT | Defines the maximum timeout in seconds after the last received message from kdumping hosts after which the host kdump flow is marked as FINISHED. | 60 | If the value of this parameter is changed, it must be double the size or higher than the value of `FenceKdumpMessageInterval` in `engine-config`. |
