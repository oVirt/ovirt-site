---
title: XBZRLE and Auto-Convergence
authors: mbetak
---

# XBZRLE and Auto-Convergence

## XBZRLE compression

By using XBZRLE (Xor Binary Zero Run-Length-Encoding) we can reduce VM downtime and total live-migration time of VMs running memory write intensive workloads typical of large enterprise applications such as SAP ERP Systems, and generally speaking for any application with a sparse memory update pattern.

On the sender side XBZRLE is used as a compact delta encoding of page updates, retrieving the old page content from an LRU cache (default size of 64 MB). The receiving side uses the existing page content and XBZRLE to decode the new page content.

Work was originally based on research results published VEE 2011: Evaluation of Delta Compression Techniques for Efficient Live Migration of Large Virtual Machines by Benoit, Svard, Tordsson and Elmroth. Additionally the delta encoder XBRLE was improved further using XBZRLE instead.

## Auto-Convergence

Busy enterprise workloads hosted on large sized VM's tend to dirty memory faster than the transfer rate achieved via live guest migration. Despite some good recent improvements (& using dedicated 10Gig NICs between hosts) the live migration may NOT converge.

Recently support was added in qemu (version 1.6) to allow a user to choose if they wish to force convergence of their migration via a new migration capability : "auto-converge". This feature allows for qemu to auto-detect lack of convergence and trigger a throttle-down of the VCPUs.

## Engine implementation

Support for configuration for above options at 3 levels:

*   engine-config -s (DefaultAutoConvergence|DefaultMigrationCompression)=(true|false)
*   cluster: true/false/inherit global ^^ setting
*   vm: true/false/inherit cluster ^^ setting

## VDSM implementation

Support for 2 new migration parameters autoConverge and migrateCompressed delegating to libvirt the appropriate flags.

Note: XBZRLE compression is supported in libvirt since RHEL 7.0 and auto-convergence since RHEL 7.1.

## Relevant patches

<http://gerrit.ovirt.org/#/c/31991/> (merged)

<http://gerrit.ovirt.org/#/c/31992/> (merged)

<http://gerrit.ovirt.org/#/c/32495/>

<http://gerrit.ovirt.org/#/c/32132/>

<http://gerrit.ovirt.org/#/c/32133/>

## Owner

*   Name: Martin Betak (Mbetak)
*   Email: <mbetak@redhat.com>
