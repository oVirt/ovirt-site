---
title: Openshift On oVirt
category: feature
authors: rgolan
---

## Owner

*   Name: Roy Golan
*   email: <rgolan@redhat.com>

## PURPOSE
Today oVirt is fast, performant and stable solution for enterprise workloads.  
It is easy to manage, fast to deploy, and provides integrated storage handling.  
Deploying openshift on top of VMs from oVirt benefits all the advantages mentioned above.  
To go one step further, containers running on this form of deployment can get direct access to the storage served by oVirt. 

## OVERVIEW
Kubernetes, the cluster manager of openshift, has an api for dynamic storage provision for its running containers. 
Its purpose is simple, call out some executable out there that will prepare some destination path a node, that can passed in as a mount to a given container.  
This is called flex volume plugin. As a preparation step, kubernetes will call another plugin that will prepare the disk space. 
This is called volume-provisioner. Together they enable dynamic provisioning of volumes (container disk space).  
This project implements the 2 plugin mentioned above, and deploys them on openshift.  
In high level, the preparation step (volume-provisioner) is creating a disk in oVirt, plain and simple, using the oVirt REST-API  
The second step, where the flex volume kicks in, is again  calling oVirt REST API, to attach a disk into the VM, which is actually an openshift node.  
That disk is then being mounted and is ready to be mounted into a container.
One of the main advantages of such flow is that openshift layer is totally indifferent of the type of storage which oVirt is using,  
which allows oVirt to use whatever it supports, NFS, Gluster, FC, ISCSI, even Local DC with local host disks, and so on.

## GOALS
- Implement a flex volume driver plugin
- Implement a volume provisioner plugin
- Provide an easy way to deploy the plugins to openshift
  - As an APB
  - As an ansible playbook

## DIAGRAM
![](/images/okd-on-ovirt/OKD_oVirt_arch.png)
![](/images/okd-on-ovirt/OKD_oVirt_extensions.png)


