---
title: Install nightly snapshot
authors: sandrobonazzola
---

# Install nightly oVirt master snapshot

## CentOS Stream 9

For CentOS Stream 9 you need to run:

```
dnf copr enable -y ovirt/ovirt-master-snapshot centos-stream-9
dnf install -y ovirt-release-master
```
