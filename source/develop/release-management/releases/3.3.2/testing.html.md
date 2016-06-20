---
title: oVirt 3.3.2 testing
authors: dougsland, gianluca, obasan, phurrelmann, sandrobonazzola, sven
wiki_title: Testing/Ovirt 3.3.2 testing
wiki_revision_count: 12
wiki_last_updated: 2013-12-18
wiki_conversion_fallback: true
wiki_warnings: conversion-fallback
---

# Ovirt 3.3.2 testing

## What to do as a participant

*   Look at [OVirt_3.3_TestDay](OVirt_3.3_TestDay) for understanding what should be tested
*   Update the Participants section.
*   Running into any issues - report it on IRC, user mailing list or bugzilla.

## Participants

Test Days are open to anyone.

If you have your own setup we will provide all the software packages and the required information.

If you're willing to participate please add yourself to the below table:

| Name | part tested | Storage | Networking | Distribution | Bugs |
|---|---|---|---|---|---|
| Douglas Landgraf | Deploy Fedora 20 as Node | Yes | Yes | Fedora 20 (beta) | - |
| Douglas Landgraf | Add iSCSI storage | Yes | Yes | Fedora 20 (beta) | [BZ 1037602](http://bugzilla.redhat.com/1037602) |
| Douglas Landgraf | Add NFS storage (data and ISO) | Yes | Yes | Fedora 20 (beta) | - |
| Douglas Landgraf | create/start/stop/suspend virtual machine | Yes | Yes | Fedora 20 (beta) | - |
| Douglas Landgraf | Use SPICE as protocol for virtual machine | - | Yes | CentOS 6 | - |
| Douglas Landgraf | Live migration | Yes | Yes | Fedora 20 (beta) | - |
| Douglas Landgraf | ovirt-log-collector | - | - | Fedora 20 (beta) | [BZ 1037663](http://bugzilla.redhat.com/1037663) |
| Ohad Basan | engine-setup , clean install, dwh and reports installation | ? | ? | ? | |
| [SandroBonazzola](/User:SandroBonazzola) | engine-setup , clean install, AIO | NFS | basic | Fedora 19 | |
| [SandroBonazzola](/User:SandroBonazzola) | upgrade from 3.3.1-2 | NFS | basic | Fedora 19 | |
| Gianluca Cecchi | Upgrade from 3.3. 1 | Gluster | ? | Fedora 19 | |
| [Sven](/User:Sven) | Upgrade from 3.3.1-2 | local storage | V-LAN / QoS | CentOS 6.4 | |
| [Patrick](/User:Phurrelmann) | Upgrade from 3.3.1-2 | iSCSI | VLANs | CentOS 6.5 | |
