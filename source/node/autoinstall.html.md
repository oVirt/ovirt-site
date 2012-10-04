---
title: Node Autoinstall
category: node
authors: dougsland, mburns
wiki_title: Node Autoinstall
wiki_revision_count: 8
wiki_last_updated: 2012-10-04
---

# AutoInstall

oVirt Node provides the option to auto-install, for **PXE environments** or pressing **TAB** on the installation screen.

At a minimum, the following parameters are required for an automated installation:

### storage_init

*   Initialize a local storage device.

### BOOTIF

*   Specify the network interface which the Hypervisor uses to connect to the Engine. When using PXE boot, BOOTIF may be automatically supplied by pxelinux.

------------------------------------------------------------------------

If you want to use oVirt Node with oVirt Engine, you must also provide at least one of the following parameters:

----

### adminpw

*   Sets an encryptedtemporary password for admin, change is forced on first login
*   Example: adminpw=RHhwCLrQXB8zE (is redhat string encrypted)

### management_server

*   Specifies - the management server to be used.

### management_server_fingerprint

*   Specifies the management server fingerprint

# Examples

### AutoInstall and AutoRegister the Node (still require Admin approval on oVirt Engine side)

      storage_init=/dev/sda BOOTIF=eth0 management_server=192.168.122.115:443 management_server_fingerprint=33:2B:79:D0:32:26:2A:08:5F:AF:F9:E9:FA:06:07:A6:6B:63:C4:8A adminpw=RHhwCLrQXB8zE 
