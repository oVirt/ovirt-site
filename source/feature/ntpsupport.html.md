---
title: NtpSupport
category: feature
authors: acathrow, bazulay, ekohl, rmiddle
wiki_category: Feature
wiki_title: Features/NtpSupport
wiki_revision_count: 17
wiki_last_updated: 2012-07-12
---

# Ntp Support

## Adding NTP Support

### Feature necessity

KVM is very sensitive to time issues especially when migrating a VM between 2 hosts with a big time gap. In a large deployment we need to make sure that the time is synched on all the hosts in the setup.

### Feture Description

The intent is to use the organization's NTP server to sync time on all the hosts in ovirt setup.

### Assumptions

*   Organizations will prefer using their own NTP server rather than install a new one for ovirt.
*   The NTP server should be configured only once (during ovirt installation), and populated to all hosts through bootstrap and registration.
*   Changing the NTP server after installation in not supported - and will require manuall steps to sync it to all the hosts in the setup.

### The feature building blocks

##### ovirt-setup

*   Need to extract NTP server details from user during the installation
*   The NTP config should be optional
*   Need to update the ntp server in vdc_option table
*   Need to configure the ovirt-server ntp to sync with the NTP server

##### DataBase

*   Need to add the NTP server configuration to the vdc_options table

##### Engine

*   Need to utilize this new NTP config (if given) option during bootstrap
*   Need to utilize this new NTP config (if given) option during registration/approval
*   Need to add support for the optional NTP server in vds_installer.py

##### vdsm:bootstrapping

##### vdsm:registration

### Optional additions to the feature

*   vdsm - to report it's NTP configuration
*   engine - handle the vdsm NTP configuration reported by VDSM (save in DB + throw event log if misconfigured)
*   UI - display the reported NTP configureation

### Questions

*   Should we support more than 1 NTP server ?
*   Should we expose this config through the ovirt-config utility ?

<Category:Feature>
