---
title: Universal Image
category: feature
authors: mburns
---


# Universal oVirt Node Image

## Summary

This feature converts the oVirt Node image into a generic image that can be customized for many different projects
using Node Plugins.

## Owner

*   Name: Mike Burns (mburns)

<!-- -->

*   Email: mburns AT redhat DOT com
*   IRC: mburns

## Current status

*   Feature is complete and merged into oVirt Node 3.0.0 (pending release at End of May)
*   Last Updated: 2013-05-22

## Detailed Description

A number of requests to use oVirt Node in projects other than oVirt have been received.
This feature is the conversion of oVirt Node into a generic image that can be customized for use in other projects using specialized Plugins.
A separate feature for moving the logic for working with oVirt Engine into a plugin is also
filed [here](/develop/release-management/features/vdsm/vdsm-plugin.html)

## Benefit to oVirt

Making oVirt Node more generic and available to other projects widens the user base for the model that oVirt Node uses.
This model will then get additional testing and use outside of the oVirt Project and thus be more stable in the long term.

## Dependencies / Related Features

*   [Node VDSM Plugin](/develop/release-management/features/vdsm/vdsm-plugin.html)
*   Affected Packages
    -   ovirt-node
    -   ovirt-node-image
    -   New Package for the plugin






