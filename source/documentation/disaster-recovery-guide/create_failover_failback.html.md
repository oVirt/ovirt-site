# Create the Failover and Failback Playbooks

Ensure that you have the mapping file that you created and configured, in this case `disaster_recovery_vars.yml`, because this must be added to the playbooks.

You can define a password file (for example `passwords.yml`) to store the Manager passwords of the primary and secondary site. For example:

```
---
# This file is in plain text, if you want to
# encrypt this file, please execute following command:
#
# $ ansible-vault encrypt passwords.yml
#
# It will ask you for a password, which you must then pass to
# ansible interactively when executing the playbook.
#
# $ ansible-playbook myplaybook.yml --ask-vault-pass
#
dr_sites_primary_password: primary_password
dr_sites_secondary_password: secondary_password
```

**Note:** For extra security you can encrypt the password file. However, you will need to use the `--ask-vault-pass` parameter when running the playbook. See _Using Ansible Roles to Configure Red Hat Virtualization_ in the [Administration Guide](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/administration_guide/chap-automating_rhv_configuration_using_ansible#Using_Ansible_Roles) for more information.

In these examples the Ansible playbooks to fail over and fail back are named `dr-rhv-failover.yml` and  `dr-rhv-failback.yml`.

Create the  following Ansible playbook to failover the environment:

```
--- 
- name: Failover RHV
  hosts: localhost
  connection: local
  vars:
    dr_target_host: secondary
    dr_source_map: primary
  vars_files:
    - disaster_recovery_vars.yml
    - passwords.yml
  roles:
    - oVirt.disaster-recovery

```

Create the  following Ansible playbook to failback the environment:

```
--- 
- name: Failback RHV
  hosts: localhost
  connection: local
  vars:
    dr_target_host: primary
    dr_source_map: secondary
  vars_files:
    - disaster_recovery_vars.yml
    - passwords.yml
  roles:
    - oVirt.disaster-recovery
```

