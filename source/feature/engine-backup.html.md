---
title: Ovirt-engine-backup
category: feature
authors: bobdrad, bproffitt, didi, emesika, mlipchuk, oschreib
wiki_category: Feature
wiki_title: Ovirt-engine-backup
wiki_revision_count: 16
wiki_last_updated: 2015-05-06
wiki_warnings: references, table-style
---

# Ovirt-engine-backup

## Ovirt backup and restore utility

### Summary

A simple utility to create and restore a complete ovirt-engine environment.

### Owner

*   Name: [Ofer Schreiber](User:oschreib)
*   Email: <oschreib@redhat.com>

### Current status

*   Last updated: ,

#### Phase

In design

#### Features

| Feature | Existing implementation | Otopi implementation | Owner                                       | Priority | Target date |
|---------|-------------------------|----------------------|---------------------------------------------|----------|-------------|
| TBD     | Done                    | Not implemented      |                                             |          |             |
| TBD     | Done                    | Done [1]             | [ Ofer Schreiber](User:Oschreib) |          |             |

<references>
[2]

</references>
### Detailed Description

Scripting language: BASH Backup logic:

      * Create Temporary directory
      * Copy configuration files into temp directory
         1. /etc/ovirt-engine/  (ovirt engine configuration)
         2. /etc/sysconfig/ovirt-engine (ovirt engine configuration)
         3. /etc/exports.d  (NFS export created on setup)
         4. /etc/pki/ovirt-engine (ovirt-engine keys)
         5. Firewall
         6. Other
       * Create tar file from that directory
       * Create database backup using pgdump (database configuration should be read from /etc and written into temporary .pgpass file)

Restore: Phase one (BASH) 1. Request user to run engine-setup 2. Override DB and PKI directories

Phase two (??) 1. Gather all needed information from the backup 2. Run otopi based ovirt-engine-setup with special parameters (use pgdump, don't create new PKI)

### Benefit to oVirt

*   Easy to use backup utility
*   Easy restore of existing environments.

### Dependencies / Related Features

TBD

### Documentation / External references

*   [Ovirt Host Deploy Presentation](:File:ovirt-host-deploy 3.2.pdf)
*   [Bug 911191 - Migrate ovirt-engine-setup and AIO plugin to otopi](https://bugzilla.redhat.com/show_bug.cgi?id=911191)

### Comments and Discussion

*   Refer to <Talk:Features/ovirt-engine-backup>

<Category:Feature>

[1] 

[2] Placeholder
