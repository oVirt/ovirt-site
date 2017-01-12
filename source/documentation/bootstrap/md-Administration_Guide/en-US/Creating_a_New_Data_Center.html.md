# Creating a New Data Center

This procedure creates a data center in your virtualization environment. The data center requires a functioning cluster, host, and storage domain to operate.

**Note:** The storage **Type** can be edited until the first storage domain is added to the data center. Once a storage domain has been added, the storage **Type** cannot be changed.

Once the **Compatibility Version** is set, it cannot be lowered at a later time; version regression is not allowed.

**Creating a New Data Center**

1. Select the **Data Centers** resource tab to list all data centers in the results list.

2. Click **New** to open the **New Data Center** window.

3. Enter the **Name** and **Description** of the data center.

4. Select the storage **Type**, **Compatibility Version**, and **Quota Mode** of the data center from the drop-down menus.

5. Optionally, change the MAC address pool for the data center. The default MAC address pool is preselected by default. For more information on creating MAC address pools see [MAC Address Pools](sect-MAC_Address_Pools).

    1. Click the **MAC Address Pool** tab.

    2. Select the required MAC address pool from the **MAC Address Pool** drop-down list. 

6. Click **OK** to create the data center and open the **New Data Center - Guide Me** window.

7. The **Guide Me** window lists the entities that need to be configured for the data center. Configure these entities or postpone configuration by clicking the **Configure Later** button; configuration can be resumed by selecting the data center and clicking the **Guide Me** button.

The new data center is added to the virtualization environment. It will remain **Uninitialized** until a cluster, host, and storage domain are configured for it; use **Guide Me** to configure these entities.
