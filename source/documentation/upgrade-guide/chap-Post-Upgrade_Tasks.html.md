---
title: Post-Upgrade Tasks
---

# Chapter 4: Post-Upgrade Tasks

## Changing the Cluster Compatibility Version

oVirt clusters have a compatibility version. The cluster compatibility version indicates the features of oVirt supported by all of the hosts in the cluster. The cluster compatibility is set according to the version of the least capable host operating system in the cluster.

**Note:** To change the cluster compatibility version, you must have first updated all the hosts in your cluster to a level that supports your desired compatibility level.

**Changing the Cluster Compatibility Version**

1. From the Administration Portal, click the **Clusters** tab.

2. Select the cluster to change from the list displayed.

3. Click **Edit**.

4. Change the **Compatibility Version** to the desired value.

5. Click **OK** to open the **Change Cluster Compatibility Version** confirmation window.

6. Click **OK** to confirm.

You have updated the compatibility version of the cluster. Once you have updated the compatibility version of all clusters in a data center, you can then change the compatibility version of the data center itself.

## Changing the Data Center Compatibility Version

oVirt data centers have a compatibility version. The compatibility version indicates the version of oVirt that the data center is intended to be compatible with. All clusters in the data center must support the desired compatibility level.

**Note:** To change the data center compatibility version, you must have first updated all the clusters in your data center to a level that supports your desired compatibility level.

**Changing the Data Center Compatibility Version**

1. From the Administration Portal, click the **Data Centers** tab.

2. Select the data center to change from the list displayed.

3. Click **Edit**.

4. Change the **Compatibility Version** to the desired value.

5. Click **OK** to open the **Change Data Center Compatibility Version** confirmation window.

6. Click **OK** to confirm.

You have updated the compatibility version of the data center.

**Prev:** [Chapter 3: Upgrading to oVirt 4.0](../chap-Upgrading_to_oVirt_4.0) <br>
**Next:** [Appendix A: Updating an Offline oVirt Engine](../appe-Updating_an_Offline_oVirt_Engine)
