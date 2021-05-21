---
title: Template Versions
authors:
  - abonas
  - mlipchuk
  - ofrenkel
---

# Template Versions

## Summary

We would like to have ability to create new version for a template,
for example with OS or other software updates.

this means that when creating VM from a template,
user could also select the version of the template to use,
by default it will be the latest version.

## Owner

*   Name: Omer Frenkel

## Current Status

*   Status: Design
*   Target release: 3.4

## Detailed Description

This feature will allow adding new versions to existing templates,
There will be two methods to create a version for a template:

*   by selecting a vm and using it to create a new version to a template.
*   by editing a template, and when saving, selecting save as version.

Version of template could be deleted if no vms are using it (same as current delete template logic). If a base template is deleted, all its versions will be deleted as well.

When creating a vm from template, the user will also select the version of the template to use, or 'latest'.
Stateless vms and vms from vm-pool that are using 'latest' version, will use new version automatically on new runs.

We should not allow creating version of a version (nested version, just one level of versioning).
Nested versioning could be confusing, and currently there is no good use case to support that.

**Use Case**

The most interesting use case is for VM-Pools, where vms are stateless.

*   admin can create pool of vms from template (from a specific version or 'latest')
*   after some time create a new version for the template
*   if the pool is from 'latest', pool is updated to use new version of template
*   from this point, every vm that is taken from the pool will have the new version.

      vms in use will not be affected immediately.

**New Functionality**

*Create Template Version*

**\1**

*   A template's version is a template that is linked to its base (original) template.
*   A new property for template - 'version_name' allowing the user to name the version
*   A new property for template - 'version' to save its version
*   A new property for vm - 'version' to save the version it is using, null means latest
*   On upgrade all templates will get version 1

<!-- -->

*   Change queries to return only latest template object for each template

<!-- -->

*   Templates sub tabs (general, discs, nics) should show information of latest version
*   Change VM and storage sub tab in Templates main tab to show information of all versions

<!-- -->

*   When a new template version is created:
    -   find all stateless vms created from the template that use 'latest' version
    -   recreate them, keeping: ID, name, description, cluster, comment, stateless flag
    -   find all vm-pools that are using the template with 'latest' version
    -   recreate all down vms
    -   for each vm that moves to down, if there is a new version, recreate it

### UI

*   add an option to select template version when creating vm, by default latest should be selected

### REST API

**Templates management usecase: For each template version we have a separate REST entity of template.**

*   GET :

new section <version> will be introduced to include all 3 properties: version number, version name and base template id (GUID) for base templates: base will have base id empty, base version numbering = 1

*   POST: (add new template version)

The version section is optional because user might be creating a base template (which is a regular template as in previous versions of ovirt)
If version section will be defined, user will have to fill the following fields:
*base_template* - required to fill (a template object with id of the base template). Not filling it will result with error and the request will fail. Filling a non existing base template id will also fail the request.
*version_name* - optional
*version_number* should not be filled by the user. (it's calculated by the engine), if user fills it, it will be ignored
 **Example for adding a template version** - this section should be added as part of body inside the template element. The relevant url is: api/templates

```xml
<version>
 <base_template id="1c4f1c18-030f-4a78-9b61-e17ca1d45cb0"/>
 <version_name>"second template for lab"</version_name>
</version>
```

*   PUT: (update a template version)

Only the version name can be updated. No update is supported for version section in 3.4 for base template id nor numbering.

Example for editing a template's version name: (add the version part inside the template element in the request body) Relevant api is the same as updating a template : `api/templates/<templateId>`

```xml
<version>
  <version_name>"new name of this version"</version_name> 
</version>
```

**VMs usecase**

template field continues to be reused and will contain version details where applicable.
VM will have a new use_latest_template_version boolean property that is relevant for stateless VMs. It indicates whether the latest template version should be used.
User will be able to pass it when creating or updating a VM. If user will try to create a new stateful VM with this property set to true, an error will be returned.
When doing GET, this property will be propagated from backend, set to 'false' for stateful VMs.
 **REST relevant patches**
<http://gerrit.ovirt.org/#/c/23453/>
<http://gerrit.ovirt.org/#/c/23560/>

### DB

*   2 new fields for vm_static:
    -   template_version - int - save a numeric, sequential, version number of the template
        -   for template its automatic handled during add template, not user changeable.
        -   for vm this is the selected templated, null marks 'use latest'
    -   template_version_name - varchar - for template, save the name of version as entered by the user
*   Reuse of existing field in vm_static - vmt_guid to save the base template id

## UI Mock-Ups

*   templates grid view with versioned templates:

![](/images/wiki/Tm_vr_template.png)

*   new template dialog

![](/images/wiki/Tm_vr_create_template.png)

*   new vm dialog

![](/images/wiki/Tm_vr_new_vm.png)

## Testing

*   Test case: **Create new version for template**
    -   setup:

Create vm and install some OS (Fedora/RHEL/Ubuntu)

Create a template from the vm.

*   -   test:

Create a new vm from this template.

Install some new software (like vim) on this new vm.

Create new version to the template from this vm.

Create new vm from the template and make sure to select latest version

Make sure new software actually there

*   Test case: **New version for VM Pool**
    -   setup:

Create VM Pool from template with some OS installed, with at least 2 vms

Have 1 vm taken (used by a user)

*   -   test:

Create new version to the template as explained in previous test

Take vm2, make sure its the new version

return vm1 to the pool, and take it again, make sure its the new version

## Open Issues

*   create version from any vm or only vm created from this template? from last version?
*   automatically use latest template with stateless vm -

this will "reset" the vm configuration - delete all existing snapshots of the vm (as disks need to be re-created), if any, and other customization..
do we want to let user choose if to auto update stateless vms (check box)?

*   saving version number - add new column or use name column?


