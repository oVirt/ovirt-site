# Testing the Active-Passive Configuration

You must test your disaster recovery solution after configuring it. This section provides multiple options to test the active-passive disaster recovery configuration.

1. Test failover while the primary site remains active and without interfering with virtual machines on the primary site's storage domains. See [Discreet Failover Test](../discreet_failover).

2. Test failover and failback using specific storage domains attached to the the primary site, therefore allowing the primary site to remain active. See [Discreet Failover and Failback Test](../discreet_failover_failback).

3. Test failover and failback for an impending disaster where you have a grace period to failover to the secondary site, or an unplanned shutdown of the primary site. See [Full Failover and Failback test](../non_discreet_failover_failback).

**Important:** Ensure that you completed all the steps to configure your active-passive configuration before running any of these tests.

* [Discreet Failover Test](../discreet_failover)
* [Discreet Failover and Failback Test](../discreet_failover_failback)
* [Full Failover and Failback test](../non_discreet_failover_failback)
