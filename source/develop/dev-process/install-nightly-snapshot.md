---
title: Install nightly snapshot
authors: sandrobonazzola
---

# Install nightly oVirt master snapshot

For CentOS Stream 9 you need to run:

```
dnf copr enable -y ovirt/ovirt-master-snapshot
dnf install -y ovirt-release-master
```

For CentOS Stream 8 / x86_64 you need to run:

```
dnf copr enable -y ovirt/ovirt-master-snapshot centos-stream-8
dnf install -y ovirt-release-master
```
