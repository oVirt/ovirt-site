---
title: Multiple Consoles
category: feature
authors: fkobzik, tjelinek
---

# Multiple Consoles

Multiple Consoles for single VM

## Owner

*   Name: Frank Kobzik (Fkobzik)
*   Email: <fkobzik@redhat.com>

## Brief description

This feature will allow a VM to have multiple consoles (e.g. SPICE and VNC at the same time) so that user can switch clients without restarting that VM.

## Status

*   1st phase
    -   VDSM part - design
    -   Backend part - design
*   2nd phase - Frontend part
    -   Refactoring frontend models to support more graphics - merged (patch: <http://gerrit.ovirt.org/#/c/21488/>)
    -   UI patch - adding new UI elements to VM/Template dialog - waiting for ^

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

*   Creating VM

<!-- -->

    // "vmCreate" JSON sent from Engine to VDSM
    {
        display: 'vnc',
        displayPort: -1,
        displaySecurePort: -1,
        // engine -> vdsm video device
        'devices': [{
          'device': 'cirrus',
          'type': 'video',
          'deviceId': '0ec7c2b9-62c9-4578-b096-f453b5cfc677', 'address': ..., 'specParams': {'vram': '32768', 'heads': '1'}
        }, ... // other devices
      ]}

*   Setting VM ticket for console auth

<!-- -->

    // SetVmTicket class
    {
      //todo
    }

This call will result in adding following devices:
```xml
    <graphics
      autoport="yes"
      keymap="en-us" 
      listen="0"
      passwd="*****"
      passwdValidTo="1970-01-01T00:00:01"
      port="-1"
      type="vnc"/>

    <video>
        <address bus="0x00" domain="0x0000" function="0x0" slot="0x02" type="pci"/>
        <model heads="1" type="cirrus" vram="32768"/>
    </video>
```

##### VDSM -> Engine

VdsBrokerObjectsBuilder processes these fields "sent" by VDSM:

*   `displayPort` - port of graphics framebuffer (no matter if it's SPICE or VNC)
*   `displaySecurePort` - SPICE secured graphics port
*   `displayType` - same value as 'display' that is sent from Engine on VM create.

#### Proposal

##### Engine -> VDSM

*   Creating VM

<!-- -->

    // New "vmCreate" JSON sent from Engine to VDSM
    {
        'devices': [
          {'device': 'cirrus',
           'type': 'video',
           'deviceId': 'blah', 'address': ..., 'specParams': {'vram': '32768', 'heads': '1'}
          },
          {'device': 'qxl', 'type': 'graphics', 'specParams': {} },  //send graphics as a regular device
          {'device': 'vnc', 'type': 'graphics', 'specParams': {} }  //dtto
      ]}

##### VDSM -> Engine

In future we'll need to report more ports (for multiple graphics devices). There are various solutions, but for sake of simlicity and backward compatibility I'm inclined in introducing a new field 'additionalDisplayPort' to ports mentioned in [VDSM -> Engine](#vdsm---engine). The data 'sent' by VDSM would look like this:

*   `displayPort` - port of first graphics framebuffer - two corner cases might happen
    -   Both SPICE and VNC are configured: In this case this field would contain _SPICE_ port and the additionalDisplayPort would be dedicated the VNC port
    -   Only VNC is configured: In this case displayPort would contain VNC port and additionalDisplayPort would be empty.
*   `displaySecurePort` - SPICE secured graphics port
*   `additionalDisplayPort` - port of VNC graphics framebuffer (only used when both SPICE and VNC are configured)

This behavior is not certainly ideal, but is backward compatible with current version of the engine.

#### Note about backwards compatibility

Firstly, this feature will require certain cluster level (planned for 3.4).

Changes proposed by this page would be backward compatible:

*   'Old' Engine + 'New' VDSM
    -   **Engine -> VDSM:** 'New' VDSM would still check if incoming vmCreate JSON contains regular graphics device(s), if not, it'd switch to legacy behavior (i.e. using 'display' field in vmCreate JSON).
    -   **VDSM -> Engine:** As noted in 'proposal' section, the displayPort and securedDisplayPort would contain same information as with old VDSM.
*   'Old' VDSM + 'New' Engine
    -   In this case engine would contain logic that switches behavior of VmInfoBuilder and VdsObjectsBrokerBuilder classes depending on cluster level of given VM.

### Frontend

Nothing interesting so far.

