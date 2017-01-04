# Host General Settings Explained

These settings apply when editing the details of a host or adding new Red Hat Enterprise Linux hosts and Satellite host provider hosts.

The **General** settings table contains the information required on the **General** tab of the **New Host** or **Edit Host** window.

**General settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Data Center</b></td>
   <td>The data center to which the host belongs. Red Hat Virtualization Host (RHVH) cannot be added to Gluster-enabled clusters.</td>
  </tr>
  <tr>
   <td><b>Host Cluster</b></td>
   <td>The cluster to which the host belongs.</td>
  </tr>
  <tr>
   <td><b>Use Foreman/Satellite</b></td>
   <td>
    <p>Select or clear this check box to view or hide options for adding hosts provided by Satellite host providers. The following options are also available:</p>
    <p><b>Discovered Hosts</b></p>
    <ul>
     <li><b>Discovered Hosts</b> - A drop-down list that is populated with the name of Satellite hosts discovered by the engine.</li>
     <li><b>Host Groups</b> -A drop-down list of host groups available.</li>
     <li><b>Compute Resources</b> - A drop-down list of hypervisors to provide compute resources.</li>
    </ul>
    <p><b>Provisioned Hosts</b></p>
    <ul>
     <li><b>Providers Hosts</b> - A drop-down list that is populated with the name of hosts provided by the selected external provider. The entries in this list are filtered in accordance with any search queries that have been input in the <b>Provider search filter</b>.</li>
     <li><b>Provider search filter</b> - A text field that allows you to search for hosts provided by the selected external provider. This option is provider-specific; see provider documentation for details on forming search queries for specific providers. Leave this field blank to view all available hosts.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Name</b></td>
   <td>The name of the cluster. This text field has a 40-character limit and must be a unique name with any combination of uppercase and lowercase letters, numbers, hyphens, and underscores.</td>
  </tr>
  <tr>
   <td><b>Comment</b></td>
   <td>A field for adding plain text, human-readable comments regarding the host.</td>
  </tr>
  <tr>
   <td><b>Address</b></td>
   <td>The IP address, or resolvable hostname of the host.</td>
  </tr>
  <tr>
   <td><b>Password</b></td>
   <td>The password of the host's root user. This can only be given when you add the host; it cannot be edited afterwards.</td>
  </tr>
  <tr>
   <td><b>SSH PublicKey</b></td>
   <td>Copy the contents in the text box to the <tt>/root/.known_hosts</tt> file on the host to use the Manager's ssh key instead of using a password to authenticate with the host.</td>
  </tr>
  <tr>
   <td><b>Automatically configure host firewall</b></td>
   <td>When adding a new host, the Manager can open the required ports on the host's firewall. This is enabled by default. This is an <b>Advanced Parameter</b>.</td>
  </tr>
  <tr>
   <td><b>SSH Fingerprint</b></td>
   <td>You can <b>fetch</b> the host's SSH fingerprint, and compare it with the fingerprint you expect the host to return, ensuring that they match. This is an <b>Advanced Parameter</b>.</td>
  </tr>
 </tbody>
</table>
