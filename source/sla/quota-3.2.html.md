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

In order to support quota on duplicate image stored on different storage domains, the quota_id column would move from "images" table to "image_storage_domain_map" table.

**image_storage_domain_map** - Represents the properties of the Quota configured on the DC.

| Column Name         | Column Type | Null? / Default | Definition        |
|---------------------|-------------|-----------------|-------------------|
| image_id           | UUID        | not null        | Image Id          |
| storage_domain_id | UUID        | not null        | Storage domain id |
| quota_id           | UUID        |                 | Quota id          |

###### Views

unchanged - see <http://www.ovirt.org/wiki/Features/Design/Quota>

###### Stored Procedures

unchanged - see <http://www.ovirt.org/wiki/Features/Design/Quota>

#### Logic Design

Each time the user will run a VM or create a new disk, there will be a quota resource check against the quota views.
The process of quota validation located today in a method validateAndSetQuota in the command execute process, would be moved into CommandBase.
As in 3.1 the quota validation should be executed as synchronize method during the internalCanDoAction and before the command execute method.
Each command which consumes quota resources would implement StorageQuotaDependent and/or VdsQuotaDependent interface and will return a list of the quota consume/release parameters.
Commands would also be marked as storage or Vds consumers in the VdcActionType class. the defauld value for this setting would be BOTH (consumes both storage and vds), so when adding new command, one would have to consider quota issues. Commands which does not consume any quota resources would be marked NONE. CommandBase would use this markings in order to decide whether quota validation is needed.
The VdcActionType marking would prevent unintentional inheritance of the interfaces and the implemented methods.

##### Classes

**Classes**
***org.ovirt.engine.core.bll.quota.QuotaManager*** - Class which manage the quota views and memory delta tables. This class would be revisited and redesined

*`consume(QuotaConsumptionParametrs` `params)`*` - This would be the main API of the QuotaManager. Any quota Consumption would call this method. Parameters are taken from CommandBase and the consuming command. the return value is a boolean - telling if the consumption was possible. Both storage resources and vds resources would be asked in the same QuotaConsumptionParametrs Object. That way the QuotaManager could validate and set all the resources required for the command (would make the external rollback redundant).    `
*`rolback(QuotaConsumptionParametrs` `params)`*` - The same as consume(), only reverting all of the consume/release done by the same params.`

***org.ovirt.engine.core.bll.quota.QuotaConsumptionParameters*** - the object passed to the QuotaManager on each consume/release call

*`storage_pool` `id`*` - Every cunsume/release call can handle only one storage_pool (DC).`
*`canDoActionMesseges`*` - Used for returning canDoAction messeges back to the command. `
*`auditLoggableBase`*` - Used in order to allow logging to the auditLog using the command itself.`
*`List` `of` `QuotaStorageConsumptionParameter`*` - Holds a single entry. the basic consumption unit`
*`List` `of` `QuotaVdsConsumptionParameter`*` - Holds a single entry. the basic consumption unit`

***org.ovirt.engine.core.bll.quota.QuotaStorageConsumptionParameter*** - a single entry. the basic consumption unit

*`quotaId`*` - the id of the quota`
*`action` `type`*` - consume or release (This allows to consume some resources while releasing others, all in the same call to consume()). `
*`storageDomainId`*` - id of the storage domain (the asked resource).`
*`requestedStorageGB`*` - the requested storage in GB.`

***org.ovirt.engine.core.bll.quota.QuotaVdsConsumptionParameter*** - a single entry. the basic consumption unit

*`quotaId`*` - the id of the quota`
*`action` `type`*` - consume or release (This allows to consume some resources while releasing others, all in the same call to consume()). `
*`vdsGroupId`*` - id of the vds group (cluster) (the asked resource).`
*`requestedCpu`*` - the requested number of vcpu.`
*`requestedMem`*` - the requested Memory.`

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

Unit-tests for testing all of the QuotaManager API will be added.

#### Expected unit-tests

1.  QuotaManager - consume quota
2.  QuotaManager - release quota
3.  QuotaManager - rollback quota
4.  QuotaManager - uncache quota

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
