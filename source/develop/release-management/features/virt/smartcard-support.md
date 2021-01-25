---
title: Smartcard support
category: feature
authors: acathrow, tjelinek
---

# Smartcard Support

## Summary

*   Support pass through of Smartcard attached to client to a virtual machine
*   Allow the VM owner or administrator to specify if a virtual machine should support smartcard
*   Allow the VM user (on portal) to be able to disable this setting.
*   Support configuring this option via web admin, Power user portal, REST API and CLI

## Owner

*   Name: Tomas Jelinek (TJelinek)
*   Email: <tjelinek@redhat.com>
*   PM Requirements : Andrew Cathrow (ACathrow)
*   Email: <acathrow@redhat.com>

## Current status

Pending review: finished

## Requirements

Should be supported on ActiveX and Linux/XPI client

*   on client
    -   spice-xpi-2.7-20 or higher
    -   console type spice
    -   does not work with spice-activex-win browser plugin
*   on guest
    -   coolkey-1.1.0-20.el6 or higher
    -   esc-1.1.0-24.el6_2.2 or higher

## Detailed Description

### Webadmin/Power User Portal

Affected dialogs:

*   new/edit VM dialog
*   new/edit Pool dialog
*   edit template dialog contains in console
*   console options in (Power) User Portal
*   VM details part in User Portal

Changes:

*   on new/edit dialogs in console side tab a new checkbox with label "Smartcard enabled" has been added.
*   on console options dialog a new checkbox "Disable smartcard" has been added
*   a visual indication that the smartcard will be enabled has been added

Behavior:

*   The "Smartcard enabled" checkbox is enabled only for the Spice client, it is visible but disabled for VNC.
*   if the checkbox is checked and the user starts a VM, engine sends the *smartcardEnable* as true to the VDSM (please refer to the VDSM part of this document for it's meaning)
*   if the checkbox is checked (e.g. smartcard is enabled) and the user clicks the console button (e.g. connects to guest), the application sets the *Smartcard* property on the spice-xpi plugin to true which has the same effect than calling the *spicec --smartcard*
    -   Should also be supported for ActiveX
*   In "Console options" dialog within the user portal the end user has the option to override this setting and _not_ pass the enable smart card option to the spice client
    -   If the smartcard option is enabled for the virtual machine then a "Disable smartcard" option is presented in the console options
    -   If the smartcard option is not enabled for the virtual machine then "Disable smartcard" checkbox does NOT appear in the console options
    -   Note the user is only able to disable this option.
*   The user portal provides a visual indication that the smart card will be enabled (in the User Portal the Vm details part contains "Spice with Smartcard" instead of Spice in the Console line)

### REST API

*   the *display* now contains a new optional property *smartcard_enabled*.
*   if not set, the default value is false
*   example of creating a VM with smartcard enabled:

      <vm>
          <name>vm2</name>
          <description>Virtual Machine 2</description>
          <type>desktop</type>
          <memory>536870912</memory>
          <cluster>
              <name>Default</name>
          </cluster>
          <template>
              <name>Blank</name>
          </template>
          <os>
            <boot dev="hd"/>
          </os>
          <display>
              <smartcard_enabled>true</smartcard_enabled>
          </display>
      </vm>
       

### VDSM

*   When VDSM receives a device named *smartcard* it adds to the libvirt configuration to the *devices* part the following:

      <smartcard mode="passthrough" type="spicevmc"/>
       

## Documentation / External references

