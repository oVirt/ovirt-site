---
title: An Introduction to oVirt Ansible Roles
author: mgoldboim
tags: Ansible, Roles, Automation, Configuration management
date: 2017-07-18 15:00:00 CET
comments: true
published: true
---

Today I would like to share with you some of the integration work with Ansible 2.3 that was done in the latest oVirt 4.1 release.
The Ansible integration work was quite extensive and included [Ansible modules](http://docs.ansible.com/ansible/list_of_cloud_modules.html#ovirt) that can be utilized for automating a wide range of
oVirt tasks, including tiered application deployment and virtualization infrastructure management.

READMORE

While Ansible has multiple levels of integrations, I would like to focus this article on oVirt Ansible roles. As stated in the Ansible documentation: “Roles in Ansible build on the idea of include files and combine them to form clean, reusable abstractions – they allow you to focus more on the big picture and only dive into the details when needed.”

We used the above logic as a guideline for developing the oVirt Ansible roles.
We will cover three of the many Ansible roles available for oVirt:

*  [oVirt infra](https://github.com/oVirt/ovirt-ansible/blob/master/roles/ovirt-infra/README.md)
*  [oVirt-image-template](https://github.com/oVirt/ovirt-ansible/tree/master/roles/ovirt-image-template)
*  [oVirt-vm-infra](https://github.com/oVirt/ovirt-ansible/tree/master/roles/ovirt-vm-infra)

For each example, I will describe the role's purpose and how it is used.

## oVirt Infra

The purpose of this role is to automatically configure and manage an oVirt  datacenter. It will take a newly deployed- but not yet configured- oVirt engine (RHV-M for RHV users), hosts, and storage and configure them to your requirements and specifications. The oVirt engine should already be installed (post engine-setup). Hosts and storage should be deployed but not configured.

This role will take a [yml-based variable file](https://github.com/oVirt/ovirt-ansible/blob/master/examples/ovirt_infra_vars.yml) such as the following (/path/to/file):



```yaml

###########################
# REST API variables
###########################
engine_url: https://ovirt-engine.example.com/ovirt-engine/api
engine_user: admin@internal
engine_cafile: /etc/pki/ovirt-engine/ca.pem



###########################
# Common
###########################
compatibility_version: 4.1


###########################
# Data center
data_center_name: mydatacenter
###########################


###########################
# Clusters
###########################
clusters:
- name: production
  cpu_type: Intel Conroe Family
  profile: production



###########################
# Hosts
###########################
hosts:
- name: myhost
  address: 1.2.3.5
  cluster: production
  password: 123456
- name: myhost1
  address: 1.2.3.6
  cluster: production
  password: 123456



###########################
# Storage
###########################
storages:
mynfsstorage:
 master: true
 state: present
 nfs:
  address: 1.2.3.4
  path: /om02
myiscsistorage:
 iscsi:
  target: iqn.2014-07.org.ovirt:storage
  port: 3260
  address: 192.168.200.3
  username: username
  password: password
  lun_id: 3600140551fcc8348ea74a99b6760fbb4
mytemplates:
 domain_function: export
 nfs:
  address: 192.168.200.3
  path: /exports/nfs/exported
myisostorage:
 domain_function: iso
 nfs:
  address: 192.168.200.3
  path: /exports/nfs/iso



###########################
# Networks
###########################
logical_networks:
-  name: mynetwork
  clusters:
   - name: development
     assigned: false
     required: true
     display: false
     migration: true
     gluster: false



host_networks:
- name: myhost1
  check: true
  save: true
  bond:
   name: bond0
   mode: 2
   interfaces:
    - eth2
    - eth3
  networks:
  -  name: mynetwork
     boot_protocol: dhcp



###########################
# Users & Groups
###########################
users:
- name: user1
  authz_name: internal-authz
  password: 1234568
  valid_to: "2018-01-01 00:00:00Z"
- name: user2
  authz_name: internal-authz
  password: 1234568
  valid_to: "2018-01-01 00:00:00Z"

```
The yml variable file describes the environment configuration and translates it to API calls that will configure the datacenter in minimal time. It will utilize the oVirt Ansible component roles to configure the datacenters, clusters, hosts, storage domains, networks, and optionally add users.

Not only can the role configure a new environment but it can also manage and reconfigure an existing one, giving the capabilities to add and remove entities from the system.
In addition, it also includes some special tweaks like cluster profiles. We defined two cluster profiles which designate the cluster as either “production” (with specific SLA and management level characteristics) or “development” (to squeeze more compute power out of the physical hardware).

## ovirt-image-template

How many times have you performed the routine task of creating a VM for the sole purpose of converting it to a template? If you find this task tedious, this role comes to the rescue. It’s a very simple and straightforward role. Specify the disk image URL and template properties, and the role automates the process of downloading the qcow2, creating an image, and then converting it into a template for you.

```yaml


 name: oVirt image template
 hosts: localhost
 connection: local
 gather_facts: false



 vars_files:
   # Contains encrypted `engine_password` varibale using ansible-vault
   - passwords.yml



 vars:
   engine_url: https://ovirt-engine.example.com/ovirt-engine/api
   engine_user: admin@internal
   engine_cafile: /etc/pki/ovirt-engine/ca.pem



   qcow_url: https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2
   template_cluster: production
   template_name: centos7_template
   template_memory: 2GiB
   template_cpu: 2
   template_disk_size: 10GiB
   template_disk_storage: nfs



 roles:
   - ovirt-image-template
```

## Ovirt-vm-infra

This role is for laying down the application infrastructure. Let’s take a simple example, say you would like to deploy a LAMP application, one VM for the database and one VM for the web-server. This role can help you to create a consistent configuration for this deployment type and redeployment, with one command line (This is the base for a N-tier application deployment using Ansible dynamic inventory, a topic for another article).
To use this role, edit a simple yml file which describes the virtual application infrastructure you would like to create. Here is one such example:

```yaml

 name: oVirt infra
 hosts: localhost
 connection: local
 gather_facts: false



 vars_files:
   # Contains encrypted `engine_password` varibale using ansible-vault
   - passwords.yml



 vars:
   engine_url: https://ovirt-engine.example.com/ovirt-engine/api
   engine_user: admin@internal
   engine_cafile: /etc/pki/ovirt-engine/ca.pem



   httpd_vm:
     cluster: production
     domain: example.com
     template: rhel7
     memory: 2GiB
     cores: 2
     ssh_key: ssh-rsa AAA...LGx user@fqdn
     disks:
       - size: 10GiB
         name: data
         storage_domain: mynfsstorage
         interface: virtio



   db_vm:
     cluster: production
     domain: example.com
     template: rhel7
     memory: 4GiB
     cores: 1
     ssh_key: ssh-rsa AAA...LGx user@fqdn
     disks:
       - size: 50GiB
         name: data
         storage_domain: mynfsstorage
         interface: virtio



   vms:
     - name: postgresql-vm-0
       tag: postgresql_vm
       profile: "{{ db_vm }}"
     - name: postgresql-vm-1
       tag: postgresql_vm
       profile: "{{ db_vm }}"
     - name: apache-vm
       tag: httpd_vm
       profile: "{{ httpd_vm }}"



 roles:
   - ovirt-vm-infra

```

Note the profiles concept. Each VM type is specified with a profile from which many instances can be created later on.

Additional information and recommendations:

Get all the Ansible roles and modules for oVirt from [Ansible Galaxy](https://galaxy.ansible.com/ovirt/ovirt-ansible-roles/), straight from [oVirt GitHub](https://github.com/oVirt/ovirt-ansible). This is where you will also find documentation and demos for each role. In the future, we plan to package all of the roles into a single RPM.

The preferred means of running playbooks is to use a bastion machine on which the oVirt python SDK and Ansible 2.3 would be installed. This way, the Ansible playbook will be translated into REST API calls which will be executed against the engine. You can also run it from the local engine or in other topologies, but using the bastion host would be more secure and performant.
If you decide to go with this option, make sure that the connection parameters are set correctly in the playbook:

```yaml

 name: oVirt infra

 hosts: localhost

 connection: local

 gather_facts: false

 vars:

   engine_url: https://ovirt-engine.example.com/ovirt-engine/api

   engine_user: admin@internal

   engine_cafile: /etc/pki/ovirt-engine/ca.pem

```

   To avoid sending passwords in cleartext, use Ansible vault and encrypt them in an [extra-vars file](https://github.com/oVirt/ovirt-ansible/blob/master/examples/passwords.yml)

   Wrapping up, I just wanted to give kudos to Ondra Machacek the lead developer of this integration, and the whole oVirt infra team which helped to push this integration forward.

   We would love to get your feedback and patches in order to improve those roles and others which are in development.
