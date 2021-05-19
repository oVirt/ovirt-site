---
title: Engine support for PPC64
category: feature
authors: gustavo.pedrosa, lbianc, ppinatti, roy, vitordelima
---

# Engine support for PPC64

## Summary

Implement support in ovirt-engine to manage KVM on IBM POWER processor based hosts.

## Owner

*   Feature owner: Paulo de Rezende Pinatti <ppinatti@linux.vnet.ibm.com>
    -   GUI Component owner: Nathan Augusto Ozelim <natoze@linux.vnet.ibm.com>
    -   Engine Component owner: Fernando Granha Jeronimo <fgranha@linux.vnet.ibm.com>
    -   Developers: Leonardo Bianconi <leonardo.bianconi@eldorado.org.br>; Vitor de Lima <vitor.lima@eldorado.org.br>; Gustavo Frederico Temple Pedrosa <gustavo.pedrosa@eldorado.org.br>

## Current status

Status: Released.

## Important notes about ppc64 support

Currently QEMU for ppc64 has some missings features which should not be used when administrating VMs for this architecture, these features include:

*   Suspension

The suspend option in the "Virtual Machines" tab should not be used until QEMU supports this feature.

*   Migration

Migration does not work, so as a workaround the "Do Not Migrate Virtual Machines" option in the "Resilience Policy" tab should be used when creating clusters. Also, every ppc64 VM should be pinned to a Host, this can be done by choosing the "Do not allow migration" in the "Migration Options" section of the "Host" tab in the "New Virtual Machine" dialog.

*   Memory Snapshots

Memory snapshots are not supported yet, so the "Save memory" option in the "Create Snapshot" dialog must not be checked.

*   Boot order

The "Boot Sequence" section in the "Boot Options" tab of the "New/Edit Virtual Machine" dialog is ignored by QEMU, the boot order is always fixed no matter what is defined in this section.

*   Alignment scans

libguestfs is not properly supported on ppc64 hosts, this affects only the "Scan Alignment" available in the context menu of Disks.

*   Self Hosted Engine

The Self Hosted Engine functionality was not implemented yet.

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

And in the VmInfoBuilder object the method would make use of the appropriate arch strategy logic:

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

**Cluster and architecture related changes** [[18226]](http://gerrit.ovirt.org/18226)

After have added the architecture field in the cluster, the following validations are necessary:

* Do not allow cluster architecture be changed (processor name of different architecture) while there are VMs and hosts attached.

* Do not allow hosts of different architectures be attached in the same cluster.

**Architecture support for VM and Template** [[18227]](http://gerrit.ovirt.org/18227)

After have added the architecture field in VM and Template, commands and UI validation related with architecture were added:

* Do not allow add VMs and Pools if the selected template (except the blank one) hasn't the same architecture of the selected cluster.

* Do not allow add VMs, Templates or Pool if the selected cluster has blank processor name (processor name indicates the architecture).

* Do not allow change the cluster on host and VM if they have different architecture.

* Do not allow migrate VMs if the destination host has different architectures.

* Do not allow change the cluster of a VM if the destination cluster has a different architecture.

**Prevent architecture mismatches in the frontend** [[19132]](http://gerrit.ovirt.org/#/c/19132)

This patch introduces some changes in the frontend in order to prevent the user from making mistakes and receive errors from the backend commands. These changes include:

* Show only CPUs compatible with the cluster's current CPU when editing clusters

* Show only clusters with the same architecture as the host when editing hosts

* Show only clusters with the same architecture as the VM, Pool or Template when editing them

* Show only clusters with the same architecture as the VM used as a model when creating a template

* Hide clusters without a CPU name in the 'New VM' and 'New Pool' dialogs

**Show only supported displays** [[17885]](http://gerrit.ovirt.org/17885)

Some displays are not compatible with a specific architecture, for example the Spice one is not compatible with PPC64 architecture. So this change uses information from the osinfo property file to load a list of supported displays per OS and blocks the selection of the ones that are not in the list, since there is an enum to handle all supported displays in the system.
Also this change adds the display and its protocol, so a protocol can be related to different displays.

OSInfo property responsible for display protocols:

    os.other.displayProtocols.value = vnc/cirrus,qxl/qxl

**Show only supported disk interfaces** [[17964]](http://gerrit.ovirt.org/17964)

As displays, some disk interfaces, cannot be compatible with an OS or an architecture, so a new property was added in the OSInfo file to handle this case.

OSInfo property responsible to show specific disk interfaces:

    os.other_ppc64.devices.diskInterfaces.value = VirtIO, VirtIO_SCSI

**Disk interface validation** [[18648]](http://gerrit.ovirt.org/#/c/18648)

It introduces a validation to check if the disk interface is compatible with the selected operating system.

**Show only compatible OSes** [[17972]](http://gerrit.ovirt.org/17972)

For oVirt support for multiplatform, the OSes in the OSInfo property file are architecture specific. In the frontend they must be filtered based on the architecture, so this change shows only the compatible OSes on the VM and Pool screen. The filter is based on the OSInfo property bellow:

    os.other_ppc64.cpuArchitecture.value = ppc64

**Show only supported watchdogs** [[18221]](http://gerrit.ovirt.org/18221)

This change adds, for each OS, the list of watchdogs supported and filters it on the screen. The following property is the one created in the OSInfo property file:

    os.other.watchDogModels.value = i6300esb,ib700

**Watchdog model validation** [[18448]](http://gerrit.ovirt.org/#/c/18448)

It introduces a validation to check if the watchdog model is compatible with the selected operating system.

**Architecture parameter on search backend** [[19010]](http://gerrit.ovirt.org/#/c/19010)

This change adds a search parameter used to filter the architecture of VMs, Templates, Clusters, Pools and Hosts. In other words, the user can show only entities with a specific architecture.

**Vnic hotplug validation** [[19188]](http://gerrit.ovirt.org/#/c/19188)

This change modifies the way hotplus is indicated in the system, adding it to the OSInfo property file. The following lines were added:

       os.{id}.devices.network.hotplugSupport.value = true
       os.{id}.devices.network.hotplugSupport.value.3.0 = false

**Vnic hotplug validation** [[19189]](http://gerrit.ovirt.org/#/c/19189)

Based on the change **19188**, this change add the new way to check if a nic can be hotpluged.

### Backend related changes

**Add POWER 7 to the CPU list** [[17853]](http://gerrit.ovirt.org/17853)

It introduces the POWER 7 CPU names to the list of supported CPUs in the oVirt data base. Along with this change, a new CPU attribute was created, the architecture. Now each processor name in the data base is related with an architecture type. This also includes an Enum (called `ArchitectureType`) to internally distinguish the architecture of each supported processor. The `ClusterEmulatedMachines configuration` value was changed to include the "pseries" emulated machine. See bellow the Power CPUs added:

    IBM POWER 7 v2.3
    IBM POWER 7 v2.0
    IBM POWER 7 v2.1

**Initial support for alternative architectures** [[18938]](http://gerrit.ovirt.org/#/c/18938)

It introduces a field to indicate the target architecture of VM, Templates and clusters present in the engine. This field is used in architecture related code in order to introduce support for the IBM POWER systems. The commands responsible for adding and updating these entities were modified, along with the REST API, the DAOs, the database and the frontend.

**New OS for IBM POWER support** [[18220]](http://gerrit.ovirt.org/18220)

An new operating system was introduced in this change, which contains the characteristics of the PPC64 architecture. It includes also some information about disk interfaces that will be used in other following patches. See bellow the new OS added in the OSInfo property file:

    os.other_ppc64.id.value = 1001
    os.other_ppc64.name.value = Other OS
    os.other_ppc64.linux.derivedFrom.value = other
    os.other_ppc64.cpuArchitecture.value = ppc64
    os.other_ppc64.bus.value = 64
    os.other.displayProtocols.value = vnc/vga
    os.other_ppc64.devices.network.value = pv
    os.other_ppc64.devices.diskInterfaces.value = VirtIO, VirtIO_SCSI

**Fill and check arch when importing VM and Template from OVF** [[18702]](http://gerrit.ovirt.org/18702)

The OVF files doesn't have a field to handle the architecture, so when importing a VM or Template from it, the architecture is obtained from its OS. The system reads the OS and using the OSInfo property file, the architecture is obtained.

**OVF import in multiple architecture scenario** [[19012]](http://gerrit.ovirt.org/#/c/19012)

This change prevents the user from import VMs and templates with different architectures into the same cluster. This is done by showing a warning when there are selected VMs with different architectures in the Import VM and Import Template dialog. Also, when the Import VM dialog is shown the only clusters displayed in the dialog are the ones compatible with the architecture of the selected VMs and templates.

**OS type validation** [[18347]](http://gerrit.ovirt.org/18347)

For multiplatform support, the OSes now are architecture specific, so VM must be compatible with the OS used to create it. In all commands for these structures were added a validation to check this compatibility.

**SCSI CD-ROM on PPC64 VMs** [[18622]](http://gerrit.ovirt.org/18622)

It introduces the proper creation of the virtual CD device on PPC64 VMs. This device must be attached to a SPAPR VSCSI controller, since currently the SCSI CD doesn't work with the VirtIO SCSI controller. For that, the following lines were added in the OSInfo property file:

    # for x86_64
    os.other.cdInterface.value = ide

    # for ppc_64
    os.other_ppc64.cdInterface.value = scsi

**Display type validation** [[18150]](http://gerrit.ovirt.org/18150)

The operating system, described in the OSInfo property file, now has a property to set the supported displays. This change checks the compatibility between the selected displays and the operating system. OSInfo property used to check compatibility:

    os.other_ppc64.devices.diskInterfaces.value = VirtIO, VirtIO_SCSI

**VM Device Type for Display Type** [[18677]](http://gerrit.ovirt.org/18677)

This change adds VM Device Type for Display Type in property file. The attribute VM Device Type for each OS is present in the os info property file as bellow:

    os.other.displayProtocols.value = vnc/cirrus,qxl/qxl

The attribute VM Device Type in the Display Type now is the default value if none is found in the os file.

### TODO

*   change DisplayType.qxl to DisplayType.spice which is more appropriate and reads clearer both in config and in the code
*   refactor and cleanup CpuFlagManager so it would be open to extention - started with <http://gerrit.ovirt.org/#/c/19905> - Roy
*   ensure the Version (3.3? 3.4?) ppc emulated machine is reported on

## Benefits to oVirt

oVirt will be able to support IBM POWER processor based hosts and have a code base design suitable to include new architectures.

## Dependencies / Related Features

VDSM

## Documentation / External references

<http://en.wikipedia.org/wiki/Strategy_pattern>

[Features/Vdsm_for_PPC64](/develop/release-management/features/virt/for-ppc64.html)
