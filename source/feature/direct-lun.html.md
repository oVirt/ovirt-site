---
title: Direct Lun
category: feature
authors: derez, eduardo, ekohl, ilvovsky, lpeer, mkublin, sandrobonazzola
wiki_category: Feature|Direct_Lun
wiki_title: Features/Direct Lun
wiki_revision_count: 50
wiki_last_updated: 2015-01-16
---

# Direct Lun

## Introduction

Any block device can be used as local disk in the VM specifying it's GUID or UUID.

## Engine / VDSM API

A new API is added for this feature.

See [Features/Design/StableDeviceAddresses](Features/Design/StableDeviceAddresses) for the complete interface.
