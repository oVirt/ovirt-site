---
title: Security advisories
authors: djorm
---

<!-- TODO: Content review -->

# Security advisories

This page lists all security vulnerabilities fixed in oVirt. Each vulnerability is assigned a security impact rating on a four-point scale (low, moderate, important and critical). The versions that are affected by each vulnerability are also listed.

Before being published, security matters are discussed on a dedicated mailing list, restricted to trusted participants. If you were invited to join, then you can subscribe [on this page](https://lists.ovirt.org/admin/lists/security-private.ovirt.org/).

## [Moderate] CVE-2019-10194 ovirt-engine-metrics: disclosure of sensitive passwords in log files and ansible playbooks

### Description
Sensitive passwords used in the deployment and configuration of oVirt Metrics were found to be insufficiently protected. Passwords could be disclosed in log files (if playbooks are run with -v), or in playbooks stored on Metrics or Bastion hosts.

### Affected versions

oVirt 4.3.4 is confirmed to be affected. Older releases of oVirt may also be affected.


## [Moderate] CVE-2014-0153 ovirt-engine-api: session ID stored in HTML5 local storage

### Description

It was found that the oVirt REST API stored session IDs in HTML5 local storage. A remote attacker could provide a specially-crafted web page that, when visited by a user with a valid REST API session, would allow the attacker to read the session ID from local storage. This is possible because HTML5 local storage is not protected by same-origin policy (SOP).

### Affected versions

oVirt 3.4.0 is confirmed to be affected. Older releases of oVirt may also be affected.

### Patch commit(s)

<http://gerrit.ovirt.org/#/c/25987/>

## [Moderate] CVE-2014-0152 ovirt-engine-webadmin: session fixation

### Description

It was found that the oVirt web admin interface did not generate a new session ID after authenticating a user. A remote attacker could use this flaw to perform session fixation attacks.

### Affected versions

oVirt 3.4.0 is confirmed to be affected. Older releases of oVirt may also be affected.

### Patch commit(s)

<http://gerrit.ovirt.org/#/c/25959/>

## [Important] CVE-2014-0160 (Heartbleed) ovirt-node-iso: OpenSSL exposes information disclosure in handling of TLS heartbeat extension packets

### Description

A missing bounds check was found in the way OpenSSL handled TLS heartbeart extension packets. This flaw could be used to reveal up to 64k of memory from a connected client or server. ovirt-node-iso included a vulnerable version of OpenSSL.

### Affected versions

Only ovirt-node-iso images based on Red Hat Enterprise Linux 6.5 or Fedora 19 are affected. A patched image is available here: <http://resources.ovirt.org/pub/ovirt-3.4/iso/ovirt-node-iso-3.4-20140423.1.el6.iso>

### Patch commit(s)

N/A

## [Moderate] CVE-2013-4367 ovirt-engine: some config files left world-writable due to improper use of os.chmod()

### Description

It was found that ovirt-engine would create certain files world-writable (such as /etc/sysconfig/nfs). This is due to an upstream [kernel change](https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/fs/open.c?id=e57712ebebbb9db7d8dcef216437b3171ddcf115) which impacts how python's os.chmod() works when passed a mode of '-1'. Prior to this kernel change, a mode of '-1' would have implied "do nothing", however with the upstream kernel change this will turn all possible bits on (thus making the file world-writable).

As a result, this only affects ovirt-engine (or other python scripts using os.chmod() in this way) with newer Linux kernels (version 3.1 and newer).

This has been addressed to fix permissions on installations that upgrade from 3.2. In 3.3, the entire setup package was rewritten and the copyFile() function (from common_utils.py, where this os.chmod() call is made) has been removed. As a result, this only affects ovirt-engine 3.2 running on a Linux kernel 3.1.

### Affected versions

This vulnerability only affects ovirt-engine 3.2 running on Linux kernel 3.1.

### Patch commit(s)

<http://gerrit.ovirt.org/#/c/19472/>

## [Moderate] CVE-2013-4181 ovirt-engine: RedirectServlet cross-site scripting flaw

### Description

A reflected cross-site scripting (XSS) flaw was found in the RedirectServlet component of ovirt-engine. Access to RedirectServlet does not require authentication.

### Affected versions

All versions of ovirt-engine prior to 3.3.0 are affected.

### Patch commit(s)

<http://gerrit.ovirt.org/#/c/19152/>

## [Moderate] CVE-2012-3533 ovirt-engine: does not validate server identity in new python SDK and CLI

### Description

It was reported that oVirt 3.1 did not properly validate SSL certificates of the server when the client would connect. This could permit man-in-the-middle attacks.

In oVirt sdk, the python httplib.HTTPSConnection function is used to let the programmer specify the client's pair of certificates, but does not force the underlying SSL library to check the server certificate against the client keys. Because of this, the oVirt CLI tool does not check certificates upon connection. The new python SDK (ovirt-engine-sdk) and new python CLI (ovirt-engine-cli) were introduced in oVirt 3.1 ; earlier versions are not affected by this flaw.

### Affected versions

All versions ovirt-engine-sdk 3.1 prior to 3.1.0.6 and ovrt-engine-cli 3.1 prior to 3.1.0.8 are affected. The new python SDK (ovirt-engine-sdk) and new python CLI (ovirt-engine-cli) were introduced in oVirt 3.1 ; earlier versions are not affected by this flaw.

### Patch commit(s)

<http://gerrit.ovirt.org/#/c/7209/> <http://gerrit.ovirt.org/#/c/7249/>
