---
title: Hosted Engine removal from oVirt Node
category: feature
authors: sandrobonazzola
feature_name: Hosted Engine removal from oVirt Node
feature_modules: ovirt-node-ng
feature_status: planning for 4.4.4
---

# Hosted Engine removal from oVirt Node


## Summary

oVirt Node used to include hosted-engine related packages including cockpit based installer.
But within a datacenter only a few nodes are really going to run the hosted engine making these packages just an unused payload.
By removing hosted engine related packages from oVirt Node, the footprint of the solution will be reduced as well as the attack surface security wise.

The overall work needed seems to be feasible in the 4.4.4 time frame.


## Devel Owner

* [Sandro Bonazzola](https://github.com/sandrobonazzola) <<sbonazzo@redhat.com>>

## QE Owners
* Avihai Efrat <<aefrat@redhat.com>>
* Jiri Macku <<jmacku@redhat.com>>
* Kobi Hakimi <<khakimi@redhat.com>>
* Meital Avital <<mavital@redhat.com>>
* Michael Burman <<mburman@redhat.com>>
* Satheesaran Sundaramoorthi <<sasundar@redhat.com>>

## Detailed Description
By removing Hosted Engine related packages on oVirt Node 4.4.3:

```bash
dnf remove \
      ovirt-ansible-collection.noarch \
      ovirt-hosted-engine-ha.noarch \
      ovirt-hosted-engine-setup.noarch \
      ansible

Dependencies resolved.
================================================================================
 Package                         Arch      Version             Repository  Size
================================================================================
Removing:
 ansible                         noarch    2.9.15-2.el8        @System     98 M
 ovirt-ansible-collection        noarch    1.2.1-1.el8         @System    1.3 M
 ovirt-hosted-engine-ha          noarch    2.4.5-1.el8         @System    1.6 M
 ovirt-hosted-engine-setup       noarch    2.4.8-1.el8         @System    1.3 M
Removing dependent packages:
 ovirt-release-host-node         noarch    4.4.3-1.el8         @System    135 k
Removing unused dependencies:
 cockpit-ovirt-dashboard         noarch    0.14.13-1.el8       @System     16 M
 gluster-ansible-cluster         noarch    1.0.1-2.el8         @System     93 k
 gluster-ansible-features        noarch    1.0.5-6.el8         @System    145 k
 gluster-ansible-infra           noarch    1.0.4-15.el8        @System    186 k
 gluster-ansible-maintenance     noarch    1.0.1-10.el8        @System     85 k
 gluster-ansible-repositories    noarch    1.0.1-3.el8         @System     79 k
 gluster-ansible-roles           noarch    1.0.5-21.el8        @System    140 k
 ovirt-host                      x86_64    4.4.1-4.el8         @System     11 k

Transaction Summary
================================================================================
Remove  13 Packages

Freed space: 118 M
```

We see we’ll need to change
* `ovirt-release-host-node`
* `ovirt-host`
dependencies in order to not get them out of oVirt Node.

This will reduce the number of the packages to be removed to 11.

The removal will reduce the footprint of oVirt Node by one hundred Megabyte (roughly 5% of the used space on installed oVirt Node). It will also reduce attack surface by removing ansible and cockpit-ovirt.

This will require to change the logic for upgrades within oVirt Node by making available the removed packages within yum repositories, allowing to install them without additional repositories. This means we need changes in:
* `imgbased`
* `ovirt-engine`


## Benefit to oVirt

By removing hosted engine related packages we are going to:
* Reduce oVirt Node footprint
* Reduce attack surface
* Reduce the number of respins needed due to updates to related packages.

## Limitations
By removing hosted engine related packages we are now requiring to download them.
For offline deployment this means that the packages will need to be provided in a local repository or within a local Foreman/Satellite.
This should not be a significant burden for the user, because the Engine appliance has to be downloaded anyhow.

## Installation / Upgrade

Installation without hosted engine is not going to change the user experience
Installation with hosted engine with cockpit interface will require:
```bash
dnf install cockpit-ovirt-dashboard
```

If hyperconverged deployment is needed, in addition to above command, user will need also:
```bash
dnf install gluster-ansible-cluster \
      gluster-ansible-features \
      gluster-ansible-infra \
      gluster-ansible-maintenance \
      gluster-ansible-repositories \
      gluster-ansible-roles
```

This last command can be simplified by introducing a meta package requiring all of them.

Deploying an host with hosted engine support enabled may require similar operations to be added to the ansible role performing the host deployment.

Upgrades from previous versions with yum update will see the removal of above mentioned packages.
Doing the upgrade from the ovirt-engine interface must take care of re-installing hosted-engine packages: requiring the packages to be present should be enough.

Both installation and upgrade in disconnected environments will require a few more packages to be downloaded and provided locally, documentation will need to be updated accordingly.


## Dependencies and Related Features

As mentioned above, following packages will need to be adjusted for accommodating this change:
* imgbased
* ovirt-engine
* ovirt-release-host-node
* ovirt-host

Documentation will require an update as well covering for the changes in installation and upgrade flows.

## Testing

* We’ll need to cover upgrade tests from previous 4.4 versions to the one including this feature.
* We’ll need to cover installation flow for Hosted Engine as it will be documented.
* We’ll need to cover host deployment with and without a hosted engine to ensure the final result will be compatible with previous versions' results.


## Contingency Plan

This is a feature that either will be all in or all out. If it’s not ready on time it has to be reverted to the previous version in all touched packages.

