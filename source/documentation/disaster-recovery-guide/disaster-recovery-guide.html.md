# Disaster Recovery Guide


## Chapter 1: [Disaster Recovery Solutions](../disaster_recovery_solutions)

## Chapter 2: Active-Active Disaster Recovery

This chapter provides instructions to configure Red Hat Virtualization for disaster recovery using the active-active disaster recovery solution.

### [Active-Active Overview](../active_active_overview)
#### [Network Considerations](../network_considerations)
#### [Storage Considerations](../storage_considerations_active_active)

### [Configure a Self-hosted Engine Stretch Cluster Environment](../configure_she_stretch_cluster)

### [Configure a Standalone Manager Stretch Cluster Environment](../configure_standalone_manager_stretch_cluster)

## Chapter 3: Active-Passive Disaster Recovery

This chapter provides instructions to configure Red Hat Virtualization for disaster recovery using the active-passive disaster recovery solution.

### [Active-Passive Overview](../active_passive_overview)
#### [Network Considerations](../network_considerations_active_passive)
#### [Storage Considerations](../storage_considerations_active-passive)

### [Create the Required Ansible Playbooks](../create_ansible_playbooks)
#### [Using the `ovirt-dr` Script for Ansible Tasks](../Using-ovirt-dr-script)
#### [Create the Playbook to Generate the Mapping File](../generate_mapping)
#### [Create the Failover and Failback Playbooks](../create_failover_failback)
#### [Create the Playbook to Clean the Primary Site](../create_cleanup)

### [Execute a Failover](../execute_failover)

### [Clean the Primary Site](../clean)

### [Execute a Failback](../execute_failback)

## Appendix A: [Mapping File Attributes](../mapping_file_attributes)

## Appendix B: [Testing the Active-Passive Configuration](../testing_active_passive)
### [Discreet Failover Test](../discreet_failover)
### [Discreet Failover and Failback Test](../discreet_failover_failback)
### [Full Failover and Failback test](../non_discreet_failover_failback)
