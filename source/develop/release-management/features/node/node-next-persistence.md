---
title: Next Gen Node RPM persistence
category: feature
authors: rbarry
---

# Node RPM Persistence After Upgrades

## Summary
[oVirt Node NG](/develop/release-management/features/node/node.next.html) is an advancement over vintage Node, especially that it allows users to install RPMs or customize the system through configuration management tools. Some of these changes are migrated over from /etc after upgrades, and some are kept persistenly in /var, but any packages which are installed on a running layer will be lost after upgrades and need re-installation. This presents some problems with vendor tooling, IPMI, utilities to collect statistics, and other add-ons.

This feature presents a mechanism by which packages installed through yum/dnf can be saved and automatically re-applied when the OS is updated.

A deep dive presentation of the feature is available on [youtube](https://www.youtube.com/watch?v=tpAVkBEDdVg)

### Owner
* Name: Ryan Barry
* Email: rbarry@redhat.com

### Current Status
* Status: On QA
* Last updated date: 29th Jan 2017

### Benefit to oVirt

This feature will greatly improve the user experience of Node by maintaining a consistent userland and system configuration after upgrades. This allows for Node customizations to "stick".

### Dependencies
None! We simply need to add an additional yum plugin to imgbased.

## Detailed Description

Node NG performs a number of actions when updates are applied.

* A new layer is added
* An event fires for the new layer

## Consumers

## osupdater
* The new squashfs is extracted onto that layer
* `/etc`/ and `/root` are rsynced to the new layer
* UIDs and GIDs are synchronized across packages, in case a drift occurred inbetween images for UIDs/GIDs which are not fixed
* A new bootloader entry is added and set as the default

## RPM persistence

* An additional plugin can be added to imgbased which also consumes the 'on-layer-added' hook

A reliable mechanism must be written in order to capture packages as they are installed, however.

[yum.PackageObject](http://yum.baseurl.org/api/yum/yum/packages.html?highlight=yum.packages.packageobjec#yum.packages.PackageObject) is able to immediately provide the location of a cached RPM (after downloading or from localinstall), and this is available as part of yum plugin hooks.

It _may_ be possible to [extend RPM](https://rpm-software-management.github.io/rpm/manual/plugins.html), but some research must be done in order to discover whether RPM's plugin interface is as informative as yum.PackageObject. It is possible that RPM's plugin mechanism only triggers during the execution of the RPM specfile, and cannot be used to pin down the location of the actual package. This also provides the additional burden of maintaining a small codebase in C, though that may be an acceptable tradeoff.

## Implementation

### yum plugin

yum provides a [variety of places to add hooks](http://yum.baseurl.org/wiki/WritingYumPlugins.html), and actually somewhat more than what's listed:

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

The yum plugin will add a hook into `pretrans`

* The pretrans conduit is able to retrieve the transaction set from yum
* Inside this transaction set, if a package is being installed or updated, `TransactionSet.installed` will contain all package objects
* We can iterate over the package objects, and retrieve `TransactionSet.PackageObject.localpkg()` (this is actually `po.localpkg`, since yum uses short variable internally
* The package will be copied over to `/var/imgbased/persisted-rpms`
* Using the yum cache is not reliable, as `yum clean all` would remove cached RPMs, and `yum localinstall` never touches the cache

Additionally:

* If the package set is empty, the plugin should check whether `remove` or `uninstall` have been used as verbs
* If they are, a `posttrans` hook can be used to remove the specified packages from `/var/imgbased/persisted-rpms`, so they are not spuriously installed again when users upgrade

The yum plugin should provide a configuration file, with only one parameter necessary:

* excludepkgs=foo,bar

Any package which is on the list of exclusions will not be persisted.



### imgbased plugin

A new imgbased plugin will be added, which triggers when a new layer is added.

* This plugin will mount the new layer, and bind mount /var into the tree
* Then we'll set up a local yum repository, pointed at `/var/imgbased/persisted_packages`, and install all RPMs

### imgbased extension

With the packages saved in /var, imgbased.osupdater can set up a local yum repository which points at `/var/imgbased/persisted_packages` (pathname to be determined), and install them when osupdater triggers during a Node update.
