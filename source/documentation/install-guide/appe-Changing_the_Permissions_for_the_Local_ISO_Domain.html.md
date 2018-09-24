---
title: Changing the Permissions for the Local ISO Domain
---

# Appendix A: Changing the Permissions for the Local ISO Domain

If the Engine was configured during setup to provide a local ISO domain, that domain can be attached to one or more data centers, and used to provide virtual machine image files. By default, the access control list (ACL) for the local ISO domain provides read and write access for only the Engine machine. Virtualization hosts require read and write access to the ISO domain in order to attach the domain to a data center. Use this procedure if network or host details were not available at the time of setup, or if you need to update the ACL at any time.

While it is possible to allow read and write access to the entire network, it is recommended that you limit access to only those hosts and subnets that require it.

**Changing the Permissions for the Local ISO Domain**

1. Log in to the Engine machine.

2. Edit the `/etc/exports` file, and add the hosts, or the subnets to which they belong, to the access control list:

        /var/lib/exports/iso 10.1.2.0/255.255.255.0(rw) host01.example.com(rw) host02.example.com(rw)

    The example above allows read and write access to a single /24 network and two specific hosts. `/var/lib/exports/iso` is the default file path for the ISO domain. See the `exports(5)` man page for further formatting options.

3. Apply the changes:

        # exportfs -ra

Note that if you manually edit the `/etc/exports` file after running `engine-setup`, running `engine-cleanup` later will not undo the changes.

**Prev:** [Chapter 9: Configuring Storage](../chap-Configuring_Storage) <br>
**Next:** [Appendix B: Attaching the Local ISO Domain to a Data Center](../appe-Attaching_the_Local_ISO_Domain_to_a_Data_Center)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/installation_guide/appe-changing_the_permissions_for_the_local_iso_domain)
