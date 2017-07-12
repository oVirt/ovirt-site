---
title: How to configure pNFS storage domain
category: howto
authors: acanan
---

<!-- TODO: Content review -->

# How to configure pNFS storage domain

## Summary

A pNFS type Storage Domain is a mounted pNFS share attached to a POSIX data center. It provides storage for virtualized guest images and ISO boot media. After you have exported pNFS storage, it must be attached to the Red Hat Enterprise Virtualization Manager using the Administration Portal.

## Owner

QA: Aharon Canan <aharonca@gmail.com>

## Attaching pNFS Storage

1. Click the Storage resource tab to list the existing storage domains.

2. Click New Domain to open the New Domain window.

3. Enter the Name of the storage domain.

4. Select the relevant **POSIX** Data Center and Use Host from the drop-down menus.

5. Enter the Export Path to be used for the storage domain. (The export path should be in the format of 192.168.0.10:/data or domain.example.com:/data)

6. In the VFS Type field, enter "nfs".

7. In the Mount Options field, enter "vers=4.1".

8. Click OK to create the storage domain and close the window.

The new pNFS data domain is displayed on the Storage tab with a status of Locked while the disk prepares. It is automatically attached to the data center upon completion.

**Important**

All communication to the storage domain comes from the selected host and not from Ovirt. At least one active host must be attached to the chosen Data Center before the storage is configured.
