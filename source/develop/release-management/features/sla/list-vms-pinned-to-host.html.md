---
title: List VMs pinned to a host
category: feature
authors: akrejcir
feature_name: List VMs pinned to a host
feature_modules: engine
feature_status: design
---

# List VMs pinned to a host
It can be useful to list all VMs that are pinned to a chosen host.

## Owner
* Owner: Andrej Krejcir
* Email: akrejcir@redhat.com

## Changes in this feature
- Add new query to the engine, to retrieve all VMs pinned to a Host.
- Add a DB call to get all VMs pinned to a host.
- Expose a way to get all VMs pinned to a host through REST API.
- Show the pinned VMs in the webadmin in `Host` details page.

### New query
A new query `GetVmsPinnedToHostQuery` is added to get all VMs pinned to a host.
It uses a simple SQL function.


### REST API
Possibilities to expose the new query through the REST API:

- Extend the `search` parameter of the `vms` REST endpoint to get VMs pinned to a host. For exaxmple:

  ```
  /ovirt-engine/api/vms?search='pinned-to={host-id}'
  ```

- Add a REST endpoint that returns all VMs pinned to a host. For example:

  ```
  /ovirt-engine/api/hosts/{host-id}/pinned-vms
  ```

### Webadmin
There will be two tables in the `Virtual Machines` sub-tab in the host details page.
One for running VMs and the other for pinned VMs:

![](/images/wiki/VMs_pinned_to_host.png)


## References
- RFE in bugzilla: [Bug 1428498](https://bugzilla.redhat.com/show_bug.cgi?id=1428498)
- Gerrit patch with the query to get VMs pinned to a host: [oVirt gerrit 80870](https://gerrit.ovirt.org/#/c/80870/)
