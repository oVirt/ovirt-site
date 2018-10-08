# Execute a Failback

Once you fail over, you can fail back to the primary site when it is active and you have performed the necessary steps to clean the environment.

**Prerequisites**:

* The environment in the primary site is running and has been cleaned, see [Clean the Primary Site](../clean) for more information.
* The environment in the secondary site is running, and has active storage domains.
* A machine running Red Hat Ansible Engine that can connect via SSH to the Manager in the primary and secondary site, with the required packages and files:
  * The `oVirt.disaster-recovery` package.
  * The mapping file and required failback playbook.

This example uses the `dr-rhv-failback.yml` playbook created earlier.

**Executing a failback**:

1. Run the failback playbook with the following command:

   ```
   #  ansible-playbook dr-rhv-failback.yml --tags "fail_back"
   ```

2. Enable replication from the primary storage domains to the secondary storage domains.
