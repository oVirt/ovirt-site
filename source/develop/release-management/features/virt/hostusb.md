---
title: hostusb
category: feature
authors: dyasny, herrold
---

# hostusb

*Note this hook should not be used ever since 3.6 since the passthrough support for USB was implemented natively as part of [hostdev-passthrough](/develop/release-management/features/virt/hostdev-passthrough.html)*<br>
**Do not use this hook!**

hostusb adds host's usb device/s to VM. This hook is useful for VMs that need to access USB devices attached to the hypervisor host, most commonly HASP plugs

VM XML changes:

```xml
<hostdev mode='subsystem' type='usb'>
  <vendor id='0x1234'/>
  <product id='0xbeef'/>
</hostdev>
```

Syntax:

         hostusb=0x1234:0xbeef&0x2222:0xabaa

This maps to:

         hostusb=VendorId:ProductId&AnotherVendorId:AnotherProductId...

Note: The VM must be pinned to host and this hook will fail any migration attempt.

Host attached USB devices can be viewed with `lsusb`

N.B.: link to binary file is dead 2014 05 13

