# Settings in the New Host Network Quality of Service and Edit Host Network Quality of Service Windows Explained

Host network quality of service settings allow you to configure bandwidth limits for outbound traffic.

**Host Network QoS Settings**

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
   <td>The data center to which the host network QoS policy is to be added. This field is configured automatically according to the selected data center.</td>
  </tr>
  <tr>
   <td><b>QoS Name</b></td>
   <td>A name to represent the host network QoS policy within the Manager.</td>
  </tr>
  <tr>
   <td><b>Description</b></td>
   <td>A description of the host network QoS policy. </td>
  </tr>
  <tr>
   <td><b>Outbound</b></td>
   <td>
    <p>The settings to be applied to outbound traffic.</p>
    <ul>
     <li><b>Weighted Share</b>: Signifies how much of the logical link's capacity a specific network should be allocated, relative to the other networks attached to the same logical link. The exact share depends on the sum of shares of all networks on that link. By default this is a number in the range 1-100. </li>
     <li><b>Rate Limit [Mbps]</b>: The maximum bandwidth to be used by a network. </li>
     <li><b>Committed Rate [Mbps]</b>: The minimum bandwidth required by a network. The Committed Rate requested is not guaranteed and will vary depending on the network infrastructure and the Committed Rate requested by other networks on the same logical link.</li>
    </ul>
   </td>
  </tr>
 </tbody>
</table>
