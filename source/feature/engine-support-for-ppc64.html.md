---
title: Engine support for PPC64
category: feature
authors: gustavo.pedrosa, lbianc, ppinatti, roy, vitordelima
wiki_category: Feature
wiki_title: Features/Engine support for PPC64
wiki_revision_count: 33
wiki_last_updated: 2014-04-30
---

# Engine support for PPC64

## Summary

Implement support in ovirt-engine to manage KVM on IBM POWER processor based hosts.

## Owner

*   Feature owner: Paulo de Rezende Pinatti <ppinatti@linux.vnet.ibm.com>
    -   GUI Component owner: Nathan Augusto Ozelim <natoze@linux.vnet.ibm.com>
    -   Engine Component owner: Fernando Granha Jeronimo <fgranha@linux.vnet.ibm.com>

## Current status

Status: design stage

Last updated: Oct 31, 2012

## Detailed description

This feature will add ppc64 architecture awareness to the ovirt-engine code, which currently makes various assumptions based on the x86 architecture. When specifying virtual machine devices for example, what is suitable for x86 architecture may not be for POWER (or may not be available yet).

For example, in the package common.businessentities the enum at VmInterfaceType.java describing some network devices types are not architecture aware and may contain devices not supported by the POWER architecture:

    public enum VmInterfaceType {
        rtl8139_pv(0,"Dual mode rtl8139, Red Hat VirtIO"),
        rtl8139(1,"rtl8139"),
        e1000(2,"e1000"),
        pv(3,"Red Hat VirtIO");

### Approach

It is highly undesirable that a new architecture increases the burden of developing and maintaining the engine code. If new commands required direct architectural gory details manipulation, it would be error prone and would increase code complexity. Therefore an important aspect to be considered is a good encapsulation of architecture differentiation.

An interesting design pattern that can be used is the Strategy pattern mentioned in the GoF book. It encapsulates the specifics of a set algorithms proving a standard interface no matter the underlying implementation, allowing the client to remain decoupled of the unnecessary details. This behaviour is extremely desirable in the canDoAction methods of bll package, once the code will not need to explicitly differentiate an architecture.

For instance, in the specific case of AddVmInterfaceCommand.java a verification similar to the one show below can be added to the canDoAction:

    if (!getVm().validateVmInterface(parameters.getInterfaceType()) {
        addCanDoActionMessage(VdcBllMessages.NETWORK_INTERFACE_WRONG_TYPE);
            return false;
    }

And in the Vm object the method would make use of the appropriate arch strategy object:

    public boolean validateVmInterface(InterfaceType iface) {
        ArchStrategy archStrategy = getArchStrategy();
        boolean result = archStrategy.validateInterface(iface);
        if (!result) {
            return false;
        }
        /* Some more optional validating code
           ...
        */

        return true
    }

    private ArchStrategy getArchStrategy() {   
        ArchStrategy strategy = strategyFactory.get(getArch(), getVersion());
        return strategy;
    }

Moreover, the strategy class can be used to list domain values. Instead of directly accessing an arch specific enum it would get the strategy associated to the context and ask it to list the available types and default values such as `contextObject.listVmInterfaceTypes();` and `contextObject.getDefaultVmInterfaceType();`.

As suggested by Itamar, a new general 'filter' parameter can be created in config to differentiate cpus and devices (disk, network, display) by architecture (such as filter:x86_64). This would be used by the strategy object to validate actions or return valid options.

### CPU flags

To be described.

## Benefits to oVirt

oVirt will be able to support IBM POWER processor based hosts and have a code base design suitable to include new architectures.

## Dependencies / Related Features

VDSM

## Documentation / External references

<http://en.wikipedia.org/wiki/Strategy_pattern>

[Features/Vdsm_for_PPC64](Features/Vdsm_for_PPC64)

## Comments and Discussion

<Category:Feature>
