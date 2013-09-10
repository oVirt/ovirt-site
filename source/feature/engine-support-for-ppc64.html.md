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
    -   Developers: Leonardo Bianconi <leonardo.bianconi@eldorado.org.br>; Vitor de Lima <vitor.lima@eldorado.org.br>; Gustavo Pedrosa <gustavo.pedrosa@eldorado.org.br>

## Current status

Status: Phase 1 work in progress.

Last updated: Jul 11, 2013

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

For instance, in the VmInfoBuilder.java, an architecture specific code similar to the one shown below can be added to the addCdDetails:

        // CDROM addresses for PPC64 must be treated differently from x86_64
        strategy.addCdromAddress(struct);

And in the VmInfoBuilder object the method would make use of the appropriate arch strategy logic

        public class ArchStrategyFactory {
            private static final EnumMap<ArchitectureType, ArchStrategy> architectureArchStrategyMap =  new EnumMap<ArchitectureType, ArchStrategy>(ArchitectureType.class);

            public static ArchStrategy getStrategy(ArchitectureType architecture) { 
                return architectureArchStrategyMap.get(architecture);
            }
        } 

        public void addCdromAddress(Map<String, Object> cdromDevice) {
            Map<String, String> cdromAddress = new HashMap<String, String>();
            /*... create the appropriate addresses for architecture specific*/
            cdromDevice.put(VdsProperties.Address, cdromAddress);
        }

Moreover, the strategy class can be used to list domain values. Instead of directly accessing an arch specific enum it would get the strategy associated to the context and ask it to list the available types and default values such as `contextObject.listDisplayTypes();` and `contextObject.getDefaultDisplayType();` (Important, this is only an example, since the OSInfo handle many of these cases).

### OSInfo Repository

After OSInfo implementation, many hard-coded architecture code specific will be removed, such as display types, network interfaces, etc. For that, the OSInfo will handle a basic PPC64 OS, which will set the basic configuration for PPC64 Platform. Example:

    os.other_ppc64.cpuArchitecture.value = ppc64
    os.other_ppc64.name.value = Other OS
    os.other_ppc64.spiceSupport.value = true
    os.other_ppc64.displayProtocols.value = vnc/cirrus
    ...

For new PPC64 OSes, will be only necessary create a new OS instance, which derivate from the generic one, like all other x86_64.

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

## Development

The oVirt PPC64 support is in development status and the following changes are under review:

### Frontend related changes

**Cluster and architecture related changes**

The following validations for cluster architecture were added:

*   Do not allow clusters to change their architecture (processor name of different architecture) while there are VMs and hosts attached
*   Do not allow clusters to accept hosts with different architectures

**Architecture support for VM and Template**

Commands and UI validation were added with this change. The following rules were added:

*   Check if template has the same architecture of the selected cluster when adding VMs and pools
*   Check if the selected cluster has blank processor name when updating and adding VMs, templates and pools
*   Check compatibility of cluster architecture when editing host and VMs
*   When migrating VMs the destination host must have the same architecture of the cluster
*   Do not allow VMs to change their clusters if the destination cluster has a different architecture

**Show only supported displays**

This change uses the information from osinfo to avoid the selection of SPICE on operating systems that do not support it. This is also used to disable the SPICE protocol on POWER hosts, because the operating systems are architecture specific.

OSInfo property responsible to hide SPICE protocol:

    os.other_ppc64.spiceSupport.value = false

**Show only supported disk interfaces**

It uses information from the osinfo to avoid the selection of disk interfaces that are not supported by the chosen operating system. This was created in order to avoid the use of IDE interfaces on POWER hosts.

OSInfo property responsible to show specific disk interfaces:

    os.other_ppc64.devices.diskInterfaces.value = VirtIO, VirtIO_SCSI

**Show only compatible OSes**

It modifies the frontend to show only OSes compatible with the architecture of the VM or pool being created. The filter is based on the OSInfo property bellow:

Example for PPC64:

    os.other_ppc64.cpuArchitecture.value = ppc64

**Show only supported watchdogs**

On fontend, only the compatible watchdogs with the OS are displayed. These compatible values are found in the OSInfo propety file. The following property contains the compatible watchdogs for each OS:

    os.other.watchDogModels.value = i6300esb,ib700

### Backend related changes

**Add POWER 7 to the CPU list**

This change introduces the POWER 7 to the list of supported CPUs in the oVirt data base. This also includes an Enum (called `ArchitectureType`) to distinguish the architecture of each supported processor. The `ClusterEmulatedMachines` configuration value was changed to include the "pseries" emulated machine. Power CPUs added:

    IBM POWER 7 v2.3
    IBM POWER 7 v2.0
    IBM POWER 7 v2.1

**Initial support for alternative architectures**

It intorduces a field to indicate the target architecture of VM, Templates and clusters present in the engine. This field is used in architecture related code in order to introduce support for the IBM POWER systems. The commands responsible for adding and updating these entities were modified, along with the REST API, the DAOs, the database and the frontend.

**New OS for IBM POWER support**

This change introduces an operating system which contains the characteristics of the IBM POWER architecture. It includes also some information about disk interfaces that will be used in other following patches. See bellow the new OS added in the OSInfo property file:

    os.other_ppc64.id.value = 1001
    os.other_ppc64.name.value = Other OS
    os.other_ppc64.linux.derivedFrom.value = other
    os.other_ppc64.cpuArchitecture.value = ppc64
    os.other_ppc64.bus.value = 64
    os.other_ppc64.spiceSupport.value = false
    os.other_ppc64.devices.network.value = pv
    os.other_ppc64.devices.diskInterfaces.value = VirtIO, VirtIO_SCSI

**Fill and check arch when importing VM and Template from OVF**

When importing a VM or Template from OVF files, the architecture is obtained from its OS. The system reads the OS and using the OSInfo property file, the architecture is taken.

**OS type validation**

For VM ant Template the OS must be compatible with its architecture. In all commands for these structures were added a validation to check this compatibility.

**SCSI CD-ROM on PPC64 VMs**

This change introduces the proper creation of the virtual CD device on PPC64 VMs. This device must be attached to a SPAPR VSCSI controller, since currently the SCSI CD doesn't work with the VirtIO SCSI controller. For that, the following lines were added in the OSInfo property file:

    # for x86_64
    os.other.cdInterface.value = ide

    # for ppc_64
    os.other_ppc64.cdInterface.value = scsi

**Display type validation**

This change displays an error if the display type is not compatible with the selected operating system.

**VM Device Type for Display Type**

This change adds VM Device Type for Display Type in property file. The attribute VM Device Type for each OS is present in the os info property file as bellow:

    os.other.displayProtocols.value = vnc/cirrus,qxl/qxl

The attribute VM Device Type in the Display Type now is the default value if none is found in the os file.

## Benefits to oVirt

oVirt will be able to support IBM POWER processor based hosts and have a code base design suitable to include new architectures.

## Dependencies / Related Features

VDSM

## Documentation / External references

<http://en.wikipedia.org/wiki/Strategy_pattern>

[Features/Vdsm_for_PPC64](Features/Vdsm_for_PPC64)

## Comments and Discussion

<Category:Feature>
