---
title: MomIntegration
category: feature
authors:
  - aglitke
  - ekohl
  - sven
---

# Mom Integration

As discussed at the oVirt Workshop and elsewhere, integrating mom with vdsm will benefit oVirt by providing a mechanism for dynamic, policy-based tuning. This mechanism will pave the way for implementing memory ballooning policies, can enhance migration policy, and will replace the existing ksm tuning thread.

MOM exists today as an independent library that can be used by python programs such as vdsm or in standalone mode (by using the accompanying momd program. Mom's operation is very configurable. The management policy is written in a Fortran-like language and is replaceable by the end user. Additionally, plugins allow you to customize the types of information collected and the manner in which it is collected. Similarly, Controller plugins permit a completely flexible control API to be created.

To integrate mom, vdsm will initialize the mom library in a new thread and start it. Therefore, mom and vdsm will exist in the same process. Vdsm will configure the mom instance to use plugins and a policy that exclusively target the vdsm API. All statistics collection will occur via API calls and any management actions (including adjustments to KSM and VM balloons) will be done through the vdsm api as well. Mom will not use libvirt at all (not even to monitor for new VMs on the system).

![](/images/wiki/Mom-vdsm.png)

## Packaging logistics

Mom is an independent package that is already in Fedora. Any changes to mom that are required to support this integration will be submitted to the mom project for inclusion. Vdsm will consume the standard MOM package as a python module/library.

In order to control its mom instance, vdsm will ship a mom configuration file and a mom policy file that will set mom's default behavior. At startup, vdsmd will import mom and initialize it with the configuration and policy files. From that point on, mom will interact with vdsm through the well-defined API in API.py.

## New features needed in vdsm

In order to fully benefit from mom's capabilities, vdsm should implement the following extra features/APIs:

*   Collection of more memory statistics via ovirt-guest-agent including the current memory balloon value.
*   A vmBalloon API to set a new balloon target.

## Status of this Feature

*   The above described features are fully implemented at the time of this writing (as far as I know).
*   The memory statistics get collected via ovirt-guest-agent through the virtio_serial device.
*   This implies that ballooning only works on supported guest-agent platforms.

