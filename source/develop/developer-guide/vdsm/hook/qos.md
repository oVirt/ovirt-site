---
title: qos
authors: dyasny
---

# qos

The QoS Hook sets up QoS on a VM's network interface.

libvirt domain xml:

<interface>
          ...
`    `<bandwidth>
`        `<inbound average='1' peak='2' burst='5'/>
`        `<outbound average='0.5'/>
`    `</bandwidth>
          ...
</interface>

Note: for average, peak, and burst explanation look at:

      # man tc tbf

Note: The 'average' attribute is mandatory, inbound or outbound elements can be used but not mandatory

syntax:

      qos=00:11:22:33:44:55=in{'average':'1','peek':'2','burst':'5'}^out{'average':'1'}&11:11:11:11:11:11=...

Example:

      qos=mac=in{...}^out{...}&mac..

Will add QoS to VM interface, can control the in and out traffic by average traffic, peek traffic and burst limit

