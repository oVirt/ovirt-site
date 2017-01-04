# Changing the Cluster Compatibility Version

Red Hat Virtualization clusters have a compatibility version. The cluster compatibility version indicates the features of Red Hat Virtualization supported by all of the hosts in the cluster. The cluster compatibility is set according to the version of the least capable host operating system in the cluster.

**Note:** To change the cluster compatibility version, you must have first updated all the hosts in your cluster to a level that supports your desired compatibility level.

**Changing the Cluster Compatibility Version**

1. From the Administration Portal, click the **Clusters** tab.

2. Select the cluster to change from the list displayed.

3. Click **Edit**.

4. Change the **Compatibility Version** to the desired value.

5. Click **OK** to open the **Change Cluster Compatibility Version** confirmation window.

6. Click **OK** to confirm.

You have updated the compatibility version of the cluster. Once you have updated the compatibility version of all clusters in a data center, you can then change the compatibility version of the data center itself.

**Important:** Upgrading the compatibility will also upgrade all of the storage domains belonging to the data center.
