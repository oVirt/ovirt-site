---
title: hosted-engine-new-deployment
category: feature
authors: jtokar
feature_name: Provide ansible script to install Hosted Engine
feature_modules: sla
feature_status: Design / partly implementaion stage
---

# Hosted Engine Deployment 

## Motivation 

Today we are using the ovirt-hosted-engine-setup project to deploy hosted engine. The project contains the code to add storage, 
disks and the vm. All of this code already exists in the ovirt-engine project. By reusing that code we can reduce bugs and unify
the different engine installations. 

## The change 

The new process will use the current engine code to create all entities neeeded for successfull hosted engine deployment.   
A local bootstrap vm with the engine appliance will be created on the host. After running engine setup on that vm we will use the 
engine api to add a host (same one we are running on), storage domain, storage disks and finally a vm that will later become the 
hosted engine vm in the engine (thus eliminating the need for importing it).   
Once all the entities are created we can shut down the bootstrap vm, copy its disk to the disk we created using the engine, create 
the hosted engine configuration files, start the agent and the broker and the hosted engine vm will start.   

## How 

All of this will be implemented using an Ansible script.  
The current answer file will need to be converted to an Ansible vars files.   
The configuration files will be created using Ansible templates and then packaged and copied to the correct location. 

## Issues

1. Host installation fails during network setup stage  
   The reason for this is that vdsm setup removes the routing table.   
   Workaround: rewrite the routing table after the host gets to the "non operational" state and then save the network configuration 
   using vdsm-client. This causes the host to go to "up" state almost immediatly.   
   Permanent solution: handle this in host deploy code.   
2. Adding hosted engine disk takes a long time   
   This might not be a problem if using a cow format and not raw. But this wasn't tested yet.   
3. When using fqdn that resolves to a real ip the bootstrap vm tries to access the real ip and the installation fails 
   Workaround: add a line to /etc/hosts on the host and the vm with the fqdn and the vm temporary ip.   
   After successfull installation those lines need to be removed.   
4. When hosted engine with iscsi domain the storage domain creation fails  
   This seems like a bug in Ansible ovirt_storage_domain module which doesn't support this feature: 
   https://www.ovirt.org/develop/release-management/features/storage/discard-after-delete/  
   Until this is fixed we can't deploy with iscsi.  
   Workaround: use direct api command until the Ansible module is fixed.   
5. Gluster and fibre channel storage  
   Not implemented   
6. When creating the configuration archive agent fails to read it  
   Ansible's archive module creates a compressed tar archive, the agent expects a non compressed one.   
   Workaround: create the archive using the command module.  
   Permanent solution: give the agent the ability to read compressed archive (add -z to the commands).  
7. After installing vdsm libvirt commands need to be authenticted with vdsm user  
   Workaround: configure libvirt to listen to tls and preform the commands using: qemu+tls:///{IP}/system
8. The fheanswers file in the configuration archive should have the answers the user submitted   
   Not implemented

## Detailed flow

1. Install needed pacakges: libvirt, ovirt-engine-appliance, virt-install and python-ovirt-engine-sdk4
2. Create a directory for the bootstrap vm 
3. Extract the appliance to the local directory
4. Create cloud init files that will run engine setup, and generate an iso cd
5. Create the bootstrap vm, cloud init will install the engine
6. Add the fqdn and the bootstrap vm ip to /etc/hosts on the host
7. Wait for the enigne setup to complete
8. Add the fqdn and the bootstrap vm ip to /etc/hosts on the vm 
9. Add host 
10. Wait for host to become non operational
11. Restore the routing table on the host
12. Save the network configuration 
13. Wait for host to become up
14. Add storage according to the selected storage type 
15. Add disk for hosted engine configuration archive 
16. Add disk for hosted engine lockspace
17. Add disk for hosted engine metadata
18. Add disk for hosted engine vm 
19. Add the hosted engine vm
20. Clean the /etc/hosts file on the vm
21. Configure libvirt to listen to tls and restart it
23. Destroy the bootstrap vm 
23. Undefine the bootstrap vm
24. Create the configuration files: vm.conf, broker.conf, version, fheanswers.conf, hosted-engine.conf
25. Create the configuration archive 
26. Create /var/run/ovirt-hosted-engine-ha/ and copy vm.conf there  
27. Find the storage domain mount point 
28. Copy the archive to the configuraion disk 
29. Copy the bootstrap vm disk to the vm disk
30. Clean the /etc/hosts file on the host
31. Start the broker and the agent services  

## Patch set
https://gerrit.ovirt.org/#/c/81712/







