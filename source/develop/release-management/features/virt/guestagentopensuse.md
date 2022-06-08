---
title: GuestAgentOpenSUSE
category: feature
authors: vfeenstr
---

# Guest Agent Open SUSE

## oVirt Guest Agent on OpenSUSE

### Summary

Packaging the ovirt-guest-agent for OpenSUSE

### Owner

*   Name: Vinzenz 'evilissimo' Feenstra (Vfeenstr)
*   Email: <evilissimo@redhat.com>

### Current status

*   Last updated: ,

### Detailed Description

This feature should provide ovirt-guest-agent packages for OpenSUSE

#### Required changes

*   policykit based elevation [DONE]
*   spec file according to openSUSE standards [DONE]
*   Path adjustments for the openSUSE environment [DONE]
*   Update package list to report for SUSE naming conventions [DONE]
*   Create wrapper scripts for elevated tasks [DONE]

### Benefit to oVirt

It'll be easier to install the ovirt-guest-agent on OpenSUSE guests.

### Repository

#### openSUSE LEAP 42.3

*   URL: <http://download.opensuse.org/repositories/home:/evilissimo/openSUSE_Leap_42.3/>
*   Repo File: <http://download.opensuse.org/repositories/home:/evilissimo/openSUSE_Leap_42.3/home:evilissimo.repo>

#### openSUSE Factory

*   URL: <http://download.opensuse.org/repositories/home:/evilissimo/openSUSE_Factory>
*   Repo File: <http://download.opensuse.org/repositories/home:/evilissimo/openSUSE_Factory/home:evilissimo.repo>

### Documentation / External references

#### The guest agent reports the following things

*   Current active user
*   Memory usage (including swap usage)
*   Network Interfaces
*   IP Addresses
*   FQDN of the guest OS
*   Disks Usage
*   Configured RPMs to report (see `/etc/ovirt-guest-agent.conf` for the packages)
*   Hostname

#### The guest agent also provides the following actions

*   Desktop Locking for GNOME
*   Shutdown/Reboot from within the Guest OS

#### Installation

```console
# zypper addrepo <URL to repo file from the Repository section>
# zypper refresh
# zypper install ovirt-guest-agent-common
# service ovirt-guest-agent start

OR with systemd:

# systemctl start ovirt-guest-agent.service
```

### Testing

#### Verification

*   Follow the installation instructions above to install the guest agent
*   After about 15-30 seconds the Web Admin Portal entry for the VM should show:
    -   the IPv4 Addresses of the VM in the grid
    -   the FQDN of the VM in the grid
    -   `kernel` package and the `ovirt-guest-agent-common` package in the application list
    -   The FQDN in the general tab
    -   Logged-in User: in the Sessions tab should be filled if a user is logged in.
    -   All IPs (IPv4 and IPv6) in the Network Interfaces tab in the Guest Agent Data section for each interface.
*   Verification via on the VDSM side: `vdsClient -s 0 getVmStats <VM UUID>`
    -   Reported fields are non-empty:
        -   `guestFQDN`
        -   `netIfaces`
        -   `disksUsage`
        -   `memoryStats`
        -   `guestName`
        -   `appsList`
        -   `guestOs`
        -   `username`
        -   `guestIPs` (if there are IPv4 addresses)

**Note:** The VM UUID can be found on the Admin Portal in the General tab for the VM

**Note:** The FQDN value is only only shown if the FQDN is not empty, not localhost and not localhost.localdomain



