---
title: HostConfiguration
category: feature
authors: ovedo, ybronhei
---

# Host Configuration Management

## Summary

oVirt 3.6 provides to admin users to set the host configuration through the UI and API. Vdsm component is the initial interface to the host, configuring the file /etc/vdsm/vdsm.conf allows to manage variance variables and attributes regarding storage, network and virt life cycle operations such as communication details, hardware usage, kernel variables and more. Each attribute is part of specific use-case and some of them are not exposed to modification by any engine API verbs.

This RFE is aimed to expose additional configuration attributes for flexibility and advanced usage. Users should NOT define any attribute normally. The case of changing\\using Vdsm internal variables depend on hardware capability, storage interfaces and other specific cases that should follow by constant support during the modification. In the scope of this feature we expose specific host configuration file and allow the admin to modify it and restart Vdsm service as described below.

In this phase of host configuration management we provide only the option to modify vdsm.conf. The API will provide general approach to manage configuration files. Following phases will be documented as part of <https://bugzilla.redhat.com/show_bug.cgi?id=838096>.

## Owner

*   Name: Yaniv Bronheim
*   Email: ybronhei@redhat.com

## Current Status

*   <https://bugzilla.redhat.com/show_bug.cgi?id=1115171> - Track the status and additional argues regarding the feature.
*   Planning design and specification details for the feature.
*   Plan to be fully supported as part of oVirt 3.6 release.

## Implementation Alternatives

1. Expose vdsm.conf from the host (via SSH) in the UI. The user will edit it and trigger the change. This will send the result back to VDSM (SSH based protocol, and not API based).

Advantages: Simple, Will support any cluster level

Disadvantages: No validation on fields, The administrator should be familiar with the options to configure (it won't be specified anywhere in the UI and depends on Vdsm implementation - probably will require some level of support (mailing list, IRC, etc...)

2. Expose new API which sends list of fields that are modifiable (and perhaps also the valid values) from VDSM. This will show the user the current values, and allow modification for those verbs.

Advantages: The UI can show the valid and default keys and values. The fields to modify are mandatory, therefore the UI can include description for each of the configurable fields

Disadvantages: Depends on cluster level which includes the new API. Requires specific logic for each field such as validation and conflicts

## The Chosen Approach

The feature will expose the vdsm.conf file and the modification will be performed by the admin in its own risk. The main assumption is that support guides the user during the change process. No validation will be involved but only replacement of current configuration file. Configuration in cluster level won't be supported, to expose such flow user will require to use manual script (such as iterate on all cluster's hosts, move each one to maintenance, use the engine's logic to perform the modification and activate the host).

## User Flow

*   "Advanced Host Configuration" tab will be exposed only through Host options (Right click on Host name).
*   When host is not on maintenance the tab will show the content of current vdsm.conf file on host without the option to edit it.
*   User requires to put host on maintenance to see the text area field enabled and then will be able to modify it with any content (**On connectivity issues an error label message will be shown**).
*   After modifying the field, if user does not click on "Update Configuration" button the changes won't save or send to host at all.
*   Clicking on "Update Configuration" will start updating flow -> SSH to host, replacing vdsm.conf content and restart vdsmd service - If the flow fails a popup message will be raised.
*   On success the content will be updated and the user can activate the host.
*   If Vdsm fails to start, the content will be reverted to last known working content. When entering back to "Advanced Host Configuration" tab the user will be able to see if the changes were committed or reverted.
*   Any communication issue or ssh errors will be shown by popup message or error label.

## Implementation Deatils

### Vdsm Side

New vdsm-tool verb that gets file path for new conf file content, the verb will replace vdsm.conf with the new file content. The verb doesn't validate the conf file, saving backup for the current /etc/vdsm/vdsm.conf file, replace the content and restart vdsmd if was up when the verb is called.

In vdsmd_init_common.sh, if one init task fails to pass we will check if backup file exists for vdsm.conf under /etc/vdsm/vdsm.conf.\*\*\*\*\* (\*\*\* implies to date). If yes it will try to restore backup file and start again - on success start the backup file will be cleaned.

From RHEV-H prospective, there is no need for additional persistence manipulation. vdsm.conf is persisted on restarts and upgrade as part of the current implementation.

### Engine Side

*   Introduce GetHostConfigurationCommand which retrieves vdsm.conf content from host by ssh.
*   Introduce SetHostConfigurationCommand(content) which by ssh commands replace vdsm.conf content, restart VDSM service. Engine will log the operation in audit log. The command runs only when host in maintenance.

### UX

*   Introducing new tab called "Advanced Host Configuration" in Host options - The content of current vdsm.conf file on host will be exposed there in editable text area field. The content will be blocked if host not on maintenance mode.

![](/images/wiki/configure_host.png)

### API

RestAPI will allow to modify configuration files on host. In scope of this RFE we will introduce the following APIs:

      Retrieves list of configuration file names:
       GET /hosts/{host:id}/configurationfiles
       Accept: application/xml
` `<host_configuration_files>
`  `<host_configuration_file href="..." id="[hex encoding of name field]">
`     `<name>`vdsm.conf`</name>
`     `<encoding>`base64`</encoding>
`  `</host_configuration_file>
         ...
` `</host_configuration_files>
      Search for specific file will be done by GET /hosts/{host:id}/configurationfiles?search=name%3Dvdsm.conf 

      Retrieve a specific configuration file:
        GET /hosts/{host:id}/configurationfiles/{configurationfile:id}
        Accept: application/xml or by text/plain
`  `<host_configuration_file href="..." id="...">
`    `<name>`vdsm.conf`</name>
`     `<encoding>`base64`</encoding>
`     `<content>
             ...
`     `</content>
`  `</host_configuration_file>

      Replace configuration file:
       PUT /hosts/{host:id}/configurationfiles/{configurationfile:id}
       Content-Type: application/xml or text/plain
` `<host_configuration_file href="..." id="...">
`   `<name>`vdsm.conf`</name>
`   `<encoding>`base64`</encoding>
`   `<content>
           ...
`   `</content>
` `</host_configuration_file>

## Open Issues

*   Do we need new action group that allows to change host configuration? Although seems like everyone that can edit the host should be able to do that as well
*   Notification - how will we show the user that it failed and we rolled back to the previous file? Entering "Advanced Host Configuration" tab again and watch the content. If saved or not.
*   UX details - such as if we can have freestyle text area in form

### Documentation / External References

