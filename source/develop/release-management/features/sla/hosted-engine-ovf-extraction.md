---
title: Hosted engine shared configuration extraction and caching
category: feature
authors: dchaplyg
feature_name: 'Hosted engine shared configuration extraction and caching'
feature_status: Planning
---

# Hosted engine shared configuration extraction and caching

## Summary

Hosted engine tools rely on configs, stored on the shared storage, such as OVF.
At the moment, OVF and shared configuration disk content are extracted on every monitoring loop execution.

The goal of this feature is to is to move config extraction code to the broker. This will result in a more maintanable code and more reliable hosted engine behavior.

## Owner

*   Name: [Denis Chaplygin](https://github.com/akashihi)

## Current status

*   Target Release: 4.3
*   Status: Planning
*   Last updated: December 11, 2017

## Detailed Description

The specific goals associated with this feature are as follows:

*   OVF extraction should be moved from the agent to the broker. Broker should update vm.conf periodically and report the time elapsed since the last update, which can then be used in score calculations in the future. Update period should be set as a configuration value or constant. We will also need additional submonitor, that will actually report 'time since last update'
*   Shared config extraction should be moved from the agent to the broker. Broker should read configuration data from the configuration disk and store it locally in some predefined location. Agent should try to read those configs from that location without shared storage access.
*   Config handling code must be broker specific and not shared between broker and agent anymore.

## Benefit to oVirt

*   Less code - less bugs.
*   Clean separation of concerns makes code cleaner and easier to maintain.
*   Hosted engine state updates will happen faster and without delays, thus decreasing overall latency of the whole system. See [Hosted engine shared configuration extraction and caching](develop/release-management/features/sla/hosted-engine-ovf-extraction#documentation)

## Documentation / External references

*   [Documentation/External references](develop/release-management/features/sla/hosted-engine-agent-offloading/#documentation)

