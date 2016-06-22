---
title: Releases
category: release
authors: knesenko, mburns, oschreib
wiki_category: Releases
wiki_title: Releases
wiki_revision_count: 4
wiki_last_updated: 2014-03-17
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
      │   ├── el6
      │   │   ├── noarch
      │   │   ├── repodata
      │   │   ├── SRPMS
      │   │   └── x86_64
      │   ├── fc18
      │   │   ├── noarch
      │   │   ├── repodata
      │   │   └── SRPMS
      │   └── fc19
      │       ├── noarch
      │       ├── repodata
      │       ├── SRPMS
      │       └── x86_64
      └── src

      ovirt-<version>-snapshot-static
      ├── iso
      ├── rpm
      │   ├── el6
      │   │   ├── noarch
      │   │   ├── repodata
      │   │   ├── SRPMS
      │   │   └── x86_64
      │   ├── fc18
      │   │   ├── noarch
      │   │   ├── repodata
      │   │   └── SRPMS
      │   └── fc19
      │       ├── noarch
      │       ├── repodata
      │       ├── SRPMS
      │       └── x86_64
      └── src

