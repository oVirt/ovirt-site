---
title: vm-init-persistent
authors: shaharh
wiki_title: Features/vm-init-persistent
wiki_revision_count: 6
wiki_last_updated: 2014-02-12
---

# vm-init-persistent

## VM-Init Persistent

### Summary

This Feature will allow persistent of Windows Sysprep and Cloud-Init data to the Database. By persisting the data Admin can create a template with VM-Init data that which will enable initialize VMs with relevant Data.

### Owner

*   Name: Shahar Havivi
*   Email: shaharh@redhatdotcom

### Detailed Description

Currently we are persisting the Timezone and Domain for Sysprep Windows based machines and Cloud-init data via Run-Once dialog. We want to be able to add more granularity to Sysprep such as saving a Windows serial key and persisting the current Cloud-init data that we have via the Run-Once dialog. The VM-Init section will have its own tab in Add/Edit VM and will stay the same for the Run-Once dialog

![](Cloud_init.jpg "Cloud_init.jpg")
