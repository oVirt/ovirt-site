---
title: oVirt and OKD
author: rgolan
tags: oVirt, oVirt 4.2, open source virtualization,kubernetes, openshift, external-storage, flexdriver, provisioner
date: 2019-01-06 09:01:00 UTC
---

This is a series of posts to demonstrate how to  install  OKD 3.11 on oVirt and what you can do with it.
**Part I**   -  How to intall OKD 3.11 on oVirt

<img align="left" src="/images/blog/2019-01-06/boxhead.png" width="400px" style="margin-right: 25px;border-radius: 4px">

# How to intall OKD 3.11 on ovirt (4.2 and up)
Installing OKD or Kubernetes on oVirt has many advantages, and it's also gotten a lot easier these days. Admins and users who want to take container platform management for a spin, on oVirt, will be encouraged by this.  
Few of the advantages are:
- Virtualizing the control plane for Kubernetes - provide HA/backup/affinity capabilities to the controllers and allowing hardware maintenance cycles
- Providing persistent volume for containers via the IAAS, without the need for additional storage array dedicated to Kubernetes
- Allowing a quick method to build up/tear down Kubernetes clusters, providing hard tenency model via VMs between clusters.

The installation uses [openshift-ansible](https://github.com/openshift/openshift-ansible) and, specifically the `openshift_ovirt` ansible-role. The integration between OpenShift and oVirt is tighter, and provides storage integration. If you need persistent volumes for your containers you can get that directly from oVirt using **ovirt-volume-provisioner** and **ovirt-flexvolume-driver**.  
For the sake of simplicity, this example will cover an all-in-one OpenShift cluster, on a single VM.  
On top of that, in the 2nd post, we will run a classic web stack, a Java application with a simple REST-API endpoint + Postgres. Postgres will get a persistent volume from oVirt using its flexvolume driver.


<span style="font: italic 10px robot, monospace; top: 220px">Picture by [Soroush golpoor on Unsplash](https://unsplash.com/@soroushgolpoor?utm_medium=referral&utm_campaign=photographer-credit&utm_content=creditBadge)</span>



<script id="asciicast-219956" src="https://asciinema.org/a/219956.js" async></script>

## Single shell file installation

Dropping to shell - this [install.sh](https://github.com/oVirt/ovirt-openshift-extensions/blob/master/automation/ci/install.sh) is a wrapper for installing  the ovirt-openshift-installer container, it uses ansible-playbook and has two main playbooks: install_okd.yaml and install_extensions.yaml. The latter is mainly for installing ovirt storage plugins.

The install.sh script has one dependency, it needs to have 'podman' installed on the host, while all the rest runs inside a container.

The only dependency (except from running oVirt datacenter) is podman:
```console
[bastion ~]# dnf install podman
``` 

[For other ways to install podman consult the readme](https://github.com/containers/libpod/blob/master/docs/tutorials/podman_tutorial.md)

If you can't install `podman` docker will be fine as well, just edit the install.sh, and substitute podman for docker.

### Get the install.sh and customize
```console
[bastion ~]# curl -O "https://raw.githubusercontent.com/oVirt/ovirt-openshift-extensions/master/automation/ci/{install.sh,vars.yaml}"
```

Edit the `vars.yaml`:

- Put the engine details in engine_url
  ```yaml
  engine_url: https://ovirt-engine-fqdn/ovirt-engine/api
  ```

- Choose the oVirt cluster and data domain you want, if you don't want 'Default'
  ```yaml
  openshift_ovirt_cluster: yours
  openshift_ovirt_data_store: yours
   ```
- Unmark to disable the memory and disks checks in case the VM memory is under 8Gb
  ```yaml
  openshift_disable_check: memory_availability,disk_availability,docker_image_availability
  ```

- Domain name of the setup. The setup will create a VM with the name master0.$public_hosted_zone here. This VM will
  be used for all the components of the setup
  ```yaml
  public_hosted_zone: example.com
  ```

For a more complete list of customizations, take a look at the [vars.yaml](https://github.com/oVirt/ovirt-openshift-extensions/blob/master/automation/ci/vars.yaml) and the [inventory file](https://github.com/oVirt/ovirt-openshift-extensions/blob/master/automation/ci/integ.ini).
## Install

Run install.sh to start the installation.

```console
[bastion ~]# bash install.sh
```

install.sh automates the following steps:
1. Pull the ovirt-openshift-installer container and run it.
2. Download Centos Cloud Image and import it into oVirt based on the `qcow_url` variable.
3. Create a VM named master0.example.com from the template above.The VM name is based on the `public_hosted_zone` variable.
4. The cloud-init script will configure repositories, a network, ovirt-guest-agent, etc. based on the `cloud_init_script_master` variable. 
5. The VM will dynamically be inserted into an ansible inventory, under `master`, `compute`, and `etc` groups
6. Openshift-ansible main playbooks are executed to install OKD: `prerequisite.yml` and `deploy_cluster.yml`


When the script finishes, an all-in-one cluster is installed and running. Let's check it out.

```console
[root@master0 ~]# oc get nodes
NAME                         STATUS    ROLES                  AGE       VERSION
master0.example.com   Ready     compute,infra,master   1h        v1.11.0+d4cacc0
```


Check oVirt's extensions
```console
[root@master0 ~]# oc get deploy/ovirt-volume-provisioner
NAME                       DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
ovirt-volume-provisioner   1         1         1            1           57m

[root@master0 ~]# oc get ds/ovirt-flexvolume-driver
NAME                      DESIRED   CURRENT   READY     UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
ovirt-flexvolume-driver   1         1         1         1            1           <none>          59m
```

### Default Storage Class
To run all the dynamic storage provisioning through ovirt's provisioner, 
we need to set oVirt's storage class to the default.  
Notice that a storage class defines which oVirt storage domain will  
be used to provision the disks. Also it will set the disk type (thin/thick) provision to be the default, thin.

```console
[root@master ~]# oc patch sc/ovirt \ 
                    -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```

### Connect to OKD web console
You can now connect to the web console, and keep manage your cluster from there. To do so  
first make sure you can resolve `master0.example.com` (substitute example.com with whatever  
is set in `public_hosted_zone` customization variable, as mentioned above.)

Browse to `https://master0.example.com:8443`  and login with whatever user/password you want:

<img src="/images/blog/2019-01-06/okd-web-console.png"/>

# Summary
This blog post covered the installation of OKD on an oVirt VM. If you followed the step you now have  
an all-in-one cluster with dynamic storage provisioning from oVirt storage.
In the next post I'm going deploy Postgres DB in a container with persistent volume from oVirt
storage domain.

