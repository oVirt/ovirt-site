---
title: How to install the guest agent in Fedora
category: howto
authors: nkesick, vfeenstr
---

# How to install the guest agent in Fedora

Installing the Guest Agent in a Fedora virtual machine is fairly simple and will provide the oVirt-engine with additional information about the VM. The process has two main steps, the first of which is installing the ovirt-guest-agent package, and the second is starting the ovirt-guest-agent service.

## Methods for Installation

There are three methods you can use.

1.  The easiest is to use yum via a terminal prompt or through the Software application. This requires that the virtual machine has access to the internet or at least to a repository mirror.
2.  Using an RPM. This is more complicated, but can be done in an isolated environment where the virtual machine does not have access to the internet.

### Using YUM via Software to install the oVirt Guest Tools

1.  Open the Software application. In Gnome for example, you can find this under Activities > Show Applications > Software
2.  In the Software application, use the search function to search for **ovirt-guest-agent**
3.  From the results, click the box beside **ovirt-guest-agent-common**
4.  Click Apply Changes. The system will when verify that any required dependencies are installed, and then install the guest agent.

### Using YUM via terminal to install the oVirt Guest Tools

From a terminal session, type the following

    sudo yum install ovirt-guest-agent-common

Accept the prompt to install **ovirt-guest-agent-common** and any required dependencies.

## Starting the service

From a terminal, enter the following commands to start the oVirt Guest Agent service

    sudo systemctl enable ovirt-guest-agent.service && sudo systemctl start ovirt-guest-agent.service

The above command will enable the service to always start at boot, and start the service now so you do not need to reboot the VM.

## Troubleshooting

The web admin interface may take some time to start displaying the memory usage and other types of information. If you find that after some time this information has not been populated, restart the VM by performing a shut down or power off, power on, and verify that the service is started by running.

    sudo systemctl status ovirt-guest-agent.service

A reboot of the virtual machine did not seem to resolve the issue.
