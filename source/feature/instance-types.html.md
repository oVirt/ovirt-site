---
title: Instance Types
category: feature
authors: acathrow, ofrenkel, tjelinek
wiki_category: Feature
wiki_title: Features/Instance Types
wiki_revision_count: 132
wiki_last_updated: 2015-01-12
---

# Instance Types

## Templates 3.2

### Summary

Enhancing templates to allow:

*   Separate Configuration from Disks

      * Support disk-less templates
      * create new template (not from vm)
      * create vm from more than one template 

*   Run template

      * Allow save template changes

*   Template changes affect vms (use latest configuration)

### Owner

*   Name:
*   Email:

### Current status

*   Target Release: 3.2
*   Status: under design and discussion, this is still not completed.

### Detailed Description

In oVirt 3.1, templates are entities created from a vm,
Contains the configuration of the vm (static information of vm memory, cpu, network, OS..)
and the disks of the vm, these are tightly coupled,
and when creating vm from a template, the vm gets that template's configuration and disks.
 We would like to allow a user to assemble a vm from more than one template,
and specifically allow choosing different templates for configurations, and for disks.
For example allow user selecting template 'Fedora-17' for the vm disks,
contains data for a fedora vm,
and template 'Fedora-17-XL' for configuration of a vm with more memory than in 'Fedora-17' template.
 Another example is allowing user creating template only with configuration, without any disks attached to it,
or on the other hand, a template that contains just disks, with no configuration.
 Further more, allowing user to 'run' a template, as is, without creating a vm,
just to see what's in it, and on some occasions allowing changes saved to the template.
 Another feature will be allowing the user to keep his vms up to date with the template,
means if template (configuration?) updates, the vm configuration will update accordingly.

## Separating Configuration from Disks

Templates could be partial, any field except name could be empty (null). When creating vm from the template, the vm entity which is sent, should contain all vm data, some from template(s) and some filled by the user. All templates used to create the vm will be saved, to update the vm if they are updated. AddVmCommand will allow sending templates for configuration and for disks. Configuration templates will have some kind of order, to allow merging the right value in case of collision. (?) The vm's disks will be snapshots of all templates disks, from the given list.

User could mark for vm if it should be updated with the template, (still need to figure which, in case of many template) and every time template will be updated, the vms will be updated as well.

#### Webadmin/Power User Portal

##### Disk-less template

*   There will be two possibilities how to create a disk-less template:
    -   When creating a Template from a VM, a checkbox will be present on the "New Template" dialog with text "Make template disk-less"
    -   On Templates tab a button "New" will be added. It will open the same dialog as the "Edit" button does, and will be used to create a new disk-less template
*   The Template -> Disks subtab will be used to attach the disks of the template the same way as the VMs' disks are attached

##### Running a template

*   There will be a possibility to run the template in two modes:
    -   Stateless: any changes made during this run on the disk will be forgotten after the VM is stopped (used for verifying that the template is correct)
    -   Stateful: any changes made during this run on the disk will be written to the disk after the VM is stopped (used to e.g. upgrade a program in it etc)

Under the hood, the run template will create a VM and run it. By default, this VM will not be visible in the "Virtual Machines" tab, however, there will be a way (radio button like for the Disks maintab) which will enable or disable to show the "internal" VMs.

#### REST API

TBD as soon as the specific requirements will be clarified

<Category:Feature> <Category:Template>
