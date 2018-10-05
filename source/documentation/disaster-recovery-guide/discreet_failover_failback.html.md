# Discreet Failover and Failback Test

For this test you must define testable storage domains that will be used specifically for testing the failover and failback. These storage domains must be replicated so that the replicated storage can be attached to the secondary site. This allows you to test the failover while users continue to work in the primary site.

**Note:** Red Hat recommends defining the testable storage domains on a separate storage server that can be offline without affecting the primary storage domains used for production in the primary site.

For more information about failing over the environment, cleaning the environment, and performing the failback, see [Execute a Failover](../execute_failover), [Clean the Primary Site](../clean), and [Execute a Failback](../execute_failback).

**Performing the discreet failover test:**

1. Stop the test storage domains in the primary site. You can do this by, for example, shutting down the server host or blocking it with an `iptables` rule.

2. Disable the storage replication between the testable storage domains and ensure that all replicated storage domains used for the test are in read/write mode.

3. Place the test primary storage domains into read-only mode.

4. Run the command to fail over to the secondary site: 

   ```
   # ansible-playbook _playbook_ --tags "fail_over"
   ```

5. Verify that all relevant storage domains, virtual machines, and templates are registered and running successfully.

**Performing the discreet failback test**

1. Run the command to clean the primary site and remove all inactive storage domains and related virtual machines and templates: 

   ```
   # ansible-playbook _playbook_ --tags "clean_engine"
   ```

2. Run the failback command:

   ```
   # ansible-playbook _playbook_ --tags "fail_back"
   ```

3. Enable replication from the primary storage domains to the secondary storage domains.

4. Verify that all relevant storage domains, virtual machines, and templates are registered and running successfully.
