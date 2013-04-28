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

*   Name: [User:oschreibOfer Schreiber](User:oschreibOfer Schreiber)
*   Email: <oschreib@redhat.com>

### Current status

*   Last updated: ,

#### Features

| Feature                                                   | Existing implementation | Otopi implementation | Owner                                                | Priority | Target date |
|-----------------------------------------------------------|-------------------------|----------------------|------------------------------------------------------|----------|-------------|
| Verify that root is the user executing the script         | Done                    | Done                 |                                                      |          |             |
| Allow unprivileged user ro run a development installation | Not implemented         | Done                 |                                                      |          |             |
| Checking total memory                                     | Done                    | Done [1]             | [ Sandro Bonazzola](User:SandroBonazzola) |          |             |

<references>
[2]

</references>
### Detailed Description

TBD

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

[2] The option `--no-mem-check` is now `--otopi-environment="OVESETUP_SYSTEM/memCheck=bool:False"`
