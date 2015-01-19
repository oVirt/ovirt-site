---
title: How to install the guest agent in Ubuntu
category: howto
authors: nkesick
wiki_title: How to install the guest agent in Ubuntu
wiki_revision_count: 10
wiki_last_updated: 2015-01-19
wiki_conversion_fallback: true
wiki_warnings: conversion-fallback
---

# How to install the guest agent in Ubuntu

Installing the Guest Agent in a Ubuntu virtual machine is fairly simple and will provide the oVirt-engine with additional information about the VM. The process has two main steps which is adding an install source and installing the ovirt-guest-agent package. Presently the ovirt-guest-agent package for Ubuntu is not in the official repos, but is available through zhshzhou who currently maintains the package.

## Methods for Installation

There are three methods you can use.

1.  The easiest is to use apt-get via a terminal prompt or through the Ubuntu Software Center application. This requires that the virtual machine has access to the internet or at least to a repository mirror.
2.  Using an .deb package. This is more complicated, but can be done in an isolated environment where the virtual machine does not have access to the internet.

### Using Ubuntu Software Center to install the oVirt Guest Tools

At present the oVirt guest agent is not available in the Ubuntu repositories add requires adding another installation source.

### Using apt-get via terminal to install the oVirt Guest Tools

For Ubuntu 12.04

1.  From a terminal session, type the following

<!-- -->

    # sudo nano -w /etc/apt/sources.list.d/ovirt-guest-agent.list

Paste in the following source.

    deb http://download.opensuse.org/repositories/home:/evilissimo:/ubuntu:/12.04/xUbuntu_12.04/

Press CTRL + O to save and CTRL + X to exit Then, continuing in the terminal session, type the following:

    # wget http://download.opensuse.org/repositories/home:/evilissimo:/ubuntu:/12.04/xUbuntu_12.04/Release.key

    sudo apt-key add - 
    sudo apt-get update
    sudo apt-get install ovirt-guest-agent
    sudo service ovirt-guest-agent start
    sudo service ovirt-guest-agent enable

The above will install ovirt-guest-agent, start it, and enable it at boot. Accept the prompt to install **ovirt-guest-agent** and any required dependencies.

For Ubuntu 13.10

1.  From a terminal session, type the following

<!-- -->

    # sudo nano -w /etc/apt/sources.list.d/ovirt-guest-agent.list

Paste in the following source.

    deb http://download.opensuse.org/repositories/home:/evilissimo:/ubuntu:/13.10/xUbuntu_13.10/ /

Press CTRL + O (enter) to save and CTRL + X to exit Then, continuing in the terminal session, type the following:

    # wget http://download.opensuse.org/repositories/home:/evilissimo:/ubuntu:/13.10/xUbuntu_13.10/Release.key

    sudo apt-key add - 
    sudo apt-get update
    sudo apt-get install ovirt-guest-agent
    sudo service ovirt-guest-agent start
    sudo service ovirt-guest-agent enable

The above will install ovirt-guest-agent. Accept the prompt to install **ovirt-guest-agent** and any required dependencies.

For Ubuntu 14.04

1.  From a terminal session, type the following

<!-- -->

    # echo 'deb http://download.opensuse.org/repositories/home:/evilissimo:/ubuntu:/14.04/xUbuntu_14.04/' >> /etc/apt/sources.list.d/ovirt-guest-agent.list

    wget http://download.opensuse.org/repositories/home:/evilissimo:/ubuntu:/14.04/xUbuntu_14.04//Release.key

    apt-key add - 
    apt-get update
    apt-get install ovirt-guest-agent
    service ovirt-guest-agent start

The above will install ovirt-guest-agent. Accept the prompt to install **ovirt-guest-agent** and any required dependencies.

## Starting the service

You can start the Ubuntu ovirt-guest-agent service by using the following command:

    sudo service ovirt-guest-agent start

You can have the service start at boot by using the following command:

sudo service ovirt-guest-agent enable>

## Troubleshooting

The web admin interface may take some time to start displaying the memory usage and other types of information. If you find that after some time this information has not been populated, restart the VM by performing a shut down or power off, power on, and verify that the service is started by running. A reboot of the virtual machine did not seem to resolve the issue.
