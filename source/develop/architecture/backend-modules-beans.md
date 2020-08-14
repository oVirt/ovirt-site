---
title: Backend modules beans
category: architecture
authors: amuller
---

# Backend modules beans

**Introduction:**
The beans module is a job scheduler, and is essentially a wrapper around [Quartz](http://quartz-scheduler.org/),
which might be described as a beefier, platform-agnostic Cron jobs alternative that can be embedded in a Java project.

The beans module is used extensively when monitoring hosts. The [VDSBroker](/develop/architecture/backend-modules-vdsbroker.html)
module's class VdsUpdateRunTimeInfo monitors hosts' CPU, memory usage and so on.
A method of the IRSBrokerCommand class monitors the SPM-host for storage related issues.

