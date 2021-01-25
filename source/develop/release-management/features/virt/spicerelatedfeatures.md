---
title: SPICERelatedFeatures
category: feature
authors: acathrow, danken, ecohen, ovedo
---

# SPICE related features

## Summary

This pages describes the changes needed on oVirt to support new SPICE features in 3.1.

## Background

Currently oVirt use the spicec client for remote Spice connections and RHEV adds the proprietary Incentives Pro USB redirector solution to add support for remote USB. Since Fedora 16, the QEMU and Spice projects have added native support for USB remoting and are moving to a new client, virt-viewer, based on spice-gtk that includes more features and is based on a more portable code-base that will extend from Linux and Windows to more platforms in the future such as Mac OS. The virt-viewer client also includes support for the new native USB support in Spice.

## Owner

*   Name: Oved Ourfali (Ovedo)
*   Email: <ovedo@redhat.com>

## Current status

*   In design phase
*   Last updated date: March 26th, 2012.

## High Level Features

In the upcoming version, SPICE is about to perform the following changes/additions:

1.  New Spice Client
2.  Native USB Support
3.  Multimonitor Support (basic)
4.  WAN Support

## Detailed Description

### New Spice Client

The Linux and Windows *spicec* based client will be replaced by the *remote-viewer* which is based on spice-gtk. The ActiveX and spice-xpi packages will be updated to include the new client which is backwards compatible with spicec - allowing remote-viewer to be used for RHEV 3 based deployments as well as RHEV 3.1.

### USB Support

For cluster level 3.1 (based on RHEL 6.3 support) native KVM/Spice USB redirection can be used in addition to the legacy Incentives Pro.

The current Incentives Pro solution needs to be supported for both 3.0 and 3.1 cluster levels. *Note :*The native USB support in Spice and KVM currently does not support live migration.

*   New/Edit VM dialog / "Console" section behavior changes:
    -   "USB Policy" drop down label will change to "USB Support"
    -   "USB Support" selected value by default will always be "Disabled"
    -   **For 3.0 Cluster level**
        -   For non-Windows VMs: "USB Support" field will be grayed out with the "Disabled" value selected.
        -   For Windows VMs: "USB Support" field will contain only the "Legacy" value (in addition to "Disabled").
    -   **For 3.1 Cluster level**
        -   For Linux VMs: "USB Support" field will contain only the "Native" value (in addition to "Disabled").
        -   For non-Windows VMs: "USB Support" field will contain both "Native" and "Legacy" values (in addition to "Disabled").

For both cluster 3.0 and 3.1 level "USB Support" should only be enabled if Spice is selected as remote protocol.

Documentation and online help should indicate that “Legacy USB support“ is deprecated and will not be supported in future releases of RHEV. When a user selects SPICE USB support we should present a warning that migration is NOT supported using SPICE USB redirection. Note: We need to disable live migration when using SPICE migration it will fail regardless of whether a device is being redirected. Targeting RHEL 6.4 to address this <https://bugzilla.redhat.com/show_bug.cgi?id=805172>

A new user editable configuration value should be added to vdc_options to specify the number of USB slots to be exposed to the virtual machine. The default should be 4

**Note:** It is suggested that we make this a system wide value, since we should be able to dynamically change this in a later implementation.

The following libvirt XML example shows adding 4 USB devices to a domain xml. The slot number would need to be adjusted based on the next available pci slot in the system. The maximum number is 6 unless we configure multiple controllers. If a usb tablet device is configured then it will take one device, however this should not be required to be configured in a spice environment with the vdagent present.

        <controller type='usb' index='0' model='ich9-ehci1'/>
        <controller type='usb' index='0' model='ich9-uhci1'/>
        <controller type='usb' index='0' model='ich9-uhci2'/>
        <controller type='usb' index='0' model='ich9-uhci3'/>

        <redirdev bus='usb' type='spicevmc'/>  
        <redirdev bus='usb' type='spicevmc'/>  
        <redirdev bus='usb' type='spicevmc'/>  
        <redirdev bus='usb' type='spicevmc'/>  

*   Each of the `redirdev` devices should be added to the `devices` list passed by Engine to Vdsm. Vdsm should be taught to recognise them.

The native qemu/Spice USB support presents an emulated echi and uchi controller to the guest. Virtual machines do not require any in-guest agents or drivers for native USB.

For native qemu/spice USB support all client to guest communication happens through the existing Spice channel so no other ports need to be opened on the guest or host.

The new Spice-XPI and Spice-ActiveX packages will wrap both the new remote-viewer client that provides support for native USB and the legacy Incentives Pro USB client. If legacy USB solution is to be used then the existing parameters can be passed as usual eg. URL & filter string. For native USB the client will read the existing filter string parameter. There is no need to explicitly enable the native USB support in the ActiveX/XPI. If legacy support parameters are not passed then the remote-viewer client will try to connect to a Spice USB channel, if no USB channel is found then USB support will be disabled automatically.

### Multi Monitor support for Linux guests (Basic)

Currently validations in the user interface prevent configuring multiple monitors for Linux guests. The backend logic permits multiple monitors. The front end logic needs to be updated to allow configuration of multiple monitors for Linux guests. This setting can be enabled for 3.0 and 3.1 cluster levels.

**Note :** Multiple monitors in Linux requires specific in-guest configuration using Xinerama and has a number of limitations (eg. X server needs to be restarted). These limitations need to be documented and included in the product documentation.

We are currently targeting RHEL 6.4 to support multihead QXL devices that would allow xrandr support in the guest for a more complete multihead solution. Multihead QXL device would require a (minot) change in Engine-Vdsm API.

### WAN Support

Spice includes a number of features to improve performance on network connections with reduced bandwidth or increased latency. Some of these features are automatic, for example increasing the image compression others have to be explicitly enabled. The spice client supports two options that should may be configured to improve user experience in WAN environments.

*   *Color depth which can be set to 16 or 32bits*
*   *Disable effects – which can be set to all, font-smooth, wallpaper or animation*

In the user portal the console options dialog should be extended to include a check box for *“Enable WAN options”*. These options should only be enabled for Windows virtual machines. Two site-wide configuration options should be added to allow the administrator to define the WAN settings within the ovirt/rhev configuration tool. The suggested names are:

*   *WAN-DisableEffects* - default to animation. Options: font-smooth, wallpaper, animation or all
*   *WAN-ColorDepth* – default to 16. Options: 16 | 32

If selected by the user then the two WAN options should be passed to the XPI / ActiveX components.

## Design

### USB Support

#### Engine

1.  Currently, there is a USB Policy Enum with two values:
    -   Enabled
    -   Disabled

2.  We will change this Enum to contain the following values:
    -   EnabledLegacy
    -   Disabled
    -   EnabledNative

3.  Validations: no legacy support on Linux VMs, no native support in 3.0 clusters.
4.  Config entries: NumberOfUSBSlots - specify the number of USB slots to be exposed to the virtual machine.
5.  The Enum will support backward compatibility easily, as the numbering will be 0 for Enabled-Legacy (as today), 1 for Disabled (as today) and 2 for Enabled-Native (new option). So, OVF import/export will work as today.
6.  No DB changes are needed in order to support this kind of change.

#### GUI

Here are the GUI mock-ups for the New/Edit VM/Template/VM-Pool dialogs:

![](/images/wiki/Neweditvmdialogusb.png) ![](/images/wiki/Neweditvmdialogusbnative.png)

#### REST API

*   Today, the API contains USB definitions as follows (both in VMs and Templates):

        <xs:complexType name="Usb">
          <xs:sequence>
            <xs:element name="enabled" type="xs:boolean" minOccurs="0" maxOccurs="1"/>
          </xs:sequence>
        </xs:complexType>
       

*   In order to support two kinds of USB support, we add a new string element named "type", which should contain either "Legacy" or "Native":

        <xs:complexType name="Usb">
          <xs:sequence>
            <xs:element name="enabled" type="xs:boolean" minOccurs="0" maxOccurs="1"/>
            <xs:element name="type" type="xs:string" minOccurs="0" maxOccurs="1"/>
          </xs:sequence>
        </xs:complexType>
       

*   Some notes on the new element:
    -   It is a temporary one, as in the future only the native option will be supported.
    -   It is relevant only in case the "enabled" element is "true"
    -   It is relevant only in VMs/Templates of cluster level 3.1 and above. For cluster level 3.0, if USB is enabled, "Legacy" will be used automatically.
    -   API-Engine mapping: If "enabled" is "true" then "Legacy" will be mapped to EnabledLegacy, and "Native" will be mapped to EnabledNative. If "enabled" is "false" then it will be mapped to Disabled (regardless of the value in the "type" element).

## Comments and Discussion

Issues/Questions:

1.  USB support - today it is only on desktops. Should it be supported on servers as well?
    -   Answer - Yes

2.  USB filtering - how will the filter be configured? Today it is done via some windows application.
    -   Same application as we are using for 3.0. Filter params are passed in the same was as 3.0/2.2

3.  Today we have all the API needed to pass the number of monitors. Are there any other flags needed for that feature (like amount of memory per-monitor)? If so, we will need to extend the API to support that.
    -   Answer - No
    -   Today this logic is done in the VDSM level. It would be best if we could leave the logic there, changing it accordingly.

4.  Installation/Packaging - will we package and install virt-viewer, or will it be installed separately by the user?
    -   Answer - Remote viewer is the replacement for SPICEC it will be packaged as an RPM for Linux user and pulled in via dependencies by spice-xpi

Future Work:

1.  Support server-side USB filtering.
2.  Persisting the protocol options per VM.

