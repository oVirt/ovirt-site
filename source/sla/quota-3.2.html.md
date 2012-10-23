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

#### DB Change

In order to support quota on duplicate image stored on different storage domains, the quota_id column would move from "images" table to "image_storage_domain_map" table.

**image_storage_domain_map** - Represents the properties of the Quota configured on the DC.

| Column Name         | Column Type | Null? / Default | Definition        |
|---------------------|-------------|-----------------|-------------------|
| image_id           | UUID        | not null        | Image Id          |
| storage_domain_id | UUID        | not null        | Storage domain id |
| quota_id           | UUID        |                 | Quota id          |

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

##### Typical flow

Before executing command

1.  Call canDoAction (on CommandBase)
    1.  Call validateAndSetQuota (on CommandBase)
        1.  If the command is not a storage/vds consumer - return true.
        2.  else - Call getQuotaStorageConsumptionParameters()/getQuotaVdsConsumptionParameters() (on the about to be executed command)
        3.  add storage pool id, auditLogable (this) and canDoActionMessages to complete the QuotaConsumptionParameters object
        4.  if QuotaManager.consume() return true - proceed to execution
            1.  If quota_enforcement != DISABLED return true
            2.  else - check the requested consumption for each parameter
                1.  If one or more parameters request can not be carried
                    1.  roll-back and return false

                2.  else - return true

        5.  execute command or return error

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

<Category:SLA> [Category: Feature](Category: Feature)
