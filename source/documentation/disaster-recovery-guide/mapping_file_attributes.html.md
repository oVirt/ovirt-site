# Mapping File Attributes

The following table describes the attributes in the mapping file that is used to fail over and fail back between the two sites in an active-passive disaster recovery solution. 

**Mapping File Attributes**

<table>
<thead><tr><th>Mapping File Section</th><th>Description</th></tr></thead>
<tbody>

<tr>
<td>Site details</td>
<td>
<p>These attributes map the Manager details in the primary and secondary site. For example:</p>
<pre>dr_sites_primary_url: https://manager1.example.redhat.com/ovirt-engine/api
dr_sites_primary_username: admin@internal
dr_sites_primary_ca_file: /etc/pki/ovirt-engine/ca.pem

# Please fill in the following properties for the secondary site:
dr_sites_secondary_url: https://manager2.example.redhat.com/ovirt-engine/api
dr_sites_secondary_username: admin@internal
dr_sites_secondary_ca_file: /etc/pki/ovirt-engine/ca.pem
</pre>
</td>
</tr>

<tr>
<td>Storage domain details</td>
<td>
<p>These attributes map the storage domain details between the primary and secondary site. For example:</p>
<pre>dr_import_storages:
- dr_domain_type: nfs
  dr_primary_name: DATA
  dr_master_domain: True
  dr_wipe_after_delete: False
  dr_backup: False
  dr_critical_space_action_blocker: 5
  dr_warning_low_space: 10
  dr_primary_dc_name: Default
  dr_discard_after_delete: False
  dr_primary_path: /storage/data
  dr_primary_address: 10.64.100.xxx
  # Fill in the empty properties related to the secondary site
  dr_secondary_dc_name: Default
  dr_secondary_path: /storage/data2
  dr_secondary_address:10.64.90.xxx
  dr_secondary_name: DATA
</pre>
</td>
</tr>

<tr>
<td>Cluster details</td>
<td>
<p>These attributes map the cluster names between the primary and secondary site. For example:</p>
<pre>dr_cluster_mappings:
  - primary_name: cluster_prod
    secondary_name: cluster_recovery
  - primary_name: fc_cluster
    secondary_name: recovery_fc_cluster
</pre>
</td>
</tr>

<tr>
<td>Affinity group details</td>
<td>
<p>These attributes map the affinity groups that virtual machines belong to. For example:</p>
<pre>dr_affinity_group_mappings:
- primary_name: affinity_prod
  secondary_name: affinity_recovery
</pre>
</td>
</tr>

<tr>
<td>Affinity label details</td>
<td>
<p>These attributes map the affinity labels that virtual machines belong to. For example:</p>
<pre>dr_affinity_label_mappings:
- primary_name: affinity_label_prod
  secondary_name: affinity_label_recovery
</pre>
</td>
</tr>

<tr>
<td>Domain AAA details</td>
<td>
<p>The domain Authentication, Authorization and Accounting (AAA) attributes map authorization details between the primary and secondary site. For example:</p>
<pre>dr_domain_mappings:
- primary_name: internal-authz
  secondary_name: recovery-authz
- primary_name: external-authz
  secondary_name: recovery2-authz
</pre>
</td>
</tr>

<tr>
<td>Role details</td>
<td>
<p>The Role attributes provide mapping for specific roles. For example, if a virtual machine is registered with a user with a `VmCreator` role, it is possible on failover for the Manager to register a permission for that virtual machine with the same user but with a different role. For example:</p>
<pre>dr_role_mappings:	
- primary_name: VmCreator
  Secondary_name: NewVmCreator
</pre>
</td>
</tr>

<tr>
<td>Network details</td>
<td>
<p>The network attributes map the vNIC details between the primary and secondary site. For example:</p>
<pre>dr_network_mappings:
- primary_network_name: ovirtmgmt
  primary_profile_name: ovirtmgmt
  primary_profile_id: 0000000a-000a-000a-000a-000000000398
  # Fill in the correlated vnic profile properties in the secondary site for profile 'ovirtmgmt'
  secondary_network_name: ovirtmgmt
  secondary_profile_name: ovirtmgmt
  secondary_profile_id:  0000000a-000a-000a-000a-000000000410
</pre>
<p>If you have multiple networks or multiple data centers then you must use an empty network mapping in the mapping file to ensure that all entities register on the target during failover. For example:</p>
<pre>dr_network_mappings:
# No mapping should be here
</pre>
</td>
</tr>

<tr>
<td>External LUN disk details</td>
<td>
<p>The external LUN attributes allow virtual machines to be registered with the appropriate external LUN disk after failover and failback. For example:</p>
<pre>dr_lun_mappings:
- primary_logical_unit_id: 460014069b2be431c0fd46c4bdce29b66
  primary_logical_unit_alias: Fedora_Disk
  primary_wipe_after_delete: False
  primary_shareable: False
  primary_logical_unit_description: 2b66
  primary_storage_type: iscsi
  primary_logical_unit_address: 10.35.xx.xxx
  primary_logical_unit_port: 3260
  primary_logical_unit_portal: 1
  primary_logical_unit_target: iqn.2017-12.com.prod.example:444
  secondary_storage_type: iscsi
  secondary_wipe_after_delete: False
  secondary_shareable: False
  secondary_logical_unit_id: 460014069b2be431c0fd46c4bdce29b66
  secondary_logical_unit_address: 10.35.x.xxx
  secondary_logical_unit_port: 3260
  secondary_logical_unit_portal: 1
  secondary_logical_unit_target: iqn.2017-12.com.recovery.example:444
</pre>
</td>
</tr>

</tbody>
</table>

