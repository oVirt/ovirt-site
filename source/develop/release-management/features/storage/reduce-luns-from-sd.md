---
title: Reduce LUNs from a Storage Domain
category: feature
authors: laravot
feature_name: Reduce LUNs from Storage Domain
feature_modules: vdsm, engine
feature_status: Released in oVirt 4.1
---

# Reduce LUNs from a Storage Domain

## Summary

Adding ability to reduce LUNs from a Block Storage Domain.

## Owner

*   Name: Liron Aravot


## Detailed Description

The purpose of this feature is to provide a way to reduce LUNs from an oVirt Storage Domain.
Currently oVirt supports extension of a block Storage Domain, but one may want to reduce from a storage domains
because of various reasons, for example - unused storage domain space and need to extend a different storage
domain.
oVirt will allow to move the data off the selected devices to other devices of the domain and eventually will free
the selected device(s).
Note that the Storage Domain must be in Maintenance state.

## Benefit to oVirt

Ability to reduce devices from block storage domains.

#### User Experience

1. Refactor the Edit Storage Domain dialog to include option to reduce devices.
2. Add REST-API support

#### User work-flows

REST-API:

In order to reduce luns the user will submit a POST request to
`/ovirt-engine/api/storagedomains/{storagedomain:id}/reduceluns` with the luns it wishes
to reduce from the storage domain.
For example:

```xml
<action>
<logical_units>
<logical_unit id="1IET_00010001"/>
<logical_unit id="1IET_00010002"/>
</logical_units>
</action>
```

WEB-UI:

The user will be able to choose the LUNs it wishes to reduce from the Storage Domain in the Edit Storage Domain dialog.

### Documentation / External references

This feature is using the following LVM commands:

*   [pvmove](https://man7.org/linux/man-pages/man8/pvmove.8.html)

*   [vgreduce](https://man7.org/linux/man-pages/man8/vgreduce.8.html)


