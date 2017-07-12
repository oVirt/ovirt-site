---
title: Releases
category: release
authors: knesenko, mburns, oschreib
---

# Releases

Releases directory stucture

**Nightly repositories**

For nightly repositories we use this layout. Each nightly (snapshot) needs its -static repo. See the example bellow.

**Official Releases**

For official releases we use the bellow layouts. Official released shipped without -static repos. You will get all packages inside the repo.

      ovirt-<version>[-snapshot]
      ├── iso
      ├── rpm
      │   ├── el7
      │   │   ├── noarch
      │   │   ├── repodata
      │   │   ├── SRPMS
      │   │   └── x86_64
      │   └── fc24
      │       ├── noarch
      │       ├── repodata
      │       └── SRPMS
      │       └── x86_64
      └── src

      ovirt-<version>-snapshot-static
      ├── iso
      ├── rpm
      │   ├── el7
      │   │   ├── noarch
      │   │   ├── repodata
      │   │   ├── SRPMS
      │   │   └── x86_64
      │   └── fc24
      │       ├── noarch
      │       ├── repodata
      │       ├── SRPMS
      │       └── x86_64
      └── src

