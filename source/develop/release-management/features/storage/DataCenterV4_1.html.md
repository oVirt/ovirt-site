---
title: DataCenterV4_1
category: feature
authors: mlipchuk
feature_name: Data Center V4.1
feature_status: In Progress
feature_modules: engine/vdsm
---

## Summary

Data Center 4.1 which is being introduced at oVirt 4.1 should support the following features:

* Storage Domain's version upgrade
* [Gluster libgfapi](http://staged-gluster-docs.readthedocs.io/en/release3.7.0beta1/Features/libgfapi/)
* copy/discard via HSM
* 'io=native' in both block and file based storage


## Current status

* Development

## General Functionality

Data Center 4.1 which will be introduce at oVirt 4.1 should support the following features:

* Storage Domain's version upgrade - Upgrading Data storage domains' version from V3 to V4.
This should make the storage domains support qcow2 version 3 which is compatible with
qemu 1.1 as well as the old qemu version 0.10.
* [Gluster libgfapi](http://staged-gluster-docs.readthedocs.io/en/release3.7.0beta1/Features/libgfapi/)
* copy/discard via HSM
* 'io=native' in both block and file based storage, as it provides better performance overall.

