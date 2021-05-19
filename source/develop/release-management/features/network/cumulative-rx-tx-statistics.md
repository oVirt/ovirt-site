---
title: Cumulative RX TX Statistics
category: feature
authors: danken, lvernia
---

# Cumulative Network Usage Statistics

## Summary

This feature will implement reporting of total received/transmitted bytes per network interface (both for hosts and for VMs), on top of the currently-reported receive/transmit rate.

## Owner

*   Name: Lior Vernia
*   Email: lvernia@redhat.com

## Benefit to oVirt

Numerous benefits have been suggested:

*   This data is useful in several use cases (e.g. hosting services), where total VM network usage needs to be accounted for. While it's possible to compute total usage out of the reported rates, it requires implementing some logic in a script, and the precision of the reported rate is limited).
*   Due to the aforementioned limited precision of reported rate (e.g. traffic needs to be bigger, on average over a 15-second period, than an interface's speed divided by 1000 to be reported), reporting the total RX/TX statistics will allow to spot thinner traffic going through the interface, for example to make sure that an interface is operational.
*   The reported 'speed' of each interface is nothing to be trusted. It may change during [1118699 a single measurement window](https://bugzilla.redhat.com/show_bug.cgi?id=1118699), causing currently-reported rxRate/txRate utterly meaningless.

## Detailed Description

Currently, the only network usage statistics reported for network interfaces (whether host or VM) are momentary receive/transmit rates. By popular demand, as part of this feature reporting will be added for total received/transmitted bytes for both hosts and VMs, both in the GUI and via REST.

This will generally be implemented by having vdsm report total RX/TX byte statistics and sample times back to the engine, and having the engine store and show those statistics, as well as compute the average rate from the previous sample rather than depend on the reported vdsm rate (depending on cluster compatibility version).

To store cumulative statistics from the beginning of a VM interface's life to its end, surviving shut downs, migrations and hot-unplugs - these reset the counters on the network devices - we will have to also store for each interface offset numbers for RX and TX traffic (and update whenever one of the above cases happen). A nice touch would be to also keep these offsets for hosts, starting from zero when they're added to a deployment, which will enable VDI-type deployments to keep count of total network resources used by their hosts (e.g. in case the hosts are leased from a VPS provider).

All values will be stored as Long - this will limit them to values up to 2^63 (as Java currently only uses signed longs). This is probably okay and we would not have to deal with wraparound values. Null values will correspond to hosts/VMs residing in incompatible clusters (where the data is not reported so it's not available).

#### Entity Description

No new entities need to be implemented, but NetworkStatistics (used by both host and VM interfaces) will be added total RX, total TX, RX offset, TX offset and sample time members. Corresponding columns will be added to the vds_interface_statistics and vm_interface_statistics tables, whose DAOs will have to be updated accordingly. Related views will need to be updated as well.

#### Engine Flows

Whenever new statistics reported by vdsm (either for a host or for a VM) are collected for persistence to the DB, and assuming cluster compatibility version >= 3.6:

*   Total RX/TX should be updated, after accounting for the offset at the time.
*   The sample time should be stored as reported.
*   RX/TX rates should be computed from the difference between the sampled values divided by the difference between sample times. Special care should be taken with statistics reported for the first time, when the previous sample value and sample time should be null - in which case, it's best to set the rate to null (it will be updated as soon as the next sample arrives). Similar care should be taken if the time interval isn't positive - this likely means that the host had been rebooted and the time measurement had reset.
*   RX/TX offsets should be updated if the reported value is bigger than the previous one - this means that for some reason, RX/TX counters had reset. The offset should be set to the previously reported values (newly sampled values will start from zero again, so they would have to be added to whatever had been accumulated before). This should take care of VM interface hot-unplug, VM migration and host/VM reboot/shutdown. As with the rates, caution should be exercised in the case of a first-time measurement - this would mean that the interface has not been encountered yet, therefore its offset should be set to minus the currently-reported total RX/TX (so that accounting will begin from zero at this point in time).

If the cluster compatibility version < 3.6, rate and drop statistics should be updated as before, and the newly-reported statistics should be set to null (including the internally-used offsets). This should take care of hosts/VMs being moved from a compatible cluster to an incompatible one - whenever the first statistics data arrive in the new cluster, previous values will be cleared.

#### User Experience

The "new" statistics should be reported as additional columns in all the existing tables where interface statistics are displayed: host/interfaces subtab, VM/interfaces subtab, network/hosts subtab, network/VMs subtab.

#### VDSM

New data entries should be added to the NIC dictionaries reported in getVdsStats and getVmStats: "rx", "tx" and "sampleTime".

<http://gerrit.ovirt.org/#/q/status:merged+project:vdsm+branch:master+topic:rx_tx,n,z>

#### REST

New data entries should be added to the host and VM NIC statistical queries: "data.total.rx" and "data.total.tx". There's no apparent reason to expose the sample time, as the existing RFEs haven't asked for it - it could be exposed in the future if need be. The new entries should all be of type "Counter", of value "Integer" and of unit "Bytes".

## Documentation / External references

*   RFE for vdsm to report total byte count: <https://bugzilla.redhat.com/show_bug.cgi?id=1066570>.
*   RFE for engine to report it via the GUI and REST: <https://bugzilla.redhat.com/show_bug.cgi?id=1063343>
*   RFE requesting better accounting information in general: <https://bugzilla.redhat.com/show_bug.cgi?id=1172153>
*   Workaround using existing reported rates: <https://lists.ovirt.org/pipermail/users/2014-November/029048.html>
*   Various other requests on the users@ovirt.org mailing list.

## Testing

### Host interfaces

*   Verify the reported RX/TX values correspond to the ones reported inside the host itself, when running for example "ip -s link show" on the interface.
*   Verify that when a host is moved from a compatible cluster to an incompatible cluster, the total RX/TX statistics are reset.
*   Initiate constant traffic on a host interface (for example by using iperf), of a rate lower than the interface's speed divided by 1000. Verify that while no rate is displayed, the total byte count increases as expected.

### VM interfaces

*   Verify that total RX/TX statistics are reset to zero when:
    -   A new interface is created.
    -   A VM is moved from an incompatible cluster to a compatible cluster.
*   Verify that total RX/TX statistics are NOT reset to zero when:
    -   An interface is hot-unplugged and then hot-plugged back.
    -   The VM is brought down and then up (possibly unplugging and plugging interfaces while the VM is down).
    -   The VM is migrated.
*   Verify that total RX/TX statistics are cleared (not reported) when:
    -   A new interface is created for a VM in an incompatible cluster.
    -   A VM is moved from a compatible cluster to an incompatible cluster.
*   Run the same traffic test as with the host interfaces.

## Contingency Plan

Could be postponed to the next minor version - this feature doesn't provide critical functionality, and workarounds exist.

## Comments and Discussion

At the moment there don't appear to be any critical open issues concerning this feature. The feature is being discussed in a dedicated thread on the users@ovirt.org mailing list.

