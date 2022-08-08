---
title: Build Binary Package
authors:
  - alonbl
  - dneary
  - ranglust
---

# Build Source Package

Most components of oVirt project use standard sequence to build rpms.

Summary of sequence is:

```console
$ git clone <repository>
$ cd <repository>
$ [ -r configure.ac ] && autoreconf -ivf
$ [ -r configure ] && ./configure
$ make dist                # <-- will output source tarball
```

Note: If autoreconf is required, install `autoconf`, `automake` optionally `gettext-devel` packages.

# Build RPM Package

```console
$ rpmbuild -tb `<tarball>`   # <-- will output rpms
```

Another useful command is `createrepo` which scans directory and prepare rpm repository that can be added to yum via `/etc/yum.repos.d/xxx.repo`

```ini
[xxx]
name=xxx
baseurl=file:///location/of/repository
enabled=1
gpgcheck=0
```
