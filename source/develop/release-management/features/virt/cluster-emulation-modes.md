---
title: Cluster emulation modes
category: feature
authors:
  - ofrenkel
  - roy
  - sandrobonazzola
---

# Cluster emulation mode

## Summary

This feature will enable per cluster emulation mode. EmulatedMachine is a property passed to QEMU as -M flag and Instead of a system-wide config value
A cluster could have a specific value which all host must comply to. If the cluster has no value set, the first host that is active
must comply to a configurable list of values and then set it thereafter.

## Owner

*   Name: Roy Golan (rgolan)
*   Email: <rgolan@redhat.com>

## Current status

*   Implementation is done. Review phase. See <http://gerrit.ovirt.org/#/q/status:open+project:ovirt-engine+branch:master+topic:cluster_emulation_modes,n,z>
*   Last updated: ,
*   Target Release: 3.3

## Detailed Description

We want to keep the cluster homogeneous but be able to have different types cross-cluster i.e one cluster to be RHELs and another to be Fedora based.
to achieve that we need a config value, per version with a list of supported emulation types, order by priority:

### New Config value

      ClusterEmulationModes(3.0,"rhel6.2.0, pc-1.0")
      ClusterEmulationModes(3.1,"rhel6.3.0, pc-1.0")
      ClusterEmulationModes(3.2,"rhel6.4.0, pc-1.0")
      ClusterEmulationModes(3.3,"rhel6.4.0, pc-1.0")

### New Host field

new "supportedEmulatedMachines" field will be added to VDS entitu and vds_dynamic table.

      VDS.supportedEmulatedMachines
      vds_dynamic.supported_emulated_machines

### New Cluster field

A cluster entity will be added by a new field - emulatedMachine.
 vds_group.emulated_machine default NULL varchar(255) The default is NULL which means the value would be set once a host during the first refresh would have
its reported emulatedMachines list match against the Config Value

### New NON_OPERATIONAL reason

      NonOperationalReason
       ...,
      EMULATED_MACHINES_INCOMPATIBLE_WITH_CLUSTER ;

This new REASON if for host which can't join the cluster becuase they
don't comply with the Config ClusterEmulatedMachines or the clusters
emulatedMachine field which is a subset of the config.

### HandleVdsCpuFlagsOrClusterChangedCommand

This commands will match an activated Host against the cluster definition.
If the cluster definition is null then the host will be matched against the config values.
That match will set the cluster definition for the rest of the hosts in that cluster
 consider this pseudo-code:

      operational = false 
      if cluster.emulationMode == NULL
       for configVal in Config.ClusterEmulationMode(3.3)
          if configVal in host.emulationModes 
              cluster.emulationMode = configVal
              operational = true
       else if clusterEmulationMode in host.emulationMode
             operational = true
      if (!operational)
          set host non operationl, reason = EMULATED_MACHINES_INCOMPATIBLE_WITH_CLUSTER

### Run VM

The OVFs emulatedMachine property will be populated by the cluster's emulatedMachine field and not by the global config value, which will be deleted as it is not relevant any more

### New UI subtab field (readonly)

TODO A sketch of cluster subtab

## Benefit to oVirt

## Documentation / External references

Please see <https://bugzilla.redhat.com/show_bug.cgi?id=927874>

## Testing

*   Test case: **Vm start up - A cluster of fedora nodes and cluster of RHEL6 should be both supported out of the box**
    -   setup:

Cluster "f" has 1 fedora host, compat version 3.3

Cluster "R" has 1 RHEL6 host. compat version 3.3

DB config values for clusterEmulationMode = "el6,pc-1.0" version 3.3

*   -   test:

create a VM on each cluster and start it

*   -   expected result:

A vm is able to start on each of the clusters.

*   Test case: **Host with unsupported emulation mode goes NON-OPERATIONAL with reason UNSUPPORTED_EMULATION_MODE**
    -   setup:

use the same setup as the former case

*   -   test:

add a RHEL6 node to cluster "f"

*   -   expected result:

host should go NON_OPERATIONAL with reason UNSUPPORTED_EMULATION_MODE




