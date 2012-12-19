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

For Handling the above we have the process of sysprep. For guests with Windows OS you can use the current sysprep mechanism we have in oVirt. For Linux guests we don't have such process in place yet so you better seal the template manually.

## The process for sealing a Linux guest template

1.  SSH to the VM as root
2.  flag the system for reconfiguring
3.  touch /.unconfigured
4.  Remove ssh host keys:
5.  rm -i /etc/ssh/ssh_host_\*
6.  Set HOSTNAME=localhost.localdomain in /etc/sysconfig/network
7.  Remove UDEV rules:
8.  rm -i /etc/udev/rules.d/70-persistent\*
9.  Remove the HWADDR= line from /etc/sysconfig/network-scripts/ifcfg-\*
10. [optionally] Delete the logs from /var/log
11. [Optionally] Delete the build logs from /root.
12. Shut down the virtual machine.

## Future work

We intend to have a virt-prep process that handles both Linux and Windows guests.

This will save us the need for manual sealing of Linux template.
