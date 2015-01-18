---
title: HostConfiguration
category: feature
authors: ovedo, ybronhei
wiki_category: Feature
wiki_title: Features/HostConfiguration
wiki_revision_count: 18
wiki_last_updated: 2015-01-28
---

# Host Configuration

### Summary

oVirt 3.6 provides to admin users to set the host configuration through the UI and API. Vdsm component is the initial interface to the host, configuring the file /etc/vdsm/vdsm.conf allows to manage variance variables and attributes regarding storage, network and virt life cycle operations such as communication details, hardware usage, kernel variables and more. Each attribute is part of specific use-case and some of them are not exposed to modification by any engine API verbs.

This RFE is aimed to expose additional configuration attributes for flexibility and advanced usage. Users should NOT define any attribute normally. The case of changing\\using Vdsm internal variables depend on hardware capability, storage interfaces and other specific cases that should follow by constant support during the modification. In the scope of this feature we expose specific host configuration file and allow the admin to modify it and restart Vdsm service as described below.

### Owner

*   Name: Yaniv Bronheim
*   Email: ybronhei@redhat.com

### Current Status

*   Planning design and specification details for the feature.
*   Plan to be fully supported as part of oVirt 3.6 release.

### Implementation Alternatives

1. Expose vdsm.conf from the host (via SSH) in the UI. The user will edit it and trigger the change. This will send the result back to VDSM (SSH based protocol, and not API based).

Advantages: Simple, Will support any cluster level

Disadvantages: No validation on fields, The administrator should be familiar with the options to configure (it won't be specified anywhere in the UI and depends on Vdsm implementation - probably will require some level of support (mailing list, IRC, etc...)

2. Expose new API which sends list of fields that are modifiable (and perhaps also the valid values) from VDSM. This will show the user the current values, and allow modification for those verbs.

Advantages: The UI can show the valid and default keys and values. The fields to modify are mandatory, therefore the UI can include description for each of the configurable fields

Disadvantages: Depends on cluster level which includes the new API. Requires specific logic for each field such as validation and conflicts

### The Chosen Approach

The feature will expose the vdsm.conf file and the modification will be performed by the admin in its own risk. The main assumption is that support guides the user during the change process. No validation will be involved but only replacement of current configuration file. Configuration in cluster level won't be supported, to expose such flow user will require to use manual script (such as iterate on all cluster's hosts, move each one to maintenance, use the engine's logic to perform the modification and activate the host).

### User Flow

*   "Advanced Host Configuration" tab will be exposed only through EditHost form.
*   When host is not on maintenance the tab will show the content of current vdsm.conf file on host without the option to edit it.
*   User requires to put host on maintenance to see the text area field enabled and then will be able to modify it with any content (**On connectivity issues an error label message will be shown**).
*   After modifying the field, if user does not click on "Update Configuration" button the changes won't save or send to host at all.
*   Clicking on "Update Configuration" will start updating flow -> SSH to host, replacing vdsm.conf content and restart vdsmd service - If the flow fails a popup message will be raised.
*   On success the content will be updated and the user can activate the host.
*   If Vdsm fails to start, the content will be reverted to last known working content. When entering back to "Advanced Host Configuration" tab the user will be able to see if the changes were committed or reverted.
*   Any communication issue or ssh errors will be shown by popup message or error label.

### Implementation Deatils

#### Vdsm Side

[nothing?]

#### Engine Side

*   New Engine command that gets vdsm.conf from host by ssh
*   New Engine command that copies that modified vdsm.conf file to host, replace the current content (persist the change for RHEV-H) and restart VDSM service [TBD: automatically?] (All by SSH based protocol)
*   The flow should be allowed only when host in maintenance [or for new hosts?]

#### UX

*   In tab "Host Configuration" as part of EditHost form - The content of vdsm.conf file is exposed after clicking on "Fetch Current Host Configuration" - For new host this will show ovirt-host-deploy defaults [TBD: not sure how to fetch the defaults. it can be overrided by ovirt-host-deploy conf files..]

### Open Issues

*   Should we expose more related conf files (should host profiles should be separated from this feature - <https://bugzilla.redhat.com/show_bug.cgi?id=838096>)
*   can RHEV-H persist vdsm.conf easily? or is it require additional changes?
*   Does upgrade (RHEV-H upgrade and yum upgrade) override vdsm.conf ?
*   Do we need new action group that allows to change host configuration? Although seems like everyone that can edit the host should be able to do that as well
*   Notification - how will we show the user that it failed and we rolled back to the previous file?
*   UX details - such as if we can have freestyle text area in form

#### Documentation / External References

<Category:Feature> <Category:Template>
