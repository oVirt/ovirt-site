---
title: Zero-copy migrations
category: feature
authors: mzamazal
---

# Zero-copy migrations

## Summary

This feature adds support for zero-copy migrations.

## Owner

*   Name: Milan Zamazal
*   Email: mzamazal@redhat.com

## Description

Zero-copy migrations further improve migration speed and may allow migrating large VMs (>1 TB RAM).

Zero-copy migrations can be enabled by passing ``VIR_MIGRATE_ZEROCOPY`` flag to [virDomainMigrateToURI3](https://libvirt.org/html/libvirt-libvirt-domain.html#virDomainMigrateToURI3) libvirt call.

## Prerequisites

Nothing special, just up-to-date libvirt and QEMU.

## Limitations

Current implementation of zero-copy migration in QEMU has some restrictions:

- It can be used only with [parallel migrations](parallel-migrations.html) and thus the same limitations as for parallel migrations apply.

- It cannot be used with migration encryption.

- QEMU must be permitted to lock guest RAM pages in memory (libvirt takes care of this unless memory limits are set manually in ``<memtune>``.

- This is a new feature in QEMU/libvirt and may contain bugs.  It's not recommended to use it in oVirt at the moment it unless it is really needed.

- Vdsm, libvirt and QEMU on the migration source host must support the feature.

## User experience

A new migration policy *Very large VMs* is introduced in cluster migration options.  If this policy is selected, zero-copy migrations are enabled (unless other settings prevent it, see below) and other migrations parameters specified in the policy are applied (this allows using migrations parameters such as downtime schedule customized for such migrations).  The policy is available only when parallel migrations are enabled in Engine config (i.e. on cluster level 4.7 by default).

Since the policy is aimed at very large VMs where short downtimes are unlikely to suffice, especially if the other migration policies are insufficient to migrate the VM, it sets longer initial downtimes.  Autoconverge is enabled; although very large VMs are supposed to be mostly idle when being migrated and thus autoconverge doesn't help much, having it enabled may be still useful to migrate busy large (although not very large) VMs.

If this policy is selected while the [limitations above](#limitations) are not satisfied then:

- If parallel migrations are disabled or only conditionally enabled ("Auto") then they are enabled with automatic number of parallel connections.

- If migration encryption is enabled then zero-copy is not enabled.

If the policy is selected and the host doesn't support the feature then:

- If Vdsm doesn't support the feature, API call mismatch is logged and zero-copy is not enabled.

This applies only when parallel migrations are enabled in Engine config (cluster level 4.7 by default) and the host is not up-to-date.

In all the cases, VM migration proceeds, although with different parameters.

## Testing

It should be tested that when the policy above is selected and the limitations above are satisfied then ``VIR_MIGRATE_ZEROCOPY`` flag is passed to the libvirt migration call.

## Changes to Engine and Vdsm

``VM.migrate`` Vdsm API call gets an additional boolean parameter ``zerocopy``.  Iff it is set to true, zero-copy migration flag is passed to the libvirt migration call.  It is responsibility of the caller (Engine) to pass a correct combination of migration parameters to ``VM.migrate``; if this is not satisfied the migration may fail.

Vdsm adds functionality for processing the parameter and passing the corresponding flag and parameter to the libvirt migration call.

Engine adds the new migration policy.  The policy contains a new policy boolean argument ``zerocopy``.  In case the argument is set to true, Engine ensures the contingent requirement conflicts are silently resolved as described in [User experience](#user-experience) above.
