---
title: engine-cleanup
category: feature
authors: herrold, simong
---

# engine-cleanup

## Engine Cleanup (Work in progress)

### Summary

This utility is intended to bring the host to a state it can be reused by oVirt engine

### Owner

*   Name: TBD
*   Email: TBD

### Present

(To be replaced to a link when a design page is created)

      * Drop DB - works both on local and remote
      * Remove keystore (not perfect)
      * cleanup symlinks
      * stop services (jbossas, notifer)
      * non-interactive switch -u/--unattended, default is drop DB.
      * switch: -d/--dont-drop-db

### Absent

Missing to comply with the purpose definition:

------------------------------------------------------------------------

      * Default mode is interactive - asking if to drop DB or not.
        Message: Drop data base? if you want to reuse the existing database for the future installation choose no.
      * Message at the end: Finished cleanup it is now safe to rerun engine-setup.
      * If it did not dropped DB add: Note that after re-install you'll have to run Hosts re-install/re-approve
      * Add -h/--help
      * Add message (Hide all options except -d/-u/-h in the usage message/help)

### Detailed Description

The cleanup should provide:

1. Reset a failed installation to a state in which you can safely rerun: engine-setup

2. Clean up before a new installation before or after the user has run:

      # yum remove

and the later tries it a second time without a formal clean-up being performed

* Meaning the sequence I (first example) :

      # engine-cleanup
      # yum remove ovirt-engine
      # yum install ovirt-engine
      # engine-setup 

* Or the sequence II (second example):

      # yum remove ovirt-engine,
      # yum install ovirt-engine
      # engine-cleanup
      # engine-setup

* If sequence II is not possible, don't start cleanup at all, but exit with proper message.

3. Reset an existing installation without dropping DB.

* Use cases: fix failed upgrade or a corrupted installation

* Next required 'Manual' steps:

      # yum remove engine
      # yum install engine
      # engine-setup   # This script should know how to reuse an existing DB, and to perform an upgrade if necessary

Note 1: The above includes Reports and DHW

Note 2. This utility is not intended to leave the machine clean for other application to reuse - only to be reused by a oVirt Manager

Note 3: Preserve DB is not intended to relocate db from local to remote and vice versa - Need to provide a procedure to do that.

Note 4: It will not remove any local NFS export, including the one it created during last installation. If we wish for engine-setup to reuse, this is enhancement to for engine-setup.

### Benefit to oVirt

This feature saved the need to re-install the host OS if a re-install of the engine is required. Currently in some cases even an initial installation failure may require clean install

### Dependencies / Related Features

### Documentation / External references

The clean-up script should be idempotent. If not, it needs a bug filed noting the deficiency. That is, one should be able to repeatedly run:

      # engine-cleanup
      # engine-cleanup
      # engine-cleanup # ... 

with no additional changes occurring on the second and following runs, beyond what occurred on the first, and supplementation of the log files




