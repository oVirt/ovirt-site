---
title: AllInOne
category: feature
authors: acathrow, alourie, didi, dneary, jbrooks, netbulae, oschreib, sandrobonazzola
feature_name: All in One
feature_modules: engine,node
feature_status: Removed
---

# All in One

## Notes

This feature is deprecated in 3.6 and it will be dropped in the next release, 4.0.

An alternative, supported since 3.4 and the only one to be in 4.0, is to use a [Self Hosted Engine](/develop/release-management/features/sla/self-hosted-engine.html). 

## Summary

"All in One" means configuring VDSM on the same host where oVirt-engine is installed, so that VMs can be hosted on the same machine.

## Owner

*   Name: Alex Lourie (Alourie)

## Current status
*   Included since 3.1
*   Deprecated since 3.6.0
*   Removed since 4.0.0

## Detailed Description

The plugin works by providing parameters, group and sequences and adding them into the Controller object (the main object of the setup flow), which will invoke appropriate logic during the setup operation.

The following steps are performed by the plugin:

1.  Detect CPU architecture of the machine. After the detection, the plugin compares it with the list of supported architectures, and will raise an exception if the CPU is not supported. (Note: the plugin uses vdsm caps.py module to detect the CPU type).
2.  Verify that the given folder where VMs should be stored (provided during setup) is legal, is empty and writeable. If the folder doesn't exist, it will be created. Also, SELinux will be configured to allow writing in this folder.
3.  Plugin will wait to allow JBoss to start correctly. This is done because other steps involve using REST API (with ovirtsdk), which requires JBoss to be up.
4.  Plugin will create local datacenter and local cluster at this point.
5.  Plugin will create a local host and add it to host list (Note: an update to backend was introduced to allow creating a host without rebooting it).
6.  TODO: (waiting for [vdsm bug](https://bugzilla.redhat.com/show_bug.cgi?id=799111) to be fixed): Plugin will create a local storage domain.

## Installation flow

*   Install ovirt-engine-setup-plugin-allinone rpm.
*   Start the regular engine-setup procedure.
*   When asked "Configure VDSM on this host?", answer yes.
*   After all answers are provided, the setup will install oVirt-engine and configure VDSM, including local cluster, local datacenter and local host.

## API

### Installation using answer file

The following parameters are added by the plugin to the answer file:

OVESETUP_AIO/configure
OVESETUP_AIO/storageDomainDir

It is recommended to generate the answer file automatically:

`engine-setup --generate-answer=`<answer file full path>

... After that, proceed with installation using the answer file you have just created:

`engine-setup --config-append=`<answer file full path>
