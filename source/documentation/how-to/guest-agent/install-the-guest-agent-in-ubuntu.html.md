---
title: How to install the guest agent in Ubuntu
category: howto
authors: nkesick
---

# How to install the guest agent in Ubuntu

## Introduction

Installing the Guest Agent in a Ubuntu virtual machine is fairly simple and will provide the oVirt-engine with additional information about the VM. The process has two main steps which is adding an install source and installing the ovirt-guest-agent package. Presently the ovirt-guest-agent package for Ubuntu is not in the official repos, but is available through evilissimo who currently maintains the package.

## Using apt-get via terminal to install the oVirt Guest Tools

### For Ubuntu 12.04

1. From a terminal session, type the following

<!-- -->

    # sudo nano -w /etc/apt/sources.list.d/ovirt-guest-agent.list

2. Paste in the following source.

<!-- -->

    deb http://download.opensuse.org/repositories/home:/evilissimo:/ubuntu:/12.04/xUbuntu_12.04/ /

3. Press CTRL + O (enter) to save and CTRL + X to exit

4. Then, continuing in the terminal session, type the following:

<!-- -->

    # wget http://download.opensuse.org/repositories/home:/evilissimo:/ubuntu:/12.04/xUbuntu_12.04/Release.key
    # sudo apt-key add - < Release.key  
    # sudo apt-get update
    # sudo apt-get install ovirt-guest-agent

The above will install ovirt-guest-agent. Accept the prompt to install **ovirt-guest-agent** and any required dependencies.

### For Ubuntu 13.10

1. From a terminal session, type the following

<!-- -->

    # sudo nano -w /etc/apt/sources.list.d/ovirt-guest-agent.list

2. Paste in the following source.

<!-- -->

    deb http://download.opensuse.org/repositories/home:/evilissimo:/ubuntu:/13.10/xUbuntu_13.10/ /

3. Press CTRL + O (enter) to save and CTRL + X to exit

4. Then, continuing in the terminal session, type the following:

<!-- -->

    # wget http://download.opensuse.org/repositories/home:/evilissimo:/ubuntu:/13.10/xUbuntu_13.10/Release.key
    # sudo apt-key add - < Release.key  
    # sudo apt-get update
    # sudo apt-get install ovirt-guest-agent

The above will install ovirt-guest-agent. Accept the prompt to install **ovirt-guest-agent** and any required dependencies.

### For Ubuntu 14.04

1. From a terminal session, type the following

<!-- -->

    # sudo nano -w /etc/apt/sources.list.d/ovirt-guest-agent.list

2. Paste in the following source.

<!-- -->

    deb http://download.opensuse.org/repositories/home:/evilissimo:/ubuntu:/14.04/xUbuntu_14.04/ /

3. Press CTRL + O (enter) to save and CTRL + X to exit

4. Then, continuing in the terminal session, type the following:

<!-- -->

    # wget http://download.opensuse.org/repositories/home:/evilissimo:/ubuntu:/14.04/xUbuntu_14.04//Release.key
    # sudo apt-key add - < Release.key  
    # sudo apt-get update
    # sudo apt-get install ovirt-guest-agent

The above will install ovirt-guest-agent. Accept the prompt to install **ovirt-guest-agent** and any required dependencies.

### For Ubuntu 16.04

1. From a terminal session, type the following

<!-- -->

    # sudo nano -w /etc/apt/sources.list.d/ovirt-guest-agent.list

2. Paste in the following source.

<!-- -->

    deb http://download.opensuse.org/repositories/home:/evilissimo:/ubuntu:/16.04/xUbuntu_16.04/ /

3. Press CTRL + O (enter) to save and CTRL + X to exit

4. Then, continuing in the terminal session, type the following:

<!-- -->

    # wget http://download.opensuse.org/repositories/home:/evilissimo:/ubuntu:/16.04/xUbuntu_16.04//Release.key
    # sudo apt-key add - < Release.key  
    # sudo apt-get update
    # sudo apt-get install ovirt-guest-agent

The above will install ovirt-guest-agent. Accept the prompt to install **ovirt-guest-agent** and any required dependencies.

## Starting the service

The install will automatically start ovirt-guest-agent and set it to automatically start on boot.

## Troubleshooting

The web admin interface may take some time to start displaying the memory usage and other types of information. If you find that after some time this information has not been populated, restart the VM by performing a shut down or power off, power on, and verify that the service is started by running. A reboot of the virtual machine did not seem to resolve the issue.
