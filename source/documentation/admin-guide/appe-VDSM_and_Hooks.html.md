---
title: VDSM and Hooks
---

# Appendix A: VDSM and Hooks

## VDSM

The VDSM service is used by the Red Hat Virtualization Manager to manage Red Hat Virtualization Hosts (RHVH) and Red Hat Enterprise Linux hosts. VDSM manages and monitors the host's storage, memory and network resources. It also co-ordinates virtual machine creation, statistics gathering, log collection and other host administration tasks. VDSM is run as a daemon on each host managed by Red Hat Virtualization Manager. It answers XML-RPC calls from clients. The Red Hat Virtualization Manager functions as a VDSM client.

## VDSM Hooks

VDSM is extensible via hooks. Hooks are scripts executed on the host when key events occur. When a supported event occurs VDSM runs any executable hook scripts in **/usr/libexec/vdsm/hooks/nn_event-name/** on the host in alphanumeric order. By convention each hook script is assigned a two digit number, included at the front of the file name, to ensure that the order in which the scripts will be run in is clear. You are able to create hook scripts in any programming language, Python will however be used for the examples contained in this chapter.

Note that all scripts defined on the host for the event are executed. If you require that a given hook is only executed for a subset of the virtual machines which run on the host then you must ensure that the hook script itself handles this requirement by evaluating the **Custom Properties** associated with the virtual machine.

    **Warning:** VDSM hooks can interfere with the operation of Red Hat Virtualization. A bug in a VDSM hook has the potential to cause virtual machine crashes and loss of data. VDSM hooks should be implemented with caution and tested rigorously. The Hooks API is new and subject to significant change in the future.

## Extending VDSM with Hooks

This chapter describes how to extend VDSM with event-driven hooks. Extending VDSM with hooks is an experimental technology, and this chapter is intended for experienced developers. By setting custom properties on virtual machines it is possible to pass additional parameters, specific to a given virtual machine, to the hook scripts.

## Supported VDSM Events

**Supported VDSM Events**

| Name | Description |
|-
| before_vm_start | Before virtual machine starts. |
| after_vm_start | After virtual machine starts. |
| before_vm_cont | Before virtual machine continues. |
| after_vm_cont | After virtual machine continues. |
| before_vm_pause | Before virtual machine pauses. |
| after_vm_pause | After virtual machine pauses. |
| before_vm_hibernate | Before virtual machine hibernates. |
| after_vm_hibernate | After virtual machine hibernates. |
| before_vm_dehibernate | Before virtual machine dehibernates. |
| after_vm_dehibernate | After virtual machine dehibernates. |
| before_vm_migrate_source | Before virtual machine migration, run on the source host from which the migration is occurring. |
| after_vm_migrate_source | After virtual machine migration, run on the source host from which the migration is occurring. |
| before_vm_migrate_destination | Before virtual machine migration, run on the destination host to which the migration is occurring. |
| after_vm_migrate_destination | After virtual machine migration, run on the destination host to which the migration is occurring. |
| after_vm_destroy | After virtual machine destruction. |
| before_vdsm_start | Before VDSM is started on the host. `before_vdsm_start` hooks are executed as the user root, and do not inherit the environment of the VDSM process. |
| after_vdsm_stop | After VDSM is stopped on the host. `after_vdsm_stop` hooks are executed as the user root, and do not inherit the environment of the VDSM process. |
| before_nic_hotplug | Before the NIC is hot plugged into the virtual machine. |
| after_nic_hotplug | After the NIC is hot plugged into the virtual machine. |
| before_nic_hotunplug | Before the NIC is hot unplugged from the virtual machine |
| after_nic_hotunplug | After the NIC is hot unplugged from the virtual machine. |
| after_nic_hotplug_fail | After hot plugging the NIC to the virtual machine fails. |
| after_nic_hotunplug_fail | After hot unplugging the NIC from the virtual machine fails. |
| before_disk_hotplug | Before the disk is hot plugged into the virtual machine. |
| after_disk_hotplug | After the disk is hot plugged into the virtual machine. |
| before_disk_hotunplug | Before the disk is hot unplugged from the virtual machine |
| after_disk_hotunplug | After the disk is hot unplugged from the virtual machine. |
| after_disk_hotplug_fail | After hot plugging the disk to the virtual machine fails. |
| after_disk_hotunplug_fail | After hot unplugging the disk from the virtual machine fails. |
| before_device_create | Before creating a device that supports custom properties. |
| after_device_create | After creating a device that supports custom properties. |
| before_update_device | Before updating a device that supports custom properties. |
| after_update_device | After updating a device that supports custom properties. |
| before_device_destroy | Before destroying a device that supports custom properties. |
| after_device_destroy | After destroying a device that supports custom properties. |
| before_device_migrate_destination | Before device migration, run on the destination host to which the migration is occurring. |
| after_device_migrate_destination | After device migration, run on the destination host to which the migration is occurring. |
| before_device_migrate_source | Before device migration, run on the source host from which the migration is occurring. |
| after_device_migrate_source | After device migration, run on the source host from which the migration is occurring. |
| after_network_setup | After setting up the network when starting a host machine. |
| before_network_setup | Before setting up the network when starting a host machine. |

## The VDSM Hook Environment

Most hook scripts are run as the **vdsm** user and inherit the environment of the VDSM process. The exceptions are hook scripts triggered by the **before_vdsm_start** and **after_vdsm_stop** events. Hook scripts triggered by these events run as the **root** user and do not inherit the environment of the VDSM process.

## The VDSM Hook Domain XML Object

When hook scripts are started, the `_hook_domxml` variable is appended to the environment. This variable contains the path of the libvirt domain XML representation of the relevant virtual machine. Several hooks are an exception to this rule, as outlined below. The `_hook_domxml` variable of the following hooks contains the XML representation of the NIC and not the virtual machine.

* `*_nic_hotplug_*`

* `*_nic_hotunplug_*`

* `*_update_device`

* `*_device_create`

* `*_device_migrate_*`

    **Important:** The **before_migration_destination** and **before_dehibernation** hooks currently receive the XML of the domain from the source host. The XML of the domain at the destination will have various differences.

The libvirt domain XML format is used by VDSM to define virtual machines. Details on the libvirt domain XML format can be found at [http://libvirt.org/formatdomain.html](http://libvirt.org/formatdomain.html). The UUID of the virtual machine may be deduced from the domain XML, but it is also available as the environment variable `vmId`.

## Defining Custom Properties

The custom properties that are accepted by the Red Hat Virtualization Manager - and in turn passed to custom hooks - are defined using the `engine-config` command. Run this command as the **root** user on the host where oVirt Engine is installed.

The `UserDefinedVMProperties` and `CustomDeviceProperties` configuration keys are used to store the names of the custom properties supported. Regular expressions defining the valid values for each named custom property are also contained in these configuration keys.

Multiple custom properties are separated by a semi-colon. Note that when setting the configuration key, any existing value it contained is overwritten. When combining new and existing custom properties, all of the custom properties in the command used to set the key's value must be included.

Once the configuration key has been updated, the `ovirt-engine` service must be restarted for the new values to take effect.

**Virtual Machine Properties - Defining the `smartcard` Custom Property**

1. Check the existing custom properties defined by the `UserDefinedVMProperties` configuration key using the following command:

        # engine-config -g UserDefinedVMProperties

    As shown by the output below, the custom property `memory` is already defined. The regular expression `^[0-9]+$` ensures that the custom property will only ever contain numeric characters.

        # engine-config -g UserDefinedVMProperties
        UserDefinedVMProperties:  version: 3.6
        UserDefinedVMProperties:  version: 4.0
        UserDefinedVMProperties : memory=^[0-9]+$ version: 4.0

2. Because the `memory` custom property is already defined in the `UserDefinedVMProperties` configuration key, the new custom property must be appended to it. The additional custom property, `smartcard`, is added to the configuration key's value. The new custom property is able to hold a value of `true` or `false`.

        # engine-config -s UserDefinedVMProperties='memory=^[0-9]+$;smartcard=^(true|false)$' --cver=4.0

3. Verify that the custom properties defined by the `UserDefinedVMProperties` configuration key have been updated correctly.

        # engine-config -g UserDefinedVMProperties
        UserDefinedVMProperties:  version: 3.6
        UserDefinedVMProperties:  version: 4.0
        UserDefinedVMProperties : memory=^[0-9]+$;smartcard=^(true|false)$ version: 4.0

4. Finally, the `ovirt-engine` service must be restarted for the configuration change to take effect.

        # systemctl restart ovirt-engine.service

**Device Properties - Defining the `interface` Custom Property**

1. Check the existing custom properties defined by the `CustomDeviceProperties` configuration key using the following command:

        # engine-config -g CustomDeviceProperties

    As shown by the output below, no custom properties have yet been defined.

        # engine-config -g CustomDeviceProperties
        CustomDeviceProperties:  version: 3.6
        CustomDeviceProperties:  version: 4.0

2. The `interface` custom property does not already exist, so it can be appended as is. In this example, the value of the `speed` sub-property is set to a range of 0 to 99999, and the value of the `duplex` sub-property is set to a selection of either `full` or `half`.

        # engine-config -s CustomDeviceProperties="{type=interface;prop={speed=^([0-9]{1,5})$;duplex=^(full|half)$}}" --cver=4.0

3. Verify that the custom properties defined by the `CustomDeviceProperties` configuration key have been updated correctly.

        # engine-config -g CustomDeviceProperties
        UserDefinedVMProperties:  version: 3.6
        UserDefinedVMProperties:  version: 4.0
        UserDefinedVMProperties : {type=interface;prop={speed=^([0-9]{1,5})$;duplex=^(full|half)$}} version: 4.0

4. Finally, the `ovirt-engine` service must be restarted for the configuration change to take effect.

        # systemctl restart ovirt-engine.service

## Setting Virtual Machine Custom Properties

Once custom properties are defined in the oVirt Engine, you can begin setting them on virtual machines. Custom properties are set on the **Custom Properties** tab of the **New Virtual Machine** and **Edit Virtual Machine** windows in the Administration Portal.

You can also set custom properties from the **Run Virtual Machine(s)** dialog box. Custom properties set from the **Run Virtual Machine(s)** dialog box will only apply to the virtual machine until it is next shutdown.

The **Custom Properties** tab provides a facility for you to select from the list of defined custom properties. Once you select a custom property key an additional field will display allowing you to enter a value for that key. Add additional key/value pairs by clicking the **+** button and remove them by clicking the **-** button.

## Evaluating Virtual Machine Custom Properties in a VDSM Hook

Each key set in the **Custom Properties** field for a virtual machine is appended as an environment variable when calling hook scripts. Although the regular expressions used to validate the **Custom Properties** field provide some protection you should ensure that your scripts also validate that the inputs provided match their expectations.

**Evaluating Custom Properties**

This short Python example checks for the existence of the custom property `key1`. If the custom property is set then the value is printed to standard error. If the custom property is not set then no action is taken.

    #!/usr/bin/python

    import os
    import sys

    if os.environ.has_key('key1'):
    sys.stderr.write('key1 value was : %s\n' % os.environ['key1'])
    else:
        sys.exit(0)

## Using the VDSM Hooking Module

VDSM ships with a Python hooking module, providing helper functions for VDSM hook scripts. This module is provided as an example, and is only relevant to VDSM hooks written in Python.

The hooking module supports reading of a virtual machine's libvirt XML into a DOM object. Hook scripts can then use Python's built in `xml.dom` library ([http://docs.python.org/release/2.6/library/xml.dom.html](http://docs.python.org/release/2.6/library/xml.dom.html)) to manipulate the object.

The modified object can then be saved back to libvirt XML using the hooking module. The hooking module provides the following functions to support hook development:

**Hooking module functions**

| Name | Argument | Description |
|-
| `tobool` | string | Converts a string "true" or "false" to a Boolean value |
| `read_domxml` | - | Reads the virtual machine's libvirt XML into a DOM object |
| `write_domxml` | DOM object | Writes the virtual machine's libvirt XML from a DOM object |

## VDSM Hook Execution

**before_vm_start** scripts can edit the domain XML in order to change VDSM's definition of a virtual machine before it reaches libvirt. Caution must be exercised in doing so. Hook scripts have the potential to disrupt the operation of VDSM, and buggy scripts can result in outages to the Red Hat Virtualization environment. In particular, ensure you never change the UUID of the domain, and do not attempt to remove a device from the domain without sufficient background knowledge.

Both **before_vdsm_start** and **after_vdsm_stop** hook scripts are run as the **root** user. Other hook scripts that require **root** access to the system must be written to use the `sudo` command for privilege escalation. To support this the **/etc/sudoers** must be updated to allow the **vdsm** user to use `sudo` without reentering a password. This is required as hook scripts are executed non-interactively.

**Configuring `sudo` for VDSM Hooks**

In this example the `sudo` command will be configured to allow the **vdsm** user to run the `/bin/chown` command as **root**.

1. Log into the virtualization host as **root**.

2. Open the **/etc/sudoers** file in a text editor.

3. Add this line to the file:

        vdsm ALL=(ALL) NOPASSWD: /bin/chown

    This specifies that the **vdsm** user has the ability to run the `/bin/chown` command as the **root** user. The `NOPASSWD` parameter indicates that the user will not be prompted to enter their password when calling `sudo`.

Once this configuration change has been made VDSM hooks are able to use the `sudo` command to run `/bin/chown` as **root**. This Python code uses `sudo` to execute `/bin/chown` as **root** on the file **/my_file**.

    retcode = subprocess.call( ["/usr/bin/sudo", "/bin/chown", "root", "/my_file"] )

The standard error stream of hook scripts is collected in VDSM's log. This information is used to debug hook scripts.

## VDSM Hook Return Codes

Hook scripts must return one of the return codes shown in [hook-return-codes](hook-return-codes). The return code will determine whether further hook scripts are processed by VDSM.

**Hook Return Codes**

| Code | Description |
|-
| 0 | The hook script ended successfully |
| 1 | The hook script failed, other hooks should be processed |
| 2 | The hook script failed, no further hooks should be processed |
| >2 | Reserved |

## VDSM Hook Examples

The example hook scripts provided in this section are strictly not supported by the oVirt Project. You must ensure that any and all hook scripts that you install to your system, regardless of source, are thoroughly tested for your environment.

**NUMA Node Tuning**

**Purpose:**

This hook script allows for tuning the allocation of memory on a NUMA host based on the `numaset` custom property. Where the custom property is not set no action is taken.

**Configuration String:**

    numaset=^(interleave|strict|preferred):[\^]?\d+(-\d+)?(,[\^]?\d+(-\d+)?)\*$

The regular expression used allows the `numaset` custom property for a given virtual machine to specify both the allocation mode (`interleave`, `strict`, `preferred`) and the node to use. The two values are separated by a colon (`:`). The regular expression allows specification of the `nodeset` as:

* that a specific node (`numaset=strict:1`, specifies that only node 1 be used), or
* that a range of nodes be used (`numaset=strict:1-4`, specifies that nodes 1 through 4 be used), or
* that a specific node not be used (`numaset=strict:^3`, specifies that node 3 not be used), or
* any comma-separated combination of the above (`numaset=strict:1-4,6`, specifies that nodes 1 to 4, and 6 be used).

**Script:**

**/usr/libexec/vdsm/hooks/before_vm_start/50_numa**

    #!/usr/bin/python

    import os
    import sys
    import hooking
    import traceback

    '''
    numa hook
    =========
    add numa support for domain xml:

    <numatune>
        <memory mode="strict" nodeset="1-4,^3" />
    </numatune>

    memory=interleave|strict|preferred

    numaset="1" (use one NUMA node)
    numaset="1-4" (use 1-4 NUMA nodes)
    numaset="^3" (don't use NUMA node 3)
    numaset="1-4,^3,6" (or combinations)

    syntax:
        numa=strict:1-4
    '''

    if os.environ.has_key('numa'):
        try:
            mode, nodeset = os.environ['numa'].split(':')

            domxml = hooking.read_domxml()

            domain = domxml.getElementsByTagName('domain')[0]
            numas = domxml.getElementsByTagName('numatune')

            if not len(numas) > 0:
                numatune = domxml.createElement('numatune')
                domain.appendChild(numatune)

                memory = domxml.createElement('memory')
                memory.setAttribute('mode', mode)
                memory.setAttribute('nodeset', nodeset)
                numatune.appendChild(memory)

                hooking.write_domxml(domxml)
            else:
                sys.stderr.write('numa: numa already exists in domain xml')
                sys.exit(2)
        except:
            sys.stderr.write('numa: [unexpected error]: %s\n' % traceback.format_exc())
            sys.exit(2)

**Prev:** [Chapter 20: Proxies](chap-Proxies)<br>
**Next:** [Appendix B: Custom Network Properties](appe-Custom_Network_Properties)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/administration_guide/appe-vdsm_and_hooks)
