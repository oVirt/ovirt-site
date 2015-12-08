---
title: Video RAM
category: draft-documentation
authors: mzamazal
wiki_category: Draft documentation
wiki_title: Video RAM
wiki_revision_count: 12
wiki_last_updated: 2016-01-26
---

# Video RAM

There is a lot of confusion about video RAM settings and workings in libvirt/QEMU. This page provides compilation of information on the topic gathered from many sources and represents the best knowledge available as of December 2015.

## Current state in oVirt until now

The following video RAM settings are currently applied in oVirt per PCI device:

*   ram = 64 MB \* number_of_heads
*   vram = 32 MB
*   vgamem = unset (default 16 MB set by libvirt)

Note: If single-PCI option is not set, number_of_heads is always 1 and "heads" option in the Engine defines number of separate video devices. If single-PCI option is set, there is only single video device and "heads" Engine option transforms to number_of_heads above.

## libvirt

Meanings of <video> element attributes in domain XML:

*   `ram` (KB) specifies primary memory bar size, corresponds to `ram_size` (B) QEMU command line option.
*   `vram` (KB) specifies secondary memory bar size, corresponds to `vram_size` (B) QEMU command line option.
*   `vgamem` (KB) must be set to at least certain minimum value based on screen resolution and number of heads, corresponds to `vgamem_mb` (MB) QEMU command line option. `vgamem` libvirt option is available since RHEL-7.1; `vgamem_mb` QEMU option is available since RHEL-6.7.

## QXL QEMU driver

## vnc/vga and vnc/cirrus

## New settings in oVirt

[Category:Draft documentation](Category:Draft documentation)
