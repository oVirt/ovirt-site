# Installing the USB Filter Editor

The USB Filter Editor is a Windows tool used to configure the `usbfilter.txt` policy file. The policy rules defined in this file allow or deny automatic pass-through of specific USB devices from client machines to virtual machines managed using the Red Hat Virtualization Manager. The policy file resides on the Red Hat Virtualization Manager in the following location:

`/etc/ovirt-engine/usbfilter.txt`

Changes to USB filter policies do not take effect unless the `ovirt-engine` service on the Red Hat Virtualization Manager server is restarted.

Download the `USBFilterEditor.msi` file from the Content Delivery Network: [https://rhn.redhat.com/rhn/software/channel/downloads/Download.do?cid=20703](https://rhn.redhat.com/rhn/software/channel/downloads/Download.do?cid=20703). 

**Installing the USB Filter Editor**

1. On a Windows machine, launch the `USBFilterEditor.msi` installer obtained from the Content Delivery Network.

2. Follow the steps of the installation wizard. Unless otherwise specified, the USB Filter Editor will be installed by default in either `C:\Program Files\RedHat\USB Filter Editor` or `C:\Program Files(x86)\RedHat\USB Filter Editor` depending on your version of Windows.

3. A USB Filter Editor shortcut icon is created on your desktop.

**Important:** Use a Secure Copy (SCP) client to import and export filter policies from the Red Hat Virtualization Manager. A Secure Copy tool for Windows machines is WinSCP ([http://winscp.net](http://winscp.net)).

The default USB device policy provides virtual machines with basic access to USB devices; update the policy to allow the use of additional USB devices.
