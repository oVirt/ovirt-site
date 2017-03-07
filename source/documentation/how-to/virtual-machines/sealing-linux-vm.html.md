---
title: Sealing Linux VM
authors: danken, herrold, lpeer, sven
wiki_title: Sealing Linux VM
wiki_revision_count: 4
wiki_last_updated: 2014-01-29
---

# Sealing Linux VM

## Motivation

VM template is used in oVirt to later create VMs with identical images and configuration as the template.

Creating identical images and configuration does not mean that we want to keep some information that is guest specific, like the VM MAC addresses.

For Handling the above we have the process of sysprep. For guests with Windows OS you can use the current sysprep mechanism we have in oVirt. For Linux guests you can use the [ansible-role-seal](https://galaxy.ansible.com/rhevm-qe-automation/ansible-role-seal/) ansible role from galaxy that automates the sealing process shown in the steps bellow.

## The process for sealing a Linux guest template

The following is RedHat specific:

1.  SSH to the VM as root
2.  flag the system for reconfiguring
3.  touch /.unconfigured
4.  Remove ssh host keys:
5.  rm -i /etc/ssh/ssh_host_\*
6.  Optionally, for environments where a host cannot determine its own name via DNS based lookups:
7.  echo "HOSTNAME=localhost.localdomain" >> /etc/sysconfig/network
8.  Remove UDEV rules:
9.  rm -i /etc/udev/rules.d/70-persistent\*
10. Remove the HWADDR= line from /etc/sysconfig/network-scripts/ifcfg-\*
11. [optionally] Delete the logs from /var/log
12. [Optionally] Delete the build logs from /root.
13. Shut down the virtual machine.

## Future work

We intend to have a virt-prep process that handles both Linux and Windows guests.
