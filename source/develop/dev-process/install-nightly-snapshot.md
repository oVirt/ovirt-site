---
title: Install nightly snapshot
authors: sandrobonazzola
---

# Install nightly oVirt master snapshot

You need to run:

```
rpm --import https://download.copr.fedorainfracloud.org/results/ovirt/ovirt-master-snapshot/pubkey.gpg
dnf --repofrompath=ovirt-master-snapshot,https://download.copr.fedorainfracloud.org/results/ovirt/ovirt-master-snapshot/centos-stream-8-x86_64/ install ovirt-release-master
```

for adding all needed repositories.
