---
title: OVirt - connecting development vdsm to ovirt engine
category: vdsm
authors: aglitke, amuller, dougsland, lhornyak, nsoffer, rmiddle, ybronhei
wiki_title: OVirt - connecting development vdsm to ovirt engine
wiki_revision_count: 28
wiki_last_updated: 2014-06-25
---

# OVirt - connecting development vdsm to ovirt engine

By default ovirt engine will try to install vdsm and configure host SSL keys when adding a host. This is a good default for production, but unproductive when connecting vdsm development build to oVirt.

## Disable installVds option in ovirt engine

Run this command:

      psql engine -U engine -c "UPDATE vdc_options set option_value = 'false' where option_name = 'InstallVds'"

And restart oVirt service if running:

      service ovirt-engine restart

## Disabling SSL

When installVds option is disabled, you also want to disable SSL on both ovirt engine and host sides, since host SSL keys are not configured. Alternativly, you can configure SSL keys manually.

### Disable SSL in VDSM

*   In /etc/vdsm/vdsm.conf [vars] section: ssl = false
*   In /etc/libvirt/libvirtd.conf: listen_tls=0
*   In /etc/libvirt/libvirtd.conf: listen_tcp = 1
*   In /etc/libvirt/libvirtd.conf: auth_tcp = "none"
*   In /etc/libvirt/qemu.conf: spice_tls=0

If you are changing from ssl to non-ssl or vice versa, run the following command:

Fedora:

      /lib/systemd/systemd-vdsmd reconfigure

EL6:

      service vdsmd reconfigure

After this is done, restart vdsm. If you misconfigured something, vdsm will complain, so keep an eye on the error messages :)

### Disable SSL in ovirt engine

Disable SSLEnabled and UseSecureConnectionWithServers options:

      psql engine -U postgres -c "UPDATE vdc_options set option_value = 'false' where option_name = 'SSLEnabled'"
      psql engine -U postgres -c "UPDATE vdc_options set option_value = 'false' where option_name = 'UseSecureConnectionWithServers'"

And restart oVirt service if running:

      service ovirt-engine restart
