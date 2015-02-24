---
title: OVirt 3.5.2 Release Notes
category: documentation
authors: pkliczewski, sandrobonazzola
wiki_category: Documentation
wiki_title: OVirt 3.5.2 Release Notes
wiki_revision_count: 19
wiki_last_updated: 2015-05-06
---

# OVirt 3.5.2 Release Notes

The oVirt Project is pleased to announce the availability of oVirt 3.5.2 release candidate as of <date>, 2015.

<big>**Please wait for official announcement on mailing list before trying to install 3.5.2 RC**</big>

oVirt is an open source alternative to VMware vSphere, and provides an awesome KVM management interface for multi-node virtualization. This release is available now for Fedora 20, Red Hat Enterprise Linux 6.6, CentOS 6.6, (or similar) and Red Hat Enterprise Linux 7, CentOS 7 (or similar).

To find out more about features which were added in previous oVirt releases, check out the [previous versions release notes](http://www.ovirt.org/Category:Releases). For a general overview of oVirt, read [ the Quick Start Guide](Quick_Start_Guide) and the [about oVirt](about oVirt) page.

## Install / Upgrade from previous versions

### Fedora / CentOS / RHEL

### CANDIDATE RELEASE

oVirt 3.5.2 candidate release is available since 2015-<date>. In order to install it you've to enable oVirt 3.5 release candidate repository.

<big>**Please wait for official announcement on mailing list before trying to install 3.5.2 RC**</big>

In order to install it on a clean system, you need to install

`# yum localinstall `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release35.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release35.rpm)

And then manually add the release candidate repository for your distribution to **/etc/yum.repos.d/ovirt-3.5.repo**

**For CentOS / RHEL:**

      [ovirt-3.5-pre]
      name=Latest oVirt 3.5 pre release
`baseurl=`[`http://resources.ovirt.org/pub/ovirt-3.5-pre/rpm/el$releasever`](http://resources.ovirt.org/pub/ovirt-3.5-pre/rpm/el$releasever)
      enabled=1
      skip_if_unavailable=1
      gpgcheck=1

**For Fedora:**

      [ovirt-3.5-pre]
      name=Latest oVirt 3.5 pre release
`baseurl=`[`http://resources.ovirt.org/pub/ovirt-3.5-pre/rpm/fc$releasever`](http://resources.ovirt.org/pub/ovirt-3.5-pre/rpm/fc$releasever)
      enabled=1
      skip_if_unavailable=1
      gpgcheck=1

If you are upgrading from a previous version, you may have the ovirt-release34 package already installed on your system. You can then install ovirt-release35.rpm as in a clean install side-by-side.

Once ovirt-release35 package is installed, you will have the ovirt-3.5-stable repository and any other repository needed for satisfying dependencies enabled by default.

If you're installing oVirt 3.5.1 on a clean host, you should read our [Quick Start Guide](Quick Start Guide).

If you are upgrading from oVirt < 3.4.1, you must first upgrade to oVirt 3.4.1 or later. Please see [oVirt 3.4.1 release notes](oVirt 3.4.1 release notes) for upgrade instructions.

For upgrading now you just need to execute:

      # yum update "ovirt-engine-setup*"
      # engine-setup

### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please follow [Hosted_Engine_Howto#Fresh_Install](Hosted_Engine_Howto#Fresh_Install) guide.

If you're upgrading an existing Hosted Engine setup, please follow [Hosted_Engine_Howto#Upgrade_Hosted_Engine](Hosted_Engine_Howto#Upgrade_Hosted_Engine) guide.

## What's New in 3.5.2?

## Known issues

*   NFS startup on EL7 / Fedora20: due to other bugs ( or ), NFS service is not always able to start at first attempt (it doesn't wait the kernel module to be ready); if it happens oVirt engine setup detects it and aborts with

      [ INFO  ] Restarting nfs services
      [ ERROR ] Failed to execute stage 'Closing up': Command '/bin/systemctl' failed to execute

Retrying (engine-cleanup, engine-setup again) it's enough to avoid it cause the kernel module it's always ready on further attempts. Manually starting NFS service (/bin/systemctl restart nfs-server.service) before running engine setup it's enough to avoid it at all.

## CVE Fixed

## Bugs fixed

### oVirt Engine

**Fixed in oVirt 3.5.2 RC1**
 - Data Center downgrade should not be allowed if it implies downgrading the storage format
 - [engine-backend] Moving a shared disk to a gluster domain is not blocked
 - Overlap of "Enable Virt Service" and "Enable Gluster Service" radio buttons
 - [RFE] Add default-options to iDrac7 Fencing agent in RHEVM
 - [restapi] Add support to search disk by name parameter
 - Null disk size on a newly created disk is interpreted 0. Leave as null and revise usage.
 - External Keystone Connection Fails to Juno-based OpenStack
 - RHEV: Faulty storage allocation checks when merging a snapshot
 - if next run configuration exists the edit VM may load forever
 - Instance type: missing VM fields while using InstanceCreator user role.
 - engine-setup unconditionally enables the engine if ran on dwh on separate host
 - [engine-backend] Null disk size on a newly created disk is interpreted 0. Leave as null and revise usage.
 - [external providers] invalid certificate fingerprint is printed on confirmation dialog
 - [engine-backend] [iSCSI multipath] Cannot edit iSCSI multipath bond while iSCSI SD is in maintenance
 - [extapi] add default constructos
 - [engine-backend] requests doesn't reach vdsm
 - When an ISO domain is connected to multiple data centers in different statuses the image list is not fetched
 - Fencing test failed during adding single rhev-h host, but message says otherwise
 - Power management test with non approved host
 - Storage thresholds should not be inclusive
 - [AAA] [extmgr] escape extension name in ENGINE_EXTENSION_ENABLED_ configuration
 - failure of master migration on deactivation will leave domain locked
 - override SSL protocol to TLSv1
 - Bad error when adding vm to pool with low space on storage domain
 - Change message when importing a data domain to an unsupported version
 - Upgrade message in general tab is missing
 - Import of non data Storage Domains (specifically export domain) should not call engine query for web warning
 - Failure for calling internal query GetExistingStorageDomainList will cause an NPE
 - [RFE][engine-backend][HC] - add the possibility to import existing Gluster and POSIXFS export domains
 - [JSON] Force extend block domain, in JSONRPC, using a "dirty" LUN, fails
 - domain state is stuck on "Preparing For Maintenance" when having active gluster service cluster
 - [backend] [NPE] Adding permission to an object fails if DEBUG level is set
 - ENGINE_HEAP_MAX default value as 1G must be changed
 - Locked snapshot prevents VM's basic operations, after it's disk was removed
 - [Engine] Engine runs out of memory - java.lang.OutOfMemoryError: Java heap space
 - Using "iSCSI Bond", host does not disconnect from iSCSI targets
 - RHEV-M managed firewall blocks NFS rpc.statd notifications
 - Sysprep problem after upgrade from oVirt Engine 3.5.0.1-1 to 3.5.1.1-1.el6
 - [AAA] Always set principal in Authz.FetchPrincipalRecord
 - Can not restore backup file to rhevm with non-default lc_messages
 - Document All-Content header in RSDL and add it to SDKs
 - [AAA] Sorting by 'authorization provider' in 'users' tab don't sort

### ovirt-hosted-engine-setup

**Fixed in oVirt 3.5.2 RC1**
 - [hosted-engine] Bad check of iso image permission
 - vdsClient/vdscli SSLError timeout error
 - [RFE][HC] make override of iptables configurable when using hosted-engine

### ovirt-iso-uploader

**Fixed in oVirt 3.5.2 RC1**
 - [engine-iso-uploader] engine-iso-uploader does not work with Local ISO domain

### ovirt-log-collector

**Fixed in oVirt 3.5.2 RC1**
 - [RHEL7] Missing some info from host's archive

<Category:Documentation> <Category:Releases>
