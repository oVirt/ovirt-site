---
title: How to use oVirt Ansible roles
author: omachace
tags: Ansible, Roles, Automation, Configuration management
date: 2017-08-16 15:00:00 CET
comments: true
published: true
---

The recent post, [An Introduction to Ansible Roles](./2017-07-19-ovirt-ansible-roles-an-introduction.html.md), discussed the new roles that were introduced in the oVirt 4.1.6 release. This follow-up post will explain how to set up and use Ansible roles, using either Ansible Galaxy or oVirt Ansible Roles RPM.

## Ansible Galaxy

To make life easier, [Ansible Galaxy](https://galaxy.ansible.com/) stores multiple Ansible roles, including oVirt Ansible roles. To install the roles, perform the next steps:

To install roles on your local machine, run the following command:

```bash
$ ansible-galaxy install ovirt.ovirt-ansible-roles
```

This will install your roles into directory `/etc/ansible/roles/ovirt.ovirt-ansible-roles/`.

By default, Ansible only searches for roles in `/etc/ansible/roles/` directory and your current working directory.

To change the directories where Ansible looks for roles, modify the `roles_path` option of `[defaults]` section in `ansible.cfg` configuration file.

The default location of this file is in `/etc/ansible/ansible.cfg`.

```bash
$ sed -i 's|#roles_path    = /etc/ansible/roles|roles_path = /etc/ansible/roles:/etc/ansible/roles/ovirt.ovirt-ansible-roles/roles|'  /etc/ansible/ansible.cfg
```

For more information on changing the directories where Ansible searches for roles, see the Ansible documentation pages.

Copy one of the examples from the directory `/etc/ansible/roles/ovirt.ovirt-ansible-roles/examples/` into your working directory, then modify the needed variables and run the playbook.

## oVirt Ansible Roles RPM

In the latest oVirt repositories you can find the `ovirt-ansible-roles` package. To make the oVirt repositories available, install `ovirt-release` RPM:

```bash
$ yum install -y http://resources.ovirt.org/pub/yum-repo/ovirt-release41.rpm
```

oVirt release repository now provides `ovirt-ansible-roles` package:

```bash
$ yum install -y ovirt-ansible-roles
```

The structure of the `ovirt-ansible-roles` package is as follows:

 - __/usr/share/ansible/roles__ - stores the roles
 - __/usr/share/doc/ovirt-ansible-roles/__ - stores the examples, a basic overview and the licence
 - __/usr/share/doc/ansible/roles/{role_name}__ - stores the documentation specific to the role

Copy one of the examples from the directory `/usr/share/doc/ovirt-ansible-roles/examples` into your working directory, then modify the needed variables and run the playbook.

## An Example of Tweaking and Running the Playbook

### Create Example Playbook

Running the example from Galaxy or RPM is bit different. Therefore, please follow the relevant instructions.

#### Ansible Galaxy

The following steps assume that: you followed the steps on how to install the roles from Galaxy, your roles are installed in `/etc/ansible/roles/ovirt.ovirt-ansible-roles/roles/`, and you have tweaked `ansible.cfg` to look for those roles.

Run a role called `ovirt-image-template` to download the qcow2 image and create a template from it.

Copy the `ovirt-image-template` role example. In this example we will use `/tmp` as the working directory:

```bash
$ cd /tmp
$ cp /etc/ansible/roles/ovirt.ovirt-ansible-roles/examples/ovirt_image_template.yml .
```

#### oVirt Ansible Roles RPM
The following steps assume that: you followed the instructions on how to install the roles from RPM, and your roles are already installed in `/usr/share/ansible/roles`.

Run a role called `ovirt-image-template` to download the qcow2 image and create a template from it.

Copy the `ovirt-image-template` role example. In this example I will use `/tmp` as the working directory:

```bash
$ cd /tmp
$ cp /usr/share/doc/ovirt-ansible-roles/examples/ovirt_image_template.yml .
```


### Tweaking and Running the Playbook

Modify the variables to reflect your needs:

```yaml
---
- name: oVirt image template
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
    template_cluster: testcluster
    template_name: centos7_template
    template_memory: 2GiB
    template_cpu: 2
    template_disk_size: 10GiB
    template_disk_storage: nfs

  roles:
    - ovirt-image-template
```

Create a file with an oVirt engine user password:

```bash
$ cat passwords.yml
engine_password: youruserpassword
```

Encrypt the file with an oVirt user password. You will be asked for a vault password:

```bash
$ ansible-vault encrypt passwords.yml
New Vault password: 
Confirm New Vault password: 
```

`Encryption successful` will confirm that you have encrypted the file.

Ensure you have installed Python SDK on your machine because you will run your playbook on localhost:

```bash
$ yum install -y python-ovirt-engine-sdk4
```

If you use Galaxy and don't have oVirt repositories you can install Python SDK from pip:

```bash
$ pip install ovirt-engine-sdk-python
```

Run the playbook:

```bash
$ ansible-playbook --ask-vault-pass ovirt_image_template.yml
```

That's it. After the `ansible-playbook` command completes successfully, you will have deployed a template using the qcow2 image."
