# Create the Playbook to Generate the Mapping File

The Ansible playbook used to generate the mapping file will prepopulate the file with the target (primary) site’s entities. You then need to manually add the backup site’s entities, such as IP addresses, cluster, affinity groups, affinity label, external LUN disks, authorization domains, roles, and vNIC profiles, to the file.

**Important:** The mapping file generation will fail if you have any virtual machine disks on the self-hosted engine’s storage domain. Also, the mapping file will not contain an attribute for this storage domain because it must not be failed over.

In this example the Ansible playbook is named `dr-rhv-setup.yml`, and is executed on the Manager machine in the primary site.

**Creating the mapping file**:

1. Create an Ansible playbook to generate the mapping file. For example:

   ```
   ---
   - name: Generate mapping
     hosts: localhost
     connection: local

     vars:
       site: https://example.engine.redhat.com/ovirt-engine/api
       username: admin@internal
       password: my_password
       ca: /etc/pki/ovirt-engine/ca.pem
       var_file: disaster_recovery_vars.yml

     roles:
       - oVirt.disaster-recovery
   ```

   **Note:** For extra security you can encrypt your Manager password in a `.yml` file. See [Using Ansible Roles to Configure Red Hat Virtualization](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html-single/administration_guide/index) in the *Administration Guide* for more information.

2. Run the Ansible command to generate the mapping file. The primary site’s configuration will be prepopulated.

   ```
   # ansible-playbook dr-rhv-setup.yml --tags "generate_mapping"
   ```

3. Configure the mapping file (`disaster_recovery_vars.yml` in this case) with the backup site’s configuration. See [Mapping File Attributes](../mapping_file_attributes) for more information about the mapping file’s attributes.

If you have multiple Ansible machines that can perform the failover and failback, then copy the mapping file to all relevant machines.

