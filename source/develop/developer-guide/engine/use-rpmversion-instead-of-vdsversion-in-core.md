---
title: Use RpmVersion instead of VdsVersion in core
authors: emesika
---

# Use RpmVersion instead of VdsVersion in core

## Overview

Currently we have 3 version classes in oVirt core code:
a. Version (used for compatiblity level)
b. VdsVersion (reports VDS version)
c. RpmVersion (extends Version)
 The VdsVersion is an old code that is no longer relevant to oVirt 3.1 This document describes the steps required to depricate VdsVersion and use RpmVersion instead.

The requirement is that we use from now on RpmVersion (including when clients display the host version)
 It seems that the version is stored correctly in the database and only manipulated by the oVirt code code and clients code. So, no database upgrade is required.

### Plan

1) currently the vdsm version is stored in the vds_dynamic table, since this information is static, it should be moved first to vds_static.
2) Change VDS getVersion to return RpmVersion.
3) Clients should use RpmVersion.getValue to display the version in Host General Tab and in About box.
4) Clients currently have code that checks for available hosts according to compatability version [1], we will have to remove that code and supply backend queries to get this information. This will enforce the logic to be in the backend and not beeing multiplied by clients.
5) We will have to see how GWT supports RpmVersion since GWT regex is based on our compat regex and not on java.util.regex.
6) Remove VdsVersion.
7) Add/Change relevant tests.

### Tests

We should make sure 3.0 clusters continue working including ovirt-nodes
Test that all clients gets and displays version correctly.
All BLL/DAO tests should pass

### Risks

Since the change may lead to backward comatability issues, this change will require an intensive pre-integration effort.

[1] For example ; ClusterGuideModel.java

       for (VDS vds : allHosts)
       {
          if ((!Linq.IsHostBelongsToAnyOfClusters(clusters, vds))
               && (vds.getstatus() == VDSStatus.Maintenance || vds.getstatus() == VDSStatus.PendingApproval)
               && (vds.getVersion().getFullVersion() == null || Extensions.GetFriendlyVersion(vds.getVersion()
                 .getFullVersion()).compareTo(minimalClusterVersion) >= 0))
             {
                availableHosts.add(vds);
             }
       }

All of the above is actually business logic code that must be dove in oVirt code code.
