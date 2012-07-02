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
*   Changing the NTP server after engine installation in not supported - and will require manuall steps to sync it to all the hosts in the setup.

### What needs to be done

##### ovirt-setup

*   Need to extract NTP server details from user during the installation
*   The NTP config should be optional
*   Need to update the ntp server in vdc_option table
*   Need to configure the ovirt-server ntp to sync with the NTP server

##### DataBase

*   need to add the NTP server configuration to the vdc_options table

##### Engine:boostrap code

*   The bootstrap code needs to utilize this new param (if exists) during bootstrapping/upgrading a host
*   vds_installer should support this optional param
*   the boostrap should also work on ovirt-node

##### Engine:registration

*   The registration/approval code needs to support this optional param.
*   The above should override a previous NTP configuration (done probably through TUI) .
*   The registration code should utilize the appropriate ovirt functions.

##### vdsm-bootstrap

*   Need to add functionality to configure NTP on a host
*   This functionality is optional

#### Optional Additional tasks

*   VDSM to report the configured NTP servers
*   Engine to alert on:

      * missmatch in hypervisor's NTP configuration.
      * time diff from ovirt-engine service is greater than X (x = config param ???)

*   Add a new ovirt-setup-lugin packae to enable configuring the ovirt-engine server to NTP server.

### Questions

*   Should we support more than 1 NTP server ? Answer: NTP requires 2 server to work at all and recommends at least 3 NTP servers.
*   Should we expose this config through the ovirt-config utility ?

<Category:Feature>
