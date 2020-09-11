---
title: Validate pre-conditions during installation
category: feature
authors: dougsland
feature_name: Installation/Validate Node Pre Coditions for Installation
feature_modules: node installation
feature_status: WIP, 4.1 proposed feature
---

# Node RPM Persistence After Upgrades

## Summary
Currently [oVirt Node NG](/develop/release-management/features/node/node.next.html) does not complain if it is getting installed in an environment where i.e. the storage layout is wrong (i.e. a thin pool is missing)

### Owner
* Name: Douglas Schilling Landgraf
* Email: dougsland@redhat.com

### Current Status
* Status: Design
* Last updated date: 07th Nov 2016

### Benefit to oVirt

Avoid fatal errors without any message during installation

### Dependencies
No dependecies

## Detailed Description

The imgbased component must check if it’s available thin pool in the partitions before the installation and /var must be a separate volume.
Suggestion: Add a high-level error class something like DescriptiveError
Important:  Find good error messages

* Check if / is thin volume
* Check if FS is ext4 or xfs in / and /var
* Improve error in utils.py
* /boot is at least 1GB
* /boot is a separate partition
* /var is a separate partition
