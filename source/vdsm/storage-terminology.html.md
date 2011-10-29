---
title: Vdsm Storage Terminology
category: vdsm
authors: abonas, amureini, danken, quaid
wiki_category: Vdsm
wiki_title: Vdsm Storage Terminology
wiki_revision_count: 6
wiki_last_updated: 2012-11-25
---

# Vdsm Storage Terminology

## Storage Pool

A group of domains that are managed together. Currently domains grouped and can only be managed while being a part of a pool. We plan to remove the limitations created by using storage pools.

## Storage Domain

An atomic storage unit. On file domains it's either a mount point or a folder. On block devices on the other hand this can be a group of LUNs. There is no had limitation but it is highly recommended that all the LUNs composing a block domain are on the same physical host. This is done because when only parts of the domain disappear in case of failure there is a real issue with detecting problems.

Storage domains contains the images that the VMs will use.

## Image

A group of one or more volumes comprising a disk image to be used by VMs.

## Volume/Snapshot

Currently volumes and snapshots are the same. On block domain each volume is translated to an LV and on file domains to a separate file. Base volumes can be either raw or qcow but snapshots must be in qcow format.

<Catergory:Vdsm>
