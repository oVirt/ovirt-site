---
title: Template Versions
authors: abonas, mlipchuk, ofrenkel
wiki_title: Features/Template Versions
wiki_revision_count: 35
wiki_last_updated: 2015-03-16
---

# Template Versions

### Summary

We would like to have ability to create new version for a template, for example with OS or other software updates.

this means that when creating VM from a template, user could also select the version of the template to use, by default it will be the latest version.

### Owner

*   Name: Omer Frenkel
*   Email: ofrenkel@redhat.com

### Current Status

*   Status: Design
*   Target release: 3.4

### Detailed Description

This feature will allow adding new versions to existing templates, by selecting a vm and using it to create a new version to a template.

Version of template could be deleted if no vms are using it (same as current delete template logic).

Stateless vms and vms from vm-pool will use new version automatically on new runs. (please see open issues section below about this).

**Use Case**

The most interesting use case is for VM-Pools, where vms are stateless.

*   admin can create pool of vms from template
*   after some time create a new version for the template
*   update the pool to use new version of template
*   from this point, every vm that is taken from the pool will have the new version.

      vms in use will not be affected.

**New Functionality**

*Create Template Version*

**\1**

*   Version of a template is a new type of template, which linked to the base template it is version for.

<!-- -->

*   Change queries to return only latest template object for each template

<!-- -->

*   Templates sub tabs (general, discs, nics) should show information of latest version
*   Change VM and storage sub tab in Templates main tab to show information of all versions

<!-- -->

*   On version update:
    -   find all stateless vms created from the template (and marked for auto update? [see open issues])
    -   recreate them, keeping: ID, name, description, cluster, comment, stateless flag
    -   find all vm-pools that are using the template
    -   recreate all down vms
    -   for each vm that moves to down, if there is a new version, recreate it

**UI**

*   add an option to select template version when creating vm, by default latest should be selected

**API**

Details TBD

### Testing

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

### Open Issues

*   create version from any vm or only vm created from this template? from last version?
*   automatically use latest template with stateless vm -

this will "reset" the vm configuration - delete all existing snapshots of the vm (as disks need to be re-created), if any, and other customization.. do we want to let user choose if to auto update stateless vms (check box)?

*   saving version number - add new column or use name column?

### Comments and Discussion

*   Refer to [Talk:Template Versions](Talk:Template Versions)
