---
title: Next Gen Node RPM persistence
category: feature
authors: rbarry
wiki_category: Feature|Next Gen Node RPM Persistence
wiki_title: Feature/NextGenNodeRPMPersistence
wiki_revision_count: 0
wiki_last_updated: 2016-09-20
feature_name: Reinstall/Persist RPMs after Node upgrades
feature_modules: node persistence
feature_status: WIP, 4.1 proposed feature
---

# Node RPM Persistence After Upgrades

## Summary
[oVirt Node NG](http://www.ovirt.org/develop/projects/node/4.0) is an advancement over vintage Node, especially that it allows users to install RPMs or customize the system through configuration management tools. Some of these changes are migrated over from /etc after upgrades, and some are kept persistenly in /var, but any packages which are installed on a running layer will be lost after upgrades and need re-installation. This presents some problems with vendor tooling, IPMI, utilities to collect statistics, and other add-ons.

This feature presents a mechanism by which packages installed through yum/dnf can be saved and automatically re-applied when the OS is updated.

### Owner
* Name: Ryan Barry
* Email: rbarry@redhat.com

### Current Status
* Status: Design
* Last updated date: 20th Sep 2016

### Benefit to oVirt

This feature will greatly improve the user experience of Node by maintaining a consistent userland and system configuration after upgrades. This allows for Node customizations to "stick".

### Dependencies
None! We simply need to add an additional yum plugin to imgbased.

## Detailed Description

Node NG performs a number of actions when updates are applied.

* A new layer is added
* The new squashfs is extracted onto that layer
* `/etc`/ and `/root` are rsynced to the new layer
* UIDs and GIDs are synchronized across packages, in case a drift occurred inbetween images for UIDs/GIDs which are not fixed
* A new bootloader entry is added and set as the default

The existing osupdater logic can be extended (as the new root filesystem is already mounted) in order to install a package (or packages) into the new layer before it is booted for the first time.

A reliable mechanism must be written in order to capture packages as they are installed, however.

[yum.PackageObject](http://yum.baseurl.org/api/yum-3.2.26/yum.packages.PackageObject-class.html) is able to immediately provide the location of a cached RPM (after downloading or from localinstall), and this is available as part of yum plugin hooks.

It _may_ be possible to [extend RPM](http://www.rpm.org/wiki/DevelDocs/Plugins), but some research must be done in order to discover whether RPM's plugin interface is as informative as yum.PackageObject. It is possible that RPM's plugin mechanism only triggers during the execution of the RPM specfile, and cannot be used to pin down the location of the actual package. This also provides the additional burden of maintaining a small codebase in C, though that may be an acceptable tradeoff.

## Implementation

### yum plugin

yum provides a [variety of places to add hooks](http://yum.baseurl.org/wiki/WritingYumPlugins), and actually somewhat more than what's listed:

    args
    clean
    close
    compare_providers
    config
    exclude
    historybegin
    historyend
    init
    postconfig
    postdownload
    postreposetup
    postresolve
    posttrans
    postverifytrans
    predownload
    prelistenabledrepos
    prereposetup
    preresolve
    pretrans
    preverifytrans
    verify_package

While not all of these hooks run while yum has the package cached, we can rely on `pretrans` to have the cached package available, both for `yum localinstall` and `yum install`.

Though the hook should be limited to only run during certain transaction types (install, upgrade), the transaction package object is available, and we can grab the local file from [YumAvailablePackage.localPkg](http://yum.baseurl.org/api/yum/yum/packages.html#yumavailablepackage) and save it off to /var, which is a persistent filesystem on Node NG, which is not versioned per layer.


### imgbased extension

With the packages saved in /var, imgbased.osupdater can set up a local yum repository which points at `/var/imgbased/persisted_packages` (pathname to be determined), and install them when osupdater triggers during a Node update.
