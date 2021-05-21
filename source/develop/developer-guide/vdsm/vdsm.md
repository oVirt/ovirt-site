---
title: Vdsm
category: vdsm
authors:
  - abonas
  - danken
  - ekohl
  - quaid
---

# Vdsm

*Vdsm* is a daemon which is required by a Virtualization Manager such as oVirt-engine or Red Hat Enterprise Virtualization Manager to manage Linux hosts and their KVM virtual machine guests. Vdsm manages and monitors the host's storage, memory and networks as well as virtual machine creation, other host administration tasks, statistics gathering, and log collection.

__TOC__

## Name

      V.D.S.M. ?? That's not even pronounceable!

Vdsm stands for Virtual Desktop and Server Manager.

## Important Vdsm pages

*   Most Vdsm users have it driven by oVirt-engine. [Vdsm Getting Started](/develop/developer-guide/vdsm/getting-started.html) helps those who want to use Vdsm on its own, or by another management tool.
*   [Vdsm Developers](/develop/developer-guide/vdsm/developers.html) is where you can learn how to improve Vdsm.

## More project information

Our git repository sits on [oVirt's Gerrit server](http://gerrit.ovirt.org/gitweb?p=vdsm.git). Development takes place on our mailing lists: [vdsm-patches](https://fedorahosted.org/mailman/listinfo/vdsm-patches) for submitting new patches, and [vdsm-devel](https://fedorahosted.org/mailman/listinfo/vdsm-devel) for general discussions on where Vdsm development should go. On the latter one, users and potential users should feel comfortable to seek help, ask questions, and get answers about Vdsm.

## IRC

There is [#vdsm on freenode](irc://irc.freenode.org/vdsm), including [logs](http://ekohl.nl/vdsm).

## Requirements

Currently, Vdsm requires at least Red Hat Enterprise Linux 6.2 or Fedora 16 to run properly.

## Caveats

*   Vdsm does several non-standard stuff such as configuring your `/etc/multipathd`, starting other services, or making it a bit harder to access `libvirt` directly.
*   Vdsm API is not yet rock solid and is expected to adjust in the near future.

