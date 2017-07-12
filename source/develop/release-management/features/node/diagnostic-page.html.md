---
title: Node Diagnostic Page
category: node
authors: rbarry
---

# oVirt Node Diagnostic Page

## Summary

This feature adds a diagnostic page for the TUI where users can view basic information without dropping to a shell. In addition, it adds scrollbars to widgets with long lists.

## Owner

*   Name: Ryan Barry (rbarry)

<!-- -->

*   Email: rbarry AT redhat DOT com
*   IRC: rbarry

## Current status

*   Development complete
*   Link to feature page in a specific release. That release may complete the feature, or parts of it. The complete scope of this feature in this release will be described in the release feature page
*   Last updated: ,

## Detailed Description

A diagnostic TUI page where output from commands (currently: fdisk -l, parted -l, multipath -ll) can be viewed without going to the shell. Addition of scrollbars to TableWidgets in the TUI, and creation of a new ScrollBox TUI class.

## Benefit to oVirt

Reduction in need to leave the TUI to diagnose problems. The ScrollBox and scrollbar abrogate the need to suspend the UI to display long output from commands, and give the user an indication of length.

## Dependencies / Related Features

*   [Node Plugins](/develop/release-management/features/node/plugins/)
*   Affected Packages
    -   ovirt-node

## Documentation / External references

*   Coming Soon




