# Adding Red Hat Gluster Storage Nodes

Add Red Hat Gluster Storage nodes to Gluster-enabled clusters and incorporate GlusterFS volumes and bricks into your Red Hat Virtualization environment.

This procedure presumes that you have a Gluster-enabled cluster of the appropriate **Compatibility Version** and a Red Hat Gluster Storage node already set up. For information on setting up a Red Hat Gluster Storage node, see the [Red Hat Gluster Storage Installation Guide](https://access.redhat.com/documentation/en-US/Red_Hat_Storage/3.1/html/Installation_Guide/chap-Installing_Red_Hat_Storage.html). For more information on the compatibility matrix, see the [Red Hat Gluster Storage Version Compatibility and Support](https://access.redhat.com/articles/2356261).

**Adding a Red Hat Gluster Storage Node**

1. Click the **Hosts** resource tab to list the hosts in the results list.

2. Click **New** to open the **New Host** window.

3. Use the drop-down menus to select the **Data Center** and **Host Cluster** for the Red Hat Gluster Storage node.

4. Enter the **Name**, **Address**, and **SSH Port** of the Red Hat Gluster Storage node.

5. Select an authentication method to use with the Red Hat Gluster Storage node.

    * Enter the root user's password to use password authentication.

    * Copy the key displayed in the **SSH PublicKey** field to `/root/.ssh/authorized_keys` on the Red Hat Gluster Storage node to use public key authentication.

6. Click **OK** to add the node and close the window.

You have added a Red Hat Gluster Storage node to your Red Hat Virtualization environment. You can now use the volume and brick resources of the node in your environment.


