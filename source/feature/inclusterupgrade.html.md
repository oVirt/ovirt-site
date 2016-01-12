---
title: InClusterUpgrade
authors: rmohr
wiki_title: Features/InClusterUpgrade
wiki_revision_count: 47
wiki_last_updated: 2016-01-12
feature_name: In Cluster Upgrade
feature_modules: engine
feature_status: Development
---

# InClusterUpgrade

*   Owner: Roman Mohr
*   Email: <rmohr@redhat.com>
*   Bugzilla: [1241149](//bugzilla.redhat.com/show_bug.cgi?id=1241149)

### Upgrade policy

The upgrade flow is centered arount a new cluster upgrade policy called *' InClusterPolicy*' which consists of the **InClusterUpgradeFilterPolicyUnit** and the **InClusterUpgradeWeightPolicyUnit**. When these two policy units are activated, it should be save to mix different major host OS versions. VMs will only migrate to newer hosts and will not migrate back. To allow the activation of these policy units, some preconditions have to be met which are described later.

#### Filter - InClusterUpgradeFilterPolicyUnit

The filter is responsible for filtering out all hosts which run older OS versions than the host the VM is currently running on. In other words, the filter forbids downgrades. So a VM which is running on Fedora 22 can migrate to Fedora 22 or Fedora 23 but not to Fedora 21. Once it is on a Fedora 23 host, only other Fedora 23 hosts are viable targets. When a VM was shut down, it can start on any host in the cluster.

#### Weight - InClusterUpgradeWeightPolicyUnit

The weight policy unit gives an OS which is newer than the OS where the VM is currently running on no penalty. It penalizes OS versions significantly which are running the same OS versions. Finally older OS versions are penalized even more. The policy makes sure that hosts with newer major versions of an OS will be preferred when a VM is migrating.

### Overview of activated and deactivated features

| PolicyUnit                   | Considerations               | UUID                                 |
|------------------------------|------------------------------|--------------------------------------|
| EmulatedMachineFilter        | keep                         | Has no fixed uuid                    |
| NoneBalance                  | disabled                     |
| EvenDistributionBalance      | disabled                     |
| HaReservationWeight          | disabled                     |
| PowerSavingWeight            | disabled                     |
| EvenDistributionWeight       | disabled                     |
| HostedEngineHAClusterFilter  | disabled                     |
| HaReservationBalance         | disabled                     |
| CpuAndMemoryBalancing        | disabled                     |
| PowerSavingBalance           | disabled                     |
| EvenGuestDistributionWeight  | disabled                     |
| Network                      | keep?                        | 72163d1c-9468-4480-99d9-0888664eb143 |
| EvenGuestDistributionBalance | disabled                     |
| HostedEngineHAClusterWeight  | disabled, HE is out of scope |
| Migration                    | keep                         | e659c871-0bf1-4ccc-b748-f28f5d08ddda |
| NoneWeight                   | disabled                     |
| Memory                       | keep                         | c9ddbb34-0e1d-4061-a8d7-b0893fa80932 |
| CPU                          | keep                         | 6d636bf6-a35c-4f9d-b68d-0731f720cddc |
| VmAffinityFilter             | disabled                     |
| VmAffinityWeight             | disabled                     |
| PinToHost                    | disabled                     |
| HostDeviceFilter             | disabled                     |
| CpuLevelFilter               | keep                         | 438b052c-90ab-40e8-9be0-a22560202ea6 |
| CpuPinningPolicy             | disabled (not yet merged)    |
| NumaPinningPolicy            | disabled (not yet merged)    |
| InClusterUpgradeFilter       | mandatory                    |
| InClusterUpgradeWeight       | mandatory                    |

#### Preconditions to allow policy activation

*   No suspended VMs are allowed in the cluster
*   No CPU pinning on any VM in the cluster
*   No NUMA pinning on any VM in the cluster
*   No preferred hosts with migration strategy "No migrations allowed" on any VM in the cluster
*   No PCI pass through on any VM in the cluster

#### Limitations during upgrade

*   Suspending VMs is forbidden
*   HA reservation for VMs is disabled. But the engine will still try to restart HA VMs if they are failing
*   Affinity Groups will not be respected. After the upgrade is done the Affiniy Rules Enforcement Manager will reestablish them
*   No load balancing will happen
*   Migrating a VM back to an older OS version is not possible during upgrade. To run a VM on an older host OS, the VM hast to be stopped first.

#### What might stop you from putting a host to maintenance

*   Missing networks

Since affinity will be ignored through the upgrade process, the affinity rules enforcement manager will be disabled.

### Upgrade Flow from 3.5 to 3.6

1.  Enable the upgrade mode with `engine-config -s CheckMixedRhelVersions=false --cver=3.5` (This allows to set the InClusterUpgrade policy).
2.  Restart the engine
3.  Set the InClusterUpgrade Policy on the desired cluster (this allows mixing different major host OS versions)
    1.  When saving this cluster configuration change a lot of checks are happening. They are making sure that all preconditions as described above are met
    2.  If setting the policy fails, resolve the mentioned issue and try again

4.  Move a host X to maintenance (If this is the 2nd+ host some VMs will move to el7 machines)
    1.  If needed, pre-migrate VMs manually as a precaution

5.  Upgrade host in place (fedup style) to el7 and reboot to get the new kernel or just install a new image
6.  Activate (fedup) or Reinstall (new image) the host in the engine (should move to ‘up’).
7.  Go to step 4 until all hosts upgraded for this cluster and then reset the scheduling policy.
8.  Increase cluster level to 3.6.
9.  Go to step 3 and repeat for all clusters.
10. Disable the config from step 1 with `engine-config -s CheckMixedRhelVersions=true --cver=3.5`.
11. Restart the engine

### Testing the work in progress version

The final flow is not implemented. See the instructions below to test upgrades with the work in progress version.

What is currently missing?

*   Handling VM snapshots

What is the current upgrade flow?

1.  Install hosted engine from <http://jenkins.ovirt.org/job/ovirt-engine_master_build-artifacts-el6-x86_64_no_spm_testing/55/>
2.  The rest of the flow is like described here: [#Upgrade_Flow_from_3.5_to_3.6](#Upgrade_Flow_from_3.5_to_3.6)
