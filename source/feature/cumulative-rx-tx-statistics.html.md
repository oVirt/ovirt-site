---
title: Cumulative RX TX Statistics
category: feature
authors: danken, lvernia
wiki_category: Feature
wiki_title: Features/Cumulative RX TX Statistics
wiki_revision_count: 26
wiki_last_updated: 2015-01-27
feature_name: Cumulative RX/TX Interface Statistics
feature_modules: engine,vdsm
feature_status: Design
---

# Cumulative RX/TX Interface Statistics

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

##### Entity Description

New entities and changes in existing entities.

##### CRUD

Describe the create/read/update/delete operations on the entities, and what each operation should do.

##### User Experience

Describe user experience related issues. For example: We need a wizard for ...., the behaviour is different in the UI because ....., etc. GUI mockups should also be added here to make it more clear

##### Installation/Upgrade

Describe how the feature will effect new installation or existing one.

##### User work-flows

Describe the high-level work-flows relevant to this feature.

##### Events

What events should be reported when using this feature.

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
