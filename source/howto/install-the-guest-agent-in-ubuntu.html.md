---
title: How to install the guest agent in Ubuntu
category: howto
authors: nkesick
wiki_title: How to install the guest agent in Ubuntu
wiki_revision_count: 10
wiki_last_updated: 2015-01-19
---

# How to install the guest agent in Ubuntu

Installing the Guest Agent in a Ubuntu virtual machine is fairly simple and will provide the oVirt-engine with additional information about the VM. The process has two main steps which is adding an install source and installing the ovirt-guest-agent package. Presently the ovirt-guest-agent package for Ubuntu is not in the official repos, but is available through zhshzhou who currently maintains the package.

## Methods for Installation

There are three methods you can use.

1.  The easiest is to use apt-get via a terminal prompt or through the Ubuntu Software Center application. This requires that the virtual machine has access to the internet or at least to a repository mirror.
2.  Using an .deb package. This is more complicated, but can be done in an isolated environment where the virtual machine does not have access to the internet.

### Using Ubuntu Software Center to install the oVirt Guest Tools

At present the oVirt guest agent is not available in the Ubuntu repositories add requires adding another installation source.

## Adding the Installation Source

![Ubuntu Software Center](Ubuntu_guest_agent_install.jpg "Ubuntu Software Center")

1.  Visit <https://launchpad.net/~zhshzhou/+archive/vdsm-ubuntu/+packages>
    1.  For Debian open Ovirt-Guest-Agent for the source Raring, per [the mailing list](https://www.mail-archive.com/users@ovirt.org/msg10171.html)
    2.  For Ubuntu Precise, Raring, and Sausy open Ovirt-Guest-Agent for the source Precise
        1.  Below Package files, click ovirt-guest-agent-\*.deb
        2.  Save the file or open it with /usr/bin/software-center (default)
        3.  When Ubuntu Software Center opens, click install

### Using apt-get via terminal to install the oVirt Guest Tools

For Ubuntu Precise, Raring, and Sausy

1.  From a terminal session, type the following

<!-- -->

    wget https://launchpad.net/~zhshzhou/+archive/vdsm-ubuntu/+files/ovirt-guest-agent_1.0.8.201309301944.gitb7f8f2-1ppa1_all.deb

The above will download the ovirt-guest-agent package from Zhshzhou's repository.

    sudo dpkg -i ovirt-guest-agent_1.0.8.201309301944.gitb7f8f2-1ppa1_all.deb

The above will extract the downloaded package. It will warn about missing dependencies. As long as you have an internet connection this will not matter.

    sudo apt-get -f install

The above will install ovirt-guest-agent. Accept the prompt to install **ovirt-guest-agent** and any required dependencies.

## Starting the service

Ubuntu automatically starts the ovirt-guest-agent service.

## Troubleshooting

The web admin interface may take some time to start displaying the memory usage and other types of information. If you find that after some time this information has not been populated, restart the VM by performing a shut down or power off, power on, and verify that the service is started by running. A reboot of the virtual machine did not seem to resolve the issue.
