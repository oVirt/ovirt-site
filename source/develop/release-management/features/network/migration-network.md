---
title: Migration Network
category: feature
authors:
  - alkaplan
  - danken
  - ilvovsky
  - mpavlik
---

# Migration Network

## Summary

Define a migration network role, and use such networks to carry migration data

## Owner

*   Name: Alona Kaplan (alkaplan)

<!-- -->

*   Email: <alkaplan@redhat.com>

## Current status

*   oVirt-3.3
*   Last updated: ,

## Detailed Description

When Engine requests to migrate a VM from one node to another, the VM state (Bios, IO devices, RAM) is transferred over a TCP/IP connection that is opened from the source `qemu` process to the destination `qemu`. Currently, destination qemu listens for the incoming connection on the management IP address of the destination host. This has serious downsides: a "migration storm" may choke the destination's management interface; migration is plaintext and ovirtmgmt includes Engine which sits may sit the node cluster.

With this feature, a cluster administrator may grant the "migration" role to one of the cluster networks. Engine would use that network's IP address on the destination host when it requests a migration of a VM. With proper network setup, migration data would be separated to that network.

## Benefit to oVirt

*   Users would be able to define and dedicate a separate network for migration. Users that need quick migration would use nics with high bandwidth. Users who want to cap the bandwidth consumed by migration could define a migration network over nics with bandwidth limitation.
*   Migration data can be limited to a separate network, that has no layer-2 access from Engine
*   Having a migration-specific network is one step towards capping/promising migration bandwidth. With this feature applied, this could be done with the help of external switches. In the future, we plan to let the end admin set QoS properties on each oVirt-defined network.

## Dependencies / Related Features

### Vdsm

The `migrate` verb should be extended with an additional parameter, specifying the address that the remote `qemu` process should listen on. A new argument is to be added to the currently-defined migration arguments:

*   vmId: UUID
*   dst: management address of destination host
*   dstparams: hibernation volumes definition
*   mode: migration/hibernation
*   method: rotten legacy
*   **dstqemu**: dedicated migration address of destination host. Would be used to build libivrt's `miguri` [argument](https://libvirt.org/html/libvirt-libvirt-domain.html#virDomainMigrateToURI2) such as `tcp://<ip of migration network on remote node>`.

Note that the migration protocol requires Vdms-Vdsm and libvirt-libvirt communication. Both are routed over the management network even when the new dstqemu argument is used.

### Engine

1.  Network definition.
    -   A new network role - not unlike "display network" should be added.Only one migration network should be defined on a cluster.
    -   If none is defined, the legacy "use ovirtmgmt for migration" behavior would apply.
    -   A migration network is more likely to be a *required* network, but a user may opt for non-required. He may face unpleasant surprises if he wants to migrate his machine, but no candidate host has the network available.
    -   The "migration" role can be granted or taken on-the-fly, when hosts are active, as long as there are no currently-migrating VMs.

2.  Scheduler:
    -   When deciding which host should be used for automatic migration, take into account the existence and availability of the migration network on the destination host.
    -   For manual migration, let user migrate a VM to a host with no migration network - if the admin wants to keep jamming the management network with migration traffic, let her.
    -   Just like choosing the destination host, the user may choose a specific migration network. If host is not selected then allow to choose from cluster's networks. The default should be the cluster's migration network.

3.  migration verb.
    -   For a modern cluster level, with migration network defined on the destination host, an additional *dstqemu* parameter should be added to the `migrate` command

### Screen shots

![](/images/wiki/EditMigration.png) ![](/images/wiki/MigrationSubTab.png) ![](/images/wiki/MigrationSetupNetwork.png)

## Development Phases

### First phase

*   Add a new network role of migration network.
*   Each cluster has one, and it is the default migration network for VMs on the cluster.
*   Factory default is that ovirtmgmt is the cluster migration network.

*Target:* oVirt -3.3

### Second phase

*   Add a per-VM property of migrationNetwork. If Null, the cluster migrationNetwork would be used.
*   Let the user override the VM migration network in the migrate API and in the GUI.

*Target:* TBD

## Testing

*   Set up a cluster of at least two hosts, and have them inter-connected via two different networks. Simplest form is to have two NICs on each host.
*   One NIC should be used by the management network, and the other - by the migration network. Use the new GUI to configure your hosts appropriately.
*   Start a VM on one machine, and migrate it to the other. Verify that migration succeeds.
*   Sniff the traffic on the source and destination hosts while migration is going on. Verify that qemu-to-qemu migration traffic is limited to the migration network.
*   Command that can be used to check traffic flow
        tcpdump -tnni any -c 30000 | awk -F "." '{print $1"."$2"."$3"."$4}' | sort | uniq -c | sort -nr | awk ' $1 > 1000 '

| Test                                                                   | Steps                                                                        | Expected Result                                                                                                        | Status | Version | Note                                                      |
|------------------------------------------------------------------------|------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------|--------|---------|-----------------------------------------------------------|

| Dedicated migration network                                            | 1) Assign migration role to the network                                      
                                                                          2) Attach the network to the host (do not forget to setup IP)                 
                                                                          3) Migrate VMs between nodes                                                  | 1) Role assigned                                                                                                       
                                                                                                                                                         2) Network attached                                                                                                     
                                                                                                                                                         3) Successful migration which happens over dedicated migration network                                                  |        |         | Test for: regular network, bridgeless network, VLAN, bond |

| Migrate VM which has attached migration network                        | 1) Run the VM                                                                
                                                                          2) Migrate the VM with migration network attached over the migration network  | 1) -                                                                                                                   
                                                                                                                                                         2) Migration successful                                                                                                 |        |         | Test for: regular network, bridgeless network, VLAN, bond |

| Automatic migration                                                    | 1) Assign migration role to the network                                      
                                                                          2) Attach the network to hosts (do not forget to setup IP)                    
                                                                          3) Attach another required network (NET2) to hosts                            
                                                                          4) Run VM/s on one of the hosts                                               
                                                                          5) Take down NET2 interface on host with running VM/s                         | 1) Role assigned                                                                                                       
                                                                                                                                                         2) Migration network attached                                                                                           
                                                                                                                                                         3) network NET2 attached to host                                                                                        
                                                                                                                                                         4) VM/s running                                                                                                         
                                                                                                                                                         5) VM/s auto migrated over migration network                                                                            |        |         | Test for: regular network, bridgeless network, VLAN, bond |

| Higher MTU                                                             | 1) Create network with MTU=9000                                              
                                                                          2) Assign migration role to the network                                       
                                                                          3) Attach the network to the host (do not forget to setup IP)                 
                                                                          4) Migrate VMs between nodes                                                  | 1) -                                                                                                                   
                                                                                                                                                         2) -                                                                                                                    
                                                                                                                                                         3) -                                                                                                                    
                                                                                                                                                         4) Migration successful, MTU 9000 is used (verify by tcpdump or some other network tool)                                |        |         | Test for: regular network, bridgeless network, VLAN, bond |

| Remove dedicated migration network                                     | 1) Remove dedicated migration network/s                                      
                                                                          2) Migrate VMs                                                                | 1) Networks removed                                                                                                    
                                                                                                                                                         2) VMs successfully migrate over management network                                                                     |        |         | Test for: regular network, bridgeless network, VLAN, bond |

| Migrate to host without migration network (this test requires 2 hosts) | 1) Assign migration role to the network                                      
                                                                          2) Attach the network to **one** host (do not forget IP)                      
                                                                          3) Migrate VMs between nodes                                                  | 1) Role assigned                                                                                                       
                                                                                                                                                         2) Network attached                                                                                                     
                                                                                                                                                         3) Manual migration should be possible, even if node does not have migration network (management network will be used)  |        |         | Test for: regular network, bridgeless network, VLAN, bond |

| Remove dedicated migration network                                     | 1) Remove dedicated migration network/s                                      
                                                                          2) Migrate VMs                                                                | 1) Networks removed                                                                                                    
                                                                                                                                                         2) VMs successfully migrate over management network                                                                     |        |         | Test for: regular network, bridgeless network, VLAN, bond |

| Migration network interface failure                                    | 1) Assign migration role to the network                                      
                                                                          2) Attach the network to cluster as required                                  
                                                                          3) Attach the network to hosts (do not forget to setup IPs)                   
                                                                          4) Take down migration interface on one host                                  
                                                                          5) Change the migration network to non-rquired                                
                                                                          6) Reactivate the host                                                        
                                                                          7) Migrate VMs between nodes</br>                                             | 1) Migration role assigned                                                                                             
                                                                                                                                                         2) Network attached to cluster                                                                                          
                                                                                                                                                         3) Network attached to host                                                                                             
                                                                                                                                                         4) Host goes non-opertational                                                                                           
                                                                                                                                                         5) -                                                                                                                    
                                                                                                                                                         6) Host UP (migration interface still down)                                                                             
                                                                                                                                                         7) Migration fails                                                                                                      |        |         | Test for: regular network, bridgeless network, VLAN, bond |

| Wrong / missing IPs                                                    | 1) Assign migration role to the network                                      
                                                                          2) Attach the network to the host                                             
                                                                          3) Set IP just for one host                                                   
                                                                          4) Migrate VMs between nodes                                                  
                                                                          5) Set wrong IP/netmask on one of the hosts                                   
                                                                          6) Migrate VMs between nodes                                                  | 1) -                                                                                                                   
                                                                                                                                                         2) -                                                                                                                    
                                                                                                                                                         3) IP set                                                                                                               

                                                                                                                                                         3a) IF the destination host is the one with the ip- should succeed                                                      

                                                                                                                                                         3b) IF the destination has DHCP set as boot protocol- it also should succeed                                            

                                                                                                                                                         4) -                                                                                                                    
                                                                                                                                                         5) Wrong IP set                                                                                                         
                                                                                                                                                         6) -                                                                                                                    

                                                                                                                                                         6a) IF the destination host has wrong ip on the migration network- should fail.                                         

                                                                                                                                                         6b) IF the origin host- should succeed.                                                                                 |        |         | Test for: regular network, bridgeless network, VLAN, bond |

| Migration and display network                                          | 1) Assign migration network also display network role                        
                                                                          2) Live migrate multiple VMs with open spice consoles                         | 1) -                                                                                                                   
                                                                                                                                                         2) Migration successful, spice consoles displaying correctly                                                            |        |         | Test for: regular network, bridgeless network, VLAN, bond |

| Negative: Migration network is N/A for lower cluster/dc version        | 1) Assign migration network role on DC/CL lower than 3.3                     | 1) Migration network role cannot be assigned on DC/CL lower than 3.3                                                   |        |         | Test for: regular network, bridgeless network, VLAN, bond |

## Known Limitations

*   The address of the migration network must live on the same subnet for both hosts. If it is not, qemu cannot guess the correct source address to use, so traffic would flow via the default gateway. **TODO**: open qemu and libvirt RFEs to allow specifying the source IP address of migration traffic.

## Documentation / External references

*   Yuval M asking to choose a network for migration data: <https://lists.ovirt.org/pipermail/users/2013-January/011301.html>

## Comments and Discussion

*   Currently, there is a bug when the boot protocol of the migration network is dhcp. Sometimes the engine doesn't get in time the ip of the network from the dhcp server. In this case, when the migration command will be invoked the engine won't have the ip address of the migration network. It will cause the migration to be done on the fallback (management) network. Bug Url- <https://bugzilla.redhat.com/642551>

