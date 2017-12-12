---
title: LVM Configuration the Easy Way
author: jmarks, nsofer
tags: LVM, VDSM
date: 2017-12-04 09:00:00 CET
---

Now oVirt features a simple way to prevent a host from scanning and then activating logical volumes that are not required directly by the host. In particular, the solution addresses logical volumes on shared storage managed by oVirt, and logical volumes created by a guest in oVirt raw volumes. Why is a solution required? Because scanning and activating other logical volumes may cause data corruption, slow boot, and other issues.

The solution is configuring an LVM filter on each host, which allows LVM on a host to scan only the logical volumes required directly by the host. To achieve this, we have introduced a vdsm-tool command, config-lvm-filter, that will configure the host for you.  

READMORE

The new command, `vdsm-tool config-lvm-filter` analyzes the current LVM configuration to decide
whether a filter should be configured. Then, if the LVM filter has yet to be configured, the command generates an LVM filter option for this host, and adds the option to the LVM configuration.

## Scenario 1: An Unconfigured Host

On a host yet to be configured, the command automatically configures the LVM once the user confirms the operation:

```
# vdsm-tool config-lvm-filter
Analyzing host...
Found these mounted logical volumes on this host:

  logical volume:  /dev/mapper/vg0-lv_home
  mountpoint:      /home
  devices:         /dev/vda2

  logical volume:  /dev/mapper/vg0-lv_root
  mountpoint:      /
  devices:         /dev/vda2

  logical volume:  /dev/mapper/vg0-lv_swap
  mountpoint:      [SWAP]
  devices:         /dev/vda2

This is the recommended LVM filter for this host:

  filter = [ "a|^/dev/vda2$|", "r|.*|" ]

This filter will allow LVM to access the local devices used by the
hypervisor, but not shared storage owned by Vdsm. If you add a new
device to the volume group, you will need to edit the filter manually.

Configure LVM filter? [yes,NO] ? [NO/yes] yes
Configuration completed successfully!

Please reboot to verify the LVM configuration.
```

## Scenario 2: A Configured Host

If the host is already configured, the command simply informs the user that the LVM filter is already configured:

```
# vdsm-tool config-lvm-filter
Analyzing host...
LVM filter is already configured for Vdsm
```
## Scenario 3: Manual Configuration Required

If the host configuration does not match the configuration required by Vdsm, the LVM filter will need to be configured manually:

```
# vdsm-tool config-lvm-filter
Analyzing host...
Found these mounted logical volumes on this host:

  logical volume:  /dev/mapper/vg0-lv_home
  mountpoint:      /home
  devices:         /dev/vda2

  logical volume:  /dev/mapper/vg0-lv_root
  mountpoint:      /
  devices:         /dev/vda2

  logical volume:  /dev/mapper/vg0-lv_swap
  mountpoint:      [SWAP]
  devices:         /dev/vda2

This is the recommended LVM filter for this host:

  filter = [ "a|^/dev/vda2$|", "r|.*|" ]

This filter will allow LVM to access the local devices used by the
hypervisor, but not shared storage owned by Vdsm. If you add a new
device to the volume group, you will need to edit the filter manually.

This is the current LVM filter:

  filter = [ "a|^/dev/vda2$|", "a|^/dev/vdb1$|", "r|.*|" ]

WARNING: The current LVM filter does not match the recommended filter,
Vdsm cannot configure the filter automatically.

Please edit /etc/lvm/lvm.conf and set the 'filter' option in the
'devices' section to the recommended value.

It is recommended to reboot after changing LVM filter.
```

##  Future Developments
In the future, we plan to integrate the command into the host deployment. This will allow the LVM filter to be configured automatically in common scenarios.
