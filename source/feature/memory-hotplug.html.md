---
title: Memory Hotplug
authors: ofrenkel, vitordelima
wiki_title: Features/Memory Hotplug
wiki_revision_count: 6
wiki_last_updated: 2015-05-13
---

# Memory Hotplug

#### Summary

This feature will add the possibility of hot plugging virtual memory modules into a running VM from the GWT frontend and the REST API.

#### Owner

*   Name: [ Vitor de Lima](User:Vitordelima)
*   Email: vdelima@redhat.com

#### Current status

In planning.

#### Detailed Description

Dynamically resizing the amount of memory dedicated to a guest is an important feature, it allows server upgrades without restarting the VM.

#### Benefit to oVirt

Allows the admin of an oVirt based datacenter to dynamically resize the amount of RAM of each guest.

#### Detailed Design

Hotplugging memory requires the user to choose in which NUMA cell of the guest to plug the new memory into, and other details.

#### Documentation

Discussion about the libvirt API for memory hotplug: <https://www.redhat.com/archives/libvir-list/2014-July/msg01265.html>
