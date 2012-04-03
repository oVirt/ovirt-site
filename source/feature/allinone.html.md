---
title: AllInOne
category: feature
authors: acathrow, alourie, dneary, jbrooks, netbulae, oschreib, sandrobonazzola
wiki_category: Feature|All In One
wiki_title: Feature/AllInOne
wiki_revision_count: 25
wiki_last_updated: 2015-01-16
---

# All in One

### Summary

"All in One" means configuring VDSM on the same host where oVirt-engine is installed, so that VMs can be hosted on the same machine.

### Owner

*   Name: [ Alex Lourie ](User:Alourie)
*   Email: alourie@redhat.com

### Current status

*   Currently in code review (http://gerrit.ovirt.org/#change,2221)

### Detailed Description

The plugin works by providing parameters, group and sequences and adding them into the Controller object (the main object of the setup flow), which will invoke appropriate logic during the setup operation.

The following steps are performed by the plugin:

1.  Detect CPU architecture of the machine. After the detection, the plugin compares it with the list of supported architectures, and will raise an exception if the CPU is not supported. (Note: the plugin uses vdsm caps.py module to detect the CPU type).
2.  Verify that the given folder where VMs should be stored (provided during setup) is legal, is empty and writeable. If the folder doesn't exist, it will be created. Also, SELinux will be configured to allow writing in this folder.
3.  Plugin will wait to allow JBoss to start correctly. This is done because other steps involve using REST API (with ovirtsdk), which requires JBoss to be up.
4.  Plugin will create local datacenter and local cluster at this point.
5.  Plugin will create a local host and add it to host list (Note: an update to backend was introduced to allow creating a host without rebooting it).
6.  TODO: (waiting for vdsm bug to be fixed): Plugin will create a local storage domain.

### Installation flow

*   Install ovirt-engine-setup-plugin-allinone rpm.
*   Start regular engine-setup procedure.
*   When asked "Configure VDSM on this host?", answer yes.
*   After all answers are provided, the setup will install oVirt-engine and configure VDSM, including local cluster, local datacenter and local host.

### Comments and Discussion

*   Refer to [Talk: allinone](Talk: allinone)

<Category:Features> <Category:Template>
