# Installing Windows on VirtIO-Optimized Hardware

Install VirtIO-optimized disk and network device drivers during your Windows installation by attaching the `virtio-win.vfd` diskette to your virtual machine. These drivers provide a performance improvement over emulated device drivers.

Use the **Run Once** option to attach the diskette in a one-off boot different from the **Boot Options** defined in the **New Virtual Machine** window. This procedure presumes that you added a `Red Hat VirtIO` network interface and a disk that uses the `VirtIO` interface to your virtual machine.

**Note:** The `virtio-win.vfd` diskette is placed automatically on ISO storage domains that are hosted on the Manager server. An administrator must manually upload it to other ISO storage domains using the `engine-iso-uploader` tool.

**Installing VirtIO Drivers during Windows Installation**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click **Run Once**.

3. Expand the **Boot Options** menu.

4. Select the **Attach Floppy** check box, and select `virtio-win.vfd` from the drop-down list.

5. Select the **Attach CD** check box, and select the required Windows ISO from the drop-down list.

6. Move **CD-ROM** to the top of the **Boot Sequence** field.

7. Configure the rest of your **Run Once** options as required. See [Virtual Machine Run Once settings explained](Virtual_Machine_Run_Once_settings_explained) for more details.

8. Click **OK**.

The **Status** of the virtual machine changes to `Up`, and the operating system installation begins. Open a console to the virtual machine if one does not open automatically.

Windows installations include an option to load additional drivers early in the installation process. Use this option to load drivers from the `virtio-win.vfd` diskette that was attached to your virtual machine as `A:`. For each supported virtual machine architecture and Windows version, there is a folder on the disk containing optimized hardware device drivers.
