---
title: oVirt Ansible modules
category: feature
authors: omachace
wiki_category: Feature
wiki_title: Features/Ansible
wiki_revision_count: 1
wiki_last_updated: 2016-09-22
---

# Ansible

## About

Ansible is an IT automation tool. It can configure systems, deploy software, and orchestrate more advanced IT tasks such
as continuous deployments or zero downtime rolling updates.

Ansible’s main goals are simplicity and ease-of-use. It also has a strong focus on security and reliability,
featuring a minimum of moving parts, usage of OpenSSH for transport (with an accelerated socket mode and pull modes
as alternatives), and a language that is designed around auditability by humans–even those not familiar with the program.

## Playbooks
Playbooks are Ansible’s configuration, deployment, and orchestration language. They can describe a policy you want your remote
systems to enforce, or a set of steps in a general IT process. Playbooks uses [YAML](http://yaml.org) as support language. In
general playbooks consist of tasks. Every tasks executes specific module with parameters.

## Modules
Ansible ships with a number of modules (called the ‘module library’) that can be executed directly on remote hosts or through 
Playbooks. Modules have to be idempotent. The concept that change commands should only be applied when they need to be applied,
and that it is better to describe the desired state of a system than the process of how to get to that state. This feature page
describes oVirt ansible modules.

# oVirt Ansible modules

The goal is to have a module for every entity oVirt has, so users can manage whole oVirt environment via Ansible playbooks.
So far few modules has been merged to Ansible and are part of Ansible extras [modules](https://github.com/ansible/ansible-modules-extras/).

__Note__: Links to modules documentation which will be in Ansible 2.3 are temporary on readthedocs page
once, the modules will be merged and Ansible 2.3 will be release we will change links to official documentation.

# Ansible 2.2
Following modules has been merged and can be used in Ansible version 2.2.

## ovirt_auth
[ovirt_auth](http://docs.ansible.com/ansible/ovirt_auth_module.html)
[[source]](https://github.com/ansible/ansible-modules-extras/blob/devel/cloud/ovirt/ovirt_auth.py)
module authenticates to oVirt engine and creates SSO
token, which should be later used in all other oVirt modules, so all modules don’t need to perform login and logout. This
module returns an Ansible fact called _ovirt_auth_. Every module can use this fact as auth parameter, to perform authentication

### Example
```yaml
# Obtain SSO token with using username/password credentials
no_log: true
ovirt_auth:
  url: https://ovirt.example.com/ovirt-engine/api
  username: admin@internal
  password: 123456
  ca_file: ca.pem

# Revoke the SSO token returned from previous task
ovirt_auth:
  state: absent
  ovirt_auth: "{{ ovirt_auth }}"
```

## ovirt_vms
[ovirt_vms](http://docs.ansible.com/ansible/ovirt_vms_module.html)
[[source]](https://github.com/ansible/ansible-modules-extras/blob/devel/cloud/ovirt/ovirt_vms.py)
module manages whole lifecycle of the Virtual Machine (VM)
in oVirt. In addtion you can add disks and network interfaces to VM from this module, but if you need to manage disks and
network interfaces in more depth you should use modules specifically for it.

### Example
```yaml
# Creates a new Virtual Machine from template named 'rhel7_template'
ovirt_vms:
    state: present
    name: myvm
    template: rhel7_template

# Run VM with cloud init:
ovirt_vms:
    name: rhel7
    template: rhel7
    cluster: Default
    memory: 1GiB
    high_availability: true
    cloud_init:
      nic_boot_protocol: static
      nic_ip_address: 10.34.60.86
      nic_netmask: 255.255.252.0
      nic_gateway: 10.34.63.254
      nic_name: eth1
      nic_on_boot: true
      host_name: example.com
      custom_script: |
        write_files:
         - content: |
             Hello, world!
           path: /tmp/greeting.txt
           permissions: '0644'
      user_name: root
      root_password: super_password

# Migrate/Run VM to/on host named 'host1'
ovirt_vms:
    state: running
    name: myvm
    host: host1

# Change Vm's CD:
ovirt_vms:
    name: myvm
    cd_iso: drivers.iso

# Stop vm:
ovirt_vms:
    state: stopped
    name: myvm

# Hot plug memory to already created and running VM:
# (VM won't be restarted)
ovirt_vms:
    name: myvm
    memory: 4GiB
  
# When change on the VM needs restart of the VM, use next_run state,
# The VM will be updated and rebooted if there are any changes.
# If present state would be used, VM won't be restarted.
ovirt_vms:
    state: next_run
    name: myvm
    boot_devices:
      - network
```

## ovirt_disks
[ovirt_disks](http://docs.ansible.com/ansible/ovirt_disks_module.html)
[[source]](https://github.com/ansible/ansible-modules-extras/blob/devel/cloud/ovirt/ovirt_disks.py)
module to manage Virtual Machine and floating disks in oVirt. This module can attach/detach disks from VM, update attached
disks attributes. This module also handle work with logical units.

### Examples
```yaml
# Create and attach new disk to VM
- ovirt_disks:
    name: myvm_disk
    vm_name: rhel7
    size: 10GiB
    format: cow
    interface: virtio

# Attach logical unit to VM rhel7
- ovirt_disks:
    vm_name: rhel7
    logical_unit:
      target: iqn.2016-08-09.brq.str-01:omachace
      id: 1IET_000d0001
      address: 10.34.63.204
    interface: virtio

# Detach disk from VM
- ovirt_disks:
    state: detached
    name: myvm_disk
    vm_name: rhel7
    size: 10GiB
    format: cow
    interface: virtio
```

# Ansible 2.3
Following modules are pull request ready and will be included in Ansible version 2.3.

## ovirt_clusters
## ovirt_groups
## ovirt_networks
## ovirt_permissions
## ovirt_storage_domains
## ovirt_users
## ovirt_datacenters
## ovirt_external_providers
## ovirt_host_networks
## ovirt_hosts
## ovirt_nics
## ovirt_snapshots
## ovirt_templates
## ovirt_vmpools

# Playbook execution example

### Workspace
First we need to create directory where we will store our playbooks and inventory.

```bash
$ mkdir $HOME/ovirt-ansible
```

### Additional modules
In this example we will use all modules which will be part of the Ansible 2.3, which is not yet realeased, so please first
download all releveant modules and put them into _library_ directory.

```bash
$ mkdir $HOME/ovirt-ansible/library
$ wget https://github.com/machacekondra/ovirt-ansible-example/blob/master/library/ovirt_clusters.py
...
```

### Hosts inventory
Now we need to create a hosts _invetory_ file where we will define a connection details and variables.

```bash
cat >> $HOME/ovirt-ansible/inventory/hosts << EOF
[ovirt]
ovirt.example.com

[ovirt:vars]
username=admin@internal
url=https://ovirt.example.com/ovirt-engine/api
ca_file=/etc/pki/ovirt-engine/ca.pem
external_provider=myprovider
datacenter=mydatacenter
cluster=mycluster
host=myhost
host_address=10.34.60.215
data_name=data
iscsi_name=data2
export_name=export
iso_name=iso
template=rhel7
vm=rhel7
EOF
```

### Playbook directory
Now we need to create symlink to our library from playbooks direcotry, so the ansible knows where to find our additional
modules.

```bash
$ mkdir $HOME/ovirt-ansible/playbooks
$ ln -s $HOME/ovirt-ansible/playbooks/library $HOME/ovirt-ansible/library
```

### Vault
Create vault with oVirt user password, so we don't use this password in plaintext. There is tool which make it easy for
your, just enter this command:

```bash
$ ansible-vault create  ovirt_password.yml
```

This will fire up your editor. Create there _password_ variable with password of your _admin@internal_ user:

```yaml
password: MySuperPasswordOfAdminAtInternal
```

Next it will ask your for a vault password and then it creates _ovirt_password.yml_ file, with your vault.

### Playbook creation
Create a playbook, with tasks you want to execute:
```yaml
cat >> playbooks/setup_demo.yml << EOF
---
- name: Setup oVirt environment
  hosts: ovirt
  tasks:
    - block:
        - name: Include oVirt password
          no_log: true
          include_vars: ovirt_password.yml

        - name: Obtain SSO token
          no_log: false
          ovirt_auth:
            url: "{{ url }}"
            username: "{{ username }}"
            password: "{{ password }}"
            ca_file: "{{ ca_file }}"

        - name: Create datacenter
          ovirt_datacenters:
            auth: "{{ ovirt_auth }}"
            name: "{{ datacenter }}"
            description: mydatacenter
            local: false
            compatibility_version: 4.0
            quota_mode: disabled

        - name: Create cluster
          ovirt_clusters:
            auth: "{{ ovirt_auth }}"
            datacenter_name: "{{ datacenter }}"
            name: "{{ cluster }}"
            cpu_type: Intel Nehalem Family
            description: mycluster
            compatibility_version: 4.0

        - name: Add host using public key
          ovirt_hosts:
            auth: "{{ ovirt_auth }}"
            public_key: true
            cluster: "{{ cluster }}"
            name: "{{ host }}"
            address: "{{ host_address }}"

        - name: Add data NFS storage domain
          ovirt_storage_domains:
            auth: "{{ ovirt_auth }}"
            name: "{{ data_name }}"
            host: "{{ host }}"
            data_center: "{{ datacenter }}"
            nfs:
              address: 10.34.63.199
              path: /omachace/data

        - name: Add data iSCSI storage domain
          ovirt_storage_domains:
            auth: "{{ ovirt_auth }}"
            name: "{{ iscsi_name }}"
            host: "{{ host }}"
            data_center: "{{ datacenter }}"
            iscsi:
              target: iqn.2016-08-09.brq.str-01:omachace
              lun_id: 1IET_000d0002
              address: 10.34.63.204
          ignore_errors: true

        - name: Import export NFS storage domain
          ovirt_storage_domains:
            auth: "{{ ovirt_auth }}"
            name: "{{ export_name }}"
            host: "{{ host }}"
            domain_function: export
            data_center: "{{ datacenter }}"
            nfs:
              address: 10.34.63.199
              path: /omachace/export

        - name: Create ISO NFS storage domain
          ovirt_storage_domains:
            auth: "{{ ovirt_auth }}"
            name: "{{ iso_name }}"
            host: "{{ host }}"
            domain_function: iso
            data_center: "{{ datacenter }}"
            nfs:
              address: 10.34.63.199
              path: /omachace/iso

        - name: Add image external provider
          ovirt_external_providers:
            auth: "{{ ovirt_auth }}"
            name: "{{ external_provider }}"
            type: os_image
            url: http://10.34.63.71:9292
            username: admin
            password: qum5net
            tenant: admin
            auth_url: http://10.34.63.71:35357/v2.0/

        - name: Import template
          ovirt_templates:
            auth: "{{ ovirt_auth }}"
            name: "{{ template }}"
            state: imported
            export_domain: "{{ export_name }}"
            storage_domain: "{{ data_name }}"
            cluster: "{{ cluster }}"

        - name: Create and run VM from template
          ovirt_vms:
            auth: "{{ ovirt_auth }}"
            name: "{{ vm }}"
            template: "{{ template }}"
            cluster: "{{ cluster }}"
            memory: 1GiB
            high_availability: true
            cloud_init:
              host_name: mydomain.local
              custom_script: |
                write_files:
                 - content: |
                     Hello, world!
                   path: /tmp/greeting.txt
                   permissions: '0644'
              user_name: root
              root_password: '1234567'

      always:
        - name: Revoke the SSO token
          ovirt_auth:
            state: absent
            ovirt_auth: "{{ ovirt_auth }}"
EOF
```

### Playbook execution
To execute the playbook run following command:
```bash
$ ansible-playbook -i $HOME/ovirt-ansible/inventory/hosts $HOME/ovirt-ansible/playbooks/setup_demo.yml --ask-vault-pass
Vault password: 

PLAY [Setup oVirt environment] *************************************************

TASK [setup] *******************************************************************
ok: [localhost]

TASK [Include oVirt password] **************************************************
ok: [localhost]
.....
```
It will ask you for the password of the vault and then execute the playbook. Now try to re-run the playbook, and see that no
changes was done on environment.
