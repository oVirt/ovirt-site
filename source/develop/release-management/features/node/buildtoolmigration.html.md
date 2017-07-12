---
title: BuildtoolMigration
category: feature
authors: jboggs
---

# Buildtool Migration

## oVirt Node Build Tool Migration

### Summary

This feature will move the build process for the iso image from livecd-creator to the newer livemedia-creator

### Owner

*   Name: Joey Boggs (jboggs)

<!-- -->

*   Email: jboggs AT redhat DOT com
*   IRC: jboggs

### Current status

**In Progress**

*'Issues to resolve':*

*   Requires a net install iso for minimal boot and installation run

**Kickstart Changes so far:**

*   clearpart --all
*   / partition needs ondisk=sda added and size increased roughly to size=3200 from 1536 to fit
*   libguestfs\* pulls in linux-firmware and causes install to freeze
*   ovirt-node-selinux causes OOM error on vm with 1GB

**Packages needed to be added**

*   syslinux
*   memtest86+

<!-- -->

*   Last updated: ,

### Detailed Description

This feature will move the build process for the iso image from livecd-creator to the newer livemedia-creator.

### Benefit to oVirt

Updates to a newer build system from the legacy livecd-creator

### Dependencies / Related Features

*   Affected Packages
    -   ovirt-node

### Documentation / External references

*   Coming Soon




