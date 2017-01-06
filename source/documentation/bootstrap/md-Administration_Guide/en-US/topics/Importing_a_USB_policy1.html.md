# Importing a USB Policy

**Summary**

An existing USB device policy must be downloaded and imported into the USB Filter Editor before you can edit it.

**Importing a USB Policy**

1. Using a Secure Copy client, such as WinSCP, upload the `usbfilter.txt` file to the server running Red Hat Virtualization Manager. The file must be placed in the following directory on the server:

    `/etc/ovirt-engine/`

2. Double-click the USB Filter Editor shortcut icon on your desktop to open the editor.

3. Click **Import** to open the **Open** window.

4. Open the `usbfilter.txt` file that was downloaded from the server.

**Result**

You are able to edit the USB device policy in the USB Filter Editor.
