---
title: isolatedprivatevlan
authors: dyasny
---

# isolatedprivatevlan

The isolatedprivatevlan vdsm hook limits VM traffic to a specific gateway by its mac address.
The hook prevents the VM from spoofing its mac or ip address by using `<filterref filter='clean-traffic'/>` libvirt filter and by adding a custom filter:

`isolatedprivatevlan-vdsm.xml`

The hook is updating each interface entry in VM domain:

```xml
<interface ...>
   <filterref filter='isolatedprivatevlan-vdsm'>
       <parameter name='GATEWAY_MAC' value='aa:bb:cc:dd:ee:ff'/>
   </filterref>
   <filterref filter='clean-traffic'>
       <parameter name='IP' value='10.35.16.50'/>
   </filterref>
</interface>
```

syntax:

```bash
isolatedprivatevlan=<GatewayMAC>,<GuestIP>
```

Example:

```bash
isolatedprivatevlan=aa:bb:cc:dd:ee:ff,10.35.16.50
```

Note: if no IP is supplied, the clean-traffic filter will not be added

