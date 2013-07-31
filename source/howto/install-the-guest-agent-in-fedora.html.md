---
title: How to install the guest agent in Fedora
category: howto
authors: nkesick, vfeenstr
wiki_title: How to install the guest agent in Fedora
wiki_revision_count: 5
wiki_last_updated: 2014-07-11
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

    sudo yum install ovirt-guest-agent

Accept the prompt to install **ovirt-guest-agent-common** and any required dependencies.

### Using an RPM to install the oVirt Guest Tools

1.  Using a computer or virtual machine that is connected to the internet, navigate to <http://resources.ovirt.org/releases/>
2.  Click the folder of the version of oVirt that you are using, such as 3.2
3.  Click the RPM folder
4.  Click Fedora
5.  Click the number that represents the version of Fedora that you are using, for example, Fedora 18
6.  Click on noarch
7.  Your path may look something like this:
        http://resources.ovirt.org/releases/3.2/rpm/Fedora/18/noarch/

8.  From the list of files, right click the one that starts with **ovirt-guest-agent-common** and save it to a location on your computer.
9.  Copy the **ovirt-guest-agent-common** rpm file to the VM that requires the ovirt-guest-agent
10. Install it by using the command below, and accept the prompt to install the package.
        yum localinstall /path/to/ovirt-guest-agent-common.rpm

## Starting the service

From a terminal, enter the following commands to start the oVirt Guest Agent service

    sudo systemctl enable ovirt-guest-agent.service && sudo systemctl start ovirt-guest-agent.service

The above command will enable the service to always start at boot, and start the service now so you do not need to reboot the VM.

## Troubleshooting

The web admin interface may take some time to start displaying the memory usage and other types of information. If you find that after some time this information has not been populated, restart the VM by performing a shut down or power off, power on, and verify that the service is started by running.

    sudo systemctl status ovirt-guest-agent.service

A reboot of the virtual machine did not seem to resolve the issue.
