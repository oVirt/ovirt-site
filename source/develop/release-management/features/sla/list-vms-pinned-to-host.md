---
title: List VMs pinned to a host
category: feature
authors: akrejcir
---

# List VMs pinned to a host
It can be useful to list all VMs that are pinned to a chosen host.

## Owner
* Owner: Andrej Krejcir
* Email: akrejcir@redhat.com

## Changes in this feature
- Add new query to the engine, to retrieve all VMs pinned to a Host.
- Add a DB call to get all VMs pinned to a host.
- Show the pinned VMs in the webadmin in `Host` details page.

### New query
A new query `GetVmsPinnedToHostQuery` is added to get all VMs pinned to a host.
It uses a simple SQL function.


### Webadmin
The table in the `Virtual Machines` detail tab of the `Host` entity shows
running VMs and pinned VMs. A radio button on top of it can be used to
show only one of the groups.

![](/images/wiki/VMs_on_host_all.png)


![](/images/wiki/VMs_on_host_running.png)


![](/images/wiki/VMs_on_host_pinned.png)


### REST API
In REST API, the pinning information is part of the VM object.
One API call can be made to get all VMs in a cluster and then
those not pinned to a specific host can be filtered out.


## References
- RFE in Bugzilla: [Bug 1428498](https://bugzilla.redhat.com/show_bug.cgi?id=1428498)
