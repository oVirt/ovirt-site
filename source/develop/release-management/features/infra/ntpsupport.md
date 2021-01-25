---
title: NtpSupport
category: feature
authors: acathrow, bazulay, ekohl, rmiddle
---

# Ntp Support

## Adding NTP Support

### Feature necessity

KVM is very sensitive to time issues especially when migrating a VM between 2 hosts with a big time gap. In a large deployment we need to make sure that the time is synched on all the hosts in the setup.

### Feture Description

The intent is to use the organization's NTP server to sync time on all the hosts in ovirt setup. The Info should be obtained from the user during the installation, and pupulated/configured on all the hosts in an ovirt system through bootstrap & registration.

### Assumptions

*   Organizations will prefer using their own NTP server rather than install a new one for ovirt.
*   The NTP server should be configured only once (during ovirt installation), and populated to all hosts through bootstrap and registration.
*   Changing the NTP server after engine installation is not supported - and will require manuall steps to sync it to all the hosts in the setup.
*   The NTP server is accesible from all the hosts
*   This is not retro active - this will only apply to new hosts that are added to the system

### What needs to be done

##### ovirt-setup

*   Need to extract NTP server details from user during the installation
*   If NTP client is setup on ovirt-server then default to this value
*   The NTP config should be optional
*   Need to update the ntp server in vdc_option table
*   Need to configure the ovirt-server ntp to sync with the NTP server

##### DataBase

*   need to add the NTP server configuration to the vdc_options table

##### Engine:boostrap:registration code

*   Need to utilize this new NTP config option (if given) during bootstrap
*   Need to utilize this new NTP config option (if given) during registration/approval
*   Need to add support for the optional NTP server in vds_installer.py

##### vdsm-bootstrap

*   vdsm-bootstrap - should support configuring NTP on any host bootstrapped
*   bootstrapping code now has to support ovirt-node as well

##### vdsm-registration

*   The registration code should support the optional NTP configuration
*   need to utilize ovirt functions

#### Optional Additional tasks

*   VDSM to report the configured NTP servers
*   Engine to alert on:

      * mismatch in hypervisor's NTP configuration.
      * time diff from ovirt-engine service is greater than X (x = config param ???)

*   UI - display the reported NTP configureation
*   Add a new ovirt-setup-lugin package to enable configuring the ovirt-engine server to NTP server.
*   At regular interval (config setting) check time difference between ovirt-engine and nodes and raise alert (add notification)

### Questions

*   Should we support more than 1 NTP server ? Answer: NTP requires 2 server to work at all and recommends at least 3 NTP servers.
*   Should we expose this config through the ovirt-config utility ? Yes
*   should we skip the NTP config if the NTP server is not accessible on bootstrap : No

