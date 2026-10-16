---
title: Making Edits to a Virtual Machine
authors:
  - lwrigh
  - lizsurette
  - sandrobonazzola
---

## Making Basic Edits to a Virtual Machine

The user can make edits to any portion of the VM details by interacting with each card.

### Edit Name and Description

Editing the name and description is contained in the first card:
![editvm](img/edit-vm.png)

### Edit Basic Details

Editing the basic details about the VM is in the 2nd card. This includes changing how much CPU and Memory resources should be given to this VM:
![editvmbasic](img/edit-vm-basic.png)
![editvmbasic2](img/edit-vm-basic2.png)

### Next Run Configuration Changes

In come cases, edits won't be applied until the next run of the VM. The user will be notified via a confirmation modal along with a notification until a reboot is done.
![nextrunconfirmation](img/next-run-confirmation.png)

![nextrunnotification](img/next-run-notification.png)

### Option to Hot Plug Changes

In a few cases, the user can choose to Hot Plug changes to the configuration.
In this case, a confirmation should be given to the user to choose whether they want to hot plug the changes or want until the next reboot of the VM to apply the changes.
![hotplugconfirmation](img/hot-plug-confirmation.png)

If the user chooses to Apply after Reboot, they will get a similar informational inline notification as with the next run configuration changes.

## Making Advanced Edits to a Virtual Machine

The user can make edits to the advanced options of the VM by expanding the 'Advanced options' section of the VM details card.

### Expanding Advanced Options

The user clicks on the caret to expand the advanced options for the VM settings.
![editvmadvanced1](img/edit-vm-advanced-1.png)

### Selecting Advanced Options

The user can select different options from the dropdowns in the expanded section.
![editvmadvanced2](img/edit-vm-advanced-2.png)

[![SPDX-License-Identifier: Apache-2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
