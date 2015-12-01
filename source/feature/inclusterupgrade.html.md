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

### Upgrade policy

The upgrade flow is centered arount a new cluster upgrade policy which consists of the InClusterUpgradeFilterPolicyUnit and the InClusterUpgradeWeightPolicyUnit. When these two policy units are activated, it should be save to mix different major host OS versions. VMs will only migrate to newer hosts and will not migrate back. To allow the activation of these policy units, some preconditions have to be met which are described later.

#### Filter - InClusterUpgradeFilterPolicyUnit

The filter is responsible for filtering out all hosts which run older OS versions than the host the VM is currently running on. In other words, the filter forbids downgrades. So a VM which is running on Fedora 22 can migrate to Fedora 22 or Fedora 23 but not to Fedora 21. Once it is on a Fedora 23 host, only other Fedora 23 hosts are viable targets. When a VM was shut down, it can start on any host in the cluster.

#### Weight - InClusterUpgradeWeightPolicyUnit

The weight policy unit gives an OS which is newer than the OS where the VM is currently running on no penalty. It penalizes OS versions significantly which are running the same OS versions. Finally older OS versions are penalized even more. The policy makes sure that hosts with newer major versions of an OS will be preferred when a VM is migrating.

### Overview of activated and deactivated features

| PolicyUnit                   | Considerations               |
|------------------------------|------------------------------|
| EmulatedMachineFilter        | mandatory                    |
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
| Network                      | keep?                        |
| EvenGuestDistributionBalance | disabled                     |
| HostedEngineHAClusterWeight  | disabled, HE is out of scope |
| Migration                    | keep                         |
| NoneWeight                   | disabled                     |
| Memory                       | keep                         |
| CPU                          | keep                         |
| VmAffinityFilter             | disabled                     |
| VmAffinityWeight             | disabled                     |
| PinToHost                    | keep                         |
| HostDeviceFilter             | keep                         |
| CpuLevelFilter               | keep                         |
| CpuPinningPolicy             | keep (not yet merged)        |
| NumaPinningPolicy            | keep (not yet merged)        |
| InClusterUpgradeFilter       | mandatory                    |
| InClusterUpgradeWeight       | mandatory                    |

#### Preconditions to allow policy activation

*   No paused VMs are allowed in the cluster

#### Limitations during upgrade

*   Pausing VMs is forbidden

#### What might stop you from putting a host to maintenance

*   CPU pinning
*   NUMA pinning
*   Host pinning
*   PCI pass through
*   Missing networks

Since affinity will be ignored through the upgrade process, the affinity rules enforcement manager will be disabled.

### Upgrade activation Flow

### Host upgrade Flow
