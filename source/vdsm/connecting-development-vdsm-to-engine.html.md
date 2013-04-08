---
title: OVirt - connecting development vdsm to ovirt engine
category: vdsm
authors: aglitke, amuller, dougsland, lhornyak, nsoffer, rmiddle, ybronhei
wiki_title: OVirt - connecting development vdsm to ovirt engine
wiki_revision_count: 28
wiki_last_updated: 2014-06-25
---

# OVirt - connecting development vdsm to ovirt engine

By default OVirt communicates with VDSM with ssl. This is a safe default, but difficult to handle at development and debugging.

## Disable SSL in VDSM

*   in /etc/vdsm/vdsm.conf [vars] section: ssl = false
*   in /etc/libvirt/libvirtd.conf: listen_tls=0
*   in /etc/libvirt/libvirtd.conf: listen_tcp = 1
*   in /etc/libvirt/libvirtd.conf: auth_tcp = "none"
*   and in /etc/libvirt/qemu.conf: spice_tls=0

If you are changing from ssl to non-ssl or vice versa, run the following command:

Fedora:

      /lib/systemd/systemd-vdsmd reconfigure

EL6:

      service vdsmd reconfigure

After this is done, restart vdsm. If you misconfigured something, vdsm will complain, so keep an eye on the error messages :)

## Disable SSL in ovirt engine

This works simply by updating oVirt's database:

      psql engine -U postgres -c "UPDATE vdc_options set option_value = 'false' where option_name = 'SSLEnabled'"
      psql engine -U postgres -c "UPDATE vdc_options set option_value = 'false' where option_name = 'UseSecureConnectionWithServers'"

You may also find this useful:

      psql engine -U postgres -c "UPDATE vdc_options set option_value = 'false' where option_name = 'InstallVds'"

This will stop the ovirt engine trying to install things on the hosts.

When you are done with the table updates, restart ovirt engine.

Ovirt 3.0 F16

       service jboss-as restart

Ovirt 3.1 F17

       service ovirt-engine restart

And then it should work...
