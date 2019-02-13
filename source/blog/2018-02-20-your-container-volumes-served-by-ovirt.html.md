---
title: Your Container Volumes Served By oVirt 
author: rgolan
tags: oVirt, oVirt 4.2, open source virtualization,kubernetes, openshift, external-storage, flexdriver, provisioner
date: 2018-02-20 09:01:00 UTC
---

> Note: _< 5 minutes read_

When running a virtualization workload on oVirt, a VM disk is 'natively' a disk somewhere on your network-storage.  
Entering containers world, on Kubernetes(k8s) or OpenShift, there are many options specifically because the workload can be totally stateless, i.e
they are stored on a host supplied disk and can be removed when the container is terminated. The more interesting case is *stateful workloads* i.e apps that persist data (think DBs, web servers/services, etc). k8s/OpenShift designed an API to dynamically provision the container storage (volume in k8s terminology). 

See the [resources](#resources) section for more details. 

In this post I want to cover how oVirt can provide volumes for containers running on k8s/OpenShift cluster.

READMORE

## Overview
Consider this: you want to deploy wikimedia as a container, with all its content served from `/opt`. 
For that you will create a persistent volume for the container - when we have state to keep and server
creating a volume makes sense. It is persistent, it exists regardless the container state,
and you can choose which directory exactly you serve that volume, and that is the most important
part, k8s/OpenShift gives you an API to determine who will provide the volume that you need.

There are many options, Cinder, AWS, NFS and more. And in case the _node_ that your pod is running on
is a _VM_ in oVirt, you can use ovirt-flexdriver to attach an oVirt disk and that will
appear as a device in the node, and will be mounted with filesystem to your request. If you want to know more see the documentation about [kubernetes-incubator/external-storage](https://github.com/kubernetes-incubator/external-storage)

```
    k8s/OpenShift Node          +-------> oVirt Vm
+----------------------+
|                      |                                  +----------------+
|   mediawiki pod      |                                  |                |
| +---------------+    |                                  |                |
| |               |    |                                  |                |
| |               |    |                                  |     oVirt      |
| |               |    |                                  |                |
| |/srv/mediawiki |    |                                  |                |
| +---------------+    |                                  |                |
|                      |                                  +----------------+
|                      |
|                      |
|  /dev/pv001 (/srv/mediawiki)  +-------> oVirt Disk
|                      |
+----------------------+
```

## Demo
Checkout this youtube video, that demonstrate how it looks like in __oVirt admin UI__, __kubernetes UI in cockpit__, and some __cli__:
 <iframe width="800" height="600" src="https://www.youtube.com/embed/_E9pUVrI0hs"> </iframe> 

## External Storage Provisioner and Flexvolume driver
OpenShift is able to request oVirt these special volumes by deploying ovirt-flexdriver and ovirt-provisioner and following this steps:

- Create a storage class
- Create a storage claim
- Create a pod with a volume that refernce the storage claim
- Run the pod

A storage class will can describe slow or fast data storage that maps to data domains in oVirt 
```yaml
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: ovirt-ssd-domain
provisioner: external/ovirt 
parameters:
  type: io1
  iopsPerGB: "10"
  ovirtStorageDomain: "prod-ssd-domain"
  fsType: ext4
  ovirtDiskFormat: "cow"
```

When you create a storage claim, ovirt-provisioner will create an oVirt disk for you on the
specified domain - notice the reference to the storage class:
```yaml
# storage claim
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: mediawiki-data-ssd-disk
  annotations:
    volume.beta.kubernetes.io/storage-class: ovirt-ssd-domain
spec:
  storageClassName: ovirt-ssd-domain
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi

```

Once the claim is created, oVirt is creating a 1Gb disk which is not attached to any node yet.

Run a mediawiki pod with so-called flex volume:
```yaml
apiVersion: v1 
kind: Pod 
metadata:
  name: mediawiki
  labels:
    app: ovirt 
spec:
  containers:
  - image: mediawiki 
    name: mediawiki 
    volumeMounts:
    - name: mediawiki-storage
      mountPath: "/data/"
  volumes:
  - name: mediawiki-storage
    persistentVolumeClaim:
      claimName: mediawiki-data-ssd-disk

```

And now it is the flexvolume driver job to tell oVirt to attach the disk into the node this
pod is running on, and creat file system on it, as described in the __storage class__, and to mount
it onto the node. When this is done, the volume is ready and the container can start, with
the mount set into the `/data` directory as set by `mountPath`.

## Want to give it a try? Want to get updated about this?
This work as for today (Feb 20th 2018) is in progress and all of it can be found at the [ovirt-flexdriver project page][project-page]
To *deploy* _**ovirt-flexdriver**_ and _**ovirt-provisioner**_ I created a container with _Ansible_ playbook that takes an inventory
that has the k8s nodes and k8s master specified, along with the ovirt-engine connection details. The playbook will copy and
configure both component and get you up and running with just few keystrokes. Find more on deployment in the README.md of [project][project-page]
and in an up-coming short video demonstrating the deployment.

> Note on versions: this should be working against kubernetes 1.9 and oVirt 4.2 but 4.1 should work as well (because the API in use is the same).

## Resources
- [oVirt flexdriver project page][project-page]
- [OpenShift flexvolume driver page](https://docs.openshift.org/latest/install_config/persistent_storage/persistent_storage_flex_volume.html)


[project-page]: https://github.com/rgolangh/ovirt-flexdriver
