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
| InClusterUpgradeFilter       | mandatory                    |
| InClusterUpgradeWeight       | mandatory                    |

#### Preconditions

*   No paused VMs are allowed in the cluster

### Upgrade activation Flow

### Host upgrade Flow
