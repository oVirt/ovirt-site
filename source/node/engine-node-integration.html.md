---
title: Engine Node Integration
category: node
authors: doron, dougsland, fsimonce, roy
wiki_title: Engine Node Integration
wiki_revision_count: 42
wiki_last_updated: 2012-02-21
---

# Engine Node Integration

oVirt Engine and oVirt Node Integration.

This is a work in progress for

*   integrating oVirt node with the engine
*   making oVirt engine and vdsm to run on any linux machine

## Host Machine

### oVirt Node

1.  Fix bridge name
    -   See: <http://gerrit.ovirt.org/311>

2.  Fix Registration URI
    -   See: <http://gerrit.ovirt.org/318>
    -   See: <http://gerrit.ovirt.org/310>

3.  Fix public key file name
    -   See: <http://gerrit.ovirt.org/#change,311>

### Ubunto / Gentoo / others

No experience yet. Can start by building an rpm and extract its artifacts or alternatively convert the rpm to deb using alien? <http://www.howtoforge.com/converting_rpm_to_deb_with_alien> - please fill in if the details you have it working

### Fedora / other RPM and yum based host

* the process started on Fedora 14 machine which was updated by yum to Fedora 16

clone the latest vdsm from gerrit.ovirt.org/vdsm

`git clone `[`git://gerrit.ovirt.org/vdsm`](git://gerrit.ovirt.org/vdsm)
      cd vdsm

all the patches on the oVirt Node section needs to be applied here as well (soon will be merged)

rpm it

      ./autogen.sh --system && ./configure
      make clean && make rpm
      cd /root/rpmbuild/RPM/noarch
      yum localinstall *.rpm

rpm deps:

*   autogen
*   rpm-build
*   redhat-rpm-config

## Engine core machine

*   The engine core was built on fedora 14 but all stages applies for later versions and other distro's as well.
*   The engine was built from sources and installed via maven on a pre-installed jboss 5.1.0-GA server.
*   Follow these steps(link the installation process from the wiki).

engine sources folder: ~/src/git/ovirt-engine

clone the engine sources

      cd ~/src/git
`git clone `[`git://gerrit.ovirt.org/ovirt-engine`](git://gerrit.ovirt.org/ovirt-engine)

Create /etc/pki/engine/ca

      mkdir -p /etc/pki/engine/ca

Creating OpenSSH convertor: compile pubkey2ssh

      cd backend/manager/3rdparty/pub2ssh/src
      gcc -o pubkey2ssh pubkey2ssh.c -lcrypto
      cp pubkey2ssh /etc/pki/engine/ca/

Create relevant Engine folders

      sudo mkdir -p /var/lock/engine /usr/share/engine/backend/manager/conf/

Put vds_installer.py in place (the config entry of 'DataDir')

      cp ~/src/git/ovirt-engine/backend/manager/conf/vds_installer.py /usr/share/engine/backend/manager/conf/

Create CA and certs

      cd backend/manager/conf/ca
      ` ./installCA_dev.sh `pwd` /etc/pki/engine `

Copy cert to Jboss root dir

      cp /etc/pki/engine/ca/keys/engine.ssh.key.txt /usr/local/jboss/server/default/deploy/ROOT.war/

DB updates:

      psql engine postgres -c "update vdc_options set option_value = '/etc/pki/engine/ca/certs/engine.cer' where option_name = 'CertificateFileName';"
      psql engine postgres -c "update vdc_options set option_value = '/etc/pki/engine/ca/.keystore' where option_name = 'TruststoreUrl';"
      psql engine postgres -c "update vdc_options set option_value = '/etc/pki/engine/ca/' where option_name = 'CABaseDirectory';"
      psql engine postgres -c "update vdc_options set option_value = 'ca.pem' where option_name  = 'CACertificatePath';"
      psql engine postgres -c "update vdc_options set option_value = '/etc/pki/engine/ca/.keystore' where option_name = 'keystoreUrl';"
      psql engine postgres -c "update vdc_options set option_value = '/etc/pki/engine//ca/private/ca.pem' where option_name = 'CAEngineKey';"

Restart jboss to reload the database changes
