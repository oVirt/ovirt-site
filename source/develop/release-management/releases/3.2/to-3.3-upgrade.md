---
title: oVirt 3.2 to 3.3 upgrade
authors: sandrobonazzola
---

# oVirt 3.2 to 3.3 upgrade

## General Information

oVirt 3.2 was released as Fedora 18 package while 3.3 is targeted Fedora 19.

Due to the nature of this upgrade, we DO NOT recommend it, users are advised to do a 3.3 clean installation, and to import all VM's and template into the new installation.

The following instructions were tested upgrading oVirt 3.2.3-1.fc18 to 3.3.0-4.fc19 ( see <https://bugzilla.redhat.com/1009335> )

## Upgrade Instructions

*   Make sure to backup the DB and the /etc/pki/ovirt-engine folders before the upgrade.
*   Update the system the oVirt Engine was installed on to Fedora 18 using:

      # yum update

*   Upgrade the system the oVirt Engine was installed on to Fedora 19:
    -   More info about preupgrade: <http://fedoraproject.org/wiki/PreUpgrade>

      # fedup --network 19

After reboot the following packages are on the system:

      # rpm -qa |grep ovirt
      ovirt-engine-setup-3.3.0-4.fc19.noarch
      ovirt-engine-restapi-3.2.3-1.fc18.noarch
      ovirt-engine-webadmin-portal-3.2.3-1.fc18.noarch
      ovirt-engine-lib-3.3.0-4.fc19.noarch
      ovirt-host-deploy-java-1.1.1-1.fc19.noarch
      ovirt-engine-backend-3.2.3-1.fc18.noarch
      ovirt-image-uploader-3.3.0-1.fc19.noarch
      ovirt-log-collector-3.3.0-1.fc19.noarch
      ovirt-engine-cli-3.3.0.4-1.fc19.noarch
      ovirt-engine-genericapi-3.2.3-1.fc18.noarch
      ovirt-host-deploy-1.1.1-1.fc19.noarch
      ovirt-release-fedora-8-1.noarch
      ovirt-engine-dbscripts-3.2.3-1.fc18.noarch
      ovirt-engine-userportal-3.2.3-1.fc18.noarch
      ovirt-engine-sdk-python-3.3.0.6-1.fc19.noarch
      ovirt-engine-3.2.3-1.fc18.noarch
      ovirt-iso-uploader-3.3.0-1.fc19.noarch
      ovirt-engine-tools-3.2.3-1.fc18.noarch

You may need to execute the following commands in order to have yum working correctly:

      # yum clean all
      # yum update
      # ln -s /etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-19-primary /etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-x86_64

Apache and PosgreSQL are up and running but the following error will be found:

      # service ovirt-engine status
      Redirecting to /bin/systemctl status  ovirt-engine.service
      ovirt-engine.service - oVirt Engine
        Loaded: loaded (/usr/lib/systemd/system/ovirt-engine.service; enabled)
        Active: failed (Result: exit-code) since mer 2013-09-18 08:01:50 EDT; 1s ago
       Process: 619 ExecStart=/usr/bin/engine-service start (code=exited,  status=1/FAILURE)

You must now update oVirt:

      # engine-setup

The setup will guide you during the oVirt upgrade.

If you want to enable novnc/spice html5:

      # yum -y install ovirt-engine-websocket-proxy
      # engine-setup

and access https: //<fqdn>:6100 for accepting the certificate
