---
title: Network Management
authors: lpeer, mkolesni
wiki_title: Network Management
wiki_revision_count: 20
wiki_last_updated: 2012-11-07
---

# Network Management

| Area                             | Action                    | Internal impl.                                                                       | Quantum API                                                                       |
|----------------------------------|---------------------------|--------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------|
| Logical network                  | Create network            | AddNetwork                                                                           | <http://docs.openstack.org/api/openstack-network/1.0/content/Create_Network.html> |
| Update network                   | UpdateNetwork             | <http://docs.openstack.org/api/openstack-network/1.0/content/Update_Network.html>    |
| Delete network                   | RemoveNetwork             | <http://docs.openstack.org/api/openstack-network/1.0/content/Delete_Network.html>    |
| Attachment of network to cluster | Attach to cluster         | AttachNetworkToVdsGroup                                                              | ?                                                                                 |
| Update attachment                | UpdateNetworkOnCluster    | ?                                                                                    |
| Detach from cluster              | DetachNetworkToVdsGroup   | ?                                                                                    |
| Apply networking on host         | Apply network             | SetupNetworks                                                                        
                                                                Deprecated:                                                                           
                                                                UpdateNetworkToVdsInterface                                                           
                                                                AttachNetworkToVdsInterface                                                           
                                                                DetachNetworkFromVdsInterface                                                         
                                                                AddBond                                                                               
                                                                RemoveBond                                                                            | ?                                                                                 |
| Commit changes on host           | CommitNetworkChanges      | ?                                                                                    |
| vNICs on VM Templates            | Create vNIC on Template   | AddVmTemplateInterface                                                               |                                                                                   |
| Update vNIC on Template          | UpdateVmTemplateInterface |                                                                                      |
| Delete vNIC on Template          | RemoveVmTemplateInterface |                                                                                      |
| vNICs on VMs                     | Create vNIC on VM         | AddVmInterface                                                                       | <http://docs.openstack.org/api/openstack-network/1.0/content/Create_Port.html>    |
| Update vNIC on VM                | UpdateVmInterface         | <http://docs.openstack.org/api/openstack-network/1.0/content/Update_Port.html>       |
| Delete vNIC on VM                | RemoveVmInterface         | <http://docs.openstack.org/api/openstack-network/1.0/content/Delete_Port.html>       |
| Activate vNIC on running VM      | RunVm                     
                                    HotPlugUnplugVmNic         | <http://docs.openstack.org/api/openstack-network/1.0/content/Put_Attachment.html>    |
| Deactivate vNIC on running VM    | StopVm (on callback)      
                                    HotPlugUnplugVmNic         | <http://docs.openstack.org/api/openstack-network/1.0/content/Delete_Attachment.html> |
