---
title: TestCase Hosted Engine Upgrade
category: testcase
authors: sandrobonazzola
---

# TestCase Hosted Engine Upgrade

## Description

Test the upgrade of oVirt Hosted Engine deployments

## Setup

1.  Deploy Hosted Engine on a clean system using a previous stable release ensuring to have the same oVirt version both on hosts and Hosted Engine VM.

## How to test

1.  Ensure Hosted Engine is working
2.  Follow [Upgrade Guide](/documentation/upgrade_guide/)
3.  Ensure Hosted Engine is still working after the upgrade

## Expected Results

*   The Hosted Engine upgrade is completed without errors
*   The Hosted Engine deployment is still working after the upgrade

## Optional

*   Perform other oVirt Hosted Engine / oVirt Engine test cases
