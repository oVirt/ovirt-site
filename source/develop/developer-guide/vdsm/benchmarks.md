---
title: VDSM benchmarks
category: vdsm
authors: fromani
---

# VDSM benchmarks

## Summary

This page collects the common VDSM test scenarios for performance and scalability analysis. We have a template for futher scenarios, in order to make sure we have all the informations to analyse and share the results. To run the benchmarks and to collect the data, you need to [set up profiling](/develop/developer-guide/vdsm/profiling-vdsm.html) first.

**WORK IN PROGRESS**

## Scenario Template

A benchmarking scenario should include all the informations needed to understand and evaluate the collected data. There is no specific format recommendations yet (e.g. JSON, plain text, markdown, open/libreoffice ODS, everything is ok as long is an open format), but a list of information which must be provided.

Notes:

*   versioning: version number if a software artifact is an official release or if it comes from a distribution package, git hash otherwise.

List of informations to be provided in the scenario:

*   Name: mnemonic name of the scenario. Short sentences are OK.
*   background (optional): rationale and background information about why this scenario is being considered.
*   test purpose: what is being benchmarked and why
*   test conditions: description of how to start/end the test and how to consider it finished
*   test measures: list of metrics take in to account

Examples: see the "Virt scenarios" below

List of informations to be provied in the result:

*   Name: to bind the results with the scenario
*   oVirt platform: versions of VDSM and engine (if used)
*   software platform: versions of libvirt, QEMU, python, java jdk (if used) and distribution used to run VDSM and engine
*   hardware platform: storage type (NFS, ISCSI), CPU on the VDSM hosts, amount of ram
*   how to reproduce: detailed steps, or possibly a script, about how to run the test.
*   [?] test runs: how many time did this test run

## Virt scenarios

### Monday Morning

#### Background

Suppose you have a large organization running many big machines running hundreds of VMs each. On monday morning everyone is back and everyone wants to access its VM quickly. On each host, we must create a large amount of VMs concurrently, and we should to this quickly and efficiently.

#### Purpose

Measure the overhead introduce by VDSM in starting many virtual machines. We want to minimize the overhead on an heavily-concurrent scenario. Start many VM simultaneously (the exact number depend on the test conditions) and measure the start up time

#### Conditions

Test starts when VDSM receives the first VM creation command. Test ends when the last VM is booted. For the test purposes, once a QEMU/KVM instance has started booting a VM, the VDSM job is done. All VMs should be threated as equal (we don't really care if VM abc boots before or after VM xyz).

#### Measures

*   total startup time. If VM are started in parallel, this should be equal to the boot up time of the slowest VM.
*   VM startup times:

1.  best time
2.  worst time
3.  average time (with deviation)

## Networking scenarios

Ideas: - Massive network configuring: Adding 200+ networks with a single command. - Massive network removal: Deleting 200+ networks with a single command.
