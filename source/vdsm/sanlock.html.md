---
title: SANLock
category: vdsm
authors: danken, fsimonce, teigland
wiki_category: Vdsm
wiki_title: SANLock
wiki_revision_count: 8
wiki_last_updated: 2012-04-13
---

# SAN Lock

## Sanlock Introduction

The sanlock daemon manages leases for applications running on a cluster of hosts with shared storage. All lease management and coordination is done through reading and writing blocks on the shared storage. Two types of leases are used, each based on a different algorithm:

*   **delta leases** are slow to acquire and require regular i/o to shared storage. A delta lease exists in a single sector of storage. Acquiring a delta lease involves reads and writes to that sector separated by specific delays. Once acquired, a lease must be renewed by updating a timestamp in the sector regularly. sanlock uses a delta lease internally to hold a lease on a host_id. host_id leases prevent two hosts from using the same host_id and provide basic host liveliness information based on the renewals.

<!-- -->

*   **paxos leases** are generally fast to acquire and sanlock makes them available to applications as general purpose resource leases. A paxos lease exists in 1MB of shared storage (8MB for 4k sectors). Acquiring a paxos lease involves reads and writes to max_hosts (2000) sectors in a specific sequence specified by the Disk Paxos algorithm. paxos leases use host_id’s internally to indicate the owner of the lease, and the algorithm fails if different hosts use the same host_id. So, delta leases provide the unique host_id’s used in paxos leases. paxos leases also refer to delta leases to check if a host_id is alive.

Before sanlock can be used, the user must assign each host a host_id, which is a number between 1 and 2000. Two hosts should not be given the same host_id (even though delta leases attempt to detect this mistake). sanlock views a pool of storage as a "lockspace". Each distinct pool of storage, e.g. from different sources, would typically be defined as a separate lockspace, with a unique lockspace name.

Part of this storage space must be reserved and initialized for sanlock to store delta leases. Each host that wants to use the lockspace must first acquire a delta lease on its host_id number within the lockspace. (See the add_lockspace action/api). The space required for 2000 delta leases in the lockspace (for 2000 possible host_id’s) is 1MB (8MB for 4k sectors). (This is the same size required for a single paxos lease).

<Category:Vdsm>
