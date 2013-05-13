---
title: Network QoS - detailed design
category: sla
authors: lhornyak, ofri
wiki_category: SLA
wiki_title: Features/Design/Network QoS - detailed design
wiki_revision_count: 68
wiki_last_updated: 2013-06-10
---

# Network QoS - detailed design

## Motivation

We would like to expose to the user the ability to configure the Network Quality of Service (QoS) properties of each virtual NIC. The QoS properties are properties which defines the traffic shaping applied on the virtual NIC. QoS properties currently include:

*   Inbound
    -   Average - long-term limit around which traffic should float (Mbps)
    -   Peak - the maximum allowed bandwidth during burst (Mbps)
    -   Burst - The burst size (Mb)
*   Outbound
    -   Average - long-term limit around which traffic should float (Mbps)
    -   Peak - the maximum allowed bandwidth during burst (Mbps)
    -   Burst - The burst size (Mb)

For example: if average is set to 100 units, peak to 200 and burst to 50, after sending those 50 units of data at rate 200, the rate will fall down to 100.

## Design

## GUI

## Backend

### Classes

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

### DB Change

In order to support quota on duplicate image stored on different storage domains, the quota_id column will move from "images" table to "image_storage_domain_map" table.

**image_storage_domain_map** - Represents the properties of the Quota configured on the DC.

| Column Name         | Column Type | Null? / Default | Definition        |
|---------------------|-------------|-----------------|-------------------|
| image_id           | UUID        | not null        | Image Id          |
| storage_domain_id | UUID        | not null        | Storage domain id |
| quota_id           | UUID        |                 | Quota id          |

## Tests

### Expected unit-tests

1.  QuotaManager - consume quota
2.  QuotaManager - release quota
3.  QuotaManager - rollback quota
4.  QuotaManager - clear quota cache
5.  Check quota interface is implemented where VdcActionType suggests it should

## Special considerations

## Pre-integration needs

No needs.

## responded to next version

<Category:SLA> [Category: Feature](Category: Feature)
