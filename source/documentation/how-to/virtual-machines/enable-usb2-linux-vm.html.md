# Enabling an EHCI (USB 2.0) Controller for Linux VMs on x86 Systems

## Overview
By default, x86 linux virtual machines are created with a UHCI (USB 1.1) 
controller enabled. This controller will be used for any host devices mapped 
to the virtual machine. This can be a problem when a device needs to see USB 
2.0 for full compatibility. Some drivers will detect that the device is not
connected on an EHCI controller and will prevent the driver from loading.

oVirt provides for an EHCI controller on linux virtual machines, but it is
not enabled by default. To enable the EHCI controller, perform the following
steps:

1. Edit the configuration of the virtual machine.
2. Navigate to the Console section.
3. Ensure SPICE is chosen as the graphics protocol.
4. Select "Native" under USB Support.
5. Start the VM
6. Check dmesg or lsusb to be sure that the EHCI controller is present.

## Notes
* This procedure requires that SPICE is used for console connections.
* This procedure may work for other VM types that use SPICE (not tested).
* Under ppc64le, this is not necessary as the default is nec-xhci since
  SPICE is not supported on this architecture.
* The default controller is UHCI as it supports USB 1.0 devices like
  SmartCards correctly.
* Enabling the EHCI controller leaves the UHCI controller present, but
  may prevent SmartCards from operating correctly.
* There may be a way to set this for any Linux VM regardless of the 
  console settings by changing the value stored in osinfo-defaults.properties.
  This file can be overridden on the engine in /etc/ovirt-engine/osinfo.conf.d.
* TODO: Extend this how-to documenting the above procedure after testing.

## References:
* [BZ 1373223 Comment #9](https://bugzilla.redhat.com/show_bug.cgi?id=1373223#c9)
* [Commit message for 68923](https://gerrit.ovirt.org/#/c/68923/)

