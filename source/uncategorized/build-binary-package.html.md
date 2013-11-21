---
title: Build Binary Package
authors: alonbl, dneary, ranglust
wiki_title: Build Binary Package
wiki_revision_count: 7
wiki_last_updated: 2014-07-01
---

# Build Binary Package

## Building RPM for the oVirt project

Most components of oVirt project use standard sequence to build rpms.

Summary of sequence is:

`git clone `<repository>
`cd `<repository>
      [ -r configure.ac ] && autoreconf -ivf
      [ -r configure ] && ./configure
      make dist                # <-- will output source tarball
      rpmbuild -tb `<tarball>`   # <-- will output rpms

If autoreconf is required, install autoconf, automake optionally gettext-devel packages.

Another useful command is createrepo which scans directory and prepare rpm repository that can be added to yum via /etc/yum.repos.d/xxx.repo

      [xxx]
      name=xxx
`baseurl=`[`file:///location/of/repository`](file:///location/of/repository)
      enabled=1
      gpgcheck=0
