# Creating a New Quota Policy

You have enabled quota mode, either in Audit or Enforcing mode. You want to define a quota policy to manage resource usage in your data center.

**Creating a New Quota Policy**

1. In tree mode, select the data center. The **Quota** tab appears in the Navigation Pane.

2. Click the **Quota** tab in the Navigation Pane.

3. Click **Add** in the Navigation Pane. The **New Quota** window opens.

4. Fill in the **Name** field with a meaningful name.

    Fill in the **Description** field with a meaningful name.

5. In the **Memory & CPU** section of the **New Quota** window, use the green slider to set **Cluster Threshold**.

6. In the **Memory & CPU** section of the **New Quota** window, use the blue slider to set **Cluster Grace**.

7. Select the **All Clusters** or the **Specific Clusters** radio button. If you select **Specific Clusters**, select the check box of the clusters that you want to add a quota policy to.

8. Click **Edit** to open the **Edit Quota** window.

9. Under the **Memory** field, select either the **Unlimited** radio button (to allow limitless use of Memory resources in the cluster), or select the **limit to** radio button to set the amount of memory set by this quota. If you select the **limit to** radio button, input a memory quota in megabytes (MB) in the **MB** field.

10. Under the **CPU** field, select either the **Unlimited** radio button or the **limit to** radio button to set the amount of CPU set by this quota. If you select the **limit to** radio button, input a number of vCPUs in the **vCpus** field.

11. Click **OK** in the **Edit Quota** window.

12. In the **Storage** section of the **New Quota** window, use the green slider to set **Storage Threshold**.

13. In the **Storage** section of the **New Quota** window, use the blue slider to set **Storage Grace**.

14. Select the **All Storage Domains** or the **Specific Storage Domains** radio button. If you select **Specific Storage Domains**, select the check box of the storage domains that you want to add a quota policy to.

15. Click **Edit** to open the **Edit Quota** window.

16. Under the **Storage Quota** field, select either the **Unlimited** radio button (to allow limitless use of Storage) or the **limit to** radio button to set the amount of storage to which quota will limit users. If you select the **limit to** radio button, input a storage quota size in gigabytes (GB) in the **GB** field.

17. Click **OK** in the **Edit Quota** window. You are returned to the **New Quota** window.

18. Click **OK** in the **New Quota** window.

**Result**

You have created a new quota policy.
