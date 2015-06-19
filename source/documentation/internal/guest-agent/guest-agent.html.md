---
title: Ovirt guest agent
category: ovirt-guest-agent
authors: adahms, bazulay, bproffitt, geoffoc, rmiddle, vfeenstr
wiki_category: Ovirt guest agent
wiki_title: Category:Ovirt guest agent
wiki_revision_count: 10
wiki_last_updated: 2014-07-21
---

# Ovirt guest agent

*Ovirt-guest-agent* is a daemon that resides within guest virtual machines and is required to supply information to the Virtualization Manager (such as oVirt-engine or Red Hat Enterprise Virtualization Manager) that is required to properly manage the virtual machines. The guest agent communicates to VDSM through a vioserial device using a json protocol. It is written in python and supports a growing list of guest operating systems.

__TOC__

## Important Ovirt-guest-agent wiki pages

## More project information

Our git repository will be published soon probably on Fedora Hosted.
Since the entire communication to the virtualization management system is through Vdsm, we'll use the Vdsm's mailing lists for all communications: [vdsm-patches](https://fedorahosted.org/mailman/listinfo/vdsm-patches) for submitting new patches, and [vdsm-devel](https://fedorahosted.org/mailman/listinfo/vdsm-devel) for general discussions on where Ovirt-guest-agent development should go. On the latter one, users and potential developers should feel comfortable to seek help, ask questions, and get answers about Ovirt-guest-agent.

## Requirements

Currently, Ovirt-guest-agent can run on:

*   Red Hat Enterprise Linux 5.x
*   Red Hat Enterprise Linux 6.x
*   CentOS 6.x
*   Fedora 16-20
*   Ubuntu 12.04+
*   openSUSE 12.x+
*   Windows XP (32)
*   Windows 7 (32/64)
*   Windows 8.x (32/64)
*   Windows 2003 (32/64/R2)
*   Windows 2008 (32/64/R2)
*   Windows 2012 (32/64/R2)

For Linux systems - it requires python and a vioserial device
For windows systems - it requires python and pywin32 packages installed

## Caveats

*   It is harder to set up on Windows systems (a wiki will be published soon)

[Category:Ovirt guest agent](Category:Ovirt guest agent)
