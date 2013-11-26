---
title: Multiple Consoles
category: feature
authors: fkobzik
wiki_category: Feature
wiki_title: Features/Multiple Consoles
wiki_revision_count: 27
wiki_last_updated: 2013-12-12
---

# Multiple Consoles

Multiple Consoles for single VM

## Owner

*   Name: [Frank Kobzik](User:Fkobzik)
*   Email: <fkobzik@redhat.com>

## Brief description

This feature will allow a VM to have multiple consoles (e.g. SPICE and VNC at the same time) so that user can switch clients without restarting that VM.

## Status

*   1st phase
    -   VDSM part - design
    -   Backend part - design
*   2nd phase - Frontend part - refactoring in progress (draft: <http://gerrit.ovirt.org/#/c/21488/>)

## Detailed descripiton

There are two libvirt devices that are related to this feature: `video` and `graphics`.

*   `video` determines the video card (VGA, Cirrus, QXL...)
*   `graphics` is for graphics framebuffer (SPICE, VNC)

Currently engine sends only `video` device to the vdsm. The `graphics` device is created according to 'display' element in JSON structure that is sent on createVM. Possible values of this 'display' value are inconsistent (it's either 'vnc' or 'qxl', which doesn't make any sense).

*   The first phase consists of changing modeling the `graphics` device. It should be treated as a regular device. For this both Engine and VDSM must be changed. This would also allow us to set these devices separately (various `video` and `graphics` combinations).
*   The second phase is to reflect these changes to frontend. There should be a way to configure `graphics` type and `video` type in the New/Edit VM/Template dialog. Current frontend implementation of console must be slightly refactored since now the VM doesn't allow SPICE and VNC to be set simultaneously.

### Engine <-> VDSM Communication scheme

#### Current situation - pseudocode

##### Engine -> VDSM

*   -   Creating VM

<!-- -->

    // VmInfoBulder class sends this map to VDSM
    {
      'display': 'qxl',
      'devices': [
          {'type': 'video' , 'device': 'qxl' , 'specParams': {} }
        ...]
    }

*   -   Setting VM ticket for console auth

<!-- -->

    // SetVmTicket class
    {
      //todo
    }

##### VDSM -> Engine

VdsBrokerObjectsBuilder processes these fields:

*   `displayPort` - port of graphics framebuffer (no matter if it's SPICE or VNC)
*   `displaySecurePort` - SPICE secured graphics port
*   `displayType` - same value as 'display' that is sent from Engine on VM create.

#### Proposal

##### Engine -> VDSM

*   -   Creating VM

<!-- -->

    // VmInfoBulder class would send this map to VDSM
    {
      'devices': [
          {'type': 'video' , 'device': 'qxl' , 'specParams': {} },
          {'type': 'graphics', 'device': 'spice' , 'specParams': {} },
          {'type': 'graphics', 'device': 'vnc' , 'specParams': {} }
        ...]
      // no 'display'!
    }

##### VDSM -> Engine

In future we'll need to report more ports (for multiple graphics devices). There are various solutions, but for sake of simlicity and backward compatibility I'm inclined in introducing a new field 'additionalDisplayPort' to ports mentioned in [VDSM -> Engine](VDSM -> Engine). The data 'sent' by VDSM would look like this:

*   `displayPort` - port of first graphics framebuffer - two corner cases might happen
    -   Both SPICE and VNC are configured: In this case this field would contain _SPICE_ port and the additionalDisplayPort would be dedicated the VNC port
    -   Only VNC is configured: In this case displayPort would contain VNC port and additionalDisplayPort would be empty.
*   `displaySecurePort` - SPICE secured graphics port
*   `additionalDisplayPort` - port of VNC graphics framebuffer (only used when both SPICE and VNC are configured)

This behavior is not certainly ideal, but is backward compatible with current version of the engine.

<Category:Feature>
