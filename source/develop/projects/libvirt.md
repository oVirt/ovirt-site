---
title: Libvirt
category: project
authors: dougsland
---

# Libvirt

## What's the difference between libvirtd.log and libvirt.log ?

      /var/log/libvirtd.log contains the logs about libvirt daemon
      /var/log/vdsm/libvirt.log contains the communication logs from vdsm and libvirt (created because the XMLs exchange between vdsm and libvirt were making the traditional log unreadable)

