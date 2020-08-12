---
title: kernel cmdline
category: feature
authors: mpolednik
---

# Kernel Cmdline

## Summary

This feature will add support for modifications of kernel cmdline via grubby. This will allow enabling or disabling functions such as nested virtualization, iommu (and related quirks) or using pci-stub from ovirt-host-deploy API.

## Owner

*   name: Martin Polednik (Martin Polednik)

## Current Status

*   last updated date: Thu Jun 16 2015

## Requirements

*   Linux system with grubby installed

## API

### ovirt-host-deploy

`KERNEL/cmdlineNew(str)` - New arguments to kernel command line.

`KERNEL/cmdlineOld(str)` - Previous (to be removed) arguments of kernel command line.

## Expected Workflow

The information about current cmdline will be exposed in caps (getVdsCaps verb) as kernelArgs. There are two separate workflows: first installation of a host and redeploying a host. Also, warning taken directly from the `kernel` tab:

Modifying kernel boot parameters settings can lead to a host boot failure. Please consult the documentation before doing any changes. The host needs to be rebooted after successful host deploy for kernel boot parameters to be applied.

### First deploy
1.  When adding a new host, navigate to `kernel` tab,
2.  do the desired modifications,
3.  after deploy finishes, reboot the host.

After booting up, the changes should be in effect.

### Existing host
1.  Put the host to maintenance mode,
2.  navigate to `kernel` tab,
3.  do the required modifications,
4.  reinstall the host (through oVirt engine),
5.  after installation finishes, reboot the host.

As with initial deployment, the changes should be in effect after host boots up.

## References
https://www.kernel.org/doc/Documentation/kernel-parameters.txt
