---
title: smbios
authors: dyasny
---

# smbios

The smbios vdsm hook allows for adding/changing entries to smbios domain entry.

This can be especially useful when the VM runs software that relies on specific information in DMI

syntax:

      smbios: smbios={'serial': '1234'}^{'vendor': 'redhat'}

add/edit 2 attributes to smbios: serial and vendor

Download link: <http://ovirt.org/releases/nightly/rpm/EL/6/hooks/vdsm-hook-smbios-4.10.0-0.442.git6822c4b.el6.noarch.rpm>
