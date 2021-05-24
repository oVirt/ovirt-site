---
title: Video RAM
authors: mzamazal
category: draft
---

# Video RAM

There is a lot of confusion about video RAM settings and workings in libvirt/QEMU. This page provides compilation of information on the topic gathered from many sources and represents the best knowledge available as of December 2015.

## State in oVirt until 3.6

The following video RAM settings were applied in oVirt per PCI device:

*   ram = 64 MB \* number_of_heads
*   vram = 32 MB
*   vgamem = unset (default 16 MB set by libvirt)

Note: If single-PCI option is not set, number_of_heads is always 1 and "heads" option in the Engine defines number of separate video devices. If single-PCI option is set, there is only single video device and "heads" Engine option transforms to number_of_heads above.

## libvirt

Meanings of `<video>` element attributes in domain XML:

*   `ram` (KB) specifies primary memory bar size, corresponds to `ram_size` (B) QEMU command line option.
*   `vram` (KB) specifies secondary memory bar size, corresponds to `vram_size` (B) QEMU command line option.
*   `vgamem` (KB) must be set to at least certain minimum value based on screen resolution and number of heads, corresponds to `vgamem_mb` (MB) QEMU command line option. `vgamem` libvirt option is available since RHEL-7.1; `vgamem_mb` QEMU option is available since RHEL-6.7.

## QXL QEMU driver

**Please note** that all the information about video RAM sizes below should be taken with grain of salt. Nobody knows the perfect ultimate answer to that topic, there are different guest OS drivers and as stated above, things may completely change in oVirt 4. Users should be able to override the computed default settings if they use uncommon arrangements or the computed values don't work well for them. This can be done using before_vm_start VDSM hook.

You can look for implementation details in qxl.c in QEMU sources. But don't rely on anything, things may change, so it's a good idea to get confirmation from QEMU and/or libvirt developers about everything.

libvirt `ram` represents primary memory bar, 32-bit only. libvirt `vram` represents secondary memory bar, 64-bit (it may not be true as of now, there is a separate `vram_size_mb` QEMU command line option for that, not necessarily used by libvirt).

`vgamem` is allocated within `ram`. Minimum `ram` size, as enforced by QEMU regardless the command line settings, is `2 * vgamem`. `vram` is allocated separately.

Maximum supported screen resolution is 4 megapixels (2560x1600). Maximum number of heads is 4.

The required memory sizes are basically dependent on screen resolution multiplied by number of heads. But this should actually be the bounding rectangle of the screen arrangement. For instance, let's assume 4 screens with resolution 1024x768 each. If they are arranged compactly in a single row or in two rows and two columns, it's fine, memory for 3 megapixels is required. But if three screens are in a row and the fourth screen is below them then the required memory may correspond (depending on the driver) to 4.5 (3072x1536) megapixels; when all the screens are arranged diagonally, it's 12 (4096x3072) megapixels. We don't assume such setups when computing memory values.

Due to 32-bit addressing in QEMU, total (for all video cards together) maximum size of `ram` is 256 or 512 MB. **TODO**: Check what happens when we specify more.

All memory sizes should be specified as powers of 2. This is not a strict requirement, it's just advised.

Video RAM is allocated in addition to specified guest main RAM, not within it.

The recommended memory sizes are dependent on particular guest OS and its drivers:

*   Windows:
    -   vgamem = screen_width \* screen_height \* 4
    -   ram = 4 \* vgamem
    -   vram unimportant (can be e.g. 8 MB)

<!-- -->

*   RHEL-6 (uses UMS driver):
    -   vgamem = screen_width \* screen_height \* 4 \* number_of_heads
    -   ram = 4 \* vgamem
    -   vram unimportant (can be e.g. 8 MB)
    -   Note: `ram` may (or may not) work even when it's reduced to `2 * vgamem`, but developers recommend using the larger value.

<!-- -->

*   RHEL-7 (uses KMS driver):
    -   vgamem = screen_width \* screen_height \* 4 \* number_of_heads
    -   ram = 4 \* vgamem
    -   vram >= vgamem \* 2
    -   Note: `ram` may (or may not) work with much smaller values, but it's suggested to set it at least so that `ram + vram >= 3 * vgamem`.
    -   Note: An alternative formula for `vram` is `screen_width * screen_height * 4 * (number_of_heads + 1)`. But developers strongly recommend using at least `vgamem * 2`.

It may not be a good idea to use excessively large memory values just to be safe. The extra (above required minimum) memory may be actually utilized by the guest OS drivers and applications (e.g. Excel or Firefox) for purposes not necessarily very important for graphics performance. As the result, physical RAM may be wasted for no useful purpose.

## vnc/vga and vnc/cirrus

*   The better choice of the two is clearly vnc/vga.
*   Multihead is not supported on any of the drivers.
*   Default `vram` value, 16 MB, is fine for most common uses, except for full HD on Wayland (needs twice as much due to two framebuffers—page-flipping).
*   Supported by libvirt only on RHEL-7.

## New settings in oVirt 3.6.X

We use the following settings in new oVirt versions (per PCI device):

*   QXL
    -   vgamem = 16 MB \* number_of_heads
    -   ram = 4 \* vgamem
    -   vram = 2 \* vgamem for RHEL-7 guest OS
    -   vram = 8 MB for other guest OSes
*   vnc/vga and vnc/cirrus:
    -   vram = 16 MB
