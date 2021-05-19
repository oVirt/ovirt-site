---
title: Node Glusterfs Support
category: feature
authors: mburns
---


# Node Glusterfs Support

## Summary

Include support for using Gluster based storage on oVirt Node. Gluster storage is supported already with normal Fedora OS installs. This feature will add support into oVirt Node to be able to use Gluster storage as well.

## Owner

This should link to your home wiki page so we know who you are

*   Name: Mike Burns (mburns)
*   Email: mburns AT redhat DOT com

## Current status

*   100% Code Complete

## Detailed Description

Mostly, this is a simple feature for including the glusterfs client rpms and related kernel modules which were previously blacklisted.

## Benefit to oVirt

Add a previously missing functionality to oVirt Node to reduce the gap between a full OS and the simpler to use oVirt Node.

## Dependencies / Related Features

3.1 Feature for including Glusterfs support (in existing release)

## Documentation / External references

Release Notes:

Add the ability to use Gluster Storage with oVirt Node. Previously, when using oVirt Node, Gluster storage was not an option due to missing kernel modules and client RPMS. These RPMS and kmods are now included.


