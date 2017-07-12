---
title: PackageRefactoring
category: feature
authors: didi, mburns
---

# Package Refactoring

## oVirt Node Package Refactoring

### Summary

Moving around some dependencies and features so that other images can minimize their size

### Owner

*   Name: Mike Burns (mburns)

<!-- -->

*   Email: mburns AT redhat DOT com
*   IRC: mburns or mburned

### Current status

**Not Started**

*'Issues to resolve':*

*   What needs to be refactored out
*   What sub-packages will there be

<!-- -->

*   Last updated on -- by

### Detailed Description

The idea is to move different functionality aspects from the core ovirt-node package to various sub-packages. This will allow other projects using the ovirt-node model to pick and choose which features they need.

For Example:

*   some use cases do not require virtualization, so we can remove those dependencies into a sub-package.
*   some use cases don't need the UI, they just come up, run a service and communicate over the network, then finish, so UI aspects could be removed
*   some use cases are completely stateless, so installation is not ever needed

### Benefit to oVirt

Greater adoption of oVirt Node outside of oVirt will improve the stability of the Node model.

### Dependencies / Related Features

*   Affected Packages
    -   ovirt-node

### Documentation / External references

*   Coming Soon


