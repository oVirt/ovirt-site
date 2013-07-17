---
title: Vdsm Hooks
category: vdsm
authors: amuller, danken
wiki_category: Vdsm
wiki_title: Vdsm Hooks
wiki_revision_count: 14
wiki_last_updated: 2014-02-26
---

# Vdsm Hooks

## Installing a hook

We'll install the macspoof hook as an example. This hook allows nested virtualization as it removes mac spoof filtering on the host.

Install the hook on all hosts:

      # yum install vdsm-hook-macspoof

Most hooks check for VM or device (Network interface or disk, for example) custom properties to know if they should be used. Meaning that even if you installed the macspoof hook as described above, the hook will not be used because the 'macspoof' VM custom property won't be present.

### VM-level hooks

On the server that has the engine installed:

      # engine-config -s "UserDefinedVMProperties=macspoof=(true|false)"
      # service ovirt-engine restart

In order to activate the mac spoof hook on a VM:

1.  Bring down the VM
2.  edit the VM
3.  Click advanced
4.  Go to custom properties
5.  Add a key
6.  Select macspoof
7.  Type true as the value
8.  Start the VM

### Device-level hooks

If you want to use a hook that runs at the device level (And not the VM level), you need to edit the 'CustomDeviceProperties' database key and not the 'UserDefinedVMProperties' key.

      # engine-config -s CustomDeviceProperties="{type=interface;prop={speed=^([0-9]{1,5})$;duplex=^(full|half)$}}"
      # service ovirt-engine restart

That will set two custom properties for virtual network interface cards. Speed (A number of 1 to 5 digits) and duplex (Which may be full or half).

oVirt 3.2:

1.  Select a VM (It is not required to bring it down)
2.  Select a virtual network interface card
3.  Click edit
4.  Insert a new custom property
5.  Select the key (speed or duplex)
6.  Enter a value
7.  Hit ok

oVirt 3.3:

1.  Select an existing vnic profile, or create a new one
2.  Insert a new custom property
3.  Select the key (speed or duplex)
4.  Enter a value
5.  Hit ok
6.  Select a VM
7.  Select one of its virtual interface cards
8.  Select the updated or new vnic profile
9.  Hit ok

If the device-specific hook runs at VM start, the next time the VM is restarted the hook will be ran with the updated device custom properties.

## Writing a new hook

This patch may be used as reference: <http://gerrit.ovirt.org/#/c/12833/>

When creating a new vdsm hook, create a directory for it and place it under vdsm_hooks. Each hook should contain at minimum three files:

1.  Makefile.am - You may copy an existing Makefile.am from another hook and make the appropriate changes.
2.  README - The readme should include any known gotchas, custom properties required by the hook and any domxml changes made by the hook.
3.  And the event at which the hook is fired. For example: before_vm_start. Here is where you write the actual code. Your hook may implement several events of course.

Additionally, the following changes have to be made:

1.  vdsm_hooks/Makefile.am - Add your hook name to the section at line 25.
2.  configure.ac - Add your new hook name under the section beginning at line 196.
3.  vdsm.spec.in - Your new hook must be placed in two different spots:

Hooks placed below line 993 are non-required hooks, while hooks immediately above that line are installed as part of the installation even if hooks are not explicitly enabled. Finally, you must add a package summary and description under the section at line 291.

During installation, hooks are placed at /usr/libexec/vdsm/hooks/hook_event/your_hook_name
where hook_event is one of before_vm_start, before_migrate_source and so on.

## Creating a new hook point

This patch may be used as reference: <http://gerrit.ovirt.org/#/c/13411/>

If needed additional hook points may be implemented to respond to new
