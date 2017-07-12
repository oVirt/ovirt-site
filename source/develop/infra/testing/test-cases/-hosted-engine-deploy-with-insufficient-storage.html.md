---
title: TestCase Hosted Engine Deploy With Insufficient Storage
category: testcase
authors: sandrobonazzola
---

# TestCase Hosted Engine Deploy With Insufficient Storage

## Description

{BZ|1142098} discovered that volume creation on systems with insufficient space is not always detected

## Setup

You can follow <https://fedoraproject.org/wiki/Scsi-target-utils_Quickstart_Guide> for setting up tgtd

## How to test

1.  Install ovirt-hosted-engine-setup
2.  Run hosted-engine --deploy
3.  When asked about disk size use a size equal to iSCSI device capacity
4.  VDSM should fail volume creation with insufficient space

## Expected Results

*   Hosted engine setup should detect the failure at volume creation or earlier

