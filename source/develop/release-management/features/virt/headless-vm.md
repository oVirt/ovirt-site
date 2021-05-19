---
title: Headless VM
category: feature
authors: SharonG
---

# Headless VM

### Summary

Support Headless VMs in oVirt by adding an option to run a VM without any graphical console, for cases in which a graphical console is not needed for accessing this VM. This Headless VM will run without graphical and Video devices.

### Owner

*   Name: Sharon Gratch (sgratch)
*   Email: <sgratch@redhat.com>

### Benefit to oVirt

Before this feature was implemented, oVirt Engine always added at least one graphical console to a running VM. Although this is right for most use cases, some VMs are required to run without graphical consoles from the start or after the initial setup. The reason for that can be due to host limitations or according to VM usage requirements (e.g. Real-Time VM).

This feature adds a flexible, very simple to manage and reversible option to start a Headless VM at any time via Engine and still keep an option to access the VM for setup or administrative purposes if needed.

### Usage

*   Setting a VM as Headless can be done to new or existed VM at any time and it is a reversible option, meaning that a Headless VM can be switched to non-Headless and vice versa.

*   Setting the VM as Headless can be done via the UI by checking/un-checking a new "Headless Mode" checkbox field added to the Console tab of the VM dialog (in advanced mode). In case of a running VM, this configuration change will require a VM restart. 

*   A Headless VM Template or Pool or Instance Type can also be created the same way as a VM, so in case the user wants to create or edit a VM to become Headless, he can also choose a Template, Pool or Instance type which are configured as Headless and "inherit" this property for that specific VM.

*   Invoking a graphic console via the Engine is disabled for a Headless VM and so are all options in the "Console Options" dialog.

*   In case of a new created VM, the user has two options to access this VM via oVirt for managing:

  1. Enable the oVirt Serial Console for this VM.

  2. Manage the VM via a required graphic console only on its first run by using the "Run Once" dialog, which enables 
     to run a Headless VM as non-Headless only for the first run. 
     A checkbox is added to the "Run Once" dialog and let the user choose how he wants to run this VM for the first 
     time only and with which Graphic Protocol (SPICE or VNC).  

*   In case of editing an already running VM to become Headless, the user should verify the following before restarting this VM and applying the Headless mode:

  1. How to access the VM, if needed. Options can be to enable the oVirt Serial Console, or install SSH or any 
     other service for command line access.

  2. What is the IP of this VM, if needed, since if the Guest-Agent is not installed then the oVirt Engine won't 
     know The VM IP.
     
*   This feature works on all cluster levels.     

Note that all of the scenarios described above can be done via oVirt WebAdmin or UserPortal and in the future also via the REST API and oVirt SDK.

### Detailed Description

#### WebAdmin/UserPortal UI

*   The Console side-tab of the VM dialog (in advanced mode) was re-arranged and divided to "Graphical Console" and "Serial Console" properties and a "Headless Mode" checkbox was added under the "Graphical Console" section. In case the "Headless Mode" is checked, all other Graphical Console properties are disabled/grayed out. The SPICE USB controller is disabled only if the "Serial Console" is disabled for the VM. The "Serial Console" is handled as before and is not depended on the VM Headless mode.

*   In case of a Headless VM, the "Graphics Column" and the "General" sub-tab display the "Graphics protocol" and "Video Type" values as "None". 

*   Invoking a graphic console and using the "Console Options" dialog are disabled.

*   Under the "VM devices" sub-tab no video or graphic devices are displayed in case of a Headless VM.

*   All those changes are also relevant for VM Template, VM Pool and Instance Type dialogs and the Headless Mode configuration is supported for all actions relevant for those entities including create a VM from a Template and create a Template from a VM.

*   An option of "Headless mode" was added to the Console section of the "Run Once" dialog and the user can choose the console configuration for the first run of a VM (headless or not): as non-Headless with VNC graphic protocol, as Non-Headless with SPICE graphic protocol or as Headless.

#### Backend

No new property was added to the VM object and marking a VM as Headless is done by using existing properties. 
In case of Headless VM / Template / Pool / Instance Type:

1. The VM (VMStatic object) set the defaultDisplayType property to "none" value.

2. The VM (VMDynamic object) set the graphicsInfos property (spice_port, spice_ip, vnc_port, vnc_ip, spice_tls_port etc) to null values.

3. All Video and graphic devices are removed for that VM.

#### DB

No changes in the DB

#### REST API

There is currently partial support for Headless VMs in oVirt API.
The only option supported is editing an existing VM or Template or Instance-Type and change it via oVirt API to Headless/non-Headless.
This is done by using REST API with the "vms/\<vm-id\>/graphicsconsoles" extension.
##### Usage:
1. In case an existing VM or Template or Instance-Type is non-Headless and you want to change it to Headless, 
    you need to remove all graphics console devices for this entity by calling the following API:
    
    DELETE  ..api/instancetypes/\<instancetype-id>\/graphicsconsoles/\<console-id>

    or

    DELETE  ..api/templates/\<template-id\>/graphicsconsoles/\<console-id\>

    or

    DELETE  ..api/vms/\<vm-id\>/graphicsconsoles/\<console-id\>

    while \<console-id\> is the ID of the graphics console you wish to remove (Spice or VNC).
  
    When the last graphics console is removed - the VM becomes Headless

2. In case an existing VM or Template or Instance-Type is Headless and you wish to change it to non-Headless, 
    you need to add a graphics cosnole device for this entity by calling the following APIs:
    
    POST  ..api/instancetypes/\<instancetype-id\>/graphicsconsoles
    
    \<graphics_console\>
    \<protocol\>type\</protocol\>
    \</graphics_console\>
    
    or
    
    POST  ..api/templates/\<template-id\>/graphicsconsoles
    
    \<graphics_console\>
    \<protocol\>type\</protocol\>
    \</graphics_console\>
    
    or
    
    POST  ..api/vms/\<vm-id\>/graphicsconsoles
    
    \<graphics_console\>
    \<protocol\>type\</protocol\>
    \</graphics_console\>
    
    while "type" can be "spice" or "vnc".
    
 3. For creating a new Headless VM, you need to create a VM via the API (please see REST API documentation - https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.1-beta/html/rest_api_guide/). The VM will be created as non-Headless by default. Then use action 1 described above to change the VM from non-Headless to Headless
    
    

### Status

*   Target Release: Ovirt 4.1
*   Status: All is merged (Backward compatibility is fully supported).
*   REST API full support Target Release: Ovirt 4.2 (please see https://bugzilla.redhat.com/show_bug.cgi?id=1406394)

### Limitations

*   The ability to access the Headless VM and obtaining the VM IP are not automatically supported -
In case a VM is currently running in Ovirt in a Headless mode, without a serial console enabled and without Guest-Agent installed, the user won't be able to obtain an access or login to that VM and also won't be able to check for the VM IP via the Ovirt Engine. 
There is no warning for such cases in which no guest-agent is running or no serial console enabled and no ssh key installed and it's the user responsibility to manage it in advance (either by enabling the serial console or by manage the VM on it's first run via the "run Once" dialog which enables to run a Headless VM as non-Headless only for the first run).
*   Prior to  running a VM with a Headless mode, the Grub configuration for this VM should be set to console mode since otherwise the Grub will cause the guest OS boot process to hang.

    Setting the Grub configuration into console mode is done by commenting out the spashimage flag in the Grub menu configuration file, e.g:

    \#splashimage=(hd0,0)/grub/splash.xpm.gz serial --unit=0 --speed=9600 --parity=no --stop=1 terminal --timeout=2 serial
*    There is currently partial support for Headless VMs in oVirt API. Therefore whenever using REST API to edit or create graphics console properties by setting the \<display\> attribute properties and not by using the  "vms\/<vm-id\>/graphicsconsoles" extension, the Headless mode of the VM/Template/Instance-Type may be wrongly set. Therefore it is recommended to always set the required Headless or non-Headless state only via the "vms/\<vm-id\>/graphicsconsoles" extension. This limitation is planned to be fixed for oVirt 4.2.

### Dependencies / Related Features
