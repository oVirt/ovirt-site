---
title: Attach shared Storage Domains to a local DC.
category: feature
authors: mlipchuk
---

# Attach shared Storage Domains to a local DC.


## Overview

With the ability to attach and detach a data domain (introduced in 3.5), data domains became a better option for moving VMs/Templates around than an export domain.
In order to gain this ability in local DCs, it should be possible to attach a Storage Domain of a shared type to that DC.
This feature essentially re-defines a local DC as a DC that's allowed to have just one host, bringing it closer to the general DC concept.

## Owner

- Name: [Maor Lipchuk](https://github.com/maorlipchuk)
- Email: <mlipchuk@redhat.com>

## Detailed Description

As part of this feature the user will now have the ability to change an initialized Data Center type (Local vs Shared).
The following updates will be available:
1. Shared to Local - Only for a Data Center that does not contain more than one Host and more than one cluster, since local Data Center does not support it.
The engine should validate and block this operation with the following messages:
* CLUSTER_CANNOT_ADD_MORE_THEN_ONE_HOST_TO_LOCAL_STORAGE
* VDS_CANNOT_ADD_MORE_THEN_ONE_HOST_TO_LOCAL_STORAGE
2. Local to Shared - Only for a Data Center that does not contain a local Storage Domain.
The engine should validate and block this operation with the following message ERROR_CANNOT_CHANGE_STORAGE_POOL_TYPE_WITH_LOCAL.

### Functionality

#### Detach shared Storage Domain from local Data Center
Removing a local DC used to format the master domain attached to it since local SDs can not be detached.
Shared SDs behave differently, since those can be detached.
Based on that, if a local DC will be removed the master Storage Domain will be formatted only if it is a local SD (to keep the previous behaviour) and if it is a shared SD then this Storage Domain will only be detached.

#### Memory volume placement
When selecting a Storage Domain to place memory volumes, there are currently three comparators that choose the target Storage Domain:
1. The number of the VM's disks in the Storage Domain - prefer the Storage Domain where the VM has the most disks
2. Storage type - prefer file storage over block storage
3. Free space - prefer Storage Domains with more free space 

To improve resiliency, shared Storage Domains will be preferable over local Storage Domain as the second criteria (i.e., between the current [1] and [2]).

#### Re-Initialize Data Center
Re-Initialize master should prefer shared domains over local domains
When electing a new master, reconstruction is attempted according to an ascending order of the last time a domain was used as a master (see org.ovirt.engine.core.bll.storage.domain.StorageDomainCommandBase#electNewMaster(boolean, boolean, boolean)).

In a DC that contains both shared and local domains (see bug 1302185), we should add a secondary criteria to prefer shared domains over local domains for resiliency considerations. 

### UI

When attaching a shared SD from Data Centers -> Storage sub tab, local Data Centers should now be part of the optional attachable Data Centers (among shared Data Centers).
Same for attaching a Storage Domain from the Data Center main tab, shared Storage Domains should be candidates for attach to a local Data Center.

### Bugzilla

https://bugzilla.redhat.com/1353137 - Memory volume placement should prefer shared to local domains
https://bugzilla.redhat.com/1353134 - Reconstructing master should prefer shared domains over local domains
https://bugzilla.redhat.com/1309212 - Allow changing DC type from local to shared and vice versa
https://bugzilla.redhat.com/1302185 - [RFE] Allow attaching shared storage domains to a local DC

