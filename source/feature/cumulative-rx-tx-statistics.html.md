---
title: Cumulative RX TX Statistics
category: feature
authors: danken, lvernia
wiki_category: Feature
wiki_title: Features/Cumulative RX TX Statistics
wiki_revision_count: 26
wiki_last_updated: 2015-01-27
feature_name: Cumulative Network Usage Statistics
feature_modules: engine,vdsm
feature_status: Design
---

# Cumulative Network Usage Statistics

### Summary

This feature will implement reporting of total received/transmitted bytes per network interface (both for hosts and for VMs), on top of the currently-reported receive/transmit rate.

### Owner

*   Name: Lior Vernia
*   Email: lvernia@redhat.com

### Benefit to oVirt

Numerous benefits have been suggested:

*   This data is useful in VDI use cases, where total VM network usage needs to be accounted for. While it's possible to compute total usage out of the reported rates, it requires implementing some logic in a script, and the precision of the reported rate is limited).
*   Due to the aforementioned limited precision of reported rate (e.g. traffic needs to be bigger, on average over a 15-second period, than an interface's speed divided by 1000 to be reported), reporting the total RX/TX statistics will allow to spot thinner traffic going through the interface, for example to make sure that an interface is operational.

### Detailed Description

Currently, the only network usage statistics reported for network interfaces (whether host or VM) are momentary receive/transmit rates. By popular demand, as part of this feature reporting will be added for total received/transmitted bytes for both hosts and VMs, both in the GUI and via REST.

This will generally be implemented by having vdsm report total RX/TX byte statistics and sample times back to the engine, and having the engine store and show those statistics, as well as compute the average rate from the previous sample rather than depend on the reported vdsm rate (depending on cluster compatibility version).

To store cumulative statistics from the beginning of a VM interface's life to its end, surviving shut downs, migrations and [hot]unplugs - these reset the counters on the network devices - we will have to also store for each interface offset numbers for RX and TX traffic (and update whenever one of the above cases happen).

A nice touch would be to also keep these offsets for hosts, starting from zero when they're added to a deployment, which will enable VDI-type deployments to keep count of total network resources used by their hosts (e.g. in case the hosts are leased from a VPS provider) - the problem here is we can't currently know for sure when a host was shut down, so we don't know exactly when to update the offsets. This likely won't be implemented.

All values will be stored as Long - this will limit them to values up to 2^63 (as Java currently only uses signed longs). This is probably okay and we would not have to deal with wraparound values. Null values will correspond to hosts/VMs residing in incompatible clusters.

##### Entity Description

No new entities need to be implemented, but NetworkStatistics (used by both host and VM interfaces) will be added total RX, total TX and sample time members. VmNetworkStatistics would also need offset members for both RX and TX. Corresponding columns will be added to the vds_interface_statistics and vm_interface_statistics tables, whose DAOs will have to be updated accordingly. Related views will need to be updated as well.

##### Engine Flows

Whenever new statistics reported by vdsm (either for a host or for a VM) are collected for persistence to the DB, and assuming cluster compatibility version >= 3.6 (otherwise leave things as they are):

*   Total RX/TX should be updated (in the case of VMs, after accounting for the offset at the time).
*   The sample time should be stored as is.
*   RX/TX rates should be computed from the difference between the sample and the difference between sample times.

As described earlier, RX/TX offsets will need to be updated whenever a VM is shut down, powered off or migrated (possibly as a trigger of status changes), and whenever a VM interface is unplugged or hotunplugged (possibly depending on cluster compatibility version, shouldn't matter but cleaner if we don't set any values for incompatible clusters).

##### User Experience

The "new" statistics should be reported as additional columns in all the existing tables where interface statistics are displayed: host/interfaces subtab, VM/interfaces subtab, network/hosts subtab, network/VMs subtab.

##### Installation/Upgrade

As clusters aren't automatically upgraded whenever a deployment is upgraded, no elaborate scripts should be required (only addition of columns to tables). However, upgrading a cluster version or moving a host/VM between clusters of different compatibility version should have some effect on the new cumulative values.

When upgrading a cluster to a version >= 3.6, all VMs in the cluster should have their RX/TX offsets set to zero (rather than null). The statistics themselves need not be taken care of - they will be updated whenever statistics are collected for the first time in the new cluster. Similar behavior should be implemented when moving a specific VM from an incompatible cluster to a compatible one.

In the opposite direction, i.e, when moving a VM to an incompatible cluster, cumulative statistics should be reset so that it doesn't appear as if they're still being collected. This has the disadvantage of losing data whenever a VM is moved to an incompatible cluster, then back to a compatible cluster - but in such cases, we would be "missing" any additional traffic on the VM's interfaces while it's running in the incompatible cluster (so we would have, in effect, already lost data integrity).

### Documentation / External references

*   RFE for vdsm to report total byte count: <https://bugzilla.redhat.com/show_bug.cgi?id=1066570>.
*   RFE for engine to report it via the GUI and REST: <https://bugzilla.redhat.com/show_bug.cgi?id=1063343>
*   RFE requesting better accounting information in general: <https://bugzilla.redhat.com/show_bug.cgi?id=1172153>
*   Workaround using existing reported rates: <http://lists.ovirt.org/pipermail/users/2014-November/029048.html>
*   Various other requests on the users@ovirt.org mailing list.

### Testing

#### Host interfaces

*   Verify the reported RX/TX values correspond to the ones reported inside the host itself, when running for example "ip -s link show" on the interface.
*   Initiate constant traffic on a host interface (for example by using iperf), of a rate lower than the interface's speed divided by 1000. Verify that while no rate is displayed, the total byte count increases as expected.

#### VM interfaces

*   Verify that when a new VM is created, total RX/TX statistics show zero.
*   Run the same tests as with host interfaces.
*   Migrate the VM - make sure that after the VM finishes migrating, total RX/TX statistics don't reset to zero.

### Contingency Plan

Could be postponed to the next minor version - this feature doesn't provide critical functionality, and workarounds exist.

### Comments and Discussion

At the moment there don't appear to be any open issues concerning this feature. The feature is being discussed in a dedicated thread on the users@ovirt.org mailing list.

<Category:Feature>
