---
title: Storage Domain V4 
category: feature
authors: mlipchuk
feature_name: Storage Domain V4
feature_status: Delivered in oVirt 4.1
feature_modules: engine/vdsm
---

## Summary

While every oVirt version delivers new features based on new VDSM APIs
(i.e., a new cluster level) or even new SPM APIs (i.e., a new DC level),
these features usually do not require any upgrade to the underlying
storage domain format.
The new 4.1 DC level delivers several features that do, in fact, require
such an upgrade, which inspired the introduction of a new storage domain
format, V4. This new format includes:

* Support of newer [QCOW2 compat levels](../qcow2v3)
* A new `xleases` volume to support [VM leases](../vm-leases)


## Current status

* Delivered in oVirt 4.1

## Upgrade

The upgrade will be handled as a [storage domain live
upgrade](storagedomainliveupgrade), just like previous domain upgrades
were handled.
