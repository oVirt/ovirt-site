---
title: oVirt roles Ansible Galaxy integration
author: omachace
tags: Ansible, Roles, Automation, Configuration management, Galaxy
date: 2017-12-08 15:00:00 CET
comments: true
published: true
---

In 4.2 release we have splitted our oVirt Ansible roles into separate RPM packages and also separate git repositories, so it is possible for user to install specific role either from Ansible Galaxy or as RPM package.

READMORE

## The reason
The reason to split the roles into separate packages and git repositories was mainly the usage from the AWX/Ansible Tower. Since Ansible Galaxy is only integrated with github you need to store your Ansible role in single git repostiory in order to have separate Ansible role in Galaxy. Previously we used one single repository where we have stored all the roles, but because of that manual configuration was required to make those roles usable in AWX/Ansible Tower. So as you can see on image below we now have many roles in Ansible Galaxy under oVirt user:

![oVirt roles in Ansible Galaxy](galaxy_roles.png)

## How to install the roles 
There are still two ways how to install the roles: either using Ansible Galaxy or using RPM package available from oVirt repositories.

### Ansible Galaxy
You are now able to install just a single role and not necessarily all of them at once like in previous versions
For example to install just oVirt cluster upgrade role, you have to run following command:

```bash
$ ansible-galaxy install oVirt.cluster-upgrade
```

Note that we still support the posibility to download and install all roles at once,
you can do it by executing following command:

```bash
$ ansible-galaxy install oVirt.ovirt-ansible-roles
```

### From oVirt repository
Also using RPM you are now able to install just a single role and not necessarily all of them at once like in previous versions.
For example to install just oVirt cluster upgrade role, you have to run following command:

```bash
$ yum install ovirt-ansible-cluster-upgrade
```

Note that we haven't obsoleted the `ovirt-ansible-roles` package, it still exists and you can install all available oVirt roles using:

```bash
$ yum install ovirt-ansible-roles
```

The only difference is that this package now requires all the separate packages, so the packages itself
only provides documentation and examples.

## Compatibility changes
Unfortunatelly the split has its price.

### The names

#### Roles from Ansible Galaxy
Unfortunatelly split has also broken the names of the roles in Ansible Galaxy.
So before user could used the following names:

 - ovirt-cluster-upgrade
 - ovirt-image-template
 - ovirt-infra
 - ovirt-manageiq
 - ovirt-vm-infra

But since the naming in Ansible Galaxy is done as {owner}.{role-name}, we had to rename
the roles to:

 - oVirt.cluster-upgrade
 - oVirt.image-template
 - oVirt.infra
 - oVirt.manageiq
 - oVirt.vm-infra

Notice that we have changed the first dash by the dot and renamed `ovirt` to `oVirt`.

#### Roles from RPM
For the users who installed roles from RPM. The names with dash will still work,
as we are creating a symlink to new names. But please be aware that we will remove
this legacy name one day in the future.


### Removal of component roles
Previously the ovirt-ansible-roles package shipped the following component roles:

 - ovirt-aaa-jdbc
 - ovirt-affinity-groups
 - ovirt-clusters
 - ovirt-datacenter-cleanup
 - ovirt-datacenters
 - ovirt-external-providers
 - ovirt-hosts
 - ovirt-mac-pools
 - ovirt-networks
 - ovirt-permissions
 - ovirt-storages

Those roles are not provided as separately installable roles, but those are just internal
roles of `ovirt-infra` and `ovirt-vm-infra` roles. But the good thing is that user didn't
loose the ability execute the specific component role, we have tagged all the tasks in the
component roles with specific tags, so if you want to execute just single `oVirt-infra`
role inside `oVirt.infra` role, you can execute playbook with `oVirt.infra` role with tag
`hosts` and only `ovirt-hosts` role will be executed, for example:

```bash
$ ansible-playbook --tags hosts ovirt_infra.yml
```

To list all possible tags please execute following command, on playbook, where you execute
`oVirt.infra` role:

```bash
$ ansible-playbook --list-tags ovirt_infra.yml 

playbook: ovirt_infra.yml

  play #1 (localhost): oVirt infra	TAGS: []
      TASK TAGS: [always, clusters, datacenters, external_providers, host_networks, hosts, logical_networks, mac_pools, networks, ovirt-aaa-jdbc, permissions, reinstall, storage_connections, storages, user_groups, users]
```

Please note that any of those role can be created as separate role in future, if there will be need for it.
