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
| EmulatedMachineFilter        | mandatory if possible        |
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
*   HA for VMs is disabled
*   Affinity Groups will not be respected
*   No load balancing will happen

#### What might stop you from putting a host to maintenance

*   CPU pinning
*   NUMA pinning
*   Host pinning
*   PCI pass through
*   Missing networks

Since affinity will be ignored through the upgrade process, the affinity rules enforcement manager will be disabled.

### Upgrade Flow

1.  Enable upgrade mode + restart engine to take effect
2.  Set the new scheduling policy for the desired cluster (this allows mixing different major host OS versions
3.  Check for suspended VMs and fail if they exist.
4.  Disable suspending VMs when using a specific migration policy.
5.  Move a host X to maintenance (If this is the 2nd+ host some VMs will move to el7 machines)
6.  If needed, pre-migrate VMs manually as a precaution
7.  Upgrade host in place (fedup style) to el7 and reboot to get the new kernel
8.  Configure the host to use json-rpc instead of xml (xmlrpc is no longer supported in 3.6 version)
9.  Activate host (should move to ‘up’).
10. Go to step 5 until all hosts upgraded for this cluster and then reset the scheduling policy.
11. Increaste cluster level to 3.6.
12. Go to step 2 and repeat for all clusters.
13. Disable the config from step 1 + restart engine.

### Testing the work in progress version

The final flow is not implemented. See the instructions below to test upgrades with the work in progress version.

What is currently missing?

*   Check if someone wants to pause a VM while an upgrade is happening
*   Check if someone wants to configure a VM in a way which binds it to a specific host

1.  Install hosted engine from <http://jenkins.ovirt.org/job/ovirt-engine_master_build-artifacts-el6-x86_64_no_spm_testing/43/>
2.  Set 'CheckMixedRhelVersions' to 'false' with \`engine-config\` for your verison. For instance when upgrading from 3.5 to 3.6 set it to false for 3.5.
3.  Restart the engine
4.  Set the predefinde InClusterUpgrade policy on the cluster
5.  One host after the other: Put host into maintenance, upgrade host, enable host again, configure the host to use json-rpc
6.  Set 'CheckMixedRhelVersions' to 'true' with \`engine-config\`
7.  Restart engine
8.  Set cluster compatibility to 3.6
