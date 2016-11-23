# Installing usbdk on Windows

`usbdk` is a driver that is able to install and uninstall Windows USB drivers in guest virtual machines. Installing `usbdk` requires Administrator privileges. Note that the previously supported USB Clerk option has been deprecated and is no longer supported.

**Installing usbdk on Windows**

1. Open a web browser and download one of the following installers according to the architecture of your system.

    * `usbdk` for 32-bit Windows:

            https://[your manager's address]/ovirt-engine/services/files/spice/usbdk-x86.msi

    * `usbdk` for 64-bit Windows:

            https://[your manager's address]/ovirt-engine/services/files/spice/usbdk-x64.msi

2. Open the folder where the file was saved.

3. Double-click the file.

4. Click **Run** if prompted by a security warning.

5. Click **Yes** if prompted by User Account Control.

The SPICE client sends requests to install or uninstall drivers for USB devices when users connect or disconnect USB devices to or from a guest, upon request.
