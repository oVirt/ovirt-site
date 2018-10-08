# Create the Required Ansible Playbooks

Ansible is used to initiate and manage the disaster recovery failover and failback. You therefore need to create Ansible playbooks to facilitate this. For more information about creating Ansible playbooks, see the [Ansible documentation](http://docs.ansible.com/ansible/latest/playbooks.html).

**Prerequisites**:

* Fully functioning Red Hat Virtualization environment in the primary site. See the [Installation Guide](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html-single/installation_guide/index) or [Self-hosted Engine Guide](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html-single/self-hosted_engine_guide/index) for information about installing Red Hat Virtualization environments.

* A backup environment in the secondary site with the same data center and cluster compatibility level as the primary environment. The backup environment must have:
  * A Red Hat Virtualization Manager.
  * Active hosts capable of running the virtual machines and connecting to the replicated storage domains.
  * A data center with clusters.
  * Networks with the same general connectivity as the primary site.

* Replicated storage. See [Storage Considerations](../storage_considerations_active-passive) for more information.

  **Note:** The replicated storage that contains virtual machines and templates must not be attached to the secondary site.

* The `oVirt.disaster-recovery` package must be installed on the highly available Red Hat Ansible Engine machine that will automate the failover and failback.

* The machine running Red Hat Ansible Engine must be able to use SSH to connect to the Manager in the primary and secondary site.

It is also recommended to create environment properties that exist in the primary site, such as affinity groups, affinity labels, users, on the secondary site.

**Note:** The default behaviour of the Ansible playbooks can be configured in the `/usr/share/ansible/roles/oVirt.disaster-recovery/defaults/main.yml` file.

The following playbooks must be created:

* The playbook that creates the file to map entities on the primary and secondary site.
* The failover playbook.
* The failback playbook.

You can also create an optional playbook to clean the primary site before failing back.

Create the playbooks and associated files in `/usr/share/ansible/roles/oVirt.disaster-recovery/` on the Ansible machine that is managing the failover and failback. If you have multiple Ansible machines that can manage it, ensure that you copy the files to all of them.

You can test the configuration using one or more of the testing procedures in [Testing the Active-Passive Configuration](../testing_active_passive).

* [Using the `ovirt-dr` Script for Ansible Tasks](../Using-ovirt-dr-script)
* [Create the Playbook to Generate the Mapping File](../generate_mapping)
* [Create the Failover and Failback Playbooks](../create_failover_failback)
* [Create the Playbook to Clean the Primary Site](../create_cleanup)
