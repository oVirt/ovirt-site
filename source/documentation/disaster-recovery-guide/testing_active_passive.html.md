---
title: Testing the Active-Passive Configuration
---

# Appendix B: Testing the Active-Passive Configuration

You must test your disaster recovery solution after configuring it. This section provides multiple options to test the active-passive disaster recovery configuration.

1. Test failover while the primary site remains active and without interfering with virtual machines on the primary site's storage domains. See the" Discreet Failover Test" section.

2. Test failover and failback using specific storage domains attached to the the primary site, therefore allowing the primary site to remain active. See the "Discreet Failover and Failback" Test section.

3. Test failover and failback for an impending disaster where you have a grace period to failover to the secondary site, or an unplanned shutdown of the primary site. See the "Full Failover and Failback Test" section.

    **Important:** Ensure that you completed all the steps to configure your active-passive configuration before running any of these tests.

## Discreet Failover Test

This test simulates a failover while the primary site and all its storage domains remain active, allowing users to continue working in the primary site. For this to happen you will need to disable replication between the primary storage domains and the replicated (secondary) storage domains. During this test the primary site will be unaware of the failover activities on the secondary site.

This test will not allow you to test the failback functionality.

    **Important:** Ensure that no production tasks are performed after the failover. For example, ensure that email systems are blocked from sending emails to real users, or redirect emails elsewhere. If systems are used to directly manage other systems, prohibit access to the systems or ensure that they access parallel systems in the secondary site.

**Performing the discreet failover test:**

1. Disable storage replication between the primary and replicated storage domains, and ensure that all replicated storage domains are in read/write mode.

2. Run the command to fail over to the secondary site:

        # ansible-playbook _playbook_ --tags "fail_over"

   For more information, see "Execute a Failback" section in Chapter 3.

3. Verify that all relevant storage domains, virtual machines, and templates are registered and running successfully.

**Restoring the environment to its active-passive state:**

1. Detach the storage domains from the secondary site.

2. Enable storage replication between the primary and secondary storage domains.

## Discreet Failover and Failback Test

For this test you must define testable storage domains that will be used specifically for testing the failover and failback. These storage domains must be replicated so that the replicated storage can be attached to the secondary site. This allows you to test the failover while users continue to work in the primary site.

    **Note:** the oVirt Project recommends defining the testable storage domains on a separate storage server that can be offline without affecting the primary storage domains used for production in the primary site.

For more information about failing over the environment, cleaning the environment, and performing the failback, see the appropriate sections in Chapter 3.

**Performing the discreet failover test:**

1. Stop the test storage domains in the primary site. You can do this by, for example, shutting down the server host or blocking it with an `iptables` rule.

2. Disable the storage replication between the testable storage domains and ensure that all replicated storage domains used for the test are in read/write mode.

3. Place the test primary storage domains into read-only mode.

4. Run the command to fail over to the secondary site:

      # ansible-playbook _playbook_ --tags "fail_over"

5. Verify that all relevant storage domains, virtual machines, and templates are registered and running successfully.

**Performing the discreet failback test**

1. Run the command to clean the primary site and remove all inactive storage domains and related virtual machines and templates:

      # ansible-playbook _playbook_ --tags "clean_engine"

2. Run the failback command:

      # ansible-playbook _playbook_ --tags "fail_back"

3. Enable replication from the primary storage domains to the secondary storage domains.

4. Verify that all relevant storage domains, virtual machines, and templates are registered and running successfully.

## Full Failover and Failback Test

This test performs a full failover and failback between the primary and secondary site. You can simulate the disaster by shutting down the primary site’s hosts or by adding `iptables` rules to block writing to the storage domains.

For more information about failing over the environment, cleaning the environment, and performing the failback, see the appropriate sections in Chapter 3.

**Performing the failover test:**

1. Disable storage replication between the primary and replicated storage domains and ensure that all replicated storage domains are in read/write mode.

2. Run the command to fail over to the secondary site:

        # ansible-playbook playbook --tags "fail_over"

3. Verify that all relevant storage domains, virtual machines, and templates are registered and running successfully.

**Performing the failback test**

1. Synchronize replication between the secondary site’s storage domains and the primary site’s storage domains. The secondary site’s storage domains must be in read/write mode and the primary site’s storage domains must be in read-only mode.

2. Run the command to clean the primary site and remove all inactive storage domains and related virtual machines and templates:

        # ansible-playbook playbook --tags "clean_engine"

3. Run the failback command:

        # ansible-playbook playbook --tags "fail_back"

4. Enable replication from the primary storage domains to the secondary storage domains.

5. Verify that all relevant storage domains, virtual machines, and templates are registered and running successfully.

**Prev:** [Appendix A: Mapping File Attributes](../mapping_file_attributes)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/disaster_recovery_guide/testing_active_passive)
