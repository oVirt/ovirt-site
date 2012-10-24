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

*   Support disk-less templates
*   Support creating a template without having to use a VM
*   Run template in a stateless or stateful mode

### Owner

*   Name:
*   Email:

### Current status

Discussion

### Detailed Description

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
