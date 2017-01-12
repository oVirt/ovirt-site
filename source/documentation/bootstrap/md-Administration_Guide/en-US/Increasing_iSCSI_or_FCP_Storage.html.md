# Increasing iSCSI or FCP Storage

There are multiple ways to increase iSCSI or FCP storage size:

* Create a new storage domain with new LUNs and add it to an existing datacenter. See [Adding iSCSI Storage](Adding_iSCSI_Storage1).

* Create new LUNs and add them to an existing storage domain.

* Expand the storage domain by resizing the underlying LUNs.

For information about creating, configuring, or resizing iSCSI storage on Red Hat Enterprise Linux 6 systems, see [Red Hat Enterprise Linux 6 Storage Administration Guide](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html-single/Storage_Administration_Guide/index.html#iscsi-target-setup). For Red Hat Enterprise Linux 7 systems, see [Red Hat Enterprise Linux 7 Storage Administration Guide](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html-single/Storage_Administration_Guide/index.html#osm-target-setup). 

The following procedure explains how to expand storage area network (SAN) storage by adding a new LUN to an existing storage domain.

**Increasing an Existing iSCSI or FCP Storage Domain**

1. Create a new LUN on the SAN. 

2. Click the **Storage** resource tab and select an iSCSI or FCP domain.

3. Click the **Edit** button.

4. Click on **Targets > LUNs**, and click the **Discover Targets** expansion button.

5. Enter the connection information for the storage server and click the **Discover** button to initiate the connection.

6. Click on **LUNs > Targets** and select the check box of the newly available LUN.

7. Click **OK** to add the LUN to the selected storage domain.

This will increase the storage domain by the size of the added LUN.

When expanding the storage domain by resizing the underlying LUNs, the LUNs must also be refreshed in the Red Hat Virtualization Administration Portal.

**Refreshing the LUN Size**

1. Click the **Storage** resource tab and select an iSCSI or FCP domain.

2. Click the **Edit** button.

3. Click on **LUNs > Targets**.

4. In the **Additional Size** column, click the **Add Additional_Storage_Size** button of the LUN to refresh. 

5. Click **OK** to refresh the LUN to indicate the new storage size.
