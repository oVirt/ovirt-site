---
title: How to install the guest agent in Debian
category: howto
authors: nkesick
---

# How to install the guest agent in Debian

Installing the Guest Agent in a Debian virtual machine is fairly simple and will provide the oVirt-engine with additional information about the VM. The process has two main steps, the first of which is installing the ovirt-guest-agent package, and the second is starting the ovirt-guest-agent service.

    Note: Debian 7 and above is required. Lower versions do not satisfy the minimum requirements.

## Methods for Installation

There are two methods you can use.

1.  The easiest is to use apt-get via a terminal prompt or through the Software application. This requires that the virtual machine has access to the internet or at least to a repository mirror.

### Using apt-get via terminal to install the oVirt Guest Tools

From a terminal session, type the following

     # echo "deb http://download.opensuse.org/repositories/home:/evilissimo:/deb/Debian_7.0/ ./" >> /etc/apt/sources.list
     # gpg -v -a --keyserver http://download.opensuse.org/repositories/home:/evilissimo:/deb/Debian_7.0/Release.key --recv-keys D5C7F7C373A1A299
     # gpg --export --armor 73A1A299 | apt-key add -
     # apt-get update
     # apt-get install ovirt-guest-agent

Accept the prompt to install **ovirt-guest-agent** and any required dependencies.

### Using Add/Remove software in gnome to install the oVirt Guest Tools

From the above directions, perform the first four steps. Then, open Add/Remove Software from Applications > System Tools. In the search, search for "ovirt", and ovirt-guest-agent should appear.

## Starting the service

From a terminal, enter the following commands to start the oVirt Guest Agent service

    #su -
    #service ovirt-guest-agent enable &&  service ovirt-guest-agent start

The above command will enable the service to always start at boot, and start the service now so you do not need to reboot the VM.

## Troubleshooting

The web admin interface may take some time to start displaying the memory usage and other types of information. If you find that after some time this information has not been populated, restart the VM by performing a shut down or power off, power on, and verify that the service is started by running.

    # su -
    # service ovirt-guest-agent start

A reboot of the virtual machine did not seem to resolve the issue.
