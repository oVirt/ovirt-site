---
title: engine-cleanup
category: feature
authors: herrold, simong
wiki_category: Feature
wiki_title: Features/engine-cleanup
wiki_revision_count: 12
wiki_last_updated: 2014-05-01
---

# engine-cleanup

## Engine Cleanup (Work in progress)

### Summary

This utility is intended to bring the host to a state it can be reused by oVirt engine

### Owner

This should link to your home wiki page so we know who you are

*   Name: [ TBD](User:MyUser)

Include you email address that you can be reached should people want to contact you about helping with your feature, status is requested, or technical issues need to be resolved

*   Email: TBD

### Current status

(To be replaced to a link when a desing page will be created)

      * Drop DB - works both on local and remote
      * Remove keystore (not perfect)
      * cleanup symlinks
      * stop services (jbossas, notifer)
      * non-interactive switch -u/--unattended, default is drop DB.
      * switch: -d/--dont-drop-db

Missing to comply with the purpose definition:

------------------------------------------------------------------------

      * Default mode is interactive - asking if to drop DB or not.
        Message: Drop data base? if you want to reuse the existing database for the future installation choose no.
      * Message at the end: Finished cleanup it is now safe to rerun engine-setup.
      * If it did not dropped DB add: Note that after re-install you'll have to run Hosts re-install/re-approve
      * Add -h/--help
      * Add message (Hide all options except -d/-u/-h in the usage message/help)

### Detailed Description

The cleanup should provide:

1. Reset a failed installation to a state in which you can safely rerun engine-setup

2. Cleanup before a new installation before or after the user has run yum remove and now tries it all over.

        Meaning the sequence I : engine-cleanup, yum remove ovirt-engine, yum install ovirt-engine, engine-setup
        Or the sequence      II: yum remove ovirt-engine, yum install ovirt-engine, engine-cleanup, engine-setup
        If sequence II is not possible don't start cleanup at all, but exit with proper message. 

3. Reset an exiting installation without dropping DB.

        Use cases: fix failed upgrade or a corrupted installation
        Next required 'Manual' steps: 
                             yum remove engine
                             yum install engine
                             engine-setup (it should know how to reuse this DB and upgrade if necessary)

Note 1: The above includes Reports and DHW

Note 2. This utility is not intended to leave the machine clean for other application to reuse - only to be reused by a oVirt Manager

Note 3: Preserve DB is not intended to relocate db from local to remote and vice verse - Need to provide a procedure to do that.

Note 4: It will not remove any local NFS export, including the one it created during last installation. If we wish for engine-setup to reuse, this is enhancement to for engine-setup.

### Benefit to oVirt

This feature saved the need to re-install the host OS if a re-install of the engine is required. Currently in some cases even an initial installation failure may require clean install

### Dependencies / Related Features

### Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:Your feature name](Talk:Your feature name)

<Category:Feature> <Category:Template>
