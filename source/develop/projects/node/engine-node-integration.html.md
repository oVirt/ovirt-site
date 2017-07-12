---
title: Engine Node Integration
category: node
authors: doron, dougsland, fsimonce, roy
---

# Engine Node Integration

oVirt Engine and oVirt Node Integration.

This is a work in progress for

*   integrating oVirt Node with the engine
*   making oVirt engine and vdsm to run on any linux machine

## Host Machine

### Ubunto / Gentoo / others

No experience yet. Can start by building an rpm and extract its artifacts or alternatively convert the rpm to deb using alien? <http://www.howtoforge.com/converting_rpm_to_deb_with_alien> - please fill in if the details you have it working

### Fedora / other RPM and yum based host

* the process started on Fedora 14 machine which was updated by yum to Fedora 16

clone the latest vdsm from gerrit.ovirt.org/vdsm

`git clone `[`git://gerrit.ovirt.org/vdsm`](git://gerrit.ovirt.org/vdsm)

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
*   The engine was built from sources and installed via maven on a pre-installed jboss 7.
*   Follow these steps(link the installation process from the wiki).

engine sources folder: ~/src/git/ovirt-engine

clone the engine sources

      cd ~/src/git
`git clone `[`git://gerrit.ovirt.org/ovirt-engine`](git://gerrit.ovirt.org/ovirt-engine)

Create /etc/pki/ovirt-engine/ca

      $ mkdir -p /etc/pki/ovirt-engine/ca
      $ sudo chmod -R 777 /etc/pki/ovirt-engine/

Creating OpenSSH convertor: compile pubkey2ssh

      cd backend/manager/3rdparty/pub2ssh/src
      gcc -o pubkey2ssh pubkey2ssh.c -lcrypto
      cp pubkey2ssh /etc/pki/ovirt-engine/ca/

Create relevant Engine folders

      $ sudo mkdir -p /var/lock/ovirt-engine /usr/share/engine/backend/manager/conf/
      $ touch /var/lock/ovirt-engine/.openssl.exclusivelock
      $ sudo chmod 777 /var/lock/ovirt-engine/.openssl.exclusivelock

Put vds_installer.py in place (the config entry of 'DataDir')

      $ cp ~/src/git/ovirt-engine/backend/manager/conf/vds_installer.py /usr/share/engine/backend/manager/conf/

Create CA and certs

      cd backend/manager/conf/ca
      ` ./installCA_dev.sh `pwd` /etc/pki/ovirt-engine `

Starting JBOSS7, you need to create a root context:

      cp -a ~/src/git/ovirt-engine/packaging/fedora/setup/resources/jboss/ROOT.war /usr/share/jboss-as/standalone/deployments/

Copy cert to Jboss root dir

      $ cp /etc/pki/ovirt-engine/ca/keys/engine.ssh.key.txt /usr/share/jboss-as/welcome-content/
      $ cp /etc/pki/ovirt-engine/ca/ca.pem /usr/share/jboss-as/welcome-content/ca.crt
      (Note: previous versions of jboss used: /usr/share/jboss-as/standalone/deployments/ROOT.war)

DB updates:

      psql engine postgres -c "update vdc_options set option_value = '/etc/pki/ovirt-engine/ca/certs/engine.cer' where option_name = 'CertificateFileName';"
      psql engine postgres -c "update vdc_options set option_value = '/etc/pki/ovirt-engine/ca/.keystore' where option_name = 'TruststoreUrl';"
      psql engine postgres -c "update vdc_options set option_value = '/etc/pki/ovirt-engine/ca/' where option_name = 'CABaseDirectory';"
      psql engine postgres -c "update vdc_options set option_value = 'ca.pem' where option_name  = 'CACertificatePath';"
      psql engine postgres -c "update vdc_options set option_value = '/etc/pki/ovirt-engine/ca/.keystore' where option_name = 'keystoreUrl';"
      psql engine postgres -c "update vdc_options set option_value = '/etc/pki/ovirt-engine/ca/private/ca.pem' where option_name = 'CAEngineKey';"

Additional Configuration: These 2 steps are currently required due to bugs, they will be changed/removed once the patches that will fix them will be merged. Change the default emulated VM type by executing:

      psql -U postgres engine -c "update vdc_options set option_value='pc-0.14' where option_name='EmulatedMachine' and version='3.0';"

If you wish to change the default password for admin (letmein!), execute the following command:

      psql -U postgres engine -c "update vdc_options set option_value='NEWPASSWORD' where option_name='AdminPassword';"

**TODO** - patch is needed to run the sql's above in the installCA.sh script

Restart jboss to reload the database changes
