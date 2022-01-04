---
title: Node Hosted Engine
category: feature
authors:
  - dougsland
  - fabiand
  - jboggs
---

# Node Hosted Engine

## Summary

This feature introduces the ability to setup a hosted engine on an ovirt-node instance

## Owner

*   Name: Joey Boggs (jboggs)

<!-- -->

*   Email: jboggs AT redhat DOT com
*   IRC: jboggs

## Current status

Completed. Users can deploy Hosted Engine via oVirt Node Text User Interface.

*   Last updated: ,

## Detailed Description

This plugin will pull in ovirt-hosted-engine-setup and dependencies. A plugin page in the setup tui will be available to start the installation process. The screen package will also be pulled in to help with any possible installation disconnection issues.

## Benefit to oVirt

Lowers the bar for getting a engine/node setup up and running with the least amount of hardware

## Dependencies / Related Features

*   Affected Packages
    -   ovirt-hosted-engine-setup
    -   screen

## Documentation / External references

[Hosted Engine documentation](https://ovirt.org/documentation/installing_ovirt_as_a_self-hosted_engine_using_the_command_line/) [Feature Page Hosted Engine](/develop/release-management/features/sla/self-hosted-engine.html)
