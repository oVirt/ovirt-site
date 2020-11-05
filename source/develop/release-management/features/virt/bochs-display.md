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
GOP anyway and never use any legacy VGA features.

For BIOS guests this device might be useable as well, depending on
whenever they depend on direct VGA hardware access or not.

## Changes to Engine

1. Add new `bochs` value to `DisplayType` enum and the corresponding
   `VmDeviceType.BOCHS` value. This automatically adds 'bochs' to the
   selection of display types in the UI and enables generation of the
   correct video device in libvirt XML.
2. In all places where graphics device type is derived from display
   type, return `VNC` for bochs display type.
3. In `AddVm` and `UpdateVm` commands fail validation, if default
   display type is set to bochs, but BIOS type is not UEFI.
4. If effective BIOS type of a VM is changed to non-UEFI, and it has
   default display type `bochs`, change it to `vga`.
5. In UI, do not include 'bochs' as a choice for default display type
   for a VM, if its effective BIOS type is not UEFI.
6. In UI, when 'Server' configuration is chosen for a VM and its
   effective BIOS type is UEFI, select bochs display type by default.
