---
title: Installing on RHEL
authors:
  - sandrobonazzola
page_classes: download
---

# Installing on RHEL

In order to install oVirt 4.5 beta on RHEL 8.6 beta you'll need to provide CentOS Stream required configuration.
The following bash code is needed before starting to install oVirt 4.5 beta on top of RHEL 8.6 beta


```bash
subscription-manager repos --enable rhel-8-for-x86_64-baseos-beta-rpms
subscription-manager repos --enable rhel-8-for-x86_64-appstream-beta-rpms
subscription-manager repos --enable codeready-builder-beta-for-rhel-8-x86_64-rpms

cat >/etc/yum.repos.d/CentOS-Stream-Extras.repo <<'EOF'
[extras]
name=CentOS Stream $releasever - Extras
mirrorlist=http://mirrorlist.centos.org/?release=8-stream&arch=$basearch&repo=extras&infra=$infra
#baseurl=http://mirror.centos.org/$contentdir/8-stream/extras/$basearch/os/
gpgcheck=1
enabled=1
gpgkey=https://www.centos.org/keys/RPM-GPG-KEY-CentOS-Official
EOF

cat >/etc/yum.repos.d/CentOS-Stream-Extras-common.repo <<'EOF'
[extras-common]
name=CentOS Stream $releasever - Extras common packages
mirrorlist=http://mirrorlist.centos.org/?release=8-stream&arch=$basearch&repo=extras-extras-common
#baseurl=http://mirror.centos.org/$contentdir/8-stream/extras/$basearch/extras-common/
gpgcheck=1
enabled=1
gpgkey=https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Extras
EOF

rpm -i --justdb --nodeps --force "http://mirror.centos.org/centos/8-stream/BaseOS/$(rpm --eval '%_arch')/os/Packages/centos-stream-release-8.6-1.el8.noarch.rpm"

echo "8-stream" > /etc/yum/vars/stream

dnf distro-sync --nobest
```

