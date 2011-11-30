---
title: Quota
category: sla
authors: amureini, doron, mlipchuk, oliel
wiki_category: SLA
wiki_title: Features/Design/Quota
wiki_revision_count: 112
wiki_last_updated: 2012-08-23
wiki_conversion_fallback: true
wiki_warnings: conversion-fallback
---

# Quota

This document describes the design for the Quota feature.

### Motivation

Ovirt makes it very easy for users to add VMs, thus using CPU, memory and storage resources, thus there is a requirement that system administrators will be able to limit the resource usage of users in the environment by setting a Quota on these resources.
 The resources in scope for this feature are:

     1. Per-cluster resources:
      a. Virtual CPUs
      a. Virtual RAM
     1. Storage resources

... ... ...

Please see <http://www.ovirt.org/wiki/Features/Quota>

### GUI

Please see [Mockups](Features/DetailedQuota#User_Experience)

#### Design

### REST Design (Modeling)

This section describes the REST design for this feature.

### Backend

This section describes the backend design for this feature.

#### DB Design

**quota** - Represents the Quota properties

Column Name

Column Type

Null? / Default

Definition

quota_id

UUID

not null

The Quota Id

name

String

not null

Quota name

description

String

not null

Quota description

creation_date

Date

not null

Quota creation date

update_date

Date

not null

Quota update date

type

Integer

default '0'

Represent the quota enforce mode 0-disabled 1-soft limit 2-hard limit

threshold_cluster

integer

null

The threshold of the Cluster Quota the default should be configured in the vdc_options

threshold_storage

integer

null

The threshold of the Storage Quota the default should be configured in the vdc_options

grace_cluster

integer

null

The grace in percentage of the Cluster Quota the default should be configured in the vdc_options

grace_storage

integer

null

The grace in percentage of the Storage Quota the default should be configured in the vdc_options

storage_unlimited

boolean

default false

Represent whether the quota storage is unlimited for DC

cluster_unlimited

boolean

default false

Represent whether the quota cluster is unlimited for DC

**quota_cluster** - Represent the clusters which are part of the Quota, The relationship of Cluster-Quota is Many-To-Many.

Column Name

Column Type

Null? / Default

Definition

quota_id

UUID

Not null

The Quota Id which represented in the quota

vds_group_id

UUID

not null

Foreign key for vds_groups.vds_group_id

vcpu

Integer

default '0'

The number or virtual CPU's allowed in the cluster Quota (-1 for unlimited)

vram

Integer

default '0'

The Virtual RAM allowed in the cluster Quota (-1 for unlimited)

Note: If no cluster selected for Quota,we assume the Quota Does not have any permissions to consume from the cluster resources.

**quota_storage** - Represents the Quota Storage limitation.

Column Name

Column Type

Null? / Default

Definition

quota_id

UUID

Not null

The Quota Id which represented in the quota)

storage_id

UUID

not null

The storage Id the Quota attached to

storage_limit

BigInt

default '0'

The storage limit in Mega bytes, could be -1 for no limit, or specific number of bytes

Note: If no storage selected for Quota,we assume the Quota Does not have any permissions to consume from the storage resources.

**quota_users** - Represents the Quota users which are permitted to consume from the Quota.

Column Name

Column Type

Null? / Default

Definition

quota_id

UUID

Not null

The Quota Id which represented in the quota

user_id

UUID

null

Foreign key to the users.user_id (null indicates no users permitted to consume from the Quota)

***vm_dynamic*** - Add column *quota_id*, which indicates the Quota the VM should be depended on its resources.
 ***image*** - Add column *quota_id*, which indicates the Quota the image should be depended on its storage resources.
 ***storage_pool*** - Add column *quota_enforcement*, Indicates the DC enforcement status for Quota (Disalbe(0) , Soft Limit (1),Hard Limit (2)) will be presented by Enum (see [QuotaStatusEnum](Features/Design/Quota#Classes).).

###### Views

[all_quotas](Features/Design/Quota#Appendix) - View of all the Quotas attached to all the storage pools for all Users.

Column Name

Column Type

Definition

Storage_Pool

UUID

The Storage Pool Id

Quota_ID

UUID

The Quota Id

Quota_Name

String

The Quota name

Cluster_Name

String

The cluster name

Storage_Name

String

The storage name

User_Id

String

The user Id, which has permissions to the Quota

[quota_storage_view](quota_storage_view) - View of the Quotas storage resources.

Column Name

Column Type

Definition

storage_pool

UUID

The Storage Pool Id

quota_ID

UUID

The Quota Id

storage_id

UUID

The storage domain UUID (Null for all storage domains in the DC)

storage_use

Integer

Calculated storage from the image dynamic

storage_limit

Integer

The limit which the Quota is defined

Column Name

Column Type

Definition

storage_pool

UUID

The Storage Pool Id

quota_ID

UUID

The Quota Id

cluster_id

UUID

The cluster UUID (Null for all clusters in the DC)

storage_use

Integer

Calculated storage from the image dynamic

storage_limit

Integer

The limit which the Quota is defined

###### Stored Procedures

*getAllQuotaClusterForSP*

*   Input - Storage pool Id, and user Id.
*   Output - Clusters for Quotas, for user Id and Storage Pool.

*getAllQuotaStorageForSP*

*   Input - Storage pool Id, and user Id.
*   output - All storages for Quota, for user Id and Storage Pool (If Data Center is disabled all the storage for the DC will be returned).

*getQuotaCluster* - Reflects quota_cluster_view (Using VM business entity)

*   Input - Storage pool Id and Quota Id.
*   output - All Cluster Quota properties for DC.

#### Logic Design

Each time the user will run or edit the VM, there will be a Quota check against the quota cluster view.
 Both views, quota_storage and quota_cluster should be reflected in the memory as Concurrent HashMap tables. The memory tables should be checked and updated in the canDoAction in a synchronized context (Using java.util.concurrency). Those memory tables should be managed in a pessimistic way, considering resource allocation, to prevent over-commit situations.
 Those tables should be synchronized from time to time from VdsUpdateRunTimeInfo (for cluster quota) and AsyncTaskManager(for storage quota).

###### Synchronized Vds commands

When calling synchronized Vds commands (such as createVm, MigrateVm), which should increase the consumption on cluster quota, we will update the quota dynamic table in the DB when the VdsCommand is being called.
 When we will decrease the consumption on cluster quota, the update on the Quota tables should be at the end of the VDS command.

###### A-synchronized Vds commands

For a-synchronized operations behaviour, the Quota Storage DB data, (and the quota storage memory table) will be synchronized based on the DB data and the AsyncTaskManager properties.
 The ATM will have new data, which will reflect the storage quantity change being done by each task, for example adding +4GB when new image is being added.
 Each task in the ATM map, should encapsulate the storage change which it is responsible for.
 The Quota Storage memory table should be updated at the canDoAction.
 In the end action we will validate whether the task was finished successfully or not, and by doing so we will update the quota storage memory table accordingly.
 When new SPM will be elected, we will recalculate the quota storage memory table, using the images_dynamic fields and also the AsyncTaskManager table right after re-polling all the tasks.

###### upgrade behaviour

On upgrade, an automatic script will create default Quota for each DC, with permissions for every one, and unlimited space for storage and cluster use.
 The DC status should be disabled. (Same thing when new DC will be establish)
 The disable status of the DC represents, that the user should not see any indications in the GUI that the DC has a Quota in it.

Administrator that would like to make the DC to use Quota, should change the DC status to audit,
 which means the users can now have indications on the DC, but still be able to make actions on it.
 If the user will perform an action which extend the Quota capabilities perspective, only warnings should perform.

After the Administrator, will finish to configure the Quotas he desires for the DC,
 he can set the DC to enforce status, which means users will be prevented from making actions which will extend the Quota capabilities.

A scheduler with run every 1 hour (Should be indicated in the vdc_options) and check if the quota is in their threshold limit, if not an audit log message should be performed.

##### Classes

**Config Values**
 New configuration values in vdc_options:

     quotaStorageThreshold - The default value should be 80%, and the version is General.
     Indicates the percentage of resource allocation, which beyond this (if Quota is enforced) would print an appropriate audit log message.

     quotaClusterThreshold - The default value should be 80%, and the version is General.
     Indicates the percentage of cluster allocation, which beyond this (if Quota is enforced) would print an appropriate audit log message.

     quotaStorageGrace - The default value should be 20%, and the version is General.
     Indicates the percentage of resource extension allocation.

     quotaClusterGrace - The default value should be 20%, and the version is General.
     Indicates the percentage of resource extension allocation.

**DAO Classes**
 ***org.ovirt.engine.core.dao.QuotaDAO*** - Interface for Quota DAO will extends GenericDao.
 ***org.ovirt.engine.core.dao.QuotaDAODbFacadeImpl*** - Implementation for QuotaDAO, reflects the quota view implementations.

**Classes**
 ***org.ovirt.engine.core.bll.QuotaManager*** - Class which manage the quota views and memory table

     quotaClusterMap - The quota cluster Map is a concurrent HashMap which reflects a snapshot view of the cluster consumption status for each quota, it is based on the DB view [[Features/Design/Quota#DB Design|getQuotaCluster]]. The map should be synchronized when the server starts up, and the vdsUpdateRunTimeInfo has updated the data after the first time (counting on method beforeFirstRefreshTreatment).

     quotaStorageMap - The quota storage Map is a Concurrent HashMap which reflects a snapshot view of the cluster consumption status for each quota, it is based on the DB view  [[Features/Design/Quota#DB Design|getQuotaStorage]], and it is initialized every time the Host will be chosen to be SPM, using the DB values and the task manager.

***org.ovirt.engine.core.common.businessentities.QuotaStatusEnum*** - Enum indicating the DC Quota verification status.

##### Business entities

***org.ovirt.engine.core.common.businessentities.QuotaStatic*** - A business entity that reflects quota static (see [quota_static](Features/Design/Quota#DB%20Design))
org.ovirt.engine.core.common.businessentities.QuotaDynamic - A business entity that reflects Quota dynamic (see [quota_dynamic](Features/Design/Quota#Appendix))
 org.ovirt.engine.core.common.businessentities.Quota - A business entity that reflects the view result (see [views](Features/Design/Quota#quota))

##### Query commands

***GetAllQuotaStoragesQuery*** (Extends QueriesCommandBase) - Should call query (see [getAllQuotaStorageForSP](Features/Design/Quota#DB%20Design))
 with DC id and user id, The query will return List of all Quota for user in the DC.

###### Parameter commands

***GetAllQuotaStoragesParameters*** - The parameter class will extend VdcQueryParametersBase, and will have the following fields : ... (TODO)

##### Scenarios

*Running VM* - canDoAction

     1. Get DC verification status from quota_enforcement.
     1. If quota_enforcement != DISABLED
      1. Fetch Quota Id from VM dynamic
      1. Get quota cluster properties for quota ID, using the memory Map quotaClusterMap in [[Features/Design/Quota#Classes|QuotaManager]].
      1. Check the VM configuration against the free cluster space left in the Quota.
       1. If VM capabilities are extending the free space left in the Quota
        1. if the VM capabilities are extending extending 20% of the Quota space (Grace percent) then
         1. If quota_enforcement is enforce
          1. Fail the VM from running
          1. Print an appropriate audit log.
         1. else
          1. Print an audit log warning message.
        1. Else if the VM is extending the Quota limit but not extending the grace percent
         1. Add Vm resources to Quota memory table quotaClusterMap.
         1. Print an audit log of the User which caused the extension, and the extend details.
        1. Else and update quotaClusterMap.

Result : The VM will be already calculated in the memory table but this information will not be persistent in the DB until execute will performed.

*Running VM* - execute

Each time there will be a change in the _asyncRunningVms (for example in createVMVdsCommand) the persistent Quota Dynamic data will be updated appropriately if needed
 If the command will fail then the memory table should be decreased with the resources that were added to it.

*Add New Disk - When dialog box opens*

     1. GUI will call the query command [[Features/Design/Quota#upgrade behaviour|GetAllQuotaStoragesQuery]] with DC UUID
     1. Return map of quotas, where each value represents a list of all the storage details.

*Add New Disk - Confirm dialog box*

     1. User will pick the quota and the domain, he wants the disk should be initialized on.
     1. If quota_enforcement != DISABLED
      1. Get quota storage properties for Quota ID, using the memory Map quotaStorageMap in [[Features/Design/Quota#Classes|QuotaManager]].
       1. If VM capabilities are extending the free space left in the Quota
        1. if the VM capabilities are extending extending 20% of the Quota space (Grace percent) then
         1. If quota_enforcement is enforce
          1. Fail the operation.
          1. Print an appropriate audit log.
         1. else
          1. Print an audit log warning message.
        1. Else if the VM is extending the Quota limit but not extending the grace percent
         1. Validate and update the memory table.
         1. Print an audit log of the User which caused the extension, and the extend details.
         1. Execute the command
        1. Execute the command

This logic in the canDoAction should be quite similar to the logic being done with StorageDomainSpaceChecker.

*Add new Disk - Confirm dialog box* End Action

     1. At the end action we will check what was the storage change by GB, and update the Quota dynamic table appropriately.

*Create new snapshot* - CanDoAction

     1. Add the full disk size to the quotaStorageMap.

*Create new snapshot* - End Action

     1. Get real size disk from VDSM of the snapshot created.
     1. Subtract from the memory table the following (fullSize - realSize)
     1. Update the DB quota dynamic value with + realSize

 *Create new template (similar to import scenario)* - CanDoAction

     1. Calculate the storage that should be allocated by multiple the number of disks with 1GB (Which is the QCOW default size, TODO : Need to configure this with VDSM)
     1. validate the quota properties and update the memory table.

*Create new template (similar to import scenario)* - EndAction

     1. Persist the changes in the DB.

 *Create/Edit VM* - Reflects on AddVmCommand and EditVMCommand

     1. User will select Data Center he wants the VM to be created on.
     1. GUI will call the query GetQueryForStoragePool with DC UUID
     1. Call stored procedure GetAllQuotaClusterForSP with storage pool UUID and user ID.
     1. Call query Quotas_Attached_To_Storage_Pool with storage pool UUID and user ID.
     1. Get lists of business entity objects
     1. Return map of quotas, where each value represent a list of all the cluter details and the other should be all the users.
     1. Update the VM Dynamic with the Quota Id.

#### API Design

Add new command query GetQueryForStoragePool input - DC UUID output - All the Quotas for the DC.

### VDSM

### Tests

Describe the needed unit-tests, and their implications on the build environment (if any) 1. check storage

#### Expected unit-tests

#### Special considerations

External resources, mocking, etc..

     1.  1.

#### Jenkins setup (if needed) for tests

     1.  1.

#### Pre-integration needs

### Design check list

This section describes issues that might need special consideration when writing this feature. Better sooner than later :-)

     1. Installer / Upgrader
      a. ....
     1. DB Upgrade
      a. For each DC, add Administrator Quota, which will be attached to all the users currently using the VM's in the DC.(see [[Features/Design/Quota#upgrade behaviour|upgrade logic]]) b. Initialize the Quota users table depending on the users in the system.
     1. MLA
      a. ....
     1. Migrate
      a. ...
     1. Compatibility levels
      a. Supported DC versions ....
      a. Supported Cluster versions ....
     1. Backward compatibility issues
     1. API changes (changes required in the API between components (GUI/REST  Backend  VDSM  libvirt))

### Appendix

**Pseudo code for view [quota views - all_quotas](Features/Design/Quota#DB%20Design):**

     . Select 
     From quota_static q_static,
     quota_cluster q_cluster,
      quota_storage q_storage,
      quota_users q_users,
     vds_groups,
    storage_pool_iso_map 
    Where (q_static.storage_pool_id = vds_groups.storage_pool_id And (q_cluster.Id = q_static.cluster_quota_id And q_cluster.cluster_id = vds_groups.vds_group_id) Or (q_cluster.Id = null)) 
     And (storage_pool_iso_map.storage_pool_id = q_static.storage_pool_id And storage_domain_static.id = storage_pool_iso_map.storage_id AND (q_storage.Id = q_static.Storage_Quota_ID And q_storage.storage_id = storage_domain_static.id) Or (q_storage.Id = null)) 
     And (q_users.id = q_static.user_quota_id or q_static.quota_user.id = null)

***Open issues***

     . RFE to consider: Add expiration date to the Quota 
     RFE to consider : Use templates for Quota 
     Add Quota resources to all the users on the Quota when resources were finished 
      possible result : Use grace or Tell the Administrator to add new Quota (use case : Add quota resource) 
      use audit log 

     Use case : create Desktop for specific user - Pick a quota from group, second approach , server??? 
      Snapshot with Qcow, templates Audit, enforce for DC unlimited Quota for each DC, on upgrade.

Column Name

Column Type

Null?

Definition

quota_status

int

not null

Should be Disable (o), Audit (1) and enforce (2)

grace and quota status per DC
