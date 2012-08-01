---
title: OVirt 3.0 to 3.1 upgrade
authors: fabiand, oschreib
wiki_title: OVirt 3.0 to 3.1 upgrade
wiki_revision_count: 4
wiki_last_updated: 2012-08-02
---

# OVirt 3.0 to 3.1 upgrade

## General Information

oVirt 3.0 was released as Fedora 16 package, and 3.1 is targeted to Fedora 17. Due to the nature of this upgrade, we DO NOT recommend it, users are advised to do a 3.1 clean installation, and to import all VM's and template into the new installation.

## Upgrade Instructions

*   Remove all ovirt packages

<!-- -->

     yum remove ovirt\* 

**DO NOT run the engine-cleanup utility**

*   Upgrade the system the oVirt Engine was installed on to Fedora 17:
    -   <http://fedoraproject.org/wiki/PreUpgrade>

<!-- -->

*   Install oVirt Engine rpms

<!-- -->

     yum install ovirt-engine 

*   Restore previous keystore and preserve .sh scripts

<!-- -->

    cd /etc/pki
    mv ovirt-engine ovirt-engine.old
    mv ovirt-engine-backups/ovirt-engine-DATE_OF_BACKUP/ovirt-engine .
    find ovirt-engine -user jboss-as -exec chown ovirt:ovirt {} \;
    cp -f ovirt-engine.old/*.sh ovirt-engine/

*   Execute oVirt Engine Setup utility

<!-- -->

     engine-setup
