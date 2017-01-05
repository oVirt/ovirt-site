# Importing an Existing Red Hat Gluster Storage Cluster

You can import a Red Hat Gluster Storage cluster and all hosts belonging to the cluster into Red Hat Virtualization Manager.

When you provide details such as the IP address or host name and password of any host in the cluster, the `gluster peer status` command is executed on that host through SSH, then displays a list of hosts that are a part of the cluster. You must manually verify the fingerprint of each host and provide passwords for them. You will not be able to import the cluster if one of the hosts in the cluster is down or unreachable. As the newly imported hosts do not have VDSM installed, the bootstrap script installs all the necessary VDSM packages on the hosts after they have been imported, and reboots them.

**Importing an Existing Red Hat Gluster Storage Cluster to Red Hat Virtualization Manager**

1. Select the **Clusters** resource tab to list all clusters in the results list.

2. Click **New** to open the **New Cluster** window.

3. Select the **Data Center** the cluster will belong to from the drop-down menu.

4. Enter the **Name** and **Description** of the cluster.

5. Select the **Enable Gluster Service** radio button and the **Import existing gluster configuration** check box.

    The **Import existing gluster configuration** field is displayed only if you select **Enable Gluster Service** radio button.

6. In the **Address** field, enter the hostname or IP address of any server in the cluster.

    The host **Fingerprint** displays to ensure you are connecting with the correct host. If a host is unreachable or if there is a network error, an error **Error in fetching fingerprint** displays in the **Fingerprint** field.

7. Enter the **Root Password** for the server, and click **OK**.

8. The **Add Hosts** window opens, and a list of hosts that are a part of the cluster displays.

9. For each host, enter the **Name** and the **Root Password**.

10. If you wish to use the same password for all hosts, select the **Use a Common Password** check box to enter the password in the provided text field.

    Click **Apply** to set the entered password all hosts.

    Make sure the fingerprints are valid and submit your changes by clicking **OK**.

The bootstrap script installs all the necessary VDSM packages on the hosts after they have been imported, and reboots them. You have now successfully imported an existing Red Hat Gluster Storage cluster into Red Hat Virtualization Manager.
