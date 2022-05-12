---
title: Installing on RHEL
authors:
  - sandrobonazzola
page_classes: download
---

# Installing on RHEL or derivatives
## Installing on RHEL 8.6 or derivatives

In order to install oVirt 4.5 on RHEL 8.6 or derivatives you'll need to provide CentOS Stream required configuration.
The following bash code is needed before starting to install oVirt 4.5 on top of RHEL 8.6

Specific to RHEL only:
```bash
subscription-manager repos --enable rhel-8-for-x86_64-baseos-rpms
subscription-manager repos --enable rhel-8-for-x86_64-appstream-rpms
subscription-manager repos --enable codeready-builder-for-rhel-8-x86_64-rpms

rpm -i --justdb --nodeps --force "http://mirror.centos.org/centos/8-stream/BaseOS/$(rpm --eval '%_arch')/os/Packages/centos-stream-release-8.6-1.el8.noarch.rpm"
```

Common to RHEL 8.6 and derivatives:

```bash
cat >/etc/yum.repos.d/CentOS-Stream-Extras.repo <<'EOF'
[cs8-extras]
name=CentOS Stream $releasever - Extras
mirrorlist=http://mirrorlist.centos.org/?release=8-stream&arch=$basearch&repo=extras&infra=$infra
#baseurl=http://mirror.centos.org/$contentdir/8-stream/extras/$basearch/os/
gpgcheck=1
enabled=1
gpgkey=https://www.centos.org/keys/RPM-GPG-KEY-CentOS-Official
EOF

cat >/etc/yum.repos.d/CentOS-Stream-Extras-common.repo <<'EOF'
[cs8-extras-common]
name=CentOS Stream $releasever - Extras common packages
mirrorlist=http://mirrorlist.centos.org/?release=8-stream&arch=$basearch&repo=extras-extras-common
#baseurl=http://mirror.centos.org/$contentdir/8-stream/extras/$basearch/extras-common/
gpgcheck=1
enabled=1
gpgkey=https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Extras
EOF


echo "8-stream" > /etc/yum/vars/stream

dnf distro-sync --nobest
```


## Installing on RHEL 9.0 or derivatives

Specific to RHEL only:
```bash
subscription-manager repos --enable rhel-9-for-x86_64-baseos-rpms
subscription-manager repos --enable rhel-9-for-x86_64-appstream-rpms
subscription-manager repos --enable codeready-builder-for-rhel-9-x86_64-rpms
subscription-manager repos --enable rhel-9-for-x86_64-resilientstorage-rpms

rpm -i --justdb --nodeps --force "http://mirror.stream.centos.org/9-stream/BaseOS/$(rpm --eval '%_arch')/os/Packages/centos-stream-release-9.0-12.el9.noarch.rpm"
```

Common to RHEL 9.0 and derivatives:

```bash
cat >/etc/yum.repos.d/CentOS-Stream-Extras-common.repo <<'EOF'
[c9s-extras-common]
name=CentOS Stream $releasever - Extras packages
metalink=https://mirrors.centos.org/metalink?repo=centos-extras-sig-extras-common-$stream&arch=$basearch&protocol=https,http
gpgkey=https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-Extras
gpgcheck=1
repo_gpgcheck=0
metadata_expire=6h
countme=1
enabled=1
EOF

echo "9-stream" > /etc/yum/vars/stream

dnf distro-sync --nobest
```
