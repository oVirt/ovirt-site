---
title: Node Puppet Plugin
category: node
authors: rbarry
---

# oVirt Node Puppet plugin

## Summary

This feature converts the generic oVirt Node image into an image with support for Puppet provisioning.

## Owner

*   Name: Ryan Barry (rbarry)

<!-- -->

*   Email: rbarry AT redhat DOT com
*   IRC: rbarry

## Current status

*   Development 90% complete
*   Link to feature page in a specific release. That release may complete the feature, or parts of it. The complete scope of this feature in this release will be described in the release feature page
*   Last updated: ,

## Detailed Description

A server-side puppet provider and type which identifies oVirt and allows for management of the features which can be set with the TUI, as well as a client-side TUI page suitable for configuring puppet parameters.

## Benefit to oVirt

Reduction in the number of kernel command line arguments necessary to automatically provision a node. Tighter integration with existing management infrastructure. Ease of management.

## Dependencies / Related Features

*   [Node Plugins](/develop/release-management/features/node/plugins/)
*   Affected Packages
    -   ovirt-node
    -   ovirt-node-iso
    -   New Package: ovirt-node-plugin-puppet (Name TBD)

## Documentation / External references

*   Coming Soon




