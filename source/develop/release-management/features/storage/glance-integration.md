---
title: Glance Integration
category: feature
authors: fsimonce
feature_name: Glance Integration
feature_status: Released in oVirt 3.3
feature_modules: engine, vdsm
---

# Glance Integration

## Summary

This feature will allow oVirt users to consume (use), export and share images with Glance.

### Owner

*   Name: Federico Simoncelli
*   Email: <fsimonce@redhat.com>

## Current Status

### Engine

*   Contribute to the OpenStack Java SDK project to obtain a component mature enough for the oVirt Engine (in progress)
*   Initial support for Keystone in order to access the authenticated Glance servers (in progress)
*   Adapt the current NFS ISO domains to become Image repository, hence being able to manage and display Glance domains (in progress)
*   New Glance Storage Domain (in progress)
*   Import and Export Image Commands

### VDSM

*   Implement the `imageImport` and `imageExport` commands, either explicitly supporting glance or with a more generic http repository support (with additional special headers in the glance case)

## Detailed Description

The Glance project provides services for discovering, registering, and retrieving virtual machine images. These images are to be intended as oVirt templates.

### Phase 1

*   Add the new Storage Domain for Glance (identified by the `StorageType#GLANCE` and the `StorageDomainType#Image`)
*   Add, edit and remove the Glance Storage Domains
*   List the available images in the Glance Storage Domains (leveraging the current infrastructure that oVirt uses for NFS ISO domains, which have many aspects in common)
*   Import images from Glance as oVirt Templates or floating Disks
*   Export single (floating) disks (without snapshots) to Glance

## VDSM API

    importImage(spUUID, sdUUID, imgUUID, volUUID, importInfo)
    exportImage(spUUID, sdUUID, imgUUID, volUUID, exportInfo)

    importInfo = {
       'method': 'http',
       'url': '`[`http://glance/v1/images/image-uuid`](http://glance/v1/images/image-uuid)`',
       'headers': {
         'X-Auth-Token': 'token-uuid',
       },
    }

## Future Phases

Import and Export entire VMs with multiple disks and snapshots using the OVA container format.

## User Experience

![New Glace Domain Dialog](/images/wiki/NewGlanceDomain1.png)
&nbsp;<br/>
![Glance Domain Listing](/images/wiki/GlanceDomainListing1.png)

## External References

*   [<http://github.com/woorea/openstack-java-sdk>](http://github.com/woorea/openstack-java-sdk)
*   [<http://docs.openstack.org/developer/glance>](http://docs.openstack.org/developer/glance)
