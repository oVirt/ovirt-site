# Sealing a Linux Virtual Machine for Deployment as a Template using sys-unconfig

You must generalize (seal) a Linux virtual machine before creating a template based on that virtual machine.

**Sealing a Linux Virtual Machine using sys-unconfig**

1. Log in to the virtual machine.

2. Remove ssh host keys:

        # rm -rf /etc/ssh/ssh_host_*

3. Set `HOSTNAME=localhost.localdomain` in `/etc/sysconfig/network` for Red Hat Enterprise Linux 6 or `/etc/hostname` for Red Hat Enterprise Linux 7.

4. Remove the `HWADDR` line and `UUID` line from `/etc/sysconfig/network-scripts/ifcfg-eth*`.

5. Optionally, delete all the logs from `/var/log` and build logs from `/root`.

6. Run the following command:

        # sys-unconfig

The virtual machine shuts down; it is now sealed and can be made into a template. You can deploy Linux virtual machines from this template without experiencing configuration file conflicts.
