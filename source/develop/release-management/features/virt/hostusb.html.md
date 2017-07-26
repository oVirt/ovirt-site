---
title: hostusb
authors: dyasny, herrold
feature_name: Expose Host attached USB to a Node
feature_modules: "[Node(s) of feature]"
feature_status: Released
---

# hostusb

hostusb adds host's usb device/s to VM. This hook is useful for VMs that need to access USB devices attached to the hypervisor host, most commonly HASP plugs

VM XML changes:

<hostdev mode='subsystem' type='usb'>
          

             <vendor id='0x1234'/>
             <product id='0xbeef'/>

</hostdev>

Syntax:

         hostusb=0x1234:0xbeef&0x2222:0xabaa

This maps to:

         hostusb=VendorId:ProductId&AnotherVendorId:AnotherProductId... 

Note: The VM must be pinned to host and this hook will fail any migration attempt.

Host attached USB devices can be viewed with `lsusb`

N.B.: link to binary file is dead 2014 05 13

*   ~~Download link: <http://ovirt.org/releases/nightly/rpm/EL/6/hooks/vdsm-hook-hostusb-4.10.0-0.442.git6822c4b.el6.noarch.rpm>~~
