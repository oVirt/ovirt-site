---
title: Node versions numbers
category: node
authors: mburns
---

# Node Version Numbers

Conventions for ovirt-node version numbers

## RPM versions

*   The rpm will have a version like: ovirt-node-X-Y.Z.rpm
*   X will be the overall version (like 2.2.0, 2.2.1, 2.3.0)
*   Y is the build number
    -   0 will indicate a build prior to the release of X and will generally be followed by some form of git tag or date stamp for tracking
    -   1 will be the first build of the release
    -   2+ will be respins for small bug fixes that that need to be made prior to the release of X+1
*   Z is the distribution, so something like fc16, fc17, etc

Examples:

      ovirt-node-2.2.1-1.fc16
          ^        ^   ^  ^ 
          |        |   |   --- built for Fedora 16
          |        |    --- first official rpm of the 2.2.1 release of ovirt-node
          |         --- the 2.2.1 release
           --- the ovirt-node package

## ISO Image Versions

*   Follow the ovirt-node rpm version without the distribution tag (so no .fc16)
*   Append an increasing .# to the end of the ovirt-node rpm version for the iso version
*   The number increases by one for each respin
*   Respins are generally for other package updates or updates that did not require an ovirt-node rpm update.

Example:

      ovirt-node-image-2.2.1-1.4.iso
          ^              ^   ^ ^ 
          |              |   |  --- 4th image build from the 2.2.1-1 ovirt-node rpm
          |              |    --- first official rpm of the 2.2.1 release of ovirt-node
          |               --- the 2.2.1 release
           --- the ovirt-node-image iso

[Category: Node](Category: Node)
