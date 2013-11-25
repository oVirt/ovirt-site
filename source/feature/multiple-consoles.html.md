---
title: Multiple Consoles
category: feature
authors: fkobzik
wiki_category: Feature
wiki_title: Features/Multiple Consoles
wiki_revision_count: 27
wiki_last_updated: 2013-12-12
---

# Multiple Consoles for single VM

### Owner

*   Name: [Frank Kobzik](User:Fkobzik)
*   Email: <fkobzik@redhat.com>

### Brief description

This feature will allow a VM to have multiple consoles (e.g. SPICE and VNC at the same time) so that user can switch clients without restarting that VM.

### Status

*   1st phase
    -   VDSM part - in progress
    -   Backend part - in progress
*   2nd phase - frontend

### Detailed descripiton

There are two libvirt devices that are related to this feature: `video` and `graphics`.

*   `video` determines the video card (VGA, Cirrus, QXL...)
*   `graphics` is for graphics framebuffer (SPICE, VNC)

Currently engine sends only `video` device to the vdsm. The `graphics` device is created according to 'display' element in JSON structure that is sent on createVM. Possible values of this 'display' value are inconsistent (it's either 'vnc' or 'qxl', which doesn't make any sense).

*   The first phase consists of changing modeling the `graphics` device. It should be treated as a regular device. For this both Engine and VDSM must be changed. This would also allow us to set these devices separately (various `video` and `graphics` combinations).
*   The second phase is to reflect these changes to frontend. There should be

### VDSM part

<Category:Feature>
