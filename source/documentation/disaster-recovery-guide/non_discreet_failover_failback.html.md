# Full Failover and Failback test

This test performs a full failover and failback between the primary and secondary site. You can simulate the disaster by shutting down the primary site's hosts or by adding `iptables` rules to block writing to the storage domains.

For more information about failing over the environment, cleaning the environment, and performing the failback, see [Execute a Failover](../execute_failover), [Clean the Primary Site](../clean), and [Execute a Failback](../execute_failback).

**Performing the failover test:**

1. Disable storage replication between the primary and replicated storage domains and ensure that all replicated storage domains are in read/write mode.

2. Run the command to fail over to the secondary site:

   ```
   # ansible-playbook _playbook_ --tags "fail_over"
   ```

3. Verify that all relevant storage domains, virtual machines, and templates are registered and running successfully.

**Performing the failback test**

1. Synchronize replication between the secondary site’s storage domains and the primary site’s storage domains. The secondary site’s storage domains must be in read/write mode and the primary site’s storage domains must be in read-only mode.

2. Run the command to clean the primary site and remove all inactive storage domains and related virtual machines and templates:

   ```
   # ansible-playbook _playbook_ --tags "clean_engine"
   ```

3. Run the failback command:

   ```
   # ansible-playbook _playbook_ --tags "fail_back"
   ```

4. Enable replication from the primary storage domains to the secondary storage domains.

5. Verify that all relevant storage domains, virtual machines, and templates are registered and running successfully.
