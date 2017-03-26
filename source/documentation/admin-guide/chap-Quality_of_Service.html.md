---
title: Quality of Services
---

# Chapter 3: Quality of Service

oVirt allows you to define quality of service entries that provide fine-grained control over the level of input and output, processing, and networking capabilities that resources in your environment can access. Quality of service entries are defined at the data center level and are assigned to profiles created under clusters and storage domains. These profiles are then assigned to individual resources in the clusters and storage domains where the profiles were created.

## Storage Quality of Service

Storage quality of service defines the maximum level of throughput and the maximum level of input and output operations for a virtual disk in a storage domain. Assigning storage quality of service to a virtual disk allows you to fine tune the performance of storage domains and prevent the storage operations associated with one virtual disk from affecting the storage capabilities available to other virtual disks hosted in the same storage domain.

### Creating a Storage Quality of Service Entry

Create a storage quality of service entry.

**Creating a Storage Quality of Service Entry**

1. Click the **Data Centers** resource tab and select a data center.

2. Click **QoS** in the details pane.

3. Click **Storage**.

4. Click **New**.

5. Enter a name for the quality of service entry in the **QoS Name** field.

6. Enter a description for the quality of service entry in the **Description** field.

7. Specify the throughput quality of service:

    1. Select the **Throughput** check box.

    2. Enter the maximum permitted total throughput in the **Total** field.

    3. Enter the maximum permitted throughput for read operations in the **Read** field.

    4. Enter the maximum permitted throughput for write operations in the **Write** field.

8. Specify the input and output quality of service:

    1. Select the **IOps** check box.

    2. Enter the maximum permitted number of input and output operations per second in the **Total** field.

    3. Enter the maximum permitted number of input operations per second in the **Read** field.

    4. Enter the maximum permitted number of output operations per second in the **Write** field.

9. Click **OK**.

You have created a storage quality of service entry, and can create disk profiles based on that entry in data storage domains that belong to the data center.

### Removing a Storage Quality of Service Entry

Remove an existing storage quality of service entry.

**Removing a Storage Quality of Service Entry**

1. Click the **Data Centers** resource tab and select a data center.

2. Click **QoS** in the details pane.

3. Click **Storage**.

4. Select the storage quality of service entry to remove.

5. Click **Remove**.

6. Click **OK** when prompted.

You have removed the storage quality of service entry, and that entry is no longer available. If any disk profiles were based on that entry, the storage quality of service entry for those profiles is automatically set to `[unlimited]`.

## Virtual Machine Network Quality of Service

Virtual machine network quality of service is a feature that allows you to create profiles for limiting both the inbound and outbound traffic of individual virtual network interface controllers. With this feature, you can limit bandwidth in a number of layers, controlling the consumption of network resources.

### Creating a Virtual Machine Network Quality of Service Entry

Create a virtual machine network quality of service entry to regulate network traffic when applied to a virtual network interface controller (vNIC) profile, also known as a virtual machine network interface profile.

**Creating a Virtual Machine Network Quality of Service Entry**

1. Click the **Data Centers** resource tab and select a data center.

2. Click the **QoS** tab in the details pane.

3. Click **VM Network**.

4. Click **New**.

5. Enter a name for the virtual machine network quality of service entry in the **Name** field.

6. Enter the limits for the **Inbound** and **Outbound** network traffic.

7. Click **OK**.

You have created a virtual machine network quality of service entry that can be used in a virtual network interface controller.

### Settings in the New Virtual Machine Network QoS and Edit Virtual Machine Network QoS Windows Explained

Virtual machine network quality of service settings allow you to configure bandwidth limits for both inbound and outbound traffic on three distinct levels.

**Virtual Machine Network QoS Settings**

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
   <td>The data center to which the virtual machine network QoS policy is to be added. This field is configured automatically according to the selected data center.</td>
  </tr>
  <tr>
   <td><b>Name</b></td>
   <td>A name to represent the virtual machine network QoS policy within the Engine.</td>
  </tr>
  <tr>
   <td><b>Inbound</b></td>
   <td>
    <p>The settings to be applied to inbound traffic. Select or clear the <b>Inbound</b> check box to enable or disable these settings.</p>
    <ul>
     <li><b>Average</b>: The average speed of inbound traffic.</li>
     <li><b>Peak</b>: The speed of inbound traffic during peak times.</li>
     <li><b>Burst</b>: The speed of inbound traffic during bursts.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Outbound</b></td>
   <td>
    <p>The settings to be applied to outbound traffic. Select or clear the <b>Outbound</b> check box to enable or disable these settings.</p>
    <ul>
     <li><b>Average</b>: The average speed of outbound traffic.</li>
     <li><b>Peak</b>: The speed of outbound traffic during peak times.</li>
     <li><b>Burst</b>: The speed of outbound traffic during bursts.</li>
    </ul>
   </td>
  </tr>
 </tbody>
</table>

### Removing a Virtual Machine Network Quality of Service Entry

Remove an existing virtual machine network quality of service entry.

**Removing a Virtual Machine Network Quality of Service Entry**

1. Click the **Data Centers** resource tab and select a data center.

2. Click the **QoS** tab in the details pane.

3. Click **VM Network**.

4. Select the virtual machine network quality of service entry to remove.

5. Click **Remove**.

6. Click **OK** when prompted.

You have removed the virtual machine network quality of service entry, and that entry is no longer available.

## Host Network Quality of Service

Host network quality of service configures the networks on a host to enable the control of network traffic through the physical interfaces. Host network quality of service allows for the fine tuning of network performance by controlling the consumption of network resources on the same physical network interface controller. This helps to prevent situations where one network causes other networks attached to the same physical network interface controller to no longer function due to heavy traffic. By configuring host network quality of service, these networks can now function on the same physical network interface controller without congestion issues.

### Creating a Host Network Quality of Service Entry

Create a host network quality of service entry.

**Creating a Host Network Quality of Service Entry**

1. Click the **Data Centers** resource tab and select a data center.

2. Click **QoS** in the details pane.

3. Click **Host Network**.

4. Click **New**.

5. Enter a name for the quality of service entry in the **QoS Name** field.

6. Enter a description for the quality of service entry in the **Description** field.

7. Enter the desired values for **Weighted Share**, **Rate Limit [Mbps]**, and **Committed Rate [Mbps]**.

8. Click **OK**.

### Settings in the New Host Network Quality of Service and Edit Host Network Quality of Service Windows Explained

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
   <td>A name to represent the host network QoS policy within the Engine.</td>
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

### Removing a Host Network Quality of Service Entry

Remove an existing network quality of service entry.

**Removing a Host Network Quality of Service Entry**

1. Click the **Data Centers** resource tab and select a data center.

2. Click the **QoS** tab in the details pane.

3. Click **Host Network**.

4. Select the network quality of service entry to remove.

5. Click **Remove**.

6. Click **OK** when prompted.

## CPU Quality of Service

CPU quality of service defines the maximum amount of processing capability a virtual machine can access on the host on which it runs, expressed as a percent of the total processing capability available to that host. Assigning CPU quality of service to a virtual machine allows you to prevent the workload on one virtual machine in a cluster from affecting the processing resources available to other virtual machines in that cluster.

### Creating a CPU Quality of Service Entry

Create a CPU quality of service entry.

**Creating a CPU Quality of Service Entry**

1. Click the **Data Centers** resource tab and select a data center.

2. Click **QoS** in the details pane.

3. Click **CPU**.

4. Click **New**.

5. Enter a name for the quality of service entry in the **QoS Name** field.

6. Enter a description for the quality of service entry in the **Description** field.

7. Enter the maximum processing capability the quality of service entry permits in the **Limit** field, in percentage. Do not include the `%` symbol.

8. Click **OK**.

You have created a CPU quality of service entry, and can create CPU profiles based on that entry in clusters that belong to the data center.

### Removing a CPU Quality of Service Entry

Remove an existing CPU quality of service entry.

**Removing a CPU Quality of Service Entry**

1. Click the **Data Centers** resource tab and select a data center.

2. Click **QoS** in the details pane.

3. Click **CPU**.

4. Select the CPU quality of service entry to remove.

5. Click **Remove**.

6. Click **OK** when prompted.

You have removed the CPU quality of service entry, and that entry is no longer available. If any CPU profiles were based on that entry, the CPU quality of service entry for those profiles is automatically set to `[unlimited]`.

**Prev:** [Chapter 2: System Dashboard](../chap-System_Dashboard)<br>
**Next:** [Chapter 4: Data Centers](../chap-Data_Centers)
