---
title: Install nightly snapshot
authors: sandrobonazzola
---

# Install nightly oVirt master snapshot

For CentOS Stream 9 you need to run:

```
dnf copr enable -y ovirt/ovirt-master-snapshot
yum install -y ovirt-release-master
```

For CentOS Stream 8 / x86_64 you need to run:

```
rpm --import https://download.copr.fedorainfracloud.org/results/ovirt/ovirt-master-snapshot/pubkey.gpg
dnf --repofrompath=ovirt-master-snapshot,https://download.copr.fedorainfracloud.org/results/ovirt/ovirt-master-snapshot/centos-stream-8-x86_64/ install ovirt-release-master
```

This adds all required repositories. If you are using a different architecture you'll need to adjust the above URL accordingly.
The above procedure is needed because of [Bug 2024629](https://bugzilla.redhat.com/show_bug.cgi?id=2024629) - **dnf copr plugin doesn't work on CentOS Stream 8**.
