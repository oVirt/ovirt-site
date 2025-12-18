---
title: Install nightly snapshot
authors: 
  - sandrobonazzola
  - jasperb
---

# Install nightly oVirt master snapshot

## CentOS Stream 9

For CentOS Stream 9 you need to run:

```bash
dnf copr enable -y ovirt/ovirt-master-snapshot centos-stream-9
dnf install -y ovirt-release-master
```

## Centos Stream 10:

For CentOS Stream 10 you need to run:

```bash
dnf copr enable -y ovirt/ovirt-master-snapshot centos-stream-10
dnf install -y ovirt-release-master epel-release
```

RHEL and derivates are explained [here](/download/install_on_rhel.html).

