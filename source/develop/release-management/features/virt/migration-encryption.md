---
title: Migration encryption
category: feature
authors:
  - mzamazal
  - ljelinko
---

# Migration encryption

## Summary

Add support for native TLS encryption of live migrations.

## Owner

*   Name: Milan Zamazal (mz-pdm)

*   Email: <mzamazal@redhat.com>

## Detailed Description

Now, when QEMU provides native TLS encryption support, we can add support for secure migrations with a low performance overhead.  A user can enable encrypted migration for a cluster in Engine and then libvirt is asked to perform native QEMU TLS migrations when migrating VMs between hosts.

## Prerequisites

Cluster level 4.4 or higher is required to enable migration encryption.

## Limitations

Currently, an encrypted migration cannot use a separate migration network.  The destination certificate contains only the host name and not its IP addresses.  Putting IP addresses there would be cumbersome for both the code and the user (a host must be switched to the maintenance mode to update its certificate), difficult to maintain and error-prone, since the IP addresses may change at different times and places.  The migration client checks the presence of the destination address in the destination certificate, thus only the host name (and the related network) can be used as the migration destination address.

A solution would be to enhance libvirt with a migration parameter that specifies the host name to check for in the certificate, independently of the destination address used.  QEMU already provides the facility, it just needs to be supported by libvirt, see this RFE: https://bugzilla.redhat.com/show_bug.cgi?id=1754533.

We will be able to remove the limitation once the libvirt RFE is implemented and released.

## Benefit to oVirt

Live migrations can be secured, providing more protection to the data transferred between the hosts.

## User Experience

There is new "Enable migration encryption" option in Migration Policy tab of the cluster edit dialog.  It's possible to enable or disable encrypted migrations there or to use the system default, which is not to encrypt migrations currently.

![](/images/wiki/migration-encryption-cluster.png)

There is a similar item in Host tab of the VM edit dialog, to enable or disable encrypted migrations for a particular VM if needed.

![](/images/wiki/migration-encryption-vm.png)

Migration encryption support is available only on cluster level 4.4 or higher.

There is no way to enable or disable migration encryption for individual migrations.

## Implementation

Migration encryption is supported in Vdsm by passing ``encrypted`` migration parameter, of boolean type, to ``VM.migrate`` API call.  According to the value of the parameter, Vdsm asks libvirt to perform an encrypted or non-encrypted migration.  In case the parameter is missing, non-encrypted migration is used, to be compatible with older hosts.

To make migration encryption working, there are some changes needed in certificate handling:

* libvirt support for checking the expected host name in the certificate, see [Limitations](#limitations) above.
* Introduction of QEMU-only certificates.

QEMU-only certificates are needed because a direct secure connection between QEMU processes is established and used for the migration.  For security reasons, QEMU processes must not be able to connect to libvirt, Vdsm or other services.  That means separate distinguishable QEMU certificates must be used for QEMU connections.  The safest and most robust way to separate QEMU certificates from other certificates is to use a separate certification authority for issuing QEMU certificates.  Then it is automatically ensured that QEMU processes can't connect to libvirt or Vdsm, since their certificates are signed by a different certificate authority than the other services expect.  We need to add:

* Certificate of the QEMU certification authority and its management.
* Management of QEMU certificates and their deployment to hosts.
* Libvirt configuration amendment to specify the location of the QEMU certificates on the host.

## REST API

Migration encryption, as described above, can be managed from the REST API.  New boolean option ``encrypted`` has been added to other migration options in the REST API.  It can be used to enable or disable encrypted migrations for a given cluster or a VM.

## Testing

The following facts should be checked:

* An encrypted migration can be performed successfully.
* The migration is indeed encrypted.
* There is no huge impact on migration performance when using encryption (there may still be a noticeable impact though).
* All the cluster/VM combinations of the options to enable or disable migration encryption work as expected.
