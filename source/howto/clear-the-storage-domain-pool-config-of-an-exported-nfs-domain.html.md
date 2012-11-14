---
title: How to clear the storage domain pool config of an exported nfs domain
category: howto
authors: alex.leonhardt, vered
wiki_category: How_to
wiki_title: How to clear the storage domain pool config of an exported nfs domain
wiki_revision_count: 2
wiki_last_updated: 2013-05-05
---

# How to clear the storage domain pool config of an exported nfs domain

On some occassions, e.g. after backing up your export domain(s) and wiping the HV, when the original host / domain is nolonger available, you're unable to attach it to your new HV/Data Center as it is already attached to the previous one. Here are some steps that will help you import VMs from a "abandoned" export domain.

## Assumptions and Pre-Requisites

*   You know how to export a folder/directory via NFS
*   You have setup ovirt manager and HV (ovirt-node) at least once successfully before
*   You know what a Export Domain is

## A few quick steps

So say you backed up your export domain as a .tgz - you need to unpack its content and make it available via the newly created NFS export. Unpack that .tgz into the same path

    tar -zxf /path/to/yourfile.tgz -C /path/to/nfsexport/

Once extracted, you need to edit one of the files to clear the storage domain its already allocated :

Edit the file

    /path/to/nfsexport/storagedomain/dom_md/metadata

Ensure that the value for "pool uuid" is empty

    POOL_UUID=

And ensure that the sha checksum is completely removed - the line must not exist in that file

    _SHA_CKSUM

Finally, add a new NFS Export Domain to your new HV / Data Center as you did to your previous host, oVirt Manager should detect that a storage domain exists, once activated you'll be able to re-import the VMs into your new HV / Data Center.

<Category:How_to>
