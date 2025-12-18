---
title: Installing on RHEL
authors:
  - sandrobonazzola
  - gocallag
  - jasperb
page_classes: download
---

# Installing on RHEL

## For RHEL 9.x or 10.x

The following repositories need to be enabled for RHEL 9.x only.

```bash
subscription-manager repos --enable rhel-9-for-x86_64-baseos-rpms
subscription-manager repos --enable rhel-9-for-x86_64-appstream-rpms
subscription-manager repos --enable codeready-builder-for-rhel-9-x86_64-rpms
subscription-manager repos --enable rhel-9-for-x86_64-resilientstorage-rpms
```

The same steps need to be followed for RHEL 10.x:

```bash
subscription-manager repos --enable rhel-10-for-x86_64-baseos-rpms
subscription-manager repos --enable rhel-10-for-x86_64-appstream-rpms
subscription-manager repos --enable codeready-builder-for-rhel-10-x86_64-rpms
```

## Next steps for RHEL and RHEL derivatives

**Note:** Previous steps with subscription managers are not needed for AlmaLinux distro's.

Once a minimal RHEL 9.x (or derivative like AlmaLinux) system has been built, you can install the pre-production master snapshots (oVirt Release 4.5.6 + Engine 4.5.7) 

```bash
dnf copr enable -y ovirt/ovirt-master-snapshot rhel-9-x86_64
dnf install -y ovirt-release-master
```

Or for RHEL 10.x and derivatives:

```bash
dnf copr enable -y ovirt/ovirt-master-snapshot rhel-10-x86_64
dnf install -y ovirt-release-master epel-release
```

At this point you can choose to install the :
*   Minimal Host + Self-Hosted Engine, `dnf install -y ovirt-hosted-engine-setup`
*   A minimal host, `dnf install -y ovirt-host`