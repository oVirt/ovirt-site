---
title: TestCase Hosted Engine Upgrade
category: testcase
authors: sandrobonazzola
wiki_category: TestCase
wiki_title: QA:TestCase Hosted Engine Upgrade
wiki_revision_count: 2
wiki_last_updated: 2015-01-16
---

# TestCase Hosted Engine Upgrade

## Description

Test the upgrade of oVirt Hosted Engine deployments

## Setup

1.  Deploy Hosted Engine on a clean system using a previous stable release ensuring to have the same oVirt version both on hosts and Hosted Engine VM.

## How to test

1.  Ensure Hosted Engine is working
2.  Follow [ Upgrade Hosted Engine](Hosted_Engine_Howto#Upgrade_Hosted_Engine) guide
3.  Ensure Hosted Engine is still working after the upgrade

## Expected Results

*   The Hosted Engine upgrade is completed without errors
*   The Hosted Engine deployment is still working after the upgrade

## Optional

*   Perform other oVirt Hosted Engine / oVirt Engine test cases

<Category:TestCase> <Category:Integration>
