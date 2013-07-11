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

The ovirt PPC64 support is planned to be developed in 3 phases, which phase 1 is actually under review:

### Phase 1 (WIP)

On this phase all strategy structure was created to handle the architecture specific code. In order not add hard-coded parameters, a property file to store architecture data was create and it works like OS property file. As each OS refers to an architecture, the property file as modified to handle the architecture type, where each OS refers to an architecture.

**1. File "archinfo-defaults.properties"**

This is the architecture data file and is read like an osinfo property file. It stores all disk interfaces, default OS and if it supports hot plugging for each architecture. File content for x84_64:

      arch.x86_64.devices.diskInterfaces.value = ide, virtio
      arch.x86_64.devices.diskInterfaces.value.version.3.3 = ide, scsi, virtio
      arch.x86_64.devices.diskHotPluggingSupported.value = true
      arch.x86_64.defaultOs.value = 1000

**2. Modification in the file osinfo-defaults.properties**

Each OS need to be architecture specific, so to handle that, the unassigned OS was splited into two: os.Unassigned_x86_64 and os.Unassigned_ppc64. All other OSes are derived from one of these. The OS filter is done on runtime based on the architecture type. Content for unassigned x86_64 OS:

      os.Unassigned_x86_64.id.value = 0
      os.Unassigned_x86_64.name.value = default OS
      os.Unassigned_x86_64.family.value = Other
      os.Unassigned_x86_64.cpuArchitecture.value = x86_64
      os.Unassigned_x86_64.bus.value = 32
      os.Unassigned_x86_64.resources.minimum.ram.value = 256
      os.Unassigned_x86_64.resources.maximum.ram.value = 64000
      os.Unassigned_x86_64.resources.minimum.disksize.value = 1
      os.Unassigned_x86_64.resources.minimum.numberOsCpus.value = 1
      os.Unassigned_x86_64.spiceSupport.value = true
      os.Unassigned_x86_64.id.value = 0
      os.Unassigned_x86_64.devices.audio.value = ich6
      os.Unassigned_x86_64.devices.network.value =  rtl8139, e1000, pv

Sample of OS based on unassigned x86_64:

      os.Windows.id.value = 200
      os.Windows.name.value = Windows
      os.Windows.derivedFrom.value = Unassigned_x86_64
      os.Windows.description.value = General Windows OS
      os.Windows.family.value = windows
      os.Windows.devices.audio.value = ac97
      os.Windows.sysprepPath.value = ""
      os.Windows.productKey.value = ""

**3. The Strategy Design Patter was added and is based on the classes:**

ArchStrategyFactor This class is the factory for strategy, which can be obtained by architecture name or by cpu name and cluster version. ArchStrategy The abstract class, which is the base for each architecture supported by the system. This class contains all the generic methods. X86_64Strategy Specific class for x84_64 architecture. Actually this class is empty (no methods), because all architecture specific itens, untill now, are placed in the "archinfo-defaults.properties" file. This class will contain methods when a specific architecture code become necessary. PPC64Strategy Specific class for PPC64 architecture. It is an empty (no methods) class for the same reason of X86_64Strategy class.

**4. ArchitectureData Class**

This class was created to store all information about architecture from the "archinfo-defaults.properties" during the run time. It is initialized when server goes up and on the client side right after the user login.

**5. ArchStrategy functionalities**

For this first phase the folowing functionalities are being handled by ArchStrategy: Check which OSes are supported Check which disk interfaces are supported Check if hot plugging is supported Get the default OS for each architecture Check which clusters are supported Check if a CPU is supported Check is two different CPUs are compatible

**All these changes were placed on the code and tested to do not create bugs on the functionality. The system will work with no changes for the final user.**

**6. Changes in the CpuFlagsManagerHandler class**

The CpuFlagsManagerHandler was modified to support the POWER architecture, the ServerCpuList field of the vdc_options table was changed to include the architecture of each supported processor and to be able to handle CPUs manufactured by IBM.

**7. Changes in the frontend**

Small changes in the frontend were implemented to avoid the creation of invalid VM configurations and improper configurations of clusters, pools, VMs, templates and hosts. Additional details are listed in the commit message of the associated gerrit change.

**8. Code submited for review**

[Patch 1 - <http://gerrit.ovirt.org/#/c/16700/>](http://gerrit.ovirt.org/#/c/16700/)
[Patch 2 - <http://gerrit.ovirt.org/#/c/16701/>](http://gerrit.ovirt.org/#/c/16701/)
[Patch 3 - <http://gerrit.ovirt.org/#/c/16702/>](http://gerrit.ovirt.org/#/c/16702/)

### Phase 2 (Planned)

The code for providing the support for IBM POWER systems will be added. The encapsulation done in the previous phase will reduce the effort to include this feature into the engine. The other changes that will be introduced in this phase include:

* Modifications in the frontend to avoid running a VM created on a POWER host in a x86-64 host (and vice-versa),
* All the dynamically provided capacities of the first phase will be implemented according to the capacities of the QEMU/KVM on POWER
* The POWER processors will be available as an option in the list of processor names (this will imply in significant changes in the backend)

### Phase 3 (Planned)

Adapt secondary features to polish the support for POWER:

* OVF import and export of VMs running in POWER hosts
* Dynamic searches capable of finding hosts, pools, vms and clusters according to their architectures

## Benefits to oVirt

oVirt will be able to support IBM POWER processor based hosts and have a code base design suitable to include new architectures.

## Dependencies / Related Features

VDSM

## Documentation / External references

<http://en.wikipedia.org/wiki/Strategy_pattern>

[Features/Vdsm_for_PPC64](Features/Vdsm_for_PPC64)

## Comments and Discussion

<Category:Feature>
