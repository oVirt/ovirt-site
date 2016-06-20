---
title: oVirt - connecting development vdsm to ovirt engine
category: vdsm
authors: aglitke, amuller, dougsland, lhornyak, nsoffer, rmiddle, ybronhei
wiki_title: OVirt - connecting development vdsm to ovirt engine
wiki_revision_count: 28
wiki_last_updated: 2014-06-25
---

# oVirt - connecting development vdsm to ovirt engine

How to configure a develoment host that should be attached to ovirt-engine.

## Disable automatic host installation

By default ovirt engine will try to install vdsm and configure host networking and SSL keys when adding a host. If you disable this feature, you will have to configure host networking yourself.

If you want to disable this feature, run this command:

      su - postgres -c "psql engine -c "UPDATE vdc_options set option_value = 'false' where option_name = 'InstallVds'""

And restart oVirt service if running:

      service ovirt-engine restart

## Disabling SSL

When automatic host installation is disabled, you also want to disable SSL on both ovirt engine and host sides, since host SSL keys are not configured. Alternativly, you can configure SSL keys manually.

### Disable or Enable SSL in VDSM

*   In /etc/vdsm/vdsm.conf modify [vars] section with: ssl = false (or ssl = true)
*   run "vdsm-tool configure --module libvirt " (note that libvirtd service must be down, for full automation use --force flag)
*   restart vdsmd service

### Disable SSL in ovirt engine

Disable SSLEnabled and UseSecureConnectionWithServers options:

      psql -U engine engine -c "UPDATE vdc_options set option_value = 'false'
                                                     WHERE option_name = 'SSLEnabled';"
      psql -U engine engine -c "UPDATE vdc_options set option_value = 'false' 
                                                     WHERE option_name = 'EncryptHostCommunication';"

And restart oVirt service if running:

      service ovirt-engine restart
