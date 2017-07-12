---
title: Plugins
category: feature
authors: jboggs
---

# Plugin Support

## Summary

This feature adds the ability to add additional functionality to the node

## Owner

*   Name: Joey Boggs (jboggs)
*   Email: <jboggs@redhat.com>
*   IRC: jboggs at #ovirt (irc.oftc.net)

## Current status

*   Completed:
*   Completed: Moved SNMP functionality into a plugin (ovirt-node-plugin-snmp)
*   In progress: Move CIM page to plugin
*   Last updated: Oct. 23. 2012

## Detailed Description

Plugins extend functionality by adding in packages and methods to easily configure them.

For example ovirt-node-plugin-snmp provides:

      - auto-install
      - setup pages after installation
      - minimization

*   /etc/ovirt-config-boot.d/snmp_autoinstall.py
*   /etc/ovirt-plugins.d/snmp.minimize
*   /usr/lib/python2.7/site-packages/ovirt_config_setup/snmp.py

Auto installation scripts go into /etc/ovirt-config-boot.d and are run after the install completes

Minimization configs are named /etc/ovirt-plugins.d/\*.minimize and run after the plugin is installed to the image

Setup UI pages are placed into /usr/lib/python2.7/site-packages/ovirt_config_setup/

To install a plugin:

         edit-node --install-plugin=PLUGIN_PACKAGE_NAME --repo=plugins.repo ovirt-node-image.iso

To view what plugins are installed by viewing available manifests:

         edit-node --print-manifest ovirt-image.iso

## Benefit to oVirt

Ability to minimize to a core image and reduce space used

Can add additional custom functionality to installer/setup

Can customize the iso to add packages, set default passwords, public keys

## Dependencies / Related Features

livecd-tools

## Documentation / External references

TBD


