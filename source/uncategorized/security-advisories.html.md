---
title: Security advisories
authors: djorm
wiki_title: Security advisories
wiki_revision_count: 5
wiki_last_updated: 2014-05-12
---

# Security advisories

This page lists all security vulnerabilities fixed in oVirt. Each vulnerability is assigned a security impact rating on a four-point scale (low, moderate, important and critical). The versions that are affected by each vulnerability are also listed.

## [Moderate] CVE-2013-4367 ovirt-engine: some config files left world-writable due to improper use of os.chmod()

Affected versions: This vulnerability only affects ovirt-engine 3.2 running on a Linux kernel 3.1

Description: It was found that ovirt-engine would create certain files world-writable (such as /etc/sysconfig/nfs). This is due to an upstream [kernel change](https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/fs/open.c?id=e57712ebebbb9db7d8dcef216437b3171ddcf115) which impacts how python's os.chmod() works when passed a mode of '-1'. Prior to this kernel change, a mode of '-1' would have implied "do nothing", however with the upstream kernel change this will turn all possible bits on (thus making the file world-writable).

As a result, this only affects ovirt-engine (or other python scripts using os.chmod() in this way) with newer Linux kernels (version 3.1 and newer).

This has been in [upstream git](http://gerrit.ovirt.org/#/c/19472/) to fix permissions on installations that upgrade from 3.2. In 3.3, the entire setup package was rewritten and the copyFile() function (from common_utils.py, where this os.chmod() call is made) has been removed. As a result, this only affects ovirt-engine 3.2 running on a Linux kernel 3.1.
