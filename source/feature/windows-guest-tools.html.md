---
title: oVirt Windows Guest Tools
category: feature
authors: lveyde, mpavlik, sandrobonazzola
wiki_category: Feature|oVirt Windows Guest Tools
wiki_title: Features/oVirt Windows Guest Tools
wiki_revision_count: 21
wiki_last_updated: 2015-01-20
feature_name: oVirt Windows Guest Tools ISO
feature_modules: engine
feature_status: Alpha
wiki_warnings: list-item?
---

# oVirt Windows Guest Tools ISO

### Summary

This feature will add an ISO image with required drivers and agents for Windows based VMs.

### Owner

*   Name: [ lveyde](User:lveyde)
*   Email: <lveyde@gmail.com>

### Current status

*   Link to feature page in a specific release. That release may complete the feature, or parts of it. The complete scope of this feature in this release will be described in the release feature page
*   Last updated on -- by [ WIKI}}](User:{{urlencode:{{REVISIONUSER}})

### Detailed Description

At first stage the ISO will include a collection of tools usable for Windows VMs that run under KVM (oVirt). The second stage will be to package these within the installers, to make the tools installation as easy as possible.

:\*IMPORTANT! Second alpha release of oVirt 3.5 WGT is available: <http://resources.ovirt.org/pub/ovirt-master-snapshot-static/iso/ovirt-guest-tools/ovirt-guest-tools-3.5-2.iso> It currently includes the installer for most VirtIO-Win drivers (Serial, Balloon, Net and Block), Spice QXL and Agent as well as oVirt Guest Agent, as well as the binaries that went into the installer. VirtIO-SCSI currently needs to be installed manually (from the drivers directory) - hope to fix that in the next release.

The installer itself maybe downloaded from: <http://resources.ovirt.org/pub/ovirt-master-snapshot-static/exe/ovirt-guest-tools/ovirt-guest-tools-3.5-2.exe>

The installer is based on the Spice installer's source code, and was slightly modifed for this project's needs.

Note!: Currently you can't directly upgrade between the versions without either first stopping the services or performing an uninstall. (Another TODO point).

This release fixes the issue with oVirt Guest Agent service being installed in the manual and not the auto start mode. ( <https://bugzilla.redhat.com/show_bug.cgi?id=1105624> )

The current (proposed) list of the software to be included in the ISO:

:\*VirtIO-Win drivers:

        * VirtIO-Serial

        * VirtIO-Balloon

        * VirtIO-Net

        * VirtIO-Block

        * VirtIO-SCSI From: <http://secondary.fedoraproject.org/pub/alt/virtio-win/latest/>

    * Spice drivers and agent From: <http://www.spice-space.org/download/binaries/spice-guest-tools/>

Important Note: It seems that Spice installer (current is spice-guest-tools-0.74.exe [1](http://www.spice-space.org/download/binaries/spice-guest-tools/spice-guest-tools-0.74.exe)) installs not just Spice related components (QXL and Agent), but all VirtIO-Win drivers as well.

Spice Agents for 32 and 64 bit Windows: <http://www.spice-space.org/download/windows/vdagent/vdagent-win-0.7.2/>

Spice QXL for 32 and 64 bit Windows: <http://www.spice-space.org/download/windows/qxl/qxl-0.1-21/>

    * Qemu Guest Agent

Need to check if this can be taken from Fedora or we'll need to compile it ourselves.

    * oVirt Guest Agent Current plan is to cross-compile it using Wine. Sources are available from the Git repo at: <http://gerrit.ovirt.org/ovirt-guest-agent> Initial cross-compilation seems to be successful, but requires further testing on various versions of Windows.

### Benefit to oVirt

The ISO image will become a central repository for all the software that Windows based VMs require in order to function in most optimal way under oVirt / KVM.

### Dependencies / Related Features

### Documentation / External references

### Testing

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:oVirt Windows Guest Tools ISO](Talk:oVirt Windows Guest Tools ISO)

<Category:Feature> <Category:Template>
