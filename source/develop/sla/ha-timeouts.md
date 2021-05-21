---
title: ha-timeouts
category: sla
authors:
  - abonas
  - doron
---

# ha-timeouts

## SLA: High Availability timeouts explained

### Summary

This page provides information on the various arguments used to identify and
handle connectivity issues for highly available VMs, both in previous and current oVirt versions.

### Description

There are several parameters that control monitoring and reaction behavior for
highly available VMs (vdsConnectionTimeout and vdsRetries have been added in 3.2);

*   VDSAttemptsToResetCount
*   TimeoutToResetVdsInSeconds
*   vdsTimeout
*   vdsConnectionTimeout
*   vdsRetries

**VDSAttemptsToResetCount** controls how many consecutive VDSM operations
have to fail to consider a host a candidate for fencing. Default value is **2**.

**TimeoutToResetVdsInSeconds** controls how long a host has to be failing
(VDSM operations failing continuously) to consider it a candidate for fencing. 
Default values is **60s**.

Both above parameters have to be evaluated as true to actually initiate fencing of a host,
ie- both exceeded.

**vdsTimeout** controls how long the engine waits for a VDSM operation to
complete, its default value is **180s** (3 minutes). This value shouldn't be
changed, as some VDSM operations require that time to complete.

**vdsConnectionTimeout** controls how long the engine waits for a connection
to VDSM to complete. Its default value is **180s** (3 minutes). This value should be
reduced, and in fact its default value has already been changed to **2s** in 3.3.
The default value was changed to **20s** in 3.6.

**vdsRetries** controls how many times failed VDSM operations should be
retried. Its default value is **3** in 3.2, while in 3.3 it was changed to **0**.

With these default values a host that goes completely down and doesn't respond
at all will take at least 6 minutes to be fenced: the reason is that any operation will
take those 6 minutes because we retry them 3 times (**vdsRetries**), each time it
takes approx 63s (**vdsTimeout**, the kernel cuts to 63s any value larger than that),
and we need 2 consecutive failures to start fencing: 63sec \* 3 \* 2 ~ 6min.

For a more predictable fencing the following parameters need to be changed:
 # engine-config -s vdsConnectionTimeout=2 
 # engine-config -s vdsRetries=0

With these settings the host should be fenced approx **1 minute** after it stops responding,
and this happens because now the **VDSAttemptsToResetCount** and **TimeoutToResetVdsInSeconds**
are really taken into account and not masked by the low level timeouts.

