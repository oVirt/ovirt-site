---
title: SPICERelatedFeatures
category: feature
authors: acathrow, danken, ecohen, ovedo
wiki_category: Feature
wiki_title: Features/SPICERelatedFeatures
wiki_revision_count: 43
wiki_last_updated: 2012-06-04
---

# SPICE related features

### Summary

This pages describes the changes needed on oVirt to support new SPICE features in 3.1.

### Background

Currently oVirt use the spicec client for remote Spice connections and RHEV adds the proprietary Incentives Pro USB redirector solution to add support for remote USB. Since Fedora 16, the QEMU and Spice projects have added native support for USB remoting and are moving to a new client, virt-viewer, based on spice-gtk that includes more features and is based on a more portable code-base that will extend from Linux and Windows to more platforms in the future such as Mac OS. The virt-viewer client also includes support for the new native USB support in Spice.

### Owner

This should link to your home wiki page so we know who you are

*   Name: [ Oved Ourfali](User:Ovedo)
*   Email: <ovedo@redhat.com>

### Current status

*   In design phase
*   Last updated date: March 26th, 2012.

### High Level Features

In the upcoming version, SPICE is about to perform the following changes/additions:

1.  New Spice Client
2.  Native USB Support
3.  Multimonitor Support (basic)
4.  WAN Support

### Detailed Description

#### New Spice Client

The Linux and Windows *spicec* based client will be replaced by the *remote-viewer* which is based on spice-gtk. The ActiveX and spice-xpi packages will be updated to include the new client which is backwards compatible with spicec - allowing remote-viewer to be used for RHEV 3 based deployments as well as RHEV 3.1.

#### USB Support

For cluster level 3.1 (based on RHEL 6.3 support) native KVM/Spice USB redirection can be used in addition to the legacy Incentives Pro.

The current Incentives Pro solution needs to be supported for both 3.0 and 3.1 cluster levels. *Note :*The native USB support in Spice and KVM currently does not support live migration.

*   **For 3.0 Cluster level**
    -   Update New/Edit VM dialog to change USB text to “Legacy USB Support”
    -   Legacy USB Support field should be disabled for all Linux virtual machines
    -   Legacy USB support should allow selection only on Windows VMs but default to Off

<!-- -->

*   **For 3.1 Cluster level**
    -   Add checkbox for Enable USB support
        -   Checkbox should be unselected by default
    -   When checkbox is selected two radio buttons should be presented
        -   Legacy USB Support
        -   SPICE USB Support
    -   For Linux virtual machines Legacy USB Support should not be enabled

For both cluster 3.0 and 3.1 level USB should only be enabled if Spice is selected as remote protocol.

Documentation and online help should indicate that “Legacy USB support “is deprecated and will not be supported in future releases of RHEV. When a user selects SPICE USB support we should present a warning that migration is NOT supported using SPICE USB redirection. Note: We need to disable live migration when using SPICE migration it will fail regardless of whether a device is being redirected. Targeting RHEL 6.4 to address this <https://bugzilla.redhat.com/show_bug.cgi?id=805172>

A new user editable configuration value should be added to vdc_options to specify the number of USB slots to be exposed to the virtual machine. The default should be 4

**Note:** It is suggested that we make this a system wide value, since we should be able to dynamically change this in a later implementation.

The following libvirt XML example shows adding 4 USB devices to a domain xml. The slot number would need to be adjusted based on the next available pci slot in the system. The maximum number is 6 unless we configure multiple controllers. If a usb tablet device is configured then it will take one device, however this should not be required to be configured in a spice environment with the vdagent present.

         <controller type='usb' index='0' model='ich9-ehci1'>
          <address type='pci' domain='0x0000' bus='0x00' slot='0x08' function='0x7'/>
        </controller>

        <controller type='usb' index='0' model='ich9-uhci1'>
          <master startport='0'/>
          <address type='pci' domain='0x0000' bus='0x00' slot='0x08' function='0x0' multifunction='on'/>
        </controller>

        <controller type='usb' index='0' model='ich9-uhci2'>
          <master startport='2'/>
          <address type='pci' domain='0x0000' bus='0x00' slot='0x08' function='0x1'/>
        </controller>

        <controller type='usb' index='0' model='ich9-uhci3'>
          <master startport='4'/>
          <address type='pci' domain='0x0000' bus='0x00' slot='0x08' function='0x2'/>
        </controller>

        <redirdev bus='usb' type='spicevmc'>  
          <address type='usb' bus='0' port='3'/>
        </redirdev>

        <redirdev bus='usb' type='spicevmc'>
          <address type='usb' bus='0' port='4'/>
        </redirdev>

        <redirdev bus='usb' type='spicevmc'>
          <address type='usb' bus='0' port='5'/>
        </redirdev>

        <redirdev bus='usb' type='spicevmc'>
          <address type='usb' bus='0' port='6'/>
        </redirdev>

*   Each of the `redirdev` devices should be added to the `devices` list passed by Engine to Vdsm. Vdsm should be taught to recognise them.

The native qemu/Spice USB support presents an emulated echi and uchi controller to the guest. Virtual machines do not require any in-guest agents or drivers for native USB.

For native qemu/spice USB support all client to guest communication happens through the existing Spice channel so no other ports need to be opened on the guest or host.

The new Spice-XPI and Spice-ActiveX packages will wrap both the new remote-viewer client that provides support for native USB and the legacy Incentives Pro USB client. If legacy USB solution is to be used then the existing parameters can be passed as usual eg. URL & filter string. For native USB the client will read the existing filter string parameter. There is no need to explicitly enable the native USB support in the ActiveX/XPI. If legacy support parameters are not passed then the remote-viewer client will try to connect to a Spice USB channel, if no USB channel is found then USB support will be disabled automatically.

#### Multi Monitor support for Linux guests (Basic)

Currently validations in the user interface prevent configuring multiple monitors for Linux guests. The backend logic permits multiple monitors. The front end logic needs to be updated to allow configuration of multiple monitors for Linux guests. This setting can be enabled for 3.0 and 3.1 cluster levels.

**Note :** Multiple monitors in Linux requires specific in-guest configuration using Xinerama and has a number of limitations (eg. X server needs to be restarted). These limitations need to be documented and included in the product documentation.

We are currently targeting RHEL 6.4 to support multihead QXL devices that would allow xrandr support in the guest for a more complete multihead solution. Multihead QXL device would require a (minot) change in Engine-Vdsm API.

#### WAN Support

Spice includes a number of features to improve performance on network connections with reduced bandwidth or increased latency. Some of these features are automatic, for example increasing the image compression others have to be explicitly enabled. The spice client supports two options that should may be configured to improve user experience in WAN environments.

*   *Color depth which can be set to 16 or 32bits*
*   *Disable effects – which can be set to all, font-smooth, wallpaper or animation*

In the user portal the console options dialog should be extended to include a check box for *“Enable WAN options”*. These options should only be enabled for Windows virtual machines. Two site-wide configuration options should be added to allow the administrator to define the WAN settings within the ovirt/rhev configuration tool. The suggested names are:

*   *WAN-DisableEffects* - default to animation. Options: font-smooth, wallpaper, animation or all
*   *WAN-ColorDepth* – default to 16. Options: 16 | 32

If selected by the user then the two WAN options should be passed to the XPI / ActiveX components.

### Design

#### USB Support

##### Engine

1.  Currently, there is a USB Policy Enum with two values:
    -   Enabled
    -   Disabled

2.  We will change this Enum to contain the following values:
    -   EnabledLegacy
    -   Disabled
    -   EnabledNative

The order in this Enum will allow to support backward compatibility easily, as the numbering will be 0 for Enabled-Legacy (as today), 1 for Disabled (as today) and 2 for Enabled-Native (new field). No DB changes are needed in order to support this kind of change.

##### GUI / REST API

GUI + REST API:

*   -   In case USB is enabled, we will select, by default, Legacy support for cluster level 3.0 and Native support for cluster level 3.1.

GUI:

*   For VMs in cluster level 3.0, enable and disable will be the only options. If enabled, it will be mapped to EnabledLegacy; if disabled it will be mapped to Disabled.
*   For VMs in cluster level 3.1, there will be a checkbox for enabling or disabling USB support. If enabling, two options will appear (radio buttons):
    1.  Legacy Support
    2.  Native Support
*   XPI Native support will be a new flag in SPICE-XPI
*   Native USB support isn't supported in live migration yet, so when choosing this option there will be a warning in the UI specifying that USB devices will be lost upon migration.

### Comments and Discussion

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

<Category:Feature> <Category:Template>
