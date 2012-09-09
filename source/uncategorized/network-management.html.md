---
title: Network Management
authors: lpeer, mkolesni
wiki_title: Network Management
wiki_revision_count: 20
wiki_last_updated: 2012-11-07
---

# Network Management

| Area                             | Action                    | Internal impl.                                                          | Quantum API                                                                              | Notes                                                                           |
|----------------------------------|---------------------------|-------------------------------------------------------------------------|------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------|
| Logical network                  | Create network            | AddNetwork                                                              | <http://wiki.openstack.org/Quantum/APIv2-specification#Create_Network>                   | Quantum API accept network name returns id, needs to be persisted in the engine |
| Update network                   | UpdateNetwork             | <http://wiki.openstack.org/Quantum/APIv2-specificationv#Update_Network> | Quantum API updates network name, admin. state and sharing status                        |
| Delete network                   | RemoveNetwork             | <http://wiki.openstack.org/Quantum/APIv2-specification#Delete_Network>  |                                                                                          |
| Attachment of network to cluster | Attach to cluster         | AttachNetworkToVdsGroup                                                 | ?                                                                                        |                                                                                 |
| Update attachment                | UpdateNetworkOnCluster    | ?                                                                       |                                                                                          |
| Detach from cluster              | DetachNetworkToVdsGroup   | ?                                                                       |                                                                                          |
| Apply networking on host         | Apply network             | SetupNetworks                                                           
                                                                Deprecated:                                                              
                                                                UpdateNetworkToVdsInterface                                              
                                                                AttachNetworkToVdsInterface                                              
                                                                DetachNetworkFromVdsInterface                                            
                                                                AddBond                                                                  
                                                                RemoveBond                                                               | <http://wiki.openstack.org/ConfigureOpenvswitch>                                         | This is specific to OVS plugin, need to figure out for other plugin types.      |
| Commit changes on host           | CommitNetworkChanges      | ?                                                                       | Perhaps same rollback mechanism used today can be used for plugin configuration as well? |
| vNICs on VM Templates            | Create vNIC on Template   | AddVmTemplateInterface                                                  |                                                                                          |                                                                                 |
| Update vNIC on Template          | UpdateVmTemplateInterface |                                                                         |                                                                                          |
| Delete vNIC on Template          | RemoveVmTemplateInterface |                                                                         |                                                                                          |
| vNICs on VMs                     | Create vNIC on VM         | AddVmInterface                                                          |                                                                                          |                                                                                 |
| Update vNIC on VM                | UpdateVmInterface         |                                                                         |                                                                                          |
| Delete vNIC on VM                | RemoveVmInterface         |                                                                         |                                                                                          |
| Activate vNIC on running VM      | RunVm                     
                                    HotPlugUnplugVmNic         | <http://wiki.openstack.org/Quantum/APIv2-specification#Create_Port>     |                                                                                          |
| Deactivate vNIC on running VM    | StopVm (on callback)      
                                    HotPlugUnplugVmNic         | <http://wiki.openstack.org/Quantum/APIv2-specification#Delete_Port>     |                                                                                          |
