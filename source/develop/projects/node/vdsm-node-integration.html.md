---
title: Vdsm-Node Integration
category: node
authors: danken, dougsland
---

# Vdsm-Node Integration

Vdsm can install on a standard RHEL (or Fedora) host, and manage its virtualization. It can also be deployed with the oVirt-node appliance.

## Step-by-step oVirt-node installation

The installation of Vdsm on an oVirt node is a multi-phase process that involves quite a few files and operations. The files, operations, log files that are created during installation etc are depicted below.

### vdsm-reg

When an oVirt node boots, a daemon named [vdsm-reg](http://git.fedorahosted.org/git/?p=vdsm.git;a=blob_plain;f=vdsm_reg/vdsm-reg-setup;hb=HEAD) is started. The sole responsibility of this daemon is to register the oVirt node against an instance on RHEV-M (the node's controller) and exit. vdsm-reg is periodically polling /etc/vdsm-reg/vdsm-reg.conf and checking to see if the needed parameters to connect to the RHEV-M are already configured. The default initial values for the vdsm-reg.conf can be found [here](http://git.fedorahosted.org/git/?p=vdsm.git;a=blob_plain;f=vdsm_reg/vdsm-reg.conf.in;hb=HEAD). The standard ways to configure vdsm-reg.conf are depicted later in this document.

## Non-interactive ("automatic") oVirt installation

The oVirt node is passed various kernel parameters (during the PXE boot of the node) that allow for the node to configure all its relevant data. j The oVirt-specific kernel parameters are documented in the [ovirt-early](http://git.virt.bos.redhat.com/git/?p=ovirt-node/.git;a=blob_plain;f=scripts/ovirt-early;hb=HEAD) file.

Vdsm has a few kernel arguments that, when configured, will allow for the oVirt node to register with the RHEV-M.

This scenario is believed to be the one to be used in mass deployments of oVirt nodes that will be used as the virtualization infrastructure for a data center.

The Vdsm kernel parameters are:

ovirt_managment_server / managment_server / management_server:

A tuple with the RHEV-M URL and port. URL can be either an IP address or a FQDN.

The port part is optional, and if not specified will default to 8443.

An example:

management_server=vm-17-42.qa.eng.blg.redhat.com:10443

management_server_fingerprint:

This is the RHEVM CA certificate fingerprint, as it is produced by executing on RHEVM/Engine machine:

grep SSLCACertificateFile /etc/httpd/conf.d/ssl.conf

openssl x509 -fingerprint -in /etc/pki/ovirt-engine/apache-ca.pem

An example:

management_server_fingerprint=49:2A:EB:4C:1F:52:A5:59:F6:2B:5C:AE:B4:B5:14:77:4E:D2:0D:6C

rhevm_admin_password:

When installing a RHEV-H from RHEV-M (with the 'Add Host' option), the RHEV-M will configure this password for its internal use.

The password should be hashed, the same way it is done for the rootpw kernel parameter.

An example:

rhevm_admin_password=$1$qaiUkE62$Su8QSyHgh6TIE6ISy

The handling of the Vdsm kernel parameters is in [vdsm-config](http://git.fedorahosted.org/git/?p=vdsm.git;a=blob_plain;f=vdsm_reg/vdsm-config;hb=HEAD)

## Interactive (manual) oVirt-node installation

For interactive installation (using Text User Interface), please refer to the [oVirt installation section](https://fedorahosted.org/ovirt/wiki/Installation) in oVirt's Wiki.

Essentially, the RHEV-M tab in the TUI will prompt the user for the TUI equivalents of the non-interactive kernel parameters (i.e., RHEV-M address, RHEV-M CA certificate fingerprint validation and RHEV-M admin password.

