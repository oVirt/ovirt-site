---
title: Automating Configuration Tasks Using Ansible
---

# Chapter 14: Automating Configuration Tasks Using Ansible

Ansible is an automation tool used to configure systems, deploy software, and perform rolling updates. Ansible includes support for oVirt, and Ansible modules are available to allow you to automate post-installation tasks such as data center setup and configuration, managing users, or virtual machine operations.

Ansible provides an easier method of automating oVirt configuration compared to REST APIs and SDKs, and allows you to integrate with other Ansible modules. For more information about the Ansible modules available for oVirt, see the oVirt modules in the Ansible documentation.

    **Note:** The AWX Project is a graphically enabled framework accessible through a web interface and REST APIs for Ansible.

To install Ansible, ensure that you have enabled the required repositories. Run the following command:

    # yum install ansible

See the Ansible Documentation for alternate installation instructions, and information about using Ansible.

    **Note:** To permanently increase the verbose level for the Engine when running Ansible playbooks, create a configuration file in `/etc/ovirt-engine/engine.conf.d/` with following line:

        ANSIBLE_PLAYBOOK_VERBOSE_LEVEL=4

    You must restart the Manager after creating the file by running `systemctl restart ovirt-engine`.

## Ansible Roles

Multiple Ansible roles are available to help configure and manage various parts of the oVirt infrastructure. Ansible roles provide a method of modularizing Ansible code by breaking up large playbooks into smaller, reusable files that can be shared with other users.

The Ansible roles available for oVirt are categorized by the various infrustructure components. For more information about the Ansible roles, see the oVirt Ansible Roles documentation.

### Installing Ansible Roles

Use the following command to install the Ansible roles:

    # yum install ovirt-ansible-roles

By default the roles are installed to **/usr/share/ansible/roles**. The structure of the `ovirt-ansible-roles` package is as follows:

* **/usr/share/ansible/roles** - stores the roles.

* **/usr/share/doc/ovirt-ansible-roles/** - stores the examples, a basic overview, and the license.

* **/usr/share/doc/ansible/roles/role_name** - stores the documentation specific to the role.

### Using Ansible Roles to Configure oVirt

The following procedure guides you through creating and running a playbook that uses Ansible roles to configure oVirt. This example uses Ansible to connect to the Engine on the local machine and create a new data center.

**Prerequisites**

* Ensure the `roles_path` option in **/etc/ansible/ansible.cfg** points to the location of your Ansible roles (**/usr/share/ansible/roles**).

* Ensure that you have the Python SDK installed on the machine running the playbook.

**Configuring oVirt using Ansible Roles**

1. Create a file in your working directory to store the oVirt Engine user password:

    # cat passwords.yml
      ---
    engine_password: youruserpassword

2. Encrypt the user password. You will be asked for a Vault password.

    # ansible-vault encrypt passwords.yml
    New Vault password:
    Confirm New Vault password:

3. Create a file that stores the Engine details such as the URL, certificate location, and user.

    # cat engine_vars.yml
    ---
    engine_url: https://example.engine.redhat.com/ovirt-engine/api
    engine_user: admin@internal
    engine_cafile: /etc/pki/ovirt-engine/ca.pem

    **Note:** If you prefer, these variables can be added directly to the playbook instead.

4. Create your playbook. To simplify this you can copy and modify an example in **/usr/share/doc/ovirt-ansible-roles/examples**.

    # cat rhv_infra.yml
    ---
    - name: RHV infrastructure
      hosts: localhost
      connection: local
      gather_facts: false

      vars_files:
        # Contains variables to connect to the Manager
        - engine_vars.yml
        # Contains encrypted engine_password variable using ansible-vault
        - passwords.yml

      pre_tasks:
        - name: Login to RHV
          ovirt_auth:
            url: "{{ engine_url }}"
            username: "{{ engine_user }}"
            password: "{{ engine_password }}"
            ca_file: "{{ engine_cafile | default(omit) }}"
            insecure: "{{ engine_insecure | default(true) }}"
          tags:
            - always

      vars:
        data_center_name: mydatacenter
        data_center_description: mydatacenter
        data_center_local: false
        compatibility_version: 4.1

      roles:
        - ovirt-datacenters

      post_tasks:
        - name: Logout from RHV
          ovirt_auth:
            state: absent
            ovirt_auth: "{{ ovirt_auth }}"
          tags:
            - always

5. Run the playbook.

    # ansible-playbook --ask-vault-pass rhv_infra.yml

You have successfully used the `ovirt-datacenters` Ansible role to create a data center named `mydatacenter`.

**Prev:** [Chapter 13: Backups and Migration](../chap-Backups_and_Migration)<br>
**Next:** [Chapter 15: Users and Roles](../chap-Users_and_Roles)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/administration_guide/chap-automating_rhv_configuration_using_ansible)
