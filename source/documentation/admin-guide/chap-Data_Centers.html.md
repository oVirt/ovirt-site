---
title: Data Centers
---

# Chapter 4: Data Centers

## Introduction to Data Centers

A data center is a logical entity that defines the set of resources used in a specific environment. A data center is considered a container resource, in that it is comprised of logical resources, in the form of clusters and hosts; network resources, in the form of logical networks and physical NICs; and storage resources, in the form of storage domains.

A data center can contain multiple clusters, which can contain multiple hosts; it can have multiple storage domains associated to it; and it can support multiple virtual machines on each of its hosts. An oVirt environment can contain multiple data centers; the data center infrastructure allows you to keep these centers separate.

All data centers are managed from the single Administration Portal.

**Data Centers**

![](/images/admin-guide/523.png)

oVirt creates a default data center during installation. You can configure the default data center, or set up new appropriately named data centers.

**Data Center Objects**

![](/images/admin-guide/179.png)

## The Storage Pool Manager

The Storage Pool Manager (SPM) is a role given to one of the hosts in the data center enabling it to manage the storage domains of the data center. The SPM entity can be run on any host in the data center; the oVirt Engine grants the role to one of the hosts. The SPM does not preclude the host from its standard operation; a host running as SPM can still host virtual resources.

The SPM entity controls access to storage by coordinating the metadata across the storage domains. This includes creating, deleting, and manipulating virtual disks (images), snapshots, and templates, and allocating storage for sparse block devices (on SAN). This is an exclusive responsibility: only one host can be the SPM in the data center at one time to ensure metadata integrity.

The oVirt Engine ensures that the SPM is always available. The Manager moves the SPM role to a different host if the SPM host encounters problems accessing the storage. When the SPM starts, it ensures that it is the only host granted the role; therefore it will acquire a storage-centric lease. This process can take some time.

## SPM Priority

The SPM role uses some of a host's available resources. The SPM priority setting of a host alters the likelihood of the host being assigned the SPM role: a host with high SPM priority will be assigned the SPM role before a host with low SPM priority. Critical virtual machines on hosts with low SPM priority will not have to contend with SPM operations for host resources.

You can change a host’s SPM priority in the **SPM** tab in the **Edit Host** window.

## Data Center Tasks

### Creating a New Data Center

This procedure creates a data center in your virtualization environment. The data center requires a functioning cluster, host, and storage domain to operate.

    **Note:** Once the **Compatibility Version** is set, it cannot be lowered at a later time; version regression is not allowed.

    The option to specify a MAC pool range for a data center has been disabled, and is now done at the cluster level.

**Creating a New Data Center**

1. Click **Compute** &rarr; **Data Centers**.

2. Click **New**.

3. Enter the **Name** and **Description** of the data center.

4. Select the storage **Type**, **Compatibility Version**, and **Quota Mode** of the data center from the drop-down menus.

5. Click **OK** to create the data center and open the **Data Center - Guide Me** window.

6. The **Guide Me** window lists the entities that need to be configured for the data center. Configure these entities or postpone configuration by clicking the **Configure Later** button; configuration can be resumed by selecting the data center and clicking **More Actions** &rarr; **Guide Me**.

The new data center is added to the virtualization environment. It will remain **Uninitialized** until a cluster, host, and storage domain are configured for it; use **Guide Me** to configure these entities.

### Explanation of Settings in the New Data Center and Edit Data Center Windows

The table below describes the settings of a data center as displayed in the **New Data Center** and **Edit Data Center** windows. Invalid entries are outlined in orange when you click **OK**, prohibiting the changes being accepted. In addition, field prompts indicate the expected values or range of values.

**Data Center Properties**

<table>
 <thead>
  <tr>
   <td>Field</td>
   <td>Description/Action</td>
  </tr>
   </thead>
   <tbody>
  <tr>
   <td><b>Name</b></td>
   <td>The name of the data center. This text field has a 40-character limit and must be a unique name with any combination of uppercase and lowercase letters, numbers, hyphens, and underscores.</td>
  </tr>
  <tr>
   <td><b>Description</b></td>
   <td>The description of the data center. This field is recommended but not mandatory.</td>
  </tr>
  <tr>
   <td><b>Type</b></td>
   <td>
    <p>The storage type. Choose one of the following:</p>
    <ul>
     <li><b>Shared</b></li>
     <li><b>Local</b></li>
    </ul>
    <p>The type of data domain dictates the type of the data center and cannot be changed after creation without significant disruption. Multiple types of storage domains (iSCSI, NFS, FC, POSIX, and Gluster) can be added to the same data center, though local and shared domains cannot be mixed.</p>
   </td>
  </tr>
  <tr>
   <td><b>Compatibility Version</b></td>
   <td>
    <p>The version of oVirt.</p>
    <p>After upgrading the oVirt Engine, the hosts, clusters and data centers may still be in the earlier version. Ensure that you have upgraded all the hosts, then the clusters, before you upgrade the Compatibility Level of the data center.</p>
   </td>
  </tr>
  <tr>
   <td><b>Quota Mode</b></td>
   <td>
    <p>Quota is a resource limitation tool provided with oVirt. Choose one of:</p>
    <ul>
     <li><b>Disabled</b>: Select if you do not want to implement Quota</li>
     <li><b>Audit</b>: Select if you want to edit the Quota settings</li>
     <li><b>Enforced</b>: Select to implement Quota</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Comment</b></td>
   <td>Optionally add a plain text comment about the data center.</a></td>
  </tr>
 </tbody>
</table>

### Re-Initializing a Data Center: Recovery Procedure

This recovery procedure replaces the master data domain of your data center with a new master data domain; necessary in the event of data corruption of your master data domain. Re-initializing a data center allows you to restore all other resources associated with the data center, including clusters, hosts, and non-problematic storage domains.

You can import any backup or exported virtual machines or templates into your new master data domain.

**Re-Initializing a Data Center**

1. Click **Compute** &rarr; **Data Centers** and select the data center to re-initialize.

2. Ensure that any storage domains attached to the data center are in maintenance mode.

3. Click **More Actions** &rarr; **Re-Initialize Data Center**.

4. The **Data Center Re-Initialize** window lists all available (detached; in maintenance mode) storage domains. Click the radio button for the storage domain you are adding to the data center.

5. Select the **Approve operation** check box.

6. Click **OK**.

The storage domain is attached to the data center as the master data domain and activated. You can now import any backup or exported virtual machines or templates into your new master data domain.

### Removing a Data Center

An active host is required to remove a data center. Removing a data center will not remove the associated resources.

**Removing a Data Center**

1. Ensure the storage domains attached to the data center is in maintenance mode.

2. Click **Compute** &rarr; **Data Centers** and select the data center to remove.

3. Click **Remove**.

4. Click **OK**.

### Force Removing a Data Center

A data center becomes `Non Responsive` if the attached storage domain is corrupt or if the host becomes `Non Responsive`. You cannot **Remove** the data center under either circumstance.

**Force Remove** does not require an active host. It also permanently removes the attached storage domain.

It may be necessary to **Destroy** a corrupted storage domain before you can **Force Remove** the data center.

**Force Removing a Data Center**

1. Click **Compute** &rarr; **Data Centers** and select the data center to remove.

2. Click **More Actions** &rarr; **Force Remove**.

3. Select the **Approve operation** check box.

4. Click **OK**

The data center and attached storage domain are permanently removed from the oVirt environment.

### Changing the Data Center Storage Type

You can change the storage type of the data center after it has been initialized. This is useful for data domains that are used to move virtual machines or templates around.

**Limitations**

* **Shared to Local** - For a data center that does not contain more than one host and more than one cluster, since a local data center does not support it.

* **Local to Shared** - For a data center that does not contain a local storage domain.

**Changing the Data Center Storage Type**

1. Click **Compute** &rarr; **Data Centers** and select the data center to change.

2. Click **Edit**.

3. Change the **Storage Type** to the desired value.

4. Click **OK**.

### Changing the Data Center Compatibility Version

oVirt data centers have a compatibility version. The compatibility version indicates the version of oVirt that the data center is intended to be compatible with. All clusters in the data center must support the desired compatibility level.

**Important:** To change the data center compatibility version, you must have first updated all the clusters in your data center to a level that supports your desired compatibility level.

**Procedure**

1. From the Administration Portal, click **Compute** &rarr; **Data Centers**.

2. Select the data center to change from the list displayed.

3. Click **Edit**.

4. Change the **Compatibility Version** to the desired value.

5. Click **OK** to open the **Change Data Center Compatibility Version** confirmation window.

6. Click **OK** to confirm.

You have updated the compatibility version of the data center.

**Important:** Upgrading the compatibility will also upgrade all of the storage domains belonging to the data center.

## Data Centers and Storage Domains

### Attaching an Existing Data Domain to a Data Center

Data domains that are **Unattached** can be attached to a data center. Shared storage domains of multiple types (iSCSI, NFS, FC, POSIX, and Gluster) can be added to the same data center.

**Attaching an Existing Data Domain to a Data Center**

1. Click **Compute** &rarr; **Data Centers**.

2. Click a data center’s name to open the details view.

3. Click the **Storage** tab to list the storage domains already attached to the data center.

4. Click **Attach Data**.

5. Select the check box for the data domain to attach to the data center. You can select multiple check boxes to attach multiple data domains.

6. Click **OK**.

The data domain is attached to the data center and is automatically activated.

### Attaching an Existing ISO domain to a Data Center

An ISO domain that is **Unattached** can be attached to a data center. The ISO domain must be of the same **Storage Type** as the data center.

Only one ISO domain can be attached to a data center.

**Attaching an Existing ISO Domain to a Data Center**

1. Click **Compute** &rarr; **Data Centers**.

2. Click a data center’s name to open the details view.

3. Click the **Storage** tab to list the storage domains already attached to the data center.

4. Click **Attach ISO**.

5. Click the radio button for the appropriate ISO domain.

6. Click **OK**.

The ISO domain is attached to the data center and is automatically activated.

### Attaching an Existing Export Domain to a Data Center

    **Note:** The export storage domain is deprecated. Storage data domains can be unattached from a data center and imported to another data center in the same environment, or in a different environment. Virtual machines, floating virtual disk images, and templates can then be uploaded from the imported storage domain to the attached data center. See [Importing Existing Storage Domains](sect-Importing_Existing_Storage_Domains) for information on importing storage domains.

An export domain that is **Unattached** can be attached to a data center. Only one export domain can be attached to a data center.

**Attaching an Existing Export Domain to a Data Center**

1. Click **Compute** &rarr; **Data Centers**.

2. Click a data center’s name to open the details view.

3. Click the **Storage** tab to list the storage domains already attached to the data center.

4. Click **Attach Export**.

5. Click the radio button for the appropriate export domain.

6. Click **OK**.

The export domain is attached to the data center and is automatically activated.

### Detaching a Storage Domain from a Data Center

Detaching a storage domain from a data center will stop the data center from associating with that storage domain. The storage domain is not removed from the oVirt environment; it can be attached to another data center.

Data, such as virtual machines and templates, remains attached to the storage domain.

**Note:** The master storage, if it is the last available storage domain, cannot be removed.

**Detaching a Storage Domain from a Data Center**

1. Click **Compute** &rarr; **Data Centers**.

2. Click a data center’s name to open the details view.

3. Click the **Storage** tab to list the storage domains already attached to the data center.

4. Select the storage domain to detach. If the storage domain is `Active`, click **Maintenance**.

5. Click **OK** to initiate maintenance mode.

5. Click **Detach**.

6. Click **OK**.

You have detached the storage domain from the data center. It can take up to several minutes for the storage domain to disappear from the details pane.

**Prev:** [Chapter 3: Quality of Service](chap-Quality_of_Service)<br>
**Next:** [Chapter 5: Clusters](chap-Clusters)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/administration_guide/chap-data_centers)
