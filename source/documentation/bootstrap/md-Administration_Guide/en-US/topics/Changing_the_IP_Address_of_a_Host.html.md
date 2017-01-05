# Changing the IP Address of a Host

1. Place the host into maintenance mode so the virtual machines are live migrated to another host. See [Moving a host to maintenance mode](Moving_a_host_to_maintenance_mode1) for more information. Alternatively, manually shut down or migrate all the virtual machines to another host. See [Manually Migrating Virtual Machines](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/virtual-machine-management-guide/#Manually_migrating_virtual_machines) in the *Virtual Machine Management Guide* for more information.

2. Click **Remove**, and click **OK** to remove the host from the Administration Portal.

2. Log in to your host as the `admin` user.

3. Press **F2**, select **OK**, and press **Enter** to enter the rescue shell.

4. Modify the IP address by editing the `/etc/sysconfig/network-scripts/ifcfg-ovirtmgmt` file. For example:

        # vi /etc/sysconfig/network-scripts/ifcfg-ovirtmgmt
        ...
        BOOTPROTO=none
        IPADDR=10.x.x.x
        PREFIX=24
        ...

5. Restart the network service and verify that the IP address has been updated.

        # systemctl restart network.service
        # ip addr show ovirtmgmt

6. Type `exit` to exit the rescue shell and return to the text user interface.

7. Re-register the host with the Manager. See [Adding a Host](Adding_a_Host) for more information.



