# Changing the FQDN of a Host

Use the following procedure to change the fully qualified domain name of hosts.

**Updating the FQDN of a Host**

1. Place the host into maintenance mode so the virtual machines are live migrated to another host. See [Moving a host to maintenance mode1](Moving_a_host_to_maintenance_mode1) for more information. Alternatively, manually shut down or migrate all the virtual machines to another host. See [Manually Migrating Virtual Machines](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/virtual-machine-management-guide/#Manually_migrating_virtual_machines) in the *Virtual Machine Management Guide* for more information.

2. Click **Remove**, and click **OK** to remove the host from the Administration Portal.

3. Use the `hostnamectl` tool to update the host name. For more options, see [Configure Host Names](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Networking_Guide/ch-Configure_Host_Names.html) in the *Red Hat Enterprise Linux 7 Networking Guide*.

        # hostnamectl set-hostname NEW_FQDN

4. Reboot the host.

5. Re-register the host with the Manager. See [Adding a Host](Adding_a_Host) for more information.




