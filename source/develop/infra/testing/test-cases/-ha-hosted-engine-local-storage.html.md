---
title: TestCase HA Hosted Engine Local Storage
category: testcase
authors: zordrak
---

# TestCase HA Hosted Engine Local Storage

## Description

Using a HA-Hosted-Engine configuration, it is still desirable to be able to configure storage on a specific host that can only be accessed by that host.

In my specific scenario:

3x High-Capacity Hypervisors with 300GiB RAID10 15kRPM SAS each. Limited inter-host connectivity. HostedEngine installed, highly available across all three hosts using NFS served by glusterd, with gluster replicating across all three hosts and CTDB managing a shared virtual IP address. This permits the management of three hosts, from a single engine interface which may run so long as one host is on-line. One additional HA VM is run for a critical customer-facing web-service using an additional replicated NFS-accessed gluster storage domain.

Each host is then required to run additional VMs where the storage is local:

*   Host A holds vdisks for VMs executed only on Host A.
*   Host B holds vdisks for VMs executed only on Host B.
*   Host C holds vdisks for VMs executed only on Host C.

No live-migration is required or expected for the local VMs. Manual offline migration should be possible with the use of an NFS export domain (or scp file copy if oVirt can support manual export/import).

## Setup

Currently this is not possible because of the hard requirement that all hosts can access all storage domains even if there is no requirement for them to be used on other hosts. To configure Local Storage each host must be in unique clusters which prevents the HA-HostedEngine configuration. Simply sharing the local storage via NFS is not possible because use of gluster-nfs and native nfsd are mutually exclusive, you cannot run both. This means the only possibilities are non-replicated gluster volumes or iSCSI exposure; both similar and unnecessarily complicated solutions. given the existing use of gluster, the gluster solution is probably better.

So, each host creates an unreplicated gluster volume and exposes the "<host>-local-data" storage domain via it's native physical IP using gluster's NFS, from where it can be used by the host on which it resides for VM backing storage.

Given the only obstacle being oVirt design architecture and not any physical or 3rd party problem, it ought to be feasible to permit each host to provide local storage only for use by itself.

