---
title: oVirt-node-upgrade
category: node
authors: dougsland
wiki_category: Project
wiki_title: Ovirt-node-upgrade
wiki_revision_count: 7
wiki_last_updated: 2014-06-06
---

# Ovirt-node-upgrade

## Overview

ovirt-node-upgrade is a console tool to upgrade ovirt-node. It was developed to replace the old tool called vdsm-upgrade since it belongs to ovirt-node.

## About

        # ovirt-node-upgrade  --help
        Options:
        -h, --help            show this help message and exit
        --reboot=REBOOT       Perform reboot after upgrade, argument is amount of delay in seconds 
        --skip-existing-hooks Use only new hooks from provided iso
        --iso=FILE            Image to use for upgrade, use - to read from stdin

Example:

        # ovirt-node-upgrade --iso=/path/to/ovirt-node-image.iso --reboot=1

## hooks

The new tool provides hooks schema, which users can specify scripts to run **before** or **after** the upgrade.
These hooks are stored in the iso that will be used as parameter in ovirt-node-upgrade tool and executed during the upgrade process.

Path to hooks are:
 /usr/libexec/ovirt-node/hooks/pre-upgrade/ (Run before the upgrade)

       /usr/libexec/ovirt-node/hooks/post-upgrade/''' (Run after the upgrade)

In case you want to add a hook use the format: <order-number>-<name-of-script>.
Note: **order-number** is a positive integer number that upgrade tool uses to reference the order of running the scripts

Example from ovirt-node-plugin-vdsm:

       /usr/libexec/ovirt-node/hooks/pre-upgrade/01-vdsm
       /usr/libexec/ovirt-node/hooks/pre-upgrade/02-my-second-hook-to-be-executed

#### Format of hook programs

These programs can be in python, bash, etc. and **permission must be 0755**

#### Example hook implementation

hooks: Adding hooks for ovirt-node-upgrade
<http://gerrit.ovirt.org/#/c/28424/>

<Category:Project>
