---
title: Project moVirt
authors: mbetak, tjelinek
wiki_title: Project moVirt
wiki_revision_count: 12
wiki_last_updated: 2015-02-05
---

# Project moVirt

## moVirt - Android Client for oVirt

### Summary

moVirt is a mobile (Android) client for the oVirt engine. It uses the oVirt REST API to communicate with the oVirt engine, lets the user see/start/stop VMs, connect to VMs using VNC as well as monitor the health of the VMs using the built-in trigger mechanism.

### Owner

*   Name: [Martin Betak](User:mbetak)
*   Email: <mbetak@redhat.com>
*   Name: [Tomas Jelinek](User:TJelinek)
*   Email: <tjelinek@redhat.com>
*   Name : Sphoorti Joglekar
*   Email: <sphoorti.joglekar@gmail.com>

### Status

*   All basic flows implemented including triggers and bVNC integration
*   Fixing some small bugs

### External Sources

*   Project Page including demo videos, developer documentation and the source codes: <https://github.com/matobet/moVirt>
*   Issue Tracker: <https://github.com/matobet/moVirt/issues>
*   Video Showing moVirt: <https://www.youtube.com/watch?v=QnD9v70oefA>
*   Mailing List: movirt@ovirt.org (join in: <http://lists.ovirt.org/mailman/listinfo/movirt>)

### Dependencies

*   oVirt 3.4+
*   Android 4.0.4+
*   bVNC(VNC client used from moVirt): <https://play.google.com/store/apps/details?id=com.iiordanov.freebVNC&hl=en>

### Details

![](MovirtMain.png "fig:MovirtMain.png") [200px ](File:MovirtDetails.png) [200px ](File:EditTrigger.png)

moVirt consists of the following sections

*   main screen: shows all the VMs and the events for them
*   VM details: shows the details of the VM and the events filtered to it. Contains Start/Stop/Reboot/Connect to VNC actions
*   Triggers: it is possible to set up triggers for CPU usage, memory usage and VM status (for example "vibrate when VM is DOWN"). This triggers can be configured per specific VM, per all VMs in one cluster or all VMs. If a trigger passes (e.g. the VM turns into down state) the mobile phone vibrates and a new notification is fired
*   Settings page: wide range of options for fine-tuning which VMs to poll, how often, which events to load, how much to keep in local cache etc.

Works with admin privileges (e.g. Filter: false REST header) as well as with user role (Filter: True).
