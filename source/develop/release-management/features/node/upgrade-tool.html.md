---
title: Node upgrade tool
category: node
authors: jboggs
---

# Node upgrade tool

## oVirt Node Upgrade Tool

### Summary

This feature converts allow online upgrade of the node using a newer codebase supplied from an updated oVirt Node image

### Owner

*   Name: Joey Boggs (jboggs)

<!-- -->

*   Email: jboggs AT redhat DOT com
*   IRC: jboggs

### Current status

*   Link to feature page in a specific release. That release may complete the feature, or parts of it. The complete scope of this feature in this release will be described in the release feature page
*   Last updated: ,

### Detailed Description

The upgrade tool is used to update a running node to a newer version by using the supplied iso image's codebase. This works around multiple upgrade situations where you would need to use installation media for bug fixes applied to the upgrade and installation areas.

### Benefit to oVirt

This allows upgrades directly from the Engine that apply the same as a media based upgrade. This also fixes chicken/egg scenarios that need patches to upgrade correctly.(examples: EFI/grub)

### Dependencies / Related Features

Coordination with vdsm/engine to switchover to using this new method

*   Affected Packages
    -   ovirt-node

### Documentation / External references

*   Coming Soon




