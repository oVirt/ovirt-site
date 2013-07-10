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

For instance, in the specific case of AddVmInterfaceCommand.java a verification similar to the one shown below can be added to the canDoAction:

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

### CPU flags and families

Ovirt-engine currently relies on x86 cpu flags to identify the cpu model and levels to determine compatibility between cpu families. For example, a cluster can change from family A to family B if level_A <= level_B, which means B has A's features and possibly more. This data is stored in the field ServerCpuList of the vdc_options table, in the format [0]-level, [1]-name, [2]-flags, [3]-verb as below:

    3:Intel Conroe Family:vmx,nx,model_Conroe:Conroe;
    4:Intel Penryn Family:vmx,nx,model_Penryn:Penryn;
    5:Intel Nehalem Family:vmx,nx,model_Nehalem:Nehalem;
    6:Intel Westmere Family:aes,vmx,nx,model_Westmere:Westmere;
    7:Intel SandyBridge Family:vmx,nx,model_SandyBridge:SandyBridge;
    2:AMD Opteron G1:svm,nx,model_Opteron_G1:Opteron_G1;
    3:AMD Opteron G2:svm,nx,model_Opteron_G2:Opteron_G2;
    4:AMD Opteron G3:svm,nx,model_Opteron_G3:Opteron_G3;
    5:AMD Opteron G4:svm,nx,model_Opteron_G4:Opteron_G4;

For IBM POWER, there are no cpu flags available. To be able to correctly identify a KVM enabled IBM POWER machine, the solution is to use the platform identificator string **PowerNV** available in /proc/cpuinfo, as a replacement for the vmx/svm flags.

With regard to family levels, there is no support at the moment for compatibility between POWER families, which means the current implementation does not work. For example, the code below, from UpdateVdsGroupCommand.java, needs to be adapted:

        boolean sameCpuNames = StringUtils.equals(oldGroup.getcpu_name(), getVdsGroup().getcpu_name());
        if (!sameCpuNames) {
            if (suspendedVms) {
                addCanDoActionMessage(VdcBllMessages.VDS_GROUP_CANNOT_UPDATE_CPU_WITH_SUSPENDED_VMS);
                result = false;
            } else if (notDownVms) {
                int compareResult = compareCpuLevels(oldGroup);
                if (compareResult < 0) {
                    addCanDoActionMessage(VdcBllMessages.VDS_GROUP_CANNOT_LOWER_CPU_LEVEL);
                    result = false;
                } else if (compareResult > 0) {// Upgrade of CPU in same compability level is allowed if
                                               // there
                    // are running VMs - but we should warn they
                    // cannot not be hibernated
                    AuditLogableBase logable = new AuditLogableBase();
                    logable.AddCustomValue("VdsGroup", getParameters().getVdsGroup().getname());
                    AuditLogDirector.log(logable,
                            AuditLogType.CANNOT_HIBERNATE_RUNNING_VMS_AFTER_CLUSTER_CPU_UPGRADE);
                }
            }
        }

Due to the fact that there is no notion of a more featured family containing a less one on POWER, it's necessary to adapt the code to encapsulate the x86 levels and report the (non) compatibility between POWER families accordingly. This can be addressed by using again the strategy class which will manage the cpu details and provide functions free of the level semantic:

        boolean sameCpuNames = StringUtils.equals(oldGroup.getcpu_name(), getVdsGroup().getcpu_name());
        if (!sameCpuNames) {  
            if (suspendedVms) {
                addCanDoActionMessage(VdcBllMessages.VDS_GROUP_CANNOT_UPDATE_CPU_WITH_SUSPENDED_VMS);
                result = false;
            } else if (notDownVms) {
                boolean isCompatible = getVdsGroup().isCpuCompatible(oldGroup.getcpu_name())
                if (!isCpuCompatible) {
                    addCanDoActionMessage(VdcBllMessages.VDS_GROUP_CANNOT_UPDATE_INCOMPATIBLE_CPU);
                    result = false;
                } else {
                    // At this point only x86 families as ppc64 are always incompatible between them
                    if (getVdsGroup.cpuHasMoreFeatures(oldGroup.getcpu_name())) {
                        AuditLogableBase logable = new AuditLogableBase();
                        logable.AddCustomValue("VdsGroup", getParameters().getVdsGroup().getname());
                        AuditLogDirector.log(logable,
                        AuditLogType.CANNOT_HIBERNATE_RUNNING_VMS_AFTER_CLUSTER_CPU_UPGRADE);
                    }
                }
            }
        }

    // VDSGroup class encapsulates the strategy object
    public class VDSGroup ...

        public boolean cpuHasMoreFeatures(String otherGroup) {
            ArchStrategy archStrategy = getArchStrategy();
            boolean result = archStrategy.cpuHasMoreFeatures(getcpu_name(), otherGroup);
            return result
        }

        public boolean isCpuCompatible(String otherGroup) {
            ArchStrategy archStrategy = getArchStrategy();
            boolean result = archStrategy.isCpuCompatible(getcpu_name(), otherGroup);
            return result
        }

        private ArchStrategy getArchStrategy() {   
            ArchStrategy strategy = strategyFactory.get(getArch(), getVersion());
            return strategy;
        }

As a result, the ppc64 entries entries in the vdc_options table would look like this:

    :PowerPC 7:powernv,model_POWER7:POWER7;
    :PowerPC 7 v2.1:powernv,model_POWER7_v2.1:POWER7_v2.1;
    :PowerPC 7 v2.3:powernv,model_POWER7_v2.3:POWER7_v2.3;

The level field would be empty to signalize it's not supported.

### GUI considerations

Some options in the user interface may vary according to the architecture. For instance, the operating systems available for a vm are not the same for x86 and ppc64. The engine allows to set functions to be called when certain properties of a model change, this can be used to update the options according to architecture whenever needed. For example, in the event where the selected cluster changes while adding a new vm we include a method to update the list of available operating systems:

        @Override
        public void Cluster_SelectedItemChanged()
        {
            UpdateDefaultHost();
            UpdateCustomProperties();
            UpdateMinAllocatedMemory();
            UpdateNumOfSockets();
            updateQuotaByCluster(null, "");
            updateCpuPinningVisibility();

            // Add method to update the list of oses
            UpdateOperatingSystemOptions();
        }

The function would ask the server for the operating system list:

        public void UpdateOperatingSystemOptions()
        {
            VDSGroup cluster = (VDSGroup) getModel().getCluster().getSelectedItem();

            // this function is responsible for retrieving the OS list from server
            AsyncDataProvider.GetOSList(new AsyncQuery( getModel(),
                    new INewAsyncCallback() {
                        @Override
                        public void OnSuccess(Object target, Object returnValue) {

                            UnitVmModel model = (UnitVmModel) target;
                            ArrayList<VmOsType> osList = (ArrayList<VmOsType>) returnValue;
                            model.getOSType().setItems(osList);
                            model.getOSType().setSelectedItem(VmOsType.Unassigned);

                        }
                    }, getModel().getHash()), cluster.getId());

        }

## Development Phases

### Phase 1

### Phase 2

### Phase 3

### Phase 4

## Benefits to oVirt

oVirt will be able to support IBM POWER processor based hosts and have a code base design suitable to include new architectures.

## Dependencies / Related Features

VDSM

## Documentation / External references

<http://en.wikipedia.org/wiki/Strategy_pattern>

[Features/Vdsm_for_PPC64](Features/Vdsm_for_PPC64)

## Comments and Discussion

<Category:Feature>
