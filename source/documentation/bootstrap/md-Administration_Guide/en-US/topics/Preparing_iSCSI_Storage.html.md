# Preparing iSCSI Storage

Use the following steps to export an iSCSI storage device from a server running Red Hat Enterprise Linux 6 to use as a storage domain with Red Hat Virtualization.

**Preparing iSCSI Storage**

1. Install the `scsi-target-utils` package using the `yum` command as root on your storage server.

        # yum install -y scsi-target-utils

2. Add the devices or files you want to export to the `/etc/tgt/targets.conf` file. Here is a generic example of a basic addition to the `targets.conf` file:

        <target iqn.YEAR-MONTH.com.EXAMPLE:SERVER.targetX>
                  backing-store /PATH/TO/DEVICE1 # Becomes LUN 1
                  backing-store /PATH/TO/DEVICE2 # Becomes LUN 2
                  backing-store /PATH/TO/DEVICE3 # Becomes LUN 3
        </target>

    Targets are conventionally defined using the year and month they are created, the reversed fully qualified domain that the server is in, the server name, and a target number.

3. Start the `tgtd` service.

        # systemctl start tgtd.service

4. Make the `tgtd` start persistently across reboots.

        # systemctl enable tgtd.service

5. Open an iptables firewall port to allow clients to access your iSCSI export. By default, iSCSI uses port 3260. This example inserts a firewall rule at position 6 in the INPUT table.

        # iptables -I INPUT 6 -p tcp --dport 3260 -j ACCEPT

6. Save the iptables rule you just created.

        # service iptables save

You have created a basic iSCSI export. You can use it as an iSCSI data domain.
