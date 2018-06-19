---
title: How to install the guest agent in CentOS
category: howto
authors: nkesick, vfeenstr, hjmallon, samueljon
---

# How to install the guest agent in CentOS

Installing the Guest Agent in a CentOS virtual machine is fairly simple and will provide the oVirt-engine with additional information about the VM.

## Methods for Installation

### Using YUM via terminal to install the oVirt Guest Tools

From a terminal session, type the following (for oVirt 4.2)

    sudo yum install http://resources.ovirt.org/pub/yum-repo/ovirt-release42.rpm
    sudo yum install ovirt-guest-agent-common

## Starting the service

From a terminal, enter the following commands to start the oVirt Guest Agent service

    sudo systemctl enable --now ovirt-guest-agent.service

The above command will enable the service to always start at boot, and start the service now so you do not need to reboot the VM.

## Troubleshooting

The web admin interface may take some time to start displaying the memory usage and other types of information. If you find that after some time this information has not been populated, restart the VM by performing a shut down or power off, power on, and verify that the service is started by running.

    sudo systemctl status ovirt-guest-agent.service

A reboot of the virtual machine did not seem to resolve the issue.
