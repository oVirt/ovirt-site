# Importing a Virtual Machine from a Xen Host

Import virtual machines from Xen on Red Hat Enterprise Linux 5 to your Red Hat Virtualization environment. Red Hat Virtualization uses V2V to convert Xen virtual machines to the correct format before they are imported. You must install the `virt-v2v` package on at least one Red Hat Enterprise Linux 7 host in the destination data center before proceeding (this host is referred to in the following procedure as the V2V host). The `virt-v2v` package is available in the base `rhel-7-server-rpms` repository.

**Warning:** The virtual machine must be shut down before being imported. Starting the virtual machine through Xen during the import process can result in data corruption.

**Importing a Virtual Machine from Xen**

1. Enable passwordless SSH between the V2V host and the Xen host:

    1. Log in to the V2V host and generate SSH keys for the `vdsm` user.

            # sudo -u vdsm ssh-keygen

    2. Copy the `vdsm` user's public key to the Xen host.

            # sudo -u vdsm ssh-copy-id root@xenhost.example.com

    3. Log in to the Xen host to add it to the V2V host's `known_hosts` file. 

            # sudo -u vdsm ssh root@xenhost.example.com

    4. Exit the Xen host.

            # logout

2. Log in to the Administration Portal. In the **Virtual Machines** tab, click **Import** to open the **Import Virtual Machine(s)** window.

    **The Import Virtual Machine(s) Window**

    ![](images/ImportXenVM.png)

3. Select the **Data Center** that contains the V2V host.

4. Select **XEN (via RHEL)** from the **Source** drop-down list.

5. Enter the **URI** of the Xen host. The required format is pre-filled; you must replace `<hostname>` with the host name of the Xen host.  

6. Select the V2V host from the **Proxy Host** drop-down list.

7. Click **Load** to generate a list of the virtual machines on the Xen hypervisor.

8. Select one or more virtual machines from the **Virtual Machines on Source** list, and use the arrows to move them to the **Virtual Machines to Import** list.

    **Note:** Due to current limitations, Xen virtual machines with block devices do not appear in the **Virtual Machines on Source** list, and cannot be imported to Red Hat Virtualization.

9. Click **Next**.

    **Important:** An import operation can only include virtual machines that share the same architecture. If any virtual machine to be imported has a different architecture, a warning will display and you will be prompted to change your selection to include only virtual machines with the same architecture.

    **The Import Virtual Machine(s) Window**

    ![](images/7325.png)

10. Select the **Cluster** in which the virtual machines will reside.

11. Select a **CPU Profile** for the virtual machines.

12. Select the **Collapse Snapshots** check box to remove snapshot restore points and include templates in template-based virtual machines.

13. Select the **Clone** check box to change the virtual machine name and MAC addresses, and clone all disks, removing all snapshots. If a virtual machine appears with a warning symbol beside its name or has a tick in the **VM in System** column, you must clone the virtual machine and change its name.

14. Click on each virtual machine to be imported and click on the **Disks** sub-tab. Use the **Allocation Policy** and **Storage Domain** lists to select whether the disk used by the virtual machine will be thinly provisioned or preallocated, and select the storage domain on which the disk will be stored. An icon is also displayed to indicate which of the disks to be imported acts as the boot disk for that virtual machine.

    **Note:** The target storage domain must be a filed-based domain. Due to current limitations, specifying a block-based domain causes the V2V operation to fail.

15. If you selected the **Clone** check box, change the name of the virtual machine in the **General** sub-tab.

16. Click **OK** to import the virtual machines.
