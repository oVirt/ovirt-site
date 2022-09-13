---
title: Install nightly snapshot
authors: sandrobonazzola
---

# Install nightly oVirt master snapshot

## CentOS Stream 8 / x86_64

For CentOS Stream 8 / x86_64 you need to run:

```
dnf copr enable -y ovirt/ovirt-master-snapshot centos-stream-8
dnf install -y ovirt-release-master
```

## CentOS Stream 9

Please note that this is still tech preview. Most development is done on CentOS Stream 8, for now.

For CentOS Stream 9 you need to run:

```
dnf copr enable -y ovirt/ovirt-master-snapshot centos-stream-9
dnf install -y ovirt-release-master
```
