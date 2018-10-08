# Create the Playbook to Clean the Primary Site

Before you failback to the primary site, you need to ensure that the primary site is cleaned of all storage domains to be imported. This can be performed manually on the Manager, or optionally you can create an Ansible playbook to perform it for you.

The Ansible playbook to clean the primary site is named `dr-cleanup.yml` in this example, and it uses the mapping file created in [Create the Playbook to Generate the Mapping File](../generate_mapping):

```
--- 
- name: clean RHV
  hosts: localhost
  connection: local
  vars:
    dr_source_map: primary
  vars_files:
    - disaster_recovery_vars.yml
  roles:
    - oVirt.disaster-recovery
```
