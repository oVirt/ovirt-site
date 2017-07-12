---
title: TestCase Hosted Engine Tagged VLAN Support
category: testcase
authors: sandrobonazzola
---

# TestCase Hosted Engine Tagged VLAN Support

## Description

Starting with oVirt 3.4.3 you can use tagged VLAN interface for the management bridge while deploying the Hosted Engine. This test case will check that the feature is working as expected

## Setup

1.  Create a tagged VLAN interface. You can find a guide for Fedora here: [1](http://goo.gl/zySouo)

## How to test

1.  Install ovirt-hosted-engine-setup
2.  Run hosted-engine --deploy
3.  When asked about NIC to be used for the management bridge select the tagged VLAN interface
4.  Complete the Hosted Engine deployment

## Expected Results

*   The bridge is created and it's using the tagged VLAN interface
*   The Hosted Engine deployment is completed without errors
*   The ovirtmgmt network appears with the correct VLAN tag
*   In the Host main tab, in the interfaces subtab, when pressing the "Setup Host Networks" button ovirtmgmt doesn't appear as "out-of-sync"

## Optional

*   Perform other oVirt Engine test cases related to tagged VLAN interfaces

