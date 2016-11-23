# Preventing Automatic Migration of a Virtual Machine

Red Hat Virtualization Manager allows you to disable automatic migration of virtual machines. You can also disable manual migration of virtual machines by setting the virtual machine to run only on a specific host.

The ability to disable automatic migration and require a virtual machine to run on a particular host is useful when using application high availability products, such as Red Hat High Availability or Cluster Suite.

**Preventing Automatic Migration of Virtual Machine**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click **Edit**.

    **The Edit Virtual Machine Window**

    ![](images/7321.png)

3. Click the **Host** tab.

4. Use the **Start Running On** radio buttons to designate the virtual machine to run on **Any Host in Cluster** or a **Specific** host. If applicable, select a specific host or group of hosts from the list.

    **Warning:** Explicitly assigning a virtual machine to one specific host and disabling migration is mutually exclusive with Red Hat Virtualization high availability. Virtual machines that are assigned to one specific host can only be made highly available using third party high availability products like Red Hat High Availability. This restriction does not apply to virtual machines that are assigned to multiple specific hosts.

    **Important:** If the virtual machine has host devices directly attached to it, and a different host is specified, the host devices from the previous host will be automatically removed from the virtual machine.

5. Select **Allow manual migration only** or **Do not allow migration** from the **Migration Options** drop-down list.

6. Optionally, select the **Use custom migration downtime** check box and specify a value in milliseconds.

7. Click **OK**.
