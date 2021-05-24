---
title: Separate-DWH-Host
category: feature
authors:
  - didi
  - sandrobonazzola
  - sradco
---

# Separate DWH Host

## Summary

Allow ovirt-engine-dwh to be installed and configured by engine-setup on a separate machine, without requiring ovirt-engine to be on the same host.

## Owner

*   Name: Didi (Didi)

<!-- -->

*   Email: <didi@redhat.com>

## Current status

Implemented, should be available in 3.5.

## Detailed Description

We assume that engine is already setup and running on machine A. We assume that user wants to install dwh on machine B.

We need access to the engine's database. If on separate host, user will be prompted for them.

We need to also fix bug <https://bugzilla.redhat.com/1059283> - check minimal ETL version, as we'll not be able to rely on package dependencies anymore.

## Benefit to oVirt

DWH sometimes causes a significant load on the engine machine. Installing it on a separate machine will allow distributing the load.

## Dependencies / Related Features

## Documentation / External references

<https://bugzilla.redhat.com/1080997>


## Testing

Install and setup ovirt-engine on machine A, ovirt-engine-dwh on machine B, see that dwhd on B collects data from the engine on A.

On A:

      yum install ovirt-engine-setup
      engine-setup

On B:

      yum install ovirt-engine-dwh-setup
      engine-setup


### dwhd is currently running

You might get en error from engine-setup 'dwhd is currently running'.

To fix this, you can try one of the following:

*   Restart dwhd:

      service ovirt-engine-dwhd restart

and make sure that it stopped and started cleanly (without errors in the log)

*   Clear DwhCurrentlyRunning

Make sure that dwhd is stopped, and then, in the engine's database,

      UPDATE dwh_history_timekeeping SET var_value = 0 WHERE var_name = 'DwhCurrentlyRunning';

Details:

When upgrading the engine, dwhd must be first stopped, then upgraded, then started. Otherwise it might try to collect inconsistent data, from a database in the middle of an upgrade, or from an upgraded database. In previous versions this was forced by engine-setup. Now that might be impossible, if they are on separate machines. To enforce that, a new flag was added to the database, marking that dwhd is up. It's set by dwhd on start, cleared on stop, and tested by engine-setup. Another flag was added to mark that dwhd should stop. If engine-setup sees that dwhd is up, it asks it to stop by marking that flag, then waits some time, and eventually times out and aborts if dwhd didn't mark that it is stopped. The most likely cause of this is an uncontrolled exit of dwhd, e.g. killing it with SIGKILL or unplugging the power of its host.


[Separate DWH Host](/develop/release-management/features/) [Separate DWH Host](/develop/release-management/releases/3.5/feature.html)
