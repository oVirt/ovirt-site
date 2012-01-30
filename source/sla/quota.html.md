---
title: Quota
category: sla
authors: amureini, doron, mlipchuk, oliel
wiki_category: SLA
wiki_title: Features/Design/Quota
wiki_revision_count: 112
wiki_last_updated: 2012-08-23
---

# Quota

This document describes the design for the Quota feature.

### Motivation

Ovirt makes it very easy for users to add VMs, thus using CPU, memory and storage resources, thus there is a requirement that system administrators will be able to limit the resource usage of users in the environment by setting a Quota on these resources.
 The resources in scope for this feature are:

1.  Per-cluster resources:
    1.  Virtual CPUs
    2.  Virtual RAM

2.  Storage resources

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

**quota** - Represents the properties of the Quota configured on the DC.

| Column Name                       | Column Type  | Null? / Default | Definition                                                                                        |
|-----------------------------------|--------------|-----------------|---------------------------------------------------------------------------------------------------|
| id                                | UUID         | PK(not null)    | The Quota Id                                                                                      |
| storage_pool_id                 | UUID         | not null        | Storage pool Id                                                                                   |
| quota_name                       | VARCHAR(50)  | not null        | Quota name                                                                                        |
| description                       | VARCHAR(500) | not null        | Quota description                                                                                 |
| _create_date                    | Date         | not null        | Quota creation date used for history data                                                         |
| _update_date                    | Date         | not null        | Quota update date used for history data                                                           |
| threshold_vds_group_percentage | INTEGER      | null            | The threshold of the Vds Group Quota the default should be configured in the vdc_options         |
| threshold_storage_percentage    | INTEGER      | null            | The threshold of the Storage Quota the default should be configured in the vdc_options           |
| grace_vds_group_percentage     | INTEGER      | null            | The grace in percentage of the Cluster Quota the default should be configured in the vdc_options |
| grace_storage_percentage        | INTEGER      | null            | The grace in percentage of the Storage Quota the default should be configured in the vdc_options |

**quota_limitation** - Represents the quota limitation which are part of the Quota, the limitation can be defined for storage/vds cluster/storage pool.

| Column Name        | Column Type | Null? / Default | Definition                                                        |
|--------------------|-------------|-----------------|-------------------------------------------------------------------|
| id                 | UUID        | PK(not null)    | The primary key of the quota limitation.                          |
| quota_id          | UUID        | not null        | Foreign key for the quota id.                                     |
| storage_id        | UUID        | null            | Foreign key for storage id.                                       |
| vds_group_id     | UUID        | null            | Foreign key for vds group id.                                     |
| virtual_cpu       | INTEGER     | null            | The limited virtual cpu.                                          |
| mem_size_mb      | BIGINT      | null            | The limited ram defined in mega byte.                             |
| storage_size_gb  | BIGINT      | null            | The limited defined in Giga byte.                                 |
| is_default_quota | BOOLEAN     | true/false      | Indicating if the quota is a a default quota for the Data Center. |

Use cases :

1.  When quota_limitation vds_group_id=null and storage_id=null then the limitation is referenced to global limitation
2.  When quota_limitation vds_group_id=null but storage_id!=null then the limitation is referenced only to storage quota
3.  When quota_limitation vds_group_id!=null but storage_id=null then the limitation is referenced only to vdsGroup quota
4.  unlimited quota - vds_group_id=null and storage_id=null in quota_limitation table and fields of vcpu, vram and storage will be initialized with -1.
5.  general limited quota - vds_group_id=null and storage_id=null in quota_limitation table, fields of vcpu, vram and storage will be initialized with specific number.
6.  specific limited quota - vds_group_id!=null and/or storage_id!=null in quota_limitation table, quota fields (vcpu, vram and storage) will be null.
7.  quota without any resources - vds_group_id=null and storage_id=null in quota_limitation table, quota fields (vcpu, vram and storage) will be 0.

###### Functions

1.  CalculateVdsGroupUsage - Summerise the VCPU usage and Memory usage for all the VMs in the quota which are not down, suspended, or in image locked or image illegal.
2.  CalculateStorageUsage - Summerise the storage usage for all the disks in the quota, for active disks, we summerise the full size, for snapshots and other disks summerise only the actual size.

***vm_static*** - Add column *quota_id*, which indicates the Quota the VM should be depended on its resources.
 ***image*** - Add column *quota_id*, which indicates the Quota the image should be depended on its storage resources.
 ***storage_pool*** - Add column *quota_enforcement*, Indicates the DC enforcement status for Quota (Disalbe(0) , Soft Limit (1),Hard Limit (2)) will be presented by Enum (see [QuotaStatusEnum](Features/Design/Quota#Classes).).

###### Views

**quota_global_view** - View of all the storage pool quota in the setup, that is all the quota that vds_group_id and storage_id values are null in the quota_limitation.

| Column Name              | Column Type | Definition                                                                                    |
|--------------------------|-------------|-----------------------------------------------------------------------------------------------|
| storage_pool            | UUID        | The Storage Pool Id                                                                           |
| Quota_ID                | UUID        | The Quota Id                                                                                  |
| Quota_Name              | String      | The Quota name                                                                                |
| virtual_cpu             | INTEGER     | The limited cpu, defined in Giga byte.                                                        |
| virtual_cpu_usage      | INTEGER     | The usage of the cpu in the storage pool, defined in Giga byte. (using CalculateVdsGroupsage) |
| storage_size_gb_byte  | INTEGER     | The limited GB, defined in Giga byte.                                                         |
| storage_size_gb_usage | INTEGER     | The used GB in the storage pool, defined in Giga byte. (using CalculateStorageUsage)          |
| mem_size_mb            | BIGINT      | The limited ram, defined in Mega byte.                                                        |
| mem_size_mb_usage     | BIGINT      | The used ram in the storage pool. (using CalculateVdsGroupUsage)                              |
| is_default_quota       | BOOLEAN     | Indicating if the quota is a a default quota for the Data Center.                             |

**quota_vds_group_view** - View of all the vds group quotas in the setup, that is all the quotas that vds_group_id is not null but storage_id is null in the quota_limitation.

| Column Name          | Column Type | Definition                                                                                |
|----------------------|-------------|-------------------------------------------------------------------------------------------|
| storage_pool        | UUID        | The Storage Pool Id                                                                       |
| Quota_ID            | UUID        | The Quota Id                                                                              |
| Quota_Name          | String      | The Quota name                                                                            |
| vds_static_id      | UUID        | The vds group Id                                                                          |
| vds_static_name    | UUID        | The vds group name from vds_group_static                                                |
| virtual_cpu         | INTEGER     | The limited cpu, defined in Giga byte.                                                    |
| virtual_cpu_usage  | INTEGER     | The usage of the cpu in the cluster, defined in Giga byte. (using CalculateVdsGroupUsage) |
| mem_size_mb        | BIGINT      | The limited ram defined in Mega byte.                                                     |
| mem_size_mb_usage | BIGINT      | The used ram in the cluster. (using CalculateVdsGroupUsage)                               |
| is_default_quota   | BOOLEAN     | Indicating if the quota is a a default quota for the Data Center.                         |

**quota_storage_view** - View of all the storage quotas in the setup, that is all the quotas that storage_id is not null but vds_cluster_id is null in the quota_limitation.

| Column Name              | Column Type | Definition                                                             |
|--------------------------|-------------|------------------------------------------------------------------------|
| storage_pool            | UUID        | The Storage Pool Id                                                    |
| Quota_ID                | UUID        | The Quota Id                                                           |
| storage_Name            | String      | The storage name                                                       |
| storage_id              | UUID        | The vds group Id                                                       |
| storage_size_gb        | INTEGER     | The limited GB defined in Giga byte.                                   |
| storage_size_gb_usage | INTEGER     | The used GB on the quota storage domain. (Using CalculateStorageUsage) |
| is_default_quota       | BOOLEAN     | Indicating if the quota is a a default quota for the Data Center.      |

###### Stored Procedures

*GetQuotaVdsGroupByVdsGroupGuid*

*   Input - vds_group_id UUID, storage_pool_id UUID.
*   Output - a business entity mapped by quota_vds_group_view for specified vds_group with vds_group_id. (if vds_group_id=null then returns a list of all the vds group quotas for the storage pool_id)

*GetQuotaStorageByStorageGuid*

*   Input - storage_id UUID, storage_pool_id UUID.
*   output - a business entity mapped by quota_storage_view for specified cluster_id, (if storage_id=null then returns a list of all the quota Storage for the storage pool_id)

*GetQuotaByStoragePoolGuid*

*   Input - storage_pool_id UUID.
*   output - a business entity mapped by quota_global_view for specified storage_pool_id, (if storage_pool_id=null then returns a list of all the quota in the setup)

#### Logic Design

Each time the user will run or edit the VM, there will be a Quota check against the quota cluster view.
 Both views, quota_storage and quota_cluster should be reflected in the memory as Concurrent HashMap tables. The memory tables should be checked and updated in the canDoAction in a synchronized context (Using java.util.concurrency).
 Those memory tables should be managed in a pessimistic way, considering resource allocation, to prevent over-commit situations.

###### Synchronized Vds commands

Synchronized Vds commands are commands such as Create VM or migrate VM.
These commands increase the consumption on cluster quota, right when the engine calls createVmCommandVDSCommand.
Before calling the vds command, there will be a check and update (With atomic operation), using quotaVdsGroupUsage function with the memory delta map, if there is enough resource space in the quota, the memory delta concurrent map, will be updated with the VM resources.
if there will not be enough resources for the VM cunsumption, we will decrease the memory table with the amount of resources we checked.

###### A-synchronized Vds commands

Asynchronized operations, relected in the engine as tasks.
The tasks which are being handled are :

      unknown,
      copyImage,
      moveImage,
      createVolume,
      deleteVolume,
      deleteImage,
      mergeSnapshots,
      moveMultipleImages;

**Tasks For Commands**

| command name                   | Storage / Cluster | Task Name          | Vds Command                       |
|--------------------------------|-------------------|--------------------|-----------------------------------|
| CreateCloneOfTemplateCommand   | Storage           | copyImage          | CopyImageVDSCommand               |
| CreateImageTemplateCommand     | Storage           | copyImage          | CopyImageVDSCommand               |
| CreateCloneOfTemplateCommand   | Storage           | copyImage          | CopyImageVDSCommand               |
| MoveMultipleImageGroupsCommand | Storage           | moveImage          | MoveImageGroupVDSCommand          |
| MoveOrCopyImageGroupCommand    | Storage           | moveImage          | MoveImageGroupVDSCommand          |
| AddImageFromScratchCommand     | Storage           | createVolume       | CreateImageVDSCommand             |
| CreateSnapshotCommand          | Storage           | createVolume       | CreateSnapshotVDSCommand          |
| HibernateVmCommand             | Storage           | createVolume       | CreateImageVDSCommand             |
| RestoreFromSnapshotCommand     | Storage           | deleteVolume       | DestroyImageVDSCommand            |
| RemoveImageCommand             | Storage           | deleteImage        | DeleteImageGroupVDSCommand        |
| RemoveTemplateSnapshotCommand  | Storage           | deleteImage        | DeleteImageGroupVDSCommand        |
| VmCommand                      | Storage           | deleteImage        | DeleteImageGroupVDSCommand        |
| MergeSnapshotSingleDiskCommand | Storage           | mergeSnapshots     | MergeSnapshotsVDSCommand          |
| no command                     | Storage           | moveMultipleImages | MoveMultipleImageGroupsVDSCommand |

For a-synchronized operations behaviour, the Quota Storage DB data, (and the quota storage memory table) will be synchronized based on the DB data and the AsyncTaskManager properties.
 The ATM will have new data, which will reflect the storage quantity change being done by each task, for example adding +4GB when new image is being added.
 Each task in the ATM map, should encapsulate the storage change which it is responsible for.
 The Quota Storage memory table should be updated in the execute right before the task is being created.
 At the end action we will validate whether the task was finished successfully or not, and by doing so we will update the quota storage memory table accordingly.
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

*`quotaStorageThreshold`*` - The default value should be 80%, and the version is General.`
       Indicates the percentage of resource allocation, which beyond this (if Quota is enforced) would print an appropriate audit log message.
       `*`quotaClusterThreshold`*` - The default value should be 80%, and the version is General.
       Indicates the percentage of cluster allocation, which beyond this (if Quota is enforced) would print an appropriate audit log message.
       `*`quotaStorageGrace`*` - The default value should be 20%, and the version is General.
       Indicates the percentage of resource extension allocation.
       `*`quotaClusterGrace`*` - The default value should be 20%, and the version is General.
       Indicates the percentage of resource extension allocation.

**DAO Classes**
***org.ovirt.engine.core.dao.QuotaDAO**'' - Interface for Quota DAO will extends GenericDao.
***org.ovirt.engine.core.dao.QuotaDAODbFacadeImpl**'' - Implementation for QuotaDAO, reflects the quota view implementations.

**Classes**
***org.ovirt.engine.core.bll.QuotaManager*** - Class which manage the quota views and memory table

*`quotaClusterMap`*` - The quota cluster Map is a concurrent HashMap which reflects a snapshot view of the cluster consumption status for each quota, it is based on the DB view `[`getQuotaCluster`](Features/Design/Quota#DB_Design)`. The map should be synchronized when the server starts up, and the vdsUpdateRunTimeInfo has updated the data after the first time (counting on method beforeFirstRefreshTreatment).`
       `*`storageDelta`*` - The quota storage Map is a Concurrent HashMap which reflects a snapshot view of the cluster consumption status for each quota, it is based on the DB view  `[`getQuotaStorage`](Features/Design/Quota#DB_Design)`, and it is initialized every time the Host will be chosen to be SPM, using the DB values and the task manager.
***`org.ovirt.engine.core.common.businessentities.QuotaStatusEnum`***` - Enum indicating the DC Quota verification status.`

##### Business entities

***org.ovirt.engine.core.common.businessentities.QuotaStatic*** - A business entity that reflects quota static (see [quota_static](Features/Design/Quota#DB_Design))
org.ovirt.engine.core.common.businessentities.QuotaDynamic - A business entity that reflects Quota dynamic (see [quota_dynamic](Features/Design/Quota#Appendix))
 org.ovirt.engine.core.common.businessentities.Quota - A business entity that reflects the view result (see [views](Features/Design/Quota#quota))

##### Query commands

***GetAllQuotaStoragesQuery*** (Extends QueriesCommandBase) - Should call query (see [getAllQuotaStorageForSP](Features/Design/Quota#DB_Design))
 with DC id and user id, The query will return List of all Quota for user in the DC.

###### Parameter commands

***GetAllQuotaStoragesParameters*** - The parameter class will extend VdcQueryParametersBase, and will have the following fields : ... (TODO)

##### Scenarios

*Running VM* - canDoAction

1.  Get DC verification status from quota_enforcement.
2.  If quota_enforcement != DISABLED
    1.  Fetch Quota Id from VM dynamic
    2.  Get quota cluster properties for quota ID, using the memory Map quotaClusterMap in [QuotaManager](Features/Design/Quota#Classes).
        1.  Check the VM configuration against the free cluster space left in the Quota.
            1.  If VM capabilities are extending the free space left in the Quota
                1.  if the VM capabilities are extending extending 20% of the Quota space (Grace percent) then
                    1.  If quota_enforcement is enforce
                        1.  Fail the VM from running
                        2.  Print an appropriate audit log.

                    2.  else
                        1.  Print an audit log warning message.

                2.  Else if the VM is extending the Quota limit but not extending the grace percent
                    1.  Add Vm resources to Quota memory table quotaClusterMap.
                    2.  Print an audit log of the User which caused the extension, and the extend details.

                3.  Else update quotaClusterMap.

Result : The VM will be already calculated in the memory table but this information will not be persistent in the DB until execute will performed.

*Running VM* - execute

Each time there will be a change in the _asyncRunningVms (for example in createVMVdsCommand) the persistent Quota Dynamic data will be updated appropriately if needed
If the command will fail then the memory table should be decreased with the resources that were added to it.
 *Add New Disk - When dialog box opens*

1.  GUI will call the query command [GetAllQuotaStoragesQuery](Features/Design/Quota#upgrade_behaviour) with DC UUID
2.  Return map of quotas, where each value represents a list of all the storage details.

*Add New Disk - Confirm dialog box*

1.  User will pick the quota and the domain, he wants the disk should be initialized on.
2.  If quota_enforcement != DISABLED
    1.  Get quota storage properties for Quota ID, using the memory Map quotaStorageMap in [QuotaManager](Features/Design/Quota#Classes).
        1.  If VM capabilities are extending the free space left in the Quota
            1.  if the VM capabilities are extending extending 20% of the Quota space (Grace percent) then
                1.  If quota_enforcement is enforce
                    1.  Fail the operation.
                    2.  Print an appropriate audit log.

                2.  else
                    1.  Print an audit log warning message.

                3.  else if the VM is extending the Quota limit but not extending the grace percent
                    1.  Validate and update the memory table.
                        1.  Print an audit log of the User which caused the extension, and the extend details.
                        2.  Execute the command

                    2.  Execute the command

This logic in the canDoAction should be quite similar to the logic being done with StorageDomainSpaceChecker.

*Add new Disk - Confirm dialog box* End Action

1.  At the end action we will check what was the storage change by GB, and update the Quota dynamic table appropriately.

 *Create new snapshot* - CanDoAction

1.  Add the full disk size to the quotaStorageMap.

*Create new snapshot* - End Action

1.  Get real size disk from VDSM of the snapshot created.
2.  Subtract from the memory table the following (fullSize - realSize)
3.  Update the DB quota dynamic value with + realSize

*Create new template (similar to import scenario)* - CanDoAction

1.  Calculate the storage that should be allocated by multiple the number of disks with 1GB (Which is the QCOW default size, TODO : Need to configure this with VDSM)
2.  validate the quota properties and update the memory table.

*Create new template (similar to import scenario)* - EndAction

1.  Persist the changes in the DB.

*Create/Edit VM* - Reflects on AddVmCommand and EditVMCommand

1.  User will select Data Center he wants the VM to be created on.
2.  GUI will call the query GetQueryForStoragePool with DC UUID
3.  Call stored procedure GetAllQuotaClusterForSP with storage pool UUID and user ID.
4.  Call query Quotas_Attached_To_Storage_Pool with storage pool UUID and user ID.
5.  Get lists of business entity objects
6.  Return map of quotas, where each value represent a list of all the cluter details and the other should be all the users.
7.  Update the VM Dynamic with the Quota Id.

#### API Design

Add new command query GetQueryForStoragePool input - DC UUID output - All the Quotas for the DC.

### Tests

Storage tests. Cluster tests

#### Expected unit-tests

1.  adding a new Quota
2.  running VM on Quota
3.  Adding a new Disk and attach to Quota
4.  Adding new snapshot
5.  Migrating VM

#### Special considerations

No special considerations.

#### Pre-integration needs

No needs.

### Design check list

This section describes issues that might need special consideration when writing this feature. Better sooner than later :-)

1.  Installer / Upgrader - Disk and Storage Pool should be attached to the default unlimited Quota.
2.  DB Upgrade -
    1.  For each DC, add Administrator Quota, which will be attached to all the users currently using the VM's in the DC.(see [upgrade logic](Features/Design/Quota#upgrade_behaviour))
    2.  Initialize the Quota users table depending on the users in the system.

3.  MLA - Remove user from the system should also remove the user from the Quota_users table
4.  Migrate
5.  Compatibility levels - The feature will be supported only for 2.3 VMs and up.
6.  Backward compatibility issues
7.  API changes - new command queries for GUI and REST.

### Appendix

**Pseudo code for view [quota views - all_quotas](Features/Design/Quota#DB_Design):**
 **Select** <desired fields>
 **From** quota_global_view q_g_view
 WHERE q_g_view.storage_pool_id = v_storage_pool_id; *'* Open issues *'*
 RFE to consider: Add expiration date to the Quota
 RFE to consider : Use templates for Quota.
