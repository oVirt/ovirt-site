---
title: Installing on RHEL
authors:
  - sandrobonazzola
  - gocallag
page_classes: download
---

# Installing on RHEL 9.x or derivatives

## For RHEL 9.x

The following repositories need to be enabled for RHEL 9.x only.

```bash
subscription-manager repos --enable rhel-9-for-x86_64-baseos-rpms
subscription-manager repos --enable rhel-9-for-x86_64-appstream-rpms
subscription-manager repos --enable codeready-builder-for-rhel-9-x86_64-rpms
subscription-manager repos --enable rhel-9-for-x86_64-resilientstorage-rpms
```

## For RHEL 9.x and RHEL 9.x derivatives

Once a minimal RHEL 9.x (or derivative) system has been built, you can install the pre-production master snapshots (oVirt Release 4.5.6 + Engine 4.5.7)

```bash
dnf copr enable -y ovirt/ovirt-master-snapshot centos-stream-9
dnf install -y ovirt-release-master
```

At this point you can choose to install the :
*   Minimal Host + Self-Hosted Engine, `dnf install -y ovirt-hosted-engine-setup`
*   A minimal host, `dnf install -y ovirt-host`