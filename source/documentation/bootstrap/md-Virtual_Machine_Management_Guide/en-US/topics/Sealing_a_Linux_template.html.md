# Sealing a Linux Virtual Machine Manually for Deployment as a Template

You must generalize (seal) a Linux virtual machine before creating a template based on that virtual machine.

**Sealing a Linux Virtual Machine**

1. Log in to the virtual machine.

2. Flag the system for re-configuration:

        # touch /.unconfigured

3. Remove ssh host keys:

        # rm -rf /etc/ssh/ssh_host_*

4. Set `HOSTNAME=localhost.localdomain` in `/etc/sysconfig/network` for Red Hat Enterprise Linux 6 or `/etc/hostname` for Red Hat Enterprise Linux 7.

5. Remove `/etc/udev/rules.d/70-*`:

        # rm -rf /etc/udev/rules.d/70-*

6. Remove the `HWADDR` line and `UUID` line from `/etc/sysconfig/network-scripts/ifcfg-eth*`.

7. Optionally, delete all the logs from `/var/log` and build logs from `/root`.

8. Shut down the virtual machine:

        # poweroff

The virtual machine is sealed and can be made into a template. You can deploy Linux virtual machines from this template without experiencing configuration file conflicts.

The steps provided are the minimum steps required to seal a Red Hat Enterprise Linux virtual machine for use as a template. Additional host and site-specific custom steps are available.
