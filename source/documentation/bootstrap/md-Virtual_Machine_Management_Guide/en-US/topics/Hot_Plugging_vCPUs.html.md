# Hot Plugging Virtual CPUs

You can hot plug virtual CPUs. Hot plugging means enabling or disabling devices while a virtual machine is running.

The following prerequisites apply:

* The virtual machine's **Operating System** must be explicitly set in the **New Virtual Machine** window. 

* The virtual machine's operating system must support CPU hot plug. See the table below for support details.

* Windows virtual machines must have the guest agents installed. See [Installing the Guest Agents and Drivers on Windows](Installing_the_Guest_Agents_and_Drivers_on_Windows).

**Important:** Hot unplugging virtual CPUs is not currently supported in Red Hat Virtualization.

**Hot Plugging Virtual CPUs**

1. Click the **Virtual Machines** tab and select a running virtual machine. 

2. Click **Edit**.

3. Click the **System** tab.

4. Change the value of **Virtual Sockets** as required. 

5. Click **OK**.

**Operating System Support Matrix for vCPU Hot Plug**

| Operating System | Version | Architecture | Hot Plug Supported |
|-
| Red Hat Enterprise Linux 6.3+    |     | x86 | Yes |
| Red Hat Enterprise Linux 7.0+    |     | x86 | Yes |
| Microsoft Windows Server 2008    | All | x86 | No |
| Microsoft Windows Server 2008    | Standard, Enterprise | x64 | No |
| Microsoft Windows Server 2008    | Datacenter | x64 | Yes |
| Microsoft Windows Server 2008 R2 | All | x86 | No |
| Microsoft Windows Server 2008 R2 | Standard, Enterprise | x64 | No |
| Microsoft Windows Server 2008 R2 | Datacenter | x64 | Yes |
| Microsoft Windows Server 2012    | All | x64 | Yes |
| Microsoft Windows Server 2012 R2 | All | x64 | Yes |
| Microsoft Windows 7              | All | x86 | No |
| Microsoft Windows 7              | Starter, Home, Home Premium, Professional | x64 | No |
| Microsoft Windows 7              | Enterprise, Ultimate | x64 | Yes |
| Microsoft Windows 8.x            | All | x86 | Yes |
| Microsoft Windows 8.x            | All | x64 | Yes |
