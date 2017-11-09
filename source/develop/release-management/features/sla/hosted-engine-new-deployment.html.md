---
title: hosted-engine-new-deployment
category: feature
authors: jtokar
feature_name: An Ansible Script for Installing a Hosted Engine
feature_modules: sla
feature_status: In Development 
---

# Hosted Engine Deployment 

## Motivation 

Today we are using the ovirt-hosted-engine-setup project to deploy a Hosted Engine. The project contains the code to add storage, 
disks and the VM. All of this code already exists in the ovirt-engine project. By reusing this code we can reduce bugs and unify
the different engine installations. 

## The change 

The new process will use the current engine code to create all entities needed for successful hosted engine deployment.   
A local bootstrap VM with the engine appliance will be created on the host. After running engine setup on that VM we will use the 
engine API to add a host (same one we are running on), storage domain, storage disks and finally a VM that will later become the 
hosted engine VM in the engine (thus eliminating the need for importing it).   
Once all the entities are created we can shut down the bootstrap VM, copy its disk to the disk we created using the engine, create the hosted engine configuration files, start the agent and the broker, and the hosted engine VM will start.   

## How is it Implemented?

All of this will be implemented using an Ansible script.  
The current answer file will need to be converted to an Ansible vars file.   
The configuration files will be created using Ansible templates and then packaged and copied to the correct location. 

To run the script install Ansible and run:   
    ansible-playbook hosted_engine.yml   
The script will install all the packages and will start the deployment.   
For now, the vars file needs to be populated manually. Later the user's answers in the setup stage will be used to populate the values. 

## Issues

1. Host installation fails during the network setup stage  
   The reason for this is that the VDSM setup removes the routing table.   
   Workaround: Rewrite the routing table after the host gets to the "non-operational" state and then save the network    configuration. 
   using vdsm-client. This causes the host to go to the "up" state almost immediately.   
   Permanent solution: Handle this in host deploy code.   
2. Adding Hosted Engine disk takes a long time   
   This might not be a problem if using a cow format and not raw. But this hasn't been tested yet.   
3. When using an FQDN that resolves to a real IP the bootstrap VM tries to access the real IP and the installation fails 
   Workaround: Add a line to /etc/hosts on the host that maps the FQDN to the vm temporary IP.  
               Add a line to /etc/hosts on the VM that maps the FQDN to localhost - not implemented.   
   After a successfull installation, those lines need to be removed.   
4. When hosted engine with an ISCSI domain the storage domain creation fails  
   This seems like a bug in Ansible ovirt_storage_domain module which doesn't support this feature: 
   https://www.ovirt.org/develop/release-management/features/storage/discard-after-delete/  
   Workaround: use direct API command until the Ansible module is fixed - not implemented.   
5. Gluster and fibre channel storage  
   Not implemented   
6. When creating the configuration archive the agent fails to read it  
   Ansible's archive module creates a compressed tar archive. The agent expects a non-compressed version.   
   Workaround: create the archive using the command module.    
7. After installing VDSM libvirt commands need to be authenticated  
   Workaround: configure libvirt to listen to tls and preform the commands using: qemu+tls:///{IP}/system
8. The fheanswers file in the configuration archive should have the answers the user submitted   
   Not implemented

## Detailed Flow

1. Install needed pacakges: libvirt, ovirt-engine-appliance, virt-install and python-ovirt-engine-sdk4
2. Create a directory for the bootstrap VM 
3. Extract the appliance to the local directory
4. Create cloud-init files that will run engine setup, and generate an ISO CD 
5. Create the bootstrap VM, cloud-init will install the engine
6. Add the FQDN and the bootstrap VM IP to /etc/hosts on the host
7. Wait for the Engine setup to complete
8. Add the FQDN to the localhost line in /etc/hosts on the vm 
9. Add host 
10. Wait for host to become non-operational
11. Restore the routing table on the host
12. Save the network configuration 
13. Wait for host to become up
14. Add storage according to the selected storage type 
15. Add a disk for Hosted Engine configuration archive 
16. Add a disk for Hosted Engine lockspace
17. Add a disk for Hosted Engine metadata
18. Add a disk for Hosted Engine VM 
19. Add the Hosted Engine VM
20. Clean the /etc/hosts file on the VM
21. Configure libvirt to listen to TLS and restart it
23. Destroy the bootstrap VM 
23. Undefine the bootstrap VM
24. Create the configuration files: vm.conf, broker.conf, version, fheanswers.conf, hosted-engine.conf
25. Create the configuration archive 
26. Create /var/run/ovirt-hosted-engine-ha/ and copy vm.conf there  
27. Find the storage domain mount point 
28. Copy the archive to the configuraion disk 
29. Copy the bootstrap vm disk to the vm disk
30. Clean the /etc/hosts file on the host
31. Start the broker and the agent services  

## Vars file: 

FQDN: myvm.mydomain - FQDN where the hosted engine vm shoud run   
VM_MAC_ADDR: 00:16:3e:1e:15:d7 - mac address for the VM   
CLOUD_INIT_DOMAIN_NAME: mydomain - domain name for the VM  
CLOUD_INIT_HOST_NAME: myvm - host name for the VM   
HOST_NAME: sansa - host name for the Hosted Engine host, this will appear in the UI  
HOST_ADDRESS: local.example.local1.com - host address for the Hosted Engine host  
LOCAL_VM_DIR: /usr/localvm - the local directory on the host where the all the configuration files will be created   
ADMIN_PASSWORD: 1234 - password for the engine   
APPLIANCE_PASSWORD: qum5net - password for the Hosted Engine VM   
HOST_PASSWORD: qum5net - password for the Hosted Engine host   
STORAGE_DOMAIN_NAME: he_storage - desired storage domain name   
TIME_ZONE: Asia/Jerusalem - timezone for the VM   
BRIDGE: ovirtmgmt - management bridge name   
VM_NAME: HostedEngine - Hosted Engine VM name, best not to change it as some features depend on that name   
MEM_SIZE: 2048 - memory size for the VM  
CONSOLE_TYPE: vnc - console type   
SP_UUID: 00000000-0000-0000-0000-000000000000 - storage pool ID, I used the default storage pool   
CDROM_UUID:
CDROM:
NIC_UUID: 45645645 
CONSOLE_UUID:
VIDEO_DEVICE: vga - video device   
GRAPHICS_DEVICE: vnc - graphics device  
VCPUS: 4 - virtual cpus for the VM  
MAXVCPUS: 4 - max virtual CPUs for the VM   
CPU_SOCKETS: 2 - CPU sockets   
CPU_TYPE: Conroe - CPU type   
EMULATED_MACHINE: pc  - emulated machine   
VERSION: 2.2.0-0.0.master.20170413122212 - the version for the version file in the configuration archive
GATEWAY: 10.35.1.254 - gateway 
DOMAIN_TYPE: nfs3 - desired domain type 
ISCSI_PORT: 3260 
ISCSI_TARGET: iqn.2017-10.com.example
LUN_ID: 36001405879c330daed74eae8ec28a237 - ansible module requires lun id   
ISCSI_STORAGE: false - whether this is iscsi domain or not      
ISCSI_USERNAME: username  
ISCSI_PASSWORD: password  
STORAGE: local.example.com/ - path to the storage, in ISCSI case this is the IP of the portal     
STORAGE_DOMAIN_ADDR: local.example.com - IP or host name of NFS storage     
STORAGE_DOMAIN_PATH: /local/example/local1/example1/ - path for NFS storage    
NFS_STORAGE: true - whether this is a NFS domain or not   

## Patch set
https://gerrit.ovirt.org/#/c/81712/







