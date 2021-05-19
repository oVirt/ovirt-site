---
title: QEMU Guest Agent integration
category: feature
authors: tgolembi
---

# QEMU Guest Agent integration

## Owner

*   Name: Tomáš Golembiovský
*   Email: tgolembi@redhat.com

## Summary

This feature is about introducing the most essential features of oVirt Guest
Agent into QEMU Guest Agent (QGA) and using it in VDSM.

## Description

Historically oVirt Guest Agent has been used to collect various information
about guest Operating System running inside the Virtual Machine (e.g version,
time zone, IP addresses, etc.). While this generally works, it has some
drawbacks. Notably the oVirt Guest Agent is not running on freshly installed
system. Also, installing it may not be always straightforward because it may
not be available from base repositories of that particular system.

To ease the situation some oVirt Guest Agent features are now available also in
QEMU Guest Agent. Currently this entails the following features:

* power cycle commands -- shutdown, restart (oVirt 4.2)
* host name (QGA 2.10, oVirt 4.2.3)
* timezone information (QGA 2.10, oVirt 4.2.3)
* list of active users (QGA 2.10, oVirt 4.2.3)
* guest Operating System and architecture (QGA 2.10, oVirt 4.2.3)
* list of network interfaces and IP addresses (oVirt 4.2.3)

## Details and Differences

There are no changes in the UI in how the information is presented. Not all
properties are reported exactly the same though. There are differences e.g. in
the way timezone info is reported. The values are still comparable to what
oVirt Guest Agent reports.

![Reporting comparison](/images/wiki/Guest-Agent-reporting.png)

However, there are few notable difference that concern list of active users.
When there are more users logged in to the VM, oVirt Guest Agent reports only
one while with QEMU Guest Agent all of them are reported. Secondly, on Linux,
users logged into the console are not reported by QEMU Guest Agent.

![Reporting active users](/images/wiki/Guest-Agent-reporting2.png)
