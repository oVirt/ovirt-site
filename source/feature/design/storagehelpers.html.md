---
title: StorageHelpers
authors: mlipchuk
wiki_title: Features/Design/StorageHelpers
wiki_revision_count: 8
wiki_last_updated: 2012-12-16
---

# Storage Helpers Clean up and Re-design

### Summary

Today we have three different types of storage helpers:
1. FCP
2. ISCSI,
3. BaseFS (Local FS, NFS, PosixFS)
Each one of these helpers rules the connect/disconnect storage functionality with VDSM.
The architecture today is described in the following schema:
![](ISCSIHelpers.png "fig:ISCSIHelpers.png")
There are few clean ups, re-design which should be consider to be done:
1. Removed unused methods.
2.Proxy methods which does not contribute nothing to the code should be deleted.
2. Java standards should be followed (Method names).
3. The abstract helper exposes API with the notion of LUN in it as part of the method signatures.
 NFS should not be aware of it (for example, removeLun, connect/disconnectStorageToLun, getLunDAO and more).
4. There are 0 tests.
The code seems to use slightly different functionality for NFS storage and LUN Storage (NFS helpers call vdcActionTypes which call vdsActionType, and ISCSI helper only calls vdsActionType)
 The following is a new architecture which is proposed to make the code be a bit more comfortable to use:
1. Dieting the IStorageHelper interface as much as we can, and move specific functional methods to their specific helpers. (like removeLun)
2. Remove the StorageHelperBase
3. Use two abstract helpers for Lun and NFS (Local FS, NFS, PosixFS might still be inherited from it), and will implement the new IStorageHelper interface
4. See if maybe FCP helper could be removed or at least be much more API leaner (All the methods in it return true).
From the client programmer perspective the new architecture force him to know whether he uses block storage or NFS storage, and will call the right helper for connecting the storage to the VDSM.
This is also happens today, but it is much more confusing since there is a lot of APIs in the same class

*   Email: mlipchuk@redhat.com

### Current status

*   Target Release:
*   Status: Design Stage
*   Last updated date: Wed Dec 16 2012
