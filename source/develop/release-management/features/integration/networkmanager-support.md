---
title: NetworkManager Support
category: feature
authors: fabiand, mburns
---

# NetworkManager Support

## Summary

This feature covers the migration of all the network related functionality to use NetworkManager.

## Owner

*   Feature owner: Mike Burns <mburns@redhat.com>

## Current status

*   Status: Design Stage
*   Last updated date: Tue May 08 2012

## Detailed Description

This means moving from the existing network service, not editing files directly anymore, determining what files NetworkManager changes and ensure they're persisted correctly.

## Benefit to oVirt

This migration ensures that Node can still be based on Fedora and doesn't need major workarounds.

## Dependencies / Related Features

(Probably) affected parts:

*   Node
    -   TUI
    -   o-c-\* scripts
    -   installer
*   VDSM (?)

## Documentation / External references

*   Corresponding bug: <https://bugzilla.redhat.com/show_bug.cgi?id=807039>
    -   Bug for bridge support: <https://bugzilla.redhat.com/show_bug.cgi?id=199246>
    -   Upstream GNOME bug to handle brigdes within NM: <https://bugzilla.gnome.org/show_bug.cgi?id=546197>
    -   <https://bugzilla.gnome.org/show_bug.cgi?id=546197>
*   Fedora
    -   F8 Feature: <http://fedoraproject.org/wiki/Releases/FeatureNetworkManager>
    -   F9 Feature: <http://fedoraproject.org/wiki/Releases/FeatureMoreNetworkManager>
    -   <http://fedoraproject.org/wiki/Tools/NetworkManager>
*   GNOME
    -   <https://wiki.gnome.org/Projects/NetworkManager>

## Comments and Discussion

*   Mailinglist: devel@ovirt.org

