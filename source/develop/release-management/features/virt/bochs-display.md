---
title: Bochs-display
category: feature
authors: smelamud
feature_name: Bochs-display
feature_modules: engine
feature_status: In development
---

# Bochs-display

## Summary

This feature adds new display type `bochs-display` and enables it for
UEFI VMs.

## Owner

* Name: Shmuel Melamud
* Email: smelamud@redhat.com

## Description

The bochs-display device is a simple display device which is similar to
VGA but without legacy emulation. The code size and complexity needed to
emulate this device is an order of magnitude smaller, resulting in a
reduced attack surface. Another nice feature is that you can place this
device in a PCI Express slot.

For UEFI guests it is safe to use the bochs display device instead of
the standard VGA device. The firmware will setup a linear framebuffer as
graphics output protocol anyway and never use any legacy VGA features.

For BIOS guests this device might be usable as well, depending on
whenever they depend on direct VGA hardware access or not.

## Changes to Engine

1. Add new `bochs` value to `DisplayType` enum and the corresponding
   `VmDeviceType.BOCHS` value. This automatically adds 'bochs' to the
   selection of display types in the UI and enables generation of the
   correct video device in libvirt XML.
2. In all places where graphics device type is derived from display
   type, return `VNC` for bochs display type.
3. In `AddVm` and `UpdateVm` commands fail validation, if default
   display type is set to bochs, but firmware type is not UEFI or
   cluster compatibility version < 4.5.
4. If effective firmware type of a VM is changed to non-UEFI, and it has
   default display type `bochs`, change it to `vga`.
5. In UI, do not include 'bochs' as a choice for default display type
   for a VM, if its effective firmware type is not UEFI or cluster
   compatibility version < 4.5.
6. In UI and REST API, when 'Server' configuration is chosen for a VM
   and its effective firmware type is UEFI, select bochs display type by
   default.

## Tests

1. Open VM creation dialog and select a cluster having compatibility
   version >= 4.5. Open the list of available display types.<br>
   **Expected result:** `bochs` appears in the list of display types.
2. Open VM creation dialog and select a cluster having compatibility
   version < 4.5. Open the list of available display types.<br>
   **Expected result:** `bochs` does not appear in the list of display
   types.
3. Open VM creation dialog and select a cluster having compatibility
   version >= 4.5. Set VM firware type to BIOS. Open the list of
   available display types.<br> **Expected result:** `bochs` does not
   appear in the list of display types.
4. Open VM creation dialog and select a cluster having compatibility
   version >= 4.5 and cluster firmware type BIOS. Set VM firware type to
   "Cluster default". Open the list of available display types.<br>
   **Expected result:** `bochs` does not appear in the list of display
   types.
5. Create a VM with "Cluster default" firmware type and bochs display
   type in a cluster having UEFI firmware type. Change firmware type of
   the cluster to BIOS.<br> **Expected result:** Display type of the VM
   is changed to `vga`.
6. Use REST API to create a VM with BIOS firmware type and bochs display
   type.<br> **Expected result:** VM creation fails.
7. Use REST API to create a VM with "Cluster default" firmware type and
   bochs display type in a cluster having BIOS firmware type.<br>
   **Expected result:** VM creation fails.
8. Use REST API to update a VM with BIOS firmware type and set its
   display type to bochs.<br> **Expected result:** VM update fails.
9. Use REST API to update a VM with "Cluster default" firmware type in a
   cluster having BIOS firmware type and set its display type to
   bochs.<br> **Expected result:** VM update fails.
10. Use REST API to create a VM with bochs display type in a cluster
    having compatibility version < 4.5.<br> **Expected result:** VM
    creation fails.
11. Use REST API to update a VM having bochs display type and set its
    firmware type to BIOS.<br> **Expected result:** VM display type is
    changed to `vga`.
12. Use REST API to update a VM having bochs display type and set its
    firmware type to "Cluster default" in a cluster having BIOS firmware
    type.<br> **Expected result:** VM display type is changed to `vga`.
13. Open VM creation dialog and select a cluster having compatibility
    version >= 4.5. Select 'Server' configuration.<br> **Expected
    result:** Display type `bochs` is selected.
14. Use REST API to create a VM with 'Server' configuration without
    setting its display type explicitly.<br> **Expected result:** VM
    display type is set to `bochs`.
