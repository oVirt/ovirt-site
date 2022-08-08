---
title: GuestAgentDebian
category: feature
authors: vfeenstr
---

# Guest Agent Debian

## oVirt Guest Agent on Debian 7.x

### Summary

Packaging the ovirt-guest-agent for Debian 7.x

### Owner

*   Name: Vinzenz 'evilissimo' Feenstra (Vfeenstr)
*   Email: <evilissimo@redhat.com>

### Current status

*   Last updated: ,

### Detailed Description

This feature should provide ovirt-guest-agent packages for Debian

#### Required changes

*   Debian packaging scripts [DONE]
*   SYS-V init script for Debian [DONE]
*   Adjustments to packaging [DONE]
*   Checkbashism checks on scripts [DONE]
*   Path adjustments for the Debian environment [DONE]
*   Update package list to report for SUSE naming conventions [DONE]
*   Create wrapper scripts for elevated tasks [DONE]

### Benefit to oVirt

It'll be easier to install the ovirt-guest-agent on Debian guests.

### Repository

*   URL: <http://download.opensuse.org/repositories/home:/evilissimo:/deb/Debian_7.0/>

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
# echo "deb http://download.opensuse.org/repositories/home:/evilissimo:/deb/Debian_7.0/ ./" >> /etc/apt/sources.list
# gpg -v -a \
> --keyserver http://download.opensuse.org/repositories/home:/evilissimo:/deb/Debian_7.0/Release.key \
> --recv-keys D5C7F7C373A1A299
# gpg --export --armor 73A1A299 | apt-key add -
# apt-get update
# apt-get install ovirt-guest-agent
# service ovirt-guest-agent start
```

### Testing

Testing has to be executed on a Debian 7 system. Lower version do not fulfil the minimal requirements for the guest agent and testing/unstable are currently not supported by us.

#### Verification

*   Follow the installation instructions above to install the guest agent
*   After about 15-30 seconds the Web Admin Portal entry for the VM should show:
    -   the IPv4 Addresses of the VM in the grid
    -   the FQDN of the VM in the grid
    -   kernel package and the `ovirt-guest-agent-common` package in the application list
    -   The FQDN in the general tab
    -   Logged-in User: in the Sessions tab should be filled if a user is logged in.
    -   All IPs (IPv4 and IPv6) in the Network Interfaces tab in the Guest Agent Data section for each interface.
*   Verification via on the VDSM side:
    ```console
    vdsClient -s 0 getVmStats <VM UUID>
    ```
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

**Note:** The VM UUID can be found on the Admin Portal in the General tab for the VM

**Note:** The FQDN value is only only shown if the FQDN is not empty, not localhost and not localhost.localdomain



