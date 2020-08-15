---
title: Vagrant Provider
category: project-proposal
authors: bkp
---

# Project Proposal - Vagrant Provider

## Summary

This will be a provider plugin for the Vagrant suite that allows command-line ease of virtual machine provisioning and lifecycle management.

## Owner and Initial Maintainers

* Marcus Young <3vilpenguin@gmail.com>

## Current Status

*   This project is in [incubation](/develop/projects/incubating-an-subproject.html).
*   Last updated: Dec 6 2016

Vagrant Provider currently exists as an independent open source project hosted on [github](https://github.com/myoung34/vagrant-ovirt4). This wiki page will gather input on whether Vagrant Provider should become a full oVirt sub-project and (if so) how best to integrate it into the oVirt stack.

## oVirt Infrastructure

*   Bugzilla
*   Mailing list: devel

## Detailed Description

This Vagrant provider plugin will interface with the oVirt REST API (version 4 and higher) using the oVirt provided ruby SDK 'ovirt-engine-sdk-ruby'. This allows users to abstract the user interface and experience into a set of command line abilities to
create, provision, destroy and manage the complete lifecycle of virtual machines. It also allows the use of external configuration
management and configuration files themselves to be committed into code.

## License

Licensed under the Apache License, Version 2.0 (Apache-2.0) <http://www.apache.org/licenses/LICENSE-2.0>

## Benefit to oVirt

The trend in configuration management, operations, and devops has been to maintain as much of the development process as possible in terms of the virtual machines and hosts that they run on. With software like Terraform the tasks of creating the underlying infrastructure such as network rules, etc have had great success moving into 'Infrastructure as code'. The same company behind Terraform got their reputation from Vagrant which aims to utilize the same process for virtual machines themselves. The core software allows for standard commands such as
'up', 'provision', 'destroy' to be used across a provider framework. A provider for oVirt makes the process for managing VMs easier and able to be controlled through code and source control.

## Scope

The initial goal is to get the base steps of 'up', 'down' (halt), and 'destroy' to succeed using the oVirt provided ruby SDK for v4.
Stretch/followup goals would be to ensure testability and alternate commands such as 'provision' and allow configuration management suites
like puppet to work via 'userdata' (cloud-init).

## Test Plan

*Not yet specified.*

## Dependencies

*   RHEVM/oVirt REST API - This provider must interact with the API itself to manage virtual machines.

## Contingency Plan

*Not yet specified.*

## Release Notes

*Not yet provided.*
