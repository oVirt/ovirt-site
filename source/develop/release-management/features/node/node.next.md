---
title: Node.next
category: node
authors: fabiand
feature_name: Node.next
feature_modules: engine,network,vdsm,node
feature_status: New
---

# Node.next

## Summary

Add a new approach for oVirt Node.

## Owner

This should link to your home wiki page so we know who you are

*   Name: Fabian Deutsch (fabiand)
*   Email: <fabiand@redhat.com>

## Detailed Description

oVirt Node is currently based on a heavily customized and minimized Fedora (or CentOS), this has the gain of a very minimalistic image, but has many drawbacks. The image is hard to build, to maintain and to develop features on it. Further more, payloads (like vdsm) need to be adjusted to it, to work nicely with the read-only too filesystem.

This feature is about changing the core of Node, and how it is build. Other related features like using cockpit and generic registration are covered in other features.

## Benefit to oVirt

*   Easier to build Node
*   Less delayed builds
*   Better adaptability to new features

## Dependencies / Related Features

*   The core changes should be transparent to subprojects



## Testing

TBD

## Contingency Plan

We'll need to ship the old Node.

## Release Notes

      == Node.next ==
      oVirt Node is now build differently to provide an easier to use and future proof Node. 




