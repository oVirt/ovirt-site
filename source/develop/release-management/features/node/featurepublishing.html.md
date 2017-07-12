---
title: FeaturePublishing
category: feature
authors: fabiand
---

# Feature Publishing

## Summary

Feature publishing shall help thrid parties (e.g. plugins or management systems) to discover the features of a Node. The framework specifies a way to register features. The publishing is separate and can happen e.g. via http, mdns or by ssh-ing into a Node.

## Owner

*   Name: Fabian Deutsch (fabiand)

<!-- -->

*   Email: fabiand AT redhat DOT com
*   IRC: fabiand

## Current status

*   Status: **In progress**
*   Last updated: ,

## Detailed Description

Currently there is no defined way to determin what features (or packages) a node supports (or includes). By adding a feature registry we address this point. This shall give thrd parties (like plugins) the ability to register themselves and their features. Another party can then query this feature registry to find out about the features supported by a specific Node.

## Benefit to oVirt

This is a solution to differentiate Nodes (wrt their functionality) as Nodes with different features popup (e.g. VDSM or OpenStack support).

## Dependencies / Related Features

*   Affected Packages
    -   ovirt-node

## Testing

TBD

## Documentation / External references

*   <https://bugzilla.redhat.com/show_bug.cgi?id=999325>

## Comments and Discussion

Comments and discussion can be posted on mailinglist or the referenced bug.

