---
title: GuestAgentUbuntu
category: feature
authors: vfeenstr
feature_name: oVirt Guest Agent on Ubuntu
feature_modules: ovirt-guest-agent
feature_status: Done
---

# Guest Agent Ubuntu

## oVirt Guest Agent on Ubuntu 12.04+

### Summary

Packaging the ovirt-guest-agent for Ubuntu 12.04+

### Owner

*   Name: Vinzenz 'evilissimo' Feenstra (Vfeenstr)

<!-- -->

*   Email: <evilissimo@redhat.com>

### Current status

*   Last updated: ,

### Detailed Description

This feature should provide ovirt-guest-agent packages for Ubuntu

#### Required changes

*   Ubuntu packaging scripts [DONE]
*   SYS-V init script for Ubuntu [DONE]
*   Upstart script for Ubuntu [DONE]
*   Adjustments to packaging [DONE]
*   Checkbashism checks on scripts [DONE]
*   Path adjustments for the Ubuntu environment [DONE]
*   Update package list to report for debian/ubuntu naming conventions [DONE]
*   Create wrapper scripts for elevated tasks [DONE]

### Benefit to oVirt

It'll be easier to install the ovirt-guest-agent on Ubuntu guests.

### Repository

#### 12.04

*   URL: <http://download.opensuse.org/repositories/home:/evilissimo:/ubuntu:/12.04/xUbuntu_12.04/>

#### 14.04

*   URL: <http://download.opensuse.org/repositories/home:/evilissimo:/ubuntu:/14.04/xUbuntu_14.04/>

#### 16.04

*   URL: <http://download.opensuse.org/repositories/home:/evilissimo:/ubuntu:/16.04/xUbuntu_16.04/>


### Documentation / External references

#### The guest agent reports the following things

*   Current active user
*   Memory usage (including swap usage)
*   Network Interfaces
*   IP Addresses
*   FQDN of the guest OS
*   Disks Usage
*   Configured RPMs to report (see /etc/ovirt-guest-agent.conf for the packages)
*   Hostname

#### The guest agent also provides the following actions

*   Desktop Locking for GNOME
*   Shutdown/Reboot from within the Guest OS

#### Installation

$REPOURL is any of the URLs listed in the [Repository](#repository) section

      # echo 'deb  $REPOURL /' >> /etc/apt/sources.list.d/ovirt-guest-agent.list
      # wget $REPOURL/Release.key
      # apt-key add - < Release.key  
      # apt-get update
      # apt-get install ovirt-guest-agent
      # service ovirt-guest-agent start

### Testing

Testing has to be executed on a Ubuntu 12.04+ system. Lower versions do not fulfil the minimal requirements for the guest agent.

#### Verification

*   Follow the installation instructions above to install the guest agent
*   After about 15-30 seconds the Web Admin Portal entry for the VM should show:
    -   the IPv4 Addresses of the VM in the grid
    -   the FQDN of the VM in the grid
    -   kernel package and the ovirt-guest-agent-common package in the application list
    -   The FQDN in the general tab
    -   Logged-in User: in the Sessions tab should be filled if a user is logged in.
    -   All IPs (IPv4 and IPv6) in the Network Interfaces tab in the Guest Agent Data section for each interface.
*   Verification via on the VDSM side: \`vdsClient -s 0 getVmStats <VM UUID>\`
    -   Reported fields are non-empty:
        -   guestFQDN
        -   netIfaces
        -   disksUsage
        -   memoryStats
        -   guestName
        -   appsList
        -   guestOs
        -   username
        -   guestIPs (if there are IPv4 addresses)

**Note:** The VM UUID can be found on the Admin Portal in the General tab for the VM **Note:** The FQDN value is only only shown if the FQDN is not empty, not localhost and not localhost.localdomain



