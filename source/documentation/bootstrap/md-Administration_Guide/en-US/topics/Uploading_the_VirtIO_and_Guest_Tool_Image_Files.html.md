# VirtIO and Guest Tool Image Files

The `virtio-win` ISO and Virtual Floppy Drive (VFD) images, which contain the VirtIO drivers for Windows virtual machines, and the `rhev-tools-setup` ISO, which contains the Red Hat Virtualization Guest Tools for Windows virtual machines, are copied to an ISO storage domain upon installation and configuration of the domain.

These image files provide software that can be installed on virtual machines to improve performance and usability. The most recent `virtio-win` and `rhev-tools-setup` files can be accessed via the following symbolic links on the file system of the Red Hat Virtualization Manager:

* `/usr/share/virtio-win/virtio-win.iso`

* `/usr/share/virtio-win/virtio-win_x86.vfd`

* `/usr/share/virtio-win/virtio-win_amd64.vfd`

* `/usr/share/rhev-guest-tools-iso/rhev-tools-setup.iso`

These image files must be manually uploaded to ISO storage domains that were not created locally by the installation process. Use the `engine-iso-uploader` command to upload these images to your ISO storage domain. Once uploaded, the image files can be attached to and used by virtual machines.
