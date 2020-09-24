---
title: oVirt 4.0.3 Release Notes
category: documentation
toc: true
authors: sandrobonazzola
page_classes: releases
---

# oVirt 4.0.3 Release Notes

The oVirt Project is pleased to announce the availability of oVirt 4.0.3
Release as of August 29th, 2016.

oVirt is an open source alternative to VMware™ vSphere™, and provides an awesome
KVM management interface for multi-node virtualization.
This release is available now for Red Hat Enterprise Linux 7.2, CentOS Linux 7.2 (or similar).

To find out more about features which were added in previous oVirt releases,
check out the [previous versions release notes](/develop/release-management/releases/).

An updated documentation has been provided by our downstream 
[Red Hat Virtualization](https://access.redhat.com/documentation/en/red-hat-virtualization?version=4.0/)


## Install / Upgrade from previous versions

Users upgrading from 3.6 should be aware of following 4.0 changes around
authentication and certificates handling:

1. Single Sign-On using OAUTH2 protocol has been implemented in engine to
   allow SSO between webadmin, userportal and RESTAPI. More information can
   be found at https://bugzilla.redhat.com/1092744

2. Due to SSO it's required to access engine only using the same FQDN which
   was specified during engine-setup invocation. If your engine FQDN is not
   accessible from all engine clients, you will not be able to login. Please
   use ovirt-engine-rename tool to fix your FQDN, more information can be
   found at /documentation/how-to/networking/changing-engine-hostname/ .
   If you try to access engine using IP or DNS alias, an error will be
   thrown. Please consult following bugs targeted to oVirt 4.0.4 which
   should fix this limitation:
     https://bugzilla.redhat.com/1325746
     https://bugzilla.redhat.com/1362196

3. If you have used Kerberos SSO to access engine, please consult
   https://bugzilla.redhat.com/1342192 how to update your Apache
   configuration after upgrade to 4.0

4. If you are using HTTPS certificate signed by custom certificate
   authority, please take a look at https://bugzilla.redhat.com/1336838
   for steps which need to be done after migration to 4.0. Also please
   consult https://bugzilla.redhat.com/1313379 how to setup this custom
   CA for use with virt-viewer clients.



### Fedora / CentOS / RHEL

In order to install it on a clean system, you need to install

`# yum install `[`http://resources.ovirt.org/pub/yum-repo/ovirt-release40.rpm`](http://resources.ovirt.org/pub/yum-repo/ovirt-release40.rpm)

and then follow documentation from our downstream
[Red Hat Virtualization](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/)

If you're upgrading from a previous release on Enterprise Linux 7 you just need to execute:

      # yum install http://resources.ovirt.org/pub/yum-repo/ovirt-release40.rpm
      # yum update "ovirt-engine-setup*"
      # engine-setup

Upgrade on Fedora 22 and Enterprise Linux 6 is not supported and you should follow our [Migration Guide](https://web.archive.org/web/20170723145830/http://www.ovirt.org/documentation/migration-engine-36-to-40/) in order to migrate to Enterprise Linux 7 or Fedora 23.

### oVirt Hosted Engine

If you're going to install oVirt as Hosted Engine on a clean system please follow 
Red Hat Virtualization [Self Hosted Engine Guide](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/paged/self-hosted-engine-guide/)

If you're upgrading an existing Hosted Engine setup, please follow
Red Hat Virtualization [Upgrade Guide](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/paged/upgrade-guide/)

## Known issues

 - [BZ 1297835](https://bugzilla.redhat.com/1297835) <b>Host install fails on Fedora 23 due to lack of dep on python2-dnf</b><br>On Fedora >= 23 dnf package manager with python 3 is used by default while
ovirt-host-deploy is executed by ovirt-engine using python2. This cause Host install to fail on Fedora >= 23 due to lack of python2-dnf in the default environment. As workaround please install manually python2-dnf on the host before trying to add it to the engine.


## What's New in 4.0.3?

### Enhancements

#### ovirt-distribution

 - [BZ 1368446](https://bugzilla.redhat.com/1368446) <b>Rebase qemu-kvm-ev to 2.3.0-31.el7_2.21</b><br>
qemu-kvm-ev has been rebased to 2.3.0-31.el7_2.21 including security fixes for CVE-2016-5126 and CVE-2016-5403.<br>
A build for ppc64le has been provided as well.<br>


### Deprecated Functionality

#### Documentation

 - [BZ 1255230](https://bugzilla.redhat.com/1255230)
Additional self-hosted engine hosts can only be added via the Administration Portal,
and can no longer be added by running 'hosted-engine --deploy' on the host.


### Unclassified

#### oVirt Hosted Engine HA

##### Team: Integration

 - [BZ 1367732](https://bugzilla.redhat.com/1367732) <b>If ovirt-ha-agent fails to read local answers.conf during upgrade, it writes None to shared fhanswers.conf</b><br>

#### oVirt Engine Dashboard

##### Team: UX

 - [BZ 1347238](https://bugzilla.redhat.com/1347238) <b>Tooltip on sparkline changes proportions based on time and wraps text to new line</b><br>
 - [BZ 1368767](https://bugzilla.redhat.com/1368767) <b>Dashboard: wrong alignment in top utilized resources</b><br>

#### oVirt Engine

##### Team: Infra

 - [BZ 1367513](https://bugzilla.redhat.com/1367513) <b>Kerberos negotiation for RESTAPI should be enabled by default to maintain SDK v3 compatibility</b><br>ENGINE_RESTAPI_NEGO config variable enables or disables the restapi negotiate authentication. If all restapi clients are RESTAPI/SDK v4 then this can be set to false. It is required to be set to true only for compatibility with RESTAPI/SDK v3.6 clients. By default the variable is set to true to maintain compatibility with v3.6 clients.

##### Team: Integration

 - [BZ 1369747](https://bugzilla.redhat.com/1369747) <b>Add an option '--mode=verify' to 'engine-backup' that also checks and fails if "found legacy kerberos/ldap directory integration"</b><br>

## Bug fixes

### oVirt Hosted Engine HA

#### Team: SLA

 - [BZ 1359059](https://bugzilla.redhat.com/1359059) <b>The agent got stuck if the broker takes more that 30 seconds to reach the smtp server</b><br>

### OTOPI

#### Team: Integration

 - [BZ 1350869](https://bugzilla.redhat.com/1350869) <b>[TEXT] [otopi] typo - Failed to install Host $HOST. Invalid data recieved during bootstrap.</b><br>

### oVirt Engine

#### Team: Integration

 - [BZ 1365451](https://bugzilla.redhat.com/1365451) <b>ovirt-imageio-proxy service failed to start after engine upgrade</b><br>
 - [BZ 1365744](https://bugzilla.redhat.com/1365744) <b>engine-setup should require ovirt-imageio-proxy-setup</b><br>
 - [BZ 1363816](https://bugzilla.redhat.com/1363816) <b>password DWH_DB_PASSWORD not hidden</b><br>

#### Team: SLA

 - [BZ 1367025](https://bugzilla.redhat.com/1367025) <b>[Upgrade] Cluster compatibility upgrade 3.6-> 4.0 failed on a specific system</b><br>

#### Team: Virt

 - [BZ 1356027](https://bugzilla.redhat.com/1356027) <b>During cluster level upgrade - reconfig VMs to old cluster level compatibility level until they restart</b><br>

### oVirt Hosted Engine Setup

#### Team: Integration

 - [BZ 1366879](https://bugzilla.redhat.com/1366879) <b>--upgrade-appliance - Failed to execute stage 'Environment customization': File contains no section headers. file: `<???>`, line: 1 u'None'</b><br>

