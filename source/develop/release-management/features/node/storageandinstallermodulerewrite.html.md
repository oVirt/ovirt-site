---
title: StorageAndInstallerModuleRewrite
category: feature
authors: fabiand
---

# Storage and Installer Module Rewrite

## Summary

The rewritte of the storage and installer module is the last step in rewriting Node's whole python code-base to address limitations and enable unit tests.

## Owner

*   Name: Fabian Deutsch (fabiand)

<!-- -->

*   Email: fabiand AT redhat DOT com
*   IRC: fabiand

## Current status

*   Status: **Planning**
*   Last updated: ,

## Detailed Description

One generic reason for the rewrite is, that it is not possible to add unit-tests and apply static checks to the existing python code-base. The rewrite of the two modules will address this point. Furthermore it will be investigated if existing code can be used e.g. for the storage module - e.g. to leverage anaconda's blivet - to enumerate and setup storage devices. The installer can then be rewritten to use the new storage and (already rewritten) network classes - mainly to simplify the code.

## Benefit to oVirt

The overall benefit is to make Node more robust and future proof.

## Dependencies / Related Features

*   Affected Packages
    -   ovirt-node

## Testing

TBD

## Documentation / External references

*   <https://bugzilla.redhat.com/show_bug.cgi?id=1008934>

## Comments and Discussion

Comments and discussion can be posted on mailinglist or the referenced bug.

