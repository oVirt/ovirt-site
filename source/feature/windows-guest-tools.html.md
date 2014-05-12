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
feature_status: Planning
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

The current (proposed) list of the software to be included in the ISO:

:\*VirtIO-Win drivers:

        * VirtIO-Serial

        * VirtIO-Balloon

        * VirtIO-Net

        * VirtIO-Block

        * VirtIO-SCSI

From <http://secondary.fedoraproject.org/pub/alt/virtio-win/latest/>

    * Spice drivers and agent

    * Qemu Guest Agent

    * oVirt Guest Agent

### Benefit to oVirt

The ISO image will become a central repository for all the software that Windows based VMs require in order to function in most optimal way under oVirt / KVM.

### Dependencies / Related Features

### Documentation / External references

### Testing

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:oVirt Windows Guest Tools ISO](Talk:oVirt Windows Guest Tools ISO)

<Category:Feature> <Category:Template>
