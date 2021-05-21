---
title: VDSM Potential Features
category: vdsm
authors:
  - danken
  - smizrahi
---

# VDSM Potential Features

*   Simplifying using QEMU/KVM
    -   consuming qemu via command line
        -   can we manage/support developers launching qemu directly
    -   consuming qemu via libvirt
        -   can we integrate with systems that are already using libvirt

<!-- -->

*   Addressing issues with libvirt
    -   Are there kvm specific features we can exploit that libvirt doesn't?

<!-- -->

*   Scale-up/fail-over
    -   can we support a single vdsm node, but allow for building up clusters/groups without bringing in something like ovirt-engine
    -   can we look at decentralized fail-over for reliability without a central mgmt server?

<!-- -->

*   pluggability
    -   can we support an API that allows for third-party plugins to support new features or changes in implementation?

<!-- -->

*   kvm tool integration into the API
    -   there are lots of different kvm virt tools for various tasks and they are all stand-alone tools. Can we integrate their use into the node level API. Think libguestfs, virt-install, p2v/v2v tooling. All of these are available, but there isn't an easy way to use this tools through an API.

<!-- -->

*   Host management operations
    -   vdsm already does some host level configuration (see networking e.g.) it would be good to think about extending the API to cover other areas of configuration and updates
    -   hardware enumeration
    -   driver level information
    -   storage configuration (we've got a bit of a discussion going around libstoragemgmt here)

<!-- -->

*   performance monitoring/debugging
    -   is the host collecting enough information to do debug/perf analysis
    -   can we support specific configurations of a host that optimize for specific workloads
    -   and can we do this in the API such that third-parties can supply and maintain specific workload configurations

