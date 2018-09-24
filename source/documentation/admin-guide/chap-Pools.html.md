---
title: Pools
---

# Chapter 9: Pools

## Introduction to Virtual Machine Pools

A virtual machine pool is a group of virtual machines that are all clones of the same template and that can be used on demand by any user in a given group. Virtual machine pools allow administrators to rapidly configure a set of generalized virtual machines for users.

Users access a virtual machine pool by taking a virtual machine from the pool. When a user takes a virtual machine from a pool, they are provided with any one of the virtual machines in the pool if any are available. That virtual machine will have the same operating system and configuration as that of the template on which the pool was based, but users may not receive the same member of the pool each time they take a virtual machine. Users can also take multiple virtual machines from the same virtual machine pool depending on the configuration of that pool.

Virtual machines in a virtual machine pool are stateless, meaning that data is not persistent across reboots. However, if a user configures console options for a virtual machine taken from a virtual machine pool, those options will be set as the default for that user for that virtual machine pool.

    **Note:** Virtual machines taken from a pool are not stateless when accessed from the Administration Portal. This is because administrators need to be able to write changes to the disk if necessary.

In principle, virtual machines in a pool are started when taken by a user, and shut down when the user is finished. However, virtual machine pools can also contain pre-started virtual machines. Pre-started virtual machines are kept in an up state, and remain idle until they are taken by a user. This allows users to start using such virtual machines immediately, but these virtual machines will consume system resources even while not in use due to being idle.

## Creating a Virtual Machine Pool

You can create a virtual machine pool that contains multiple virtual machines that have been created based on a common template.

**<tt>Sysprep</tt> File Configuration Options for Windows Virtual Machines**

Several `sysprep` file configuration options are available, depending on your requirements.

If your pool does not need to join a domain, you can use the default `sysprep` file, located in `/usr/share/ovirt-engine/conf/sysprep/`.

If your pool needs to join a domain, you can create a custom `sysprep` for each Windows operating system:

1. Copy the relevant sections for each operating system from `/usr/share/ovirt-engine/conf/osinfo-defaults.properties` to a new file and save as `99-defaults.properties`.

2. In `99-defaults.properties`, specify the Windows product activation key and the path of your new custom `sysprep` file:

        os.operating_system.productKey.value=Windows_product_activation_key
        ...
        os.operating_system.sysprepPath.value = ${ENGINE_USR}/conf/sysprep/sysprep.operating_system

3. Create a new `sysprep` file, specifying the domain, domain password, and domain administrator:

            <Credentials>
              <Domain>AD_Domain</Domain>
              <Password>Domain_Password</Password>
              <Username>Domain_Administrator</Username>
           </Credentials>

If you need to configure different sysprep settings for different pools of Windows virtual machines, you can create a custom sysprep file in the Administration Portal (see "Creating a Virtual Machine Pool" below).

**Creating a Virtual Machine Pool**

1. Click **Compute** &rarr; **Pools**.

2. Click **New**.

3. Select a **Cluster** from the drop-down list.

4. Select a **Template** and version from the drop-down menu. A template provides standard settings for all the virtual machines in the pool.

5. Select an **Operating System** from the drop-down list.

6. Use the **Optimized for** drop-down list to optimize virtual machines for **Desktop** or **Server**.

    **Note:** **High Performance** optimization is not recommended for pools because a high performance virtual machine is pinned to a single host and concrete resources. A pool containing multiple virtual machines with such a configuration would not run well.

7. Enter a **Name** and, optionally, a **Description** and **Comment**.

   The **Name** of the pool is applied to each virtual machine in the pool, with a numeric suffix. You can customize the numbering of the virtual machines with `?` as a placeholder.

   **Pool Name and Virtual Machine Numbering Examples**

   * Pool: `MyPool`

     Virtual machines: `MyPool-1`, `MyPool-2`, …​ `MyPool-10`

   * Pool: `MyPool-???`

     Virtual machines: `MyPool-001`, `MyPool-002`, …​ `MyPool-010`

8. Enter the **Number of VMs** for the pool.

9. Enter the number of virtual machines to be prestarted in the **Prestarted VMs** field.

10. Select the **Maximum number of VMs per user** that a single user is allowed to run in a session. The minimum is **1**.

11. Select the **Delete Protection** check box to enable delete protection.

12. If you are creating a pool of non-Windows virtual machines or if you are using the default `sysprep`, skip this step. If you are creating a custom `sysprep` file for a pool of Windows virtual machines:

    i. Click the **Show Advanced Options** button.

    ii. Click the **Initial Run** tab and select the **Use Cloud-Init/Sysprep** check box.

    iii. Click the **Authentication** arrow and enter the **User Name** and **Password** or select **Use already configured password**.

    **Note:** This `User Name` is the name of the local administrator. You can change its value from its default value (`user`) here in the **Authentication** section or in a custom `sysprep` file.

    iv. Click the **Custom Script** arrow and paste the contents of the default `sysprep` file, located in `/usr/share/ovirt-engine/conf/sysprep/`, into the text box.

    v. You can modify the following values of the `sysprep` file:

      * `Key`. If you do not want to use the pre-defined Windows activation product key, replace `<![CDATA[$ProductKey$]]>` with a valid product key:

            <ProductKey>
                <Key><![CDATA[$ProductKey$]]></Key>
            </ProductKey>

        **Windows Product Key Example**

            <ProductKey>
                <Key>0000-000-000-000</Key>
            </ProductKey>

      * `Domain` that the Windows virtual machines will join, the domain’s `Password`, and the domain administrator’s `Username`:

            <Credentials>
                <Domain>AD_Domain</Domain>
                <Password>Domain_Password</Password>
                <Username>Domain_Administrator</Username>
           </Credentials>

        **Domain Credentials Example**

            <Credentials>
                <Domain>addomain.local</Domain>
                <Password>12345678</Password>
                <Username>Sarah_Smith</Username>
            </Credentials>

                **Note:** The `Domain`, `Password`, and `Username` are required to join the domain. The `Key` is for activation. You do not necessarily need both.

                The domain and credentials cannot be modified in the **Initial Run** tab.

      * `FullName` of the local administrator:          

        <UserData>
        ...
            <FullName>Local_Administrator</FullName>
        ...
        </UserData>

      * `DisplayName` and `Name` of the local administrator:

        <LocalAccounts>
            <LocalAccount wcm:action="add">
                <Password>
                    <Value><![CDATA[$AdminPassword$]]></Value>
                    <PlainText>true</PlainText>
                </Password>
                <DisplayName>Local_Administrator</DisplayName>
                <Group>administrators</Group>
                <Name>Local_Administrator</Name>
            </LocalAccount>
        </LocalAccounts>

The remaining variables in the `sysprep` file can be filled in on the **Initial Run** tab.

13. Optionally, set a **Pool Type**:

    i. Click the **Type** tab and select a **Pool Type**:

        * **Manual** - The administrator is responsible for explicitly returning the virtual machine to the pool. The virtual machine reverts to the original base image after the administrator returns it to the pool.

        * **Automatic** - When the virtual machine is shut down, it automatically reverts to its base image and is returned to the virtual machine pool.

    ii. Select the **Stateful Pool** check box to ensure that virtual machines are started in a stateful mode. This ensures that changes made by a previous user will persist on a virtual machine.

    iii. Click **OK**.

14. Optionally, override the SPICE proxy:

    i. In the **Console** tab, select the **Override SPICE Proxy** check box

    ii. In the **Overridden SPICE proxy address** text field, specify the address of a SPICE proxy to override the global SPICE proxy.

    iii. Click **OK**.

15. For a pool of Windows virtual machines, click **Compute** &rarr; **Virtual Machines**, select each virtual machine from the pool, and click **Run** &rarr; **Run Once**.

    **Note:** If the virtual machine does not start and `Info [windeploy.exe] Found no unattend file` appears in `%WINDIR%\panther\UnattendGC\setupact.log`, add the **UnattendFile** key to the registry of the Windows virtual machine that was used to create the template for the pool:

    i. Check that the Windows virtual machine has an attached floppy device with the `unattend` file, for example, `A:\Unattend.xml`.

    ii. Click **Start**, click **Run**, type `regedit` in the **Open** text box, and click **OK**.

    iii. In the left pane, go to **HKEY_LOCAL_MACHINE** &rarr; **SYSTEM** &rarr; **Setup**.

    iv. Right-click the right pane and select **New** &rarr; **String Value**.

    v. Enter **UnattendFile** as the key name.

    vi. Double-click the new key and enter the `unattend` file name and path, for example, `A:\Unattend.xml`, as the key’s value.

    vii. Save the registry, seal the Windows virtual machine, and create a new template.

You have created and configured a virtual machine pool with the specified number of identical virtual machines. You can view these virtual machines in the **Virtual Machines** resource tab, or in the details pane of the **Pools** resource tab; a virtual machine in a pool is distinguished from independent virtual machines by its icon.

## Explanation of Settings and Controls in the New Pool and Edit Pool Windows

### New Pool and Edit Pool General Settings Explained

The following table details the information required on the **General** tab of the **New Pool** and **Edit Pool** windows that are specific to virtual machine pools. All other settings are identical to those in the **New Virtual Machine** window.

**General settings**

| Field Name | Description |
|-
| **Template** | The template on which the virtual machine pool is based. |
| **Description** | A meaningful description of the virtual machine pool. |
| **Comment** | A field for adding plain text human-readable comments regarding the virtual machine pool. |
| **Prestarted VMs** | Allows you to specify the number of virtual machines in the virtual machine pool that will be started before they are taken and kept in that state to be taken by users. The value of this field must be between `0` and the total number of virtual machines in the virtual machine pool. |
| **Number of VMs/Increase number of VMs in pool by** | Allows you to specify the number of virtual machines to be created and made available in the virtual machine pool. In the edit window it allows you to increase the number of virtual machines in the virtual machine pool by the specified number. By default, the maximum number of virtual machines you can create in a pool is 1000. This value can be configured using the `MaxVmsInPool` key of the `engine-config` command. |
| **Maximum number of VMs per user** | Allows you to specify the maximum number of virtual machines a single user can take from the virtual machine pool at any one time. The value of this field must be between `1` and `32,767`. |
| **Delete Protection** | Allows you to prevent the virtual machines in the pool from being deleted. |

### New Pool and Edit Pool Type Settings Explained

The following table details the information required on the **Type** tab of the **New Pool** and **Edit Pool** windows.

**Type settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Pool Type</b></td>
   <td>
    <p>This drop-down menu allows you to specify the type of the virtual machine pool. The following options are available:</p>
    <ul>
     <li><b>Automatic</b>: After a user finishes using a virtual machine taken from a virtual machine pool, that virtual machine is automatically returned to the virtual machine pool.</li>
     <li><b>Manual</b>: After a user finishes using a virtual machine taken from a virtual machine pool, that virtual machine is only returned to the virtual machine pool when an administrator manually returns the virtual machine.</li>
    </ul>
   </td>
   <tr>
    <td><b>Stateful Pool</b></td>
    <td>Specify whether the state of virtual machines in the pool is preserved when a virtual machine is passed to a different user. This means that changes made by a previous user will persist on the virtual machine.</td>
  </tr>
 </tbody>
</table>

#### New Pool and Edit Pool Console Settings Explained

The following table details the information required on the **Console** tab of the **New Pool** or **Edit Pool** window that is specific to virtual machine pools. All other settings are identical to those in the **New Virtual Machine** and **Edit Virtual Machine** windows.

**Console settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Override SPICE proxy</b></td>
   <td>Select this check box to enable overriding the SPICE proxy defined in global configuration. This feature is useful in a case where the user (who is, for example, connecting via the User Portal) is outside of the network where the hosts reside.</td>
  </tr>
  <tr>
   <td><b>Overridden SPICE proxy address</b></td>
   <td>
    <p>The proxy by which the SPICE client will connect to virtual machines. This proxy overrides both the global SPICE proxy defined for the oVirt environment and the SPICE proxy defined for the cluster to which the virtual machine pool belongs, if any. The address must be in the following format:</p>
    <pre>protocol://[host]:[port]</pre>
   </td>
  </tr>
 </tbody>
</table>

#### Virtual Machine Pool Host Settings Explained

The following table details the options available on the **Host** tab of the **New Pool** and **Edit Pool** windows.

**Virtual Machine Pool: Host Settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Sub-element</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Start Running On</b></td>
   <td> </td>
   <td>
    <p>Defines the preferred host on which the virtual machine is to run. Select either:</p>
    <ul>
     <li><b>Any Host in Cluster</b> - The virtual machine can start and run on any available host in the cluster.</li>
     <li><b>Specific</b> - The virtual machine will start running on a particular host in the cluster. However, the Engine or an administrator can migrate the virtual machine to a different host in the cluster depending on the migration and high-availability settings of the virtual machine. Select the specific host or group of hosts from the list of available hosts.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Migration Options</b></td>
   <td><b>Migration mode</b></td>
   <td>
    <p>Defines options to run and migrate the virtual machine. If the options here are not used, the virtual machine will run or migrate according to its cluster's policy.</p>
    <ul>
     <li><b>Allow manual and automatic migration</b> - The virtual machine can be automatically migrated from one host to another in accordance with the status of the environment, or manually by an administrator.</li>
     <li><b>Allow manual migration only</b> - The virtual machine can only be migrated from one host to another manually by an administrator.</li>
     <li><b>Do not allow migration</b> - The virtual machine cannot be migrated, either automatically or manually.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td> </td>
   <td><b>Use custom migration policy</b></td>
   <td>
    <p>Defines the migration convergence policy. If the check box is left unselected, the host determines the policy.</p>
    <ul>
     <li><b>Legacy</b> - Legacy behavior of 3.6 version. Overrides in <tt>vdsm.conf</tt> are still applied. The guest agent hook mechanism is disabled.</li>
     <li><b>Minimal downtime</b> - Allows the virtual machine to migrate in typical situations. Virtual machines should not experience any significant downtime. The migration will be aborted if virtual machine migration does not converging after a long time (dependent on QEMU iterations, with a maximum of 500 milliseconds). The guest agent hook mechanism is enabled.</li>
     <li><b>Suspend workload if needed</b> - Allows the virtual machine to migrate in most situations, including when the virtual machine is running a heavy workload. Virtual machines may experience a more significant downtime. The migration may still be aborted for extreme workloads. The guest agent hook mechanism is enabled.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td> </td>
   <td><b>Use custom migration downtime</b></td>
   <td>This check box allows you to specify the maximum number of milliseconds the virtual machine can be down during live migration. Configure different maximum downtimes for each virtual machine according to its workload and SLA requirements. Enter <tt>0</tt> to use the VDSM default value.</td>
  </tr>
  <tr>
   <td> </td>
   <td><b>Auto Converge migrations</b></td>
   <td>
    <p>Only activated with <b>Legacy</b> migration policy. Allows you to set whether auto-convergence is used during live migration of the virtual machine. Large virtual machines with high workloads can dirty memory more quickly than the transfer rate achieved during live migration, and prevent the migration from converging. Auto-convergence capabilities in QEMU allow you to force convergence of virtual machine migrations. QEMU automatically detects a lack of convergence and triggers a throttle-down of the vCPUs on the virtual machine. Auto-convergence is disabled globally by default.</p>
    <ul>
     <li>Select <b>Inherit from cluster setting</b> to use the auto-convergence setting that is set at the cluster level. This option is selected by default.</li>
     <li>Select <b>Auto Converge</b> to override the cluster setting or global setting and allow auto-convergence for the virtual machine.</li>
     <li>Select <b>Don't Auto Converge</b> to override the cluster setting or global setting and prevent auto-convergence for the virtual machine.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td> </td>
   <td><b>Enable migration compression</b></td>
   <td>
    <p>Only activated with <b>Legacy</b> migration policy. The  option allows you to set whether migration compression is used during live migration of the virtual machine. This feature uses Xor Binary Zero Run-Length-Encoding to reduce virtual machine downtime and total live migration time for virtual machines running memory write-intensive workloads or for any application with a sparse memory update pattern. Migration compression is disabled globally by default.</p>
    <ul>
     <li>Select <b>Inherit from cluster setting</b> to use the compression setting that is set at the cluster level. This option is selected by default.</li>
     <li>Select <b>Compress</b> to override the cluster setting or global setting and allow compression for the virtual machine.</li>
     <li>Select <b>Don't compress</b> to override the cluster setting or global setting and prevent compression for the virtual machine.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td> </td>
   <td> <b>Pass-Through Host CPU</b></td>
   <td>This check box allows virtual machines to take advantage of the features of the physical CPU of the host on which they are situated. This option can only be enabled when <b>Do not allow migration</b> is selected.</td>
  </tr>
  <tr>
   <td><b>Configure NUMA</b></td>
   <td><b>NUMA Node Count</b></td>
   <td>The number of virtual NUMA nodes to assign to the virtual machine. If the <b>Tune Mode</b> is <b>Preferred</b>, this value must be set to <tt>1</tt>.</td>
  </tr>
  <tr>
   <td> </td>
   <td><b>Tune Mode</b></td>
   <td>
    <p>The method used to allocate memory.</p>
    <ul>
     <li><b>Strict</b>: Memory allocation will fail if the memory cannot be allocated on the target node.</li>
     <li><b>Preferred</b>: Memory is allocated from a single preferred node. If sufficient memory is not available, memory can be allocated from other nodes.</li>
     <li><b>Interleave</b>: Memory is allocated across nodes in a round-robin algorithm.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td> </td>
   <td><b>NUMA Pinning</b></td>
   <td>Opens the <b>NUMA Topology</b> window. This window shows the host's total CPUs, memory, and NUMA nodes, and the virtual machine's virtual NUMA nodes. Pin virtual NUMA nodes to host NUMA nodes by clicking and dragging each vNUMA from the box on the right to a NUMA node on the left.</td>
  </tr>
 </tbody>
</table>

### New Pool and Edit Pool Resource Allocation Settings Explained

The following table details the information required on the **Resource Allocation** tab of the **New Pool** and **Edit Pool** windows that are specific to virtual machine pools. All other settings are identical to those in the **New Virtual Machine** window.

**Resource Allocation settings**

<table>
 <thead>
  <tr>
   <td>Field Name</td>
   <td>Sub-element</td>
   <td>Description</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Disk Allocation</b></td>
   <td><b>Auto select target</b></td>
   <td>Select this check box to automatically select the storage domain that has the most free space. The <b>Target</b> and <b>Profile</b> fields are disabled.</td>
  </tr>
  <tr>
   <td> </td>
   <td><b>Format</b></td>
   <td>This field is read-only and always displays <b>QCOW2</b> unless the storage domain type is OpenStack Volume (Cinder), in which case the format is <b>Raw</b>.</td>
  </tr>
 </tbody>
</table>

## Editing a Virtual Machine Pool

After a virtual machine pool has been created, its properties can be edited. The properties available when editing a virtual machine pool are identical to those available when creating a new virtual machine pool except that the **Number of VMs** property is replaced by **Increase number of VMs in pool by**.

    **Note:** When editing a virtual machine pool, the changes introduced affect only new virtual machines. Virtual machines that existed already at the time of the introduced changes remain unaffected.

**Editing a Virtual Machine Pool**

1. Click **Compute** &rarr; **Pools** and select a virtual machine pool.

2. Click **Edit**.

3. Edit the properties of the virtual machine pool.

4. Click **OK**.

## Prestarting Virtual Machines in a Pool

The virtual machines in a virtual machine pool are powered down by default. When a user requests a virtual machine from a pool, a machine is powered up and assigned to the user. In contrast, a prestarted virtual machine is already running and waiting to be assigned to a user, decreasing the amount of time a user has to wait before being able to access a machine. When a prestarted virtual machine is shut down it is returned to the pool and restored to its original state. The maximum number of prestarted virtual machines is the number of virtual machines in the pool.

Prestarted virtual machines are suitable for environments in which users require immediate access to virtual machines which are not specifically assigned to them. Only automatic pools can have prestarted virtual machines.

**Prestarting Virtual Machines in a Pool**

1. Click **Compute** &rarr; **Pools** and select a virtual machine pool.

2. Click **Edit**.

3. Enter the number of virtual machines to be prestarted in the **Prestarted VMs** field.

4. Click the **Type** tab. Ensure **Pool Type** is set to **Automatic**.

5. Click **OK**.

## Adding Virtual Machines to a Virtual Machine Pool

If you require more virtual machines than originally provisioned in a virtual machine pool, add more machines to the pool.

**Adding Virtual Machines to a Virtual Machine Pool**

1. Click **Compute** &rarr; **Pools** and select a virtual machine pool.

2. Click **Edit**.

3. Enter the number of additional virtual machines to add in the **Increase number of VMs in pool by** field.

4. Click **OK**.

## Detaching Virtual Machines from a Virtual Machine Pool

You can detach virtual machines from a virtual machine pool. Detaching a virtual machine removes it from the pool to become an independent virtual machine.

**Detaching Virtual Machines from a Virtual Machine Pool**

1. Click **Compute** &rarr; **Pools**.

2. Click the pool’s name to open the details view.

3. Click the **Virtual Machines** tab to list the virtual machines in the pool.

4. Ensure the virtual machine has a status of `Down`; you cannot detach a running virtual machine.

5. Select one or more virtual machines and click **Detach**.

6. Click **OK**.

    **Note:** The virtual machine still exists in the environment and can be viewed and accessed from **Compute** &rarr; **Virtual Machines** resource tab. Note that the icon changes to denote that the detached virtual machine is an independent virtual machine.

## Removing a Virtual Machine Pool

You can remove a virtual machine pool from a data center. You must first either delete or detach all of the virtual machines in the pool. Detaching virtual machines from the pool will preserve them as independent virtual machines.

**Removing a Virtual Machine Pool**

1. Click **Compute** &rarr; **Pools** and select the virtual machine pool.

2. Click **Remove**.

3. Click **OK**.

## Trusted Compute Pools

Trusted compute pools are secure clusters based on Intel Trusted Execution Technology (Intel TXT). Trusted clusters only allow hosts that are verified by Intel's OpenAttestation, which measures the integrity of the host's hardware and software against a White List database. Trusted hosts and the virtual machines running on them can be assigned tasks that require higher security. For more information on Intel TXT, trusted systems, and attestation, see [https://software.intel.com/en-us/articles/intel-trusted-execution-technology-intel-txt-enabling-guide](https://software.intel.com/en-us/articles/intel-trusted-execution-technology-intel-txt-enabling-guide).]

Creating a trusted compute pool involves the following steps:

* Configuring the Engine to communicate with an OpenAttestation server.

* Creating a trusted cluster that can only run trusted hosts.

* Adding trusted hosts to the trusted cluster. Hosts must be running the OpenAttestation agent to be verified as trusted by the OpenAttestation sever.

For information on installing an OpenAttestation server, installing the OpenAttestation agent on hosts, and creating a White List database, see [https://github.com/OpenAttestation/OpenAttestation/wiki](https://github.com/OpenAttestation/OpenAttestation/wiki).]

### Connecting an OpenAttestation Server to the Engine

Before you can create a trusted cluster, the oVirt Engine must be configured to recognize the OpenAttestation server. Use `engine-config` to add the OpenAttestation server's FQDN or IP address:

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
   <td>The FQDN or IP address of the OpenAttestation server. This must be set for the Engine to communicate with the OpenAttestation server.</td>
  </tr>
  <tr>
   <td>AttestationPort</td>
   <td>8443</td>
   <td>The port used by the OpenAttestation server to communicate with the Engine.</td>
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

### Creating a Trusted Cluster

Trusted clusters communicate with an OpenAttestation server to assess the security of hosts. When a host is added to a trusted cluster, the OpenAttestation server measures the host's hardware and software against a White List database. Virtual machines can be migrated between trusted hosts in the trusted cluster, allowing for high availability in a secure environment.

**Creating a Trusted Cluster**

1. Click **Compute** &rarr; **Clusters**.

2. Click **New**.

3. Enter a **Name** for the cluster.

4. Select the **Enable Virt Service** check box.

5. Click the **Scheduling Policy** tab and select the **Enable Trusted Service** check box.

6. Click **OK**.

### Adding a Trusted Host

Enterprise Linux hosts can be added to trusted clusters and measured against a White List database by the OpenAttestation server. Hosts must meet the following requirements to be trusted by the OpenAttestation server:

* Intel TXT is enabled in the BIOS.

* The OpenAttestation agent is installed and running.

* Software running on the host matches the OpenAttestation server's White List database.

**Adding a Trusted Host**

1. Click **Compute** &rarr; **Hosts**.

2. Click **New**.

3. Select a trusted cluster from the **Host Cluster** drop-down list.

4. Enter a **Name** for the host.

5. Enter the **Hostname** of the host.

6. Enter the host's root **Password**.

7. Click **OK**.

After the host is added to the trusted cluster, it is assessed by the OpenAttestation server. If a host is not trusted by the OpenAttestation server, it will move to a `Non Operational` state and should be removed from the trusted cluster.

**Prev:** [Chapter 8: Storage](../chap-Storage)<br>
**Next:** [Chapter 10: Virtual Disks](../chap-Virtual_Machine_Disks)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/administration_guide/chap-pools)
