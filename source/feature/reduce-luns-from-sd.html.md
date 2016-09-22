---
title: Reduce LUNs from a Storage Domain
category: feature
authors: laravot
wiki_category: Feature
wiki_title: Reduce LUNs from a Storage Domain
wiki_revision_count: 6
wiki_last_updated: 2016-09-22
feature_name: Reduce LUNs from Storage Domain
feature_modules: vdsm, engine
feature_status: Implementation
---

# Reduce LUNs from a Storage Domain

## Summary

Adding ability to reduce LUNs from a Block Storage Domain.

## Owner

*   Name: [ Liron Aravot](User:laravot)

<!-- -->

*   Email: <laravot@redhat.com>

## Detailed Description

The purpose of this feature is to provide a way to reduce LUNs from an oVirt Storage Domain.
Currently oVirt supports extension of a block Storage Domain, but one may want to reduce from a storage domains
because of various reasons, for example - unused storage domain space and need to extend a different storage
domain.
oVirt will allow to move the data off the selected devices to other devices of the domain and eventually will free
the selected device(s).

## Benefit to oVirt

Ability to reduce devices from block storage domains.

#### User Experience

1. Refactor the Edit Storage Domain dialog to include option to reduce devices.
2. Add REST-API support

#### Installation/Upgrade

Describe how the feature will effect new installation or existing one.

#### User work-flows

REST-API:
1. In order to reduce luns the user will submit a POST request to
/ovirt-engine/api/storagedomains/{storagedomain:id}/reduceluns with the luns it wishes
to reduce from the storage domain.

An example would be:

```xml
<action>
<logical_units>
<logical_unit id="1IET_00010001"/>
<logical_unit id="1IET_00010002"/>
</logical_units>
</action>
```

2. WEB-UI:
The user will be able to choose the LUNs it wishes to reduce from the Storage Domain in the Edit Storage Domain dialog.

### Documentation / External references

This feature is using the following LVM commands:

*   [pvmove](https://linux.die.net/man/8/pvmove)

*   [vgreduce](http://linuxcommand.org/man_pages/vgreduce8.html)

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:Reduce LUNs from a Storage Domain](Talk:Your feature name)

