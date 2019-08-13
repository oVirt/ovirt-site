---
title: TestCase CommandCoordinator
category: testcase
authors: rnori
---

# TestCase CommandCoordinator

## Description

Starting with oVirt 3.5 non-storage related operations can be executed asynchronously using CommandCoordinator framework. This test case will check that the feature is working as expected by invoking live merge.

## Setup

1.  Create a snapshot of a VM with disk

## How to test

1.  Install ovirt-engine
2.  Run engine-setup
3.  Add host, storage domain and create a VM with disk
4.  Create a snapshot of the VM
5.  Start the VM and after the VM is up delete the snapshot.

## Expected Results

*   Live Merge should run and the snapshot should be deleted

