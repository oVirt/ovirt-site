---
title: Hosted Engine related changes in the UI
category: feature
authors: akrejcir
---

## Hosted Engine related changes in the UI

### Summary

Several changes were made to the Webadmin UI to make it easier to see hosted engine related entities.

* New icons showing:
  * which VM is the hosted engine
  * which storage domain contains disks used by the hosted engine
  * which hosts are configured to run the hosted engine VM
* The buttons for enabling and disabling hosted engine global maintenance mode were moved to the context menu of a host
* Only one of the buttons is enabled, depending on the actual state.
* Hosts can be filtered by hosted engine deployment.

### Owner

*   Name: Andrej Krejcir (akrejcir)
*   Email: akrejcir@redhat.com

### Detailed Description

#### New icons

Added icons make it easier to see hosted engine related entities in the webadmin.
These icons were added to the webadmin UI:

* Icon showing which VM is actually the hosted engine, regardless of its name.
![](/images/wiki/he-vm-icon.png)

* Icon showing which storage domain contains the disks used by the hosted engine.
![](/images/wiki/he-storage-icon.png)

* Icons showing which hosts are configured to run the hosted engine VM.
![](/images/wiki/he-hosts-icon.png)

#### Global maintenance buttons

The buttons for enabling and disabling hosted engine global maintenance mode
were moved to the host context menu in the host tab, because it was easier to implement their state.

#### Host filtering

All hosts with hosted engine deployment can be filtered using the flag:
`Host: he_deployed = true`.

### Benefit to oVirt

It is now easily visible which entities are related to the hosted engine and
they can be filtered out from the rest if needed.

### Implementation details

Adding the icon for VM was simple, as the VM entity already has a field
indicating if it is the hosted engine.
Similarly for the hosts, the host entity has fields
indicating if the hosted engine can run on it and the mode of the maintenance.

The storage domain did not have such field, so it was added.
A new view was added to the DB which contains the ids of storage domains
with disks used by the hosted engine.

### Documentation / External references

Bugzilla references:

* [HE VM Icon](https://bugzilla.redhat.com/show_bug.cgi?id=1392389)
* [HE storage domain icon](https://bugzilla.redhat.com/show_bug.cgi?id=1392412)
* [Global maintenance buttons](https://bugzilla.redhat.com/show_bug.cgi?id=1392418)
* [Host icons and filtering](https://bugzilla.redhat.com/show_bug.cgi?id=1392407)
