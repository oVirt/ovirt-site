---
title: TestCase Hosted Engine iSCSI Multiple LUN Support
category: testcase
authors: sandrobonazzola
---

# TestCase Hosted Engine iSCSI Multiple LUN Support

## Description

As part of [Self Hosted Engine iSCSI Support Feature](/develop/release-management/features/sla/self-hosted-engine-iscsi-support.html) this case is meant to test setup when multiple LUN are available on the iSCSI target.

See  - Hosted Engine on iSCSI setup doesn't allow LUN choice

## Setup

You can follow <https://fedoraproject.org/wiki/Scsi-target-utils_Quickstart_Guide> for setting up tgtd, just repeat the step "Add a logical unit (LUN)" increasing the value passed to --lun for each lun you add.

## How to test

1.  Install ovirt-hosted-engine-setup
2.  Run hosted-engine --deploy
3.  Select iSCSI storage
4.  Select the iSCSI target with multiple LUN

## Expected Results

*   Hosted engine setup should detect all the available LUNs and ask you which one has to be used

