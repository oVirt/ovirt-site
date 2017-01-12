# Connecting an OpenAttestation Server to the Manager

Before you can create a trusted cluster, the Red Hat Virtualization Manager must be configured to recognize the OpenAttestation server. Use `engine-config` to add the OpenAttestation server's FQDN or IP address:

    # engine-config -s AttestationServer=attestationserver.example.com

The following settings can also be changed if required:

**OpenAttestation Settings for engine-config**

<table>
 <thead>
  <tr>
   <td>Option</td>
   <td>Default Value</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td>AttestationServer</td>
   <td>oat-server</td>
   <td>The FQDN or IP address of the OpenAttestation server. This must be set for the Manager to communicate with the OpenAttestation server.</td>
  </tr>
  <tr>
   <td>AttestationPort</td>
   <td>8443</td>
   <td>The port used by the OpenAttestation server to communicate with the Manager.</td>
  </tr>
  <tr>
   <td>AttestationTruststore</td>
   <td>TrustStore.jks</td>
   <td>The trust store used for securing communication with the OpenAttestation server.</td>
  </tr>
  <tr>
   <td>AttestationTruststorePass</td>
   <td>password</td>
   <td>The password used to access the trust store.</td>
  </tr>
  <tr>
   <td>AttestationFirstStageSize</td>
   <td>10</td>
   <td>Used for quick initialization. Changing this value without good reason is not recommended.</td>
  </tr>
  <tr>
   <td>SecureConnectionWithOATServers</td>
   <td>true</td>
   <td>Enables or disables secure communication with OpenAttestation servers.</td>
  </tr>
  <tr>
   <td>PollUri</td>
   <td>AttestationService/resources/PollHosts</td>
   <td>The URI used for accessing the OpenAttestation service.</td>
  </tr>
 </tbody>
</table>
