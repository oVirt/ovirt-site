# Discreet Failover Test

This test simulates a failover while the primary site and all its storage domains remain active, allowing users to continue working in the primary site. For this to happen you will need to disable replication between the primary storage domains and the replicated (secondary) storage domains. During this test the primary site will be unaware of the failover activities on the secondary site.

This test will not allow you to test the failback functionality.

**Important:** Ensure that no production tasks are performed after the failover. For example, ensure that email systems are blocked from sending emails to real users, or redirect emails elsewhere. If systems are used to directly manage other systems, prohibit access to the systems or ensure that they access parallel systems in the secondary site.

**Performing the discreet failover test:**

1. Disable storage replication between the primary and replicated storage domains, and ensure that all replicated storage domains are in read/write mode.

2. Run the command to fail over to the secondary site:

   ```
   # ansible-playbook _playbook_ --tags "fail_over"
   ```

   For more information, see [Execute a Failback](../execute_failback).

3. Verify that all relevant storage domains, virtual machines, and templates are registered and running successfully.


**Restoring the environment to its active-passive state:**

1. Detach the storage domains from the secondary site.
2. Enable storage replication between the primary and secondary storage domains.
