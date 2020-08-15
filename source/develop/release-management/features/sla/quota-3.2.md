---
title: Quota-3.2
category: sla
authors: doron, ofri, ykaul
---

# Quota

This document describes the design for the Quota updates in oVirt 3.2.

## Motivation

Current quota (as available on oVirt 3.1) handles most of the planned capabilities and UI.
Planned updates will include minor UI changes and more significant backend redesign.
Main issues which to be addressed in this version:

*   Current implementation does not integrate into the adding new command process. Thus, one can add a new command without taking Quota into concern. In the command is a resources consumer - this could potentially lead to holes in the quota mechanism.
*   In current design, a command quota dependency is inherited by its descendants. This situation leads to wrong quota calculation (when inheriting implemented methods) and unnecessary quota calculations (when the descendant should not be quota dependent). The redundant quota references often results with corrupted data passed to the QuotaManager.
*   Current design calls for a relatively complex implementation in each new command, When large portions of the code are duplicated .


## GUI

Current UI both in the Administrator Portal and the User Portal is lacking status and monitoring.

*   Administrator Portal
    -   Quota Monitoring would be added to the Quota-View Main-Tab. The main grid will be changed, adding the columns: Memory Consumption, Free Memory, vCPU Consumption, Free vCPU, Storage Consumption, Free storage. Consumption columns will show a percentage bar and free resource columns will show actual quantity of free resource.
    -   Unlimited resources will show "Unlimited" instead of the percentage and free quantity.
    -   Exceeded quota will show "Exceeded" instead of the percentage.
    -   Bars color will be set according to other system behavior (currently green<70, 70<=orange <95, red>=95) and not according to threshold and grace settings.

![|Quota Monitors in Administrator Portal](/images/wiki/MainTabQuotaViewNew.png "|Quota Monitors in Administrator Portal")

*   Power User Portal
    -   Quota monitoring would be added to the Resources Side-Tab. The current usage bar available in the vCPU box and the Memory box will be changed. instead of the current behavior showing the used/defined resources the bar will get a new behavior, showing the used/available (where available is the amount of resources allocated for the user in the quota). i.e. if the user is defined as a consumer of Quota_a which limits 30Gb of storage and the user currently have two disks of 10Gb each - the user will see 66% usage (20/30).
    -   The upper bar will show an aggregation of all of the quotas available for the consumption of the user.
    -   Under the upper bar an expansion panel will be added, showing the quota distribution.
    -   In case part of the quota is consumed by other users, this part will be shown in a different color and will get a separated percentage label
    -   Consumption bars will be added to the Storage box as well (at the top)

![|Quota Monitors in User Portal](/images/wiki/End_user_memory.png "|Quota Monitors in User Portal")

### Design

## Backend

This section describes the backend design for this feature.

### Logic Design

Each time the user will run a VM or create a new disk, there will be a quota resource check against the quota views.
The process of quota validation is located in 3.1 in a method called validateAndSetQuota in the command execute process. This will be moved into CommandBase.
As in 3.1 the quota validation should be executed as synchronize method during the internalCanDoAction and before the command execute method.
Each command which consumes quota resources will implement StorageQuotaDependent and/or VdsQuotaDependent interface and will return a list of the quota consume/release parameters.
Commands will also be marked as storage or Vds consumers in the VdcActionType class. The default value for this setting will be BOTH (consumes both storage and vds), so when adding new command, one will have to consider quota issues. Commands which does not consume any quota resources will be marked NONE. CommandBase will use this markings in order to decide whether quota validation is needed.
The VdcActionType marking will prevent unintentional inheritance of the interfaces and the implemented methods.
Additionally, a unit-test will be added to make sure all commands marked as quota consumers have a relevant implementation of the interface.

### Client support

In order to support the planned UI changes, QuotaManager will expose a new API. Using this API and reusing available queries the UI could pull quota consumption information from the QuotaManager cache (or DB). For 3.2, RESTful API is out of scope.

To support the new Quota monitoring both in User portal and Administrator portal, QuotaManager will expose a new API allowing to query the QuotaManager internal cache for quota consumption information.

Since the current caching mechanism in QuotaManager was designed to cache individual quota entries (and thus would be very inefficient for large number of quota cached at the same time), a second caching mechanism will be added to support fast caching (caching all the quota in the DB together). This caching will be called using a Quartz job once on system init and then every xx minutes (conditioned by cache size to db quota table size ratio).

#### DB Change

New store-procedures and functions will be added in order to support the new caching mechanism. No new views will be defined.

#### Classes

***org.ovirt.engine.core.bll.quota.QuotaManager:**'' A class which manages the quota views and memory delta tables. This class will be revisited and redesigned.
**consume(QuotaConsumptionParametrs params):*' This will be the main API of the QuotaManager. Any quota Consumption will call this method. Parameters are taken from CommandBase and the consuming command. The return value is a boolean - telling if the consumption was possible. Both storage resources and vds resources will be asked in the same QuotaConsumptionParametrs Object. That way the QuotaManager could validate and set all the resources required for the command (will make the external rollback redundant).
**rolback(QuotaConsumptionParametrs params):''' The same as consume(), only reverting all of the consume/release done by the same parameters.

***org.ovirt.engine.core.bll.quota.QuotaConsumptionParameters:**'' The object passed to the QuotaManager on each consume/release call.
**storage_pool id:*' Every cunsume/release call can handle only one storage_pool (DC).
**canDoActionMesseges:*' Used for returning canDoAction messeges back to the command.
**auditLoggableBase:** Used in order to allow logging to the auditLog using the command itself.
**List of QuotaStorageConsumptionParameter:** Holds a single entry. the basic consumption unit.
**List of QuotaVdsConsumptionParameter:** Holds a single entry. the basic consumption unit.
 ***org.ovirt.engine.core.bll.quota.QuotaStorageConsumptionParameter:**'' A single entry. The basic consumption unit for storage.
**quotaId:*' The ID of the quota.
**action type:*' Consume or release (This allows to consume some resources while releasing others, all in the same call to consume()).
**storageDomainId:** ID of the storage domain (the asked resource).
**requestedStorageGB:** The requested storage in GB.
 ***org.ovirt.engine.core.bll.quota.QuotaVdsConsumptionParameter:**'' A single entry. the basic consumption unit for cluster.
**quotaId:*' The ID of the quota.
**action type:''' Consume or release (This allows to consume some resources while releasing others, all in the same call to consume()).
**vdsGroupId:** ID of the vds group (cluster) (the asked resource).
**requestedCpu:** The requested number of vCPUs.
**requestedMem:** The requested Memory.

#### Typical flow

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

## Tests

Unit-tests for testing all of the QuotaManager API will be added.

### Expected unit-tests

1.  QuotaManager - consume quota
2.  QuotaManager - release quota
3.  QuotaManager - rollback quota
4.  QuotaManager - clear quota cache
5.  Check quota interface is implemented where VdcActionType suggests it should

### Special considerations

No special considerations.

### Pre-integration needs

No needs.

## responded to next version

### DB Change

In order to support quota on duplicate image stored on different storage domains, the quota_id column will move from "images" table to "image_storage_domain_map" table.

**image_storage_domain_map** - Represents the properties of the Quota configured on the DC.

| Column Name         | Column Type | Null? / Default | Definition        |
|---------------------|-------------|-----------------|-------------------|
| image_id           | UUID        | not null        | Image Id          |
| storage_domain_id | UUID        | not null        | Storage domain id |
| quota_id           | UUID        |                 | Quota id          |

