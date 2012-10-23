---
title: Quota-3.2
category: sla
authors: doron, ofri, ykaul
wiki_category: SLA
wiki_title: Features/Design/Quota-3.2
wiki_revision_count: 18
wiki_last_updated: 2012-12-24
---

# Quota

This document describes the design for the Quota feature on oVirt 3.2.

### Motivation

Current quota feature (available on oVirt 3.1) handles most of the planned capabilities and UI. This new version would include minor UI changes and more significant backend redesign.

Please see <http://www.ovirt.org/wiki/Features/Quota-3.2>

### GUI

TBD

#### Design

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

unchanged - see Features/Design/Quota

###### Stored Procedures

unchanged - see Features/Design/Quota

#### Logic Design

Each time the user will run a VM or create a new disk, there will be a quota resource check against the quota views.
The process of quota validation should be in a new method validateQuota which will be a part of the command execute process. the validateQuota should be executed as synchronize method after canDoAction and before the command execute method.
Each command which consumes quota resources, will contain a list of the delta changes, respectively quotaManager will manage a delta HashMap of the resources until they are persisted in the DB.

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

For a-synchronized operations behaviour, the operation functionality should be similar to the synchronize functionality. The Quota storage delta and the command list property will be updated before the execute starts with the planned quantity that should be consume. After every creation of task the delta map will be decreased and also the list command member. If the operation will fail, the rest of the quantity in the list will be decreased from the delta map.

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
***org.ovirt.engine.core.bll.QuotaManager*** - Class which manage the quota views and memory delta tables

*`quotaDeltaClusterMap`*` - The quota cluster delta Map is a HashMap which reflects the delta changes being done on the DC before persistence, The update to the map should be synchronized.`
*`quotaStorageDeltaMap`*` - The quota storage Map is a Concurrent HashMap which reflects the delta changes being done in the storage before persistence, the operation on it should be atomic.`

***org.ovirt.engine.core.common.businessentities.QuotaStatusEnum*** - Enum indicating the DC Quota verification status.

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

<Category:SLA>
