# Uploading a Disk Image to a Storage Domain

QEMU-compatible virtual machine disk images can be uploaded from your local machine to a Red Hat Virtualization storage domain and attached to virtual machines.

Virtual machine disk image types must be either QCOW2 or Raw. Disks created from a QCOW2 disk image cannot be shareable, and the QCOW2 disk image file must not have a backing file.

**Prerequisites:**

* You must configure the Image I/O Proxy when running `engine-setup`. See [Configuring the Red Hat Virtualization Manager](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/paged/installation-guide/33-configuring-the-red-hat-virtualization-manager) in the *Installation Guide* for more information.

* You must import the required certificate authority into the web browser used to access the Administration Portal.

* Internet Explorer 10, Firefox 35, or Chrome 13 or greater is required to perform this upload procedure. Previous browser versions do not support the required HTML5 APIs.

**Note:** To import the certificate authority, browse to https://*engine_address*/ovirt-engine/services/pki-resource?resource=ca-certificate&format=X509-PEM-CA and select all the trust settings.

**Uploading a Disk Image to a Storage Domain**

1. Open the Upload Image screen.

    * From the **Disks** tab, select **Start** from the **Upload** drop-down.

    * Alternatively, from the **Storage** tab select the storage domain, then select the **Disks** sub-tab, and select **Start** from the **Upload** drop-down.

    **The Upload Image Screen**

    ![](images/UploadImage.png)

2. In the **Upload Image** screen, click **Browse** and select the image on the local disk.

3. Set **Image Type** to **QCOW2** or **Raw**.

4. Fill in the **Disk Option** fields. See [Add Virtual Disk dialogue entries](Add_Virtual_Disk_dialogue_entries) for a description of the relevant fields.

5. Click **OK**.

A progress bar will indicate the status of the upload. You can also pause, cancel, or resume uploads from the **Upload** drop-down.
