---
title: ppc64le support
category: feature
authors: mpolednik
---

# ppc64le Support

## Summary

This feature adds full support for ppc64le platform. Most of the requirements are already implemented by [VDSM's support](/develop/release-management/features/virt/for-ppc64.html).

## Owner

*   name: Martin Polednik (Martin Polednik)

## Current Status

*   Released in oVirt 3.6

## Requirements

*   ppc64le machine - currently supported is POWER8
*   RHEL 7.2 (ppc64le)

## Differences Between ppc64le and x86_64

Most of the differences are already solved by lower components of the stack. That said, there are several details that are not abstracted at all. In order to overcome these issues, VDSM must take care of gathering the information from sources relevant for the platform and Engine must use them adequately.

### Hardware Info

#### Device Tree

First difference is hardware information. On x86_64, we use `dmidecode` to read the low level system information. POWER8 lacks DMI table at all, but another structure - device tree - is used. There are several keys in our info structure, such as `system-id`, `model-name` and `vendor`. Using device-tree to obtain them is possibly via `procfs`:

```bash
# cat /proc/device-tree/system-id
<value>
# cat /proc/device-tree/model-name
IBM Power System S822L
# cat /proc/device-tree/vendor
IBM
````

Similar information found in `dmidecode`:

````
Handle 0x0001, DMI type 1, 27 bytes
System Information
        Manufacturer: HP
        Product Name: ProLiant DL160 G6
        Version:
        Serial Number: <value>
        UUID: <value>
        Wake-up Type: Power Switch
        SKU Number: <value>
        Family:
````

#### Different cpuinfo Format

The fields in cpuinfo have different values. Following table displays how x86_64 fields map to ppc64le fields.

````
'flags'      -> __not there __
'cpu MHz'    -> 'clock'
'model name' -> 'cpu'
````

#### Cpu Flags

Libvirt uses notion of baseline CPUs for x86_64, meaning that the model of CPU is mapped by it's flags to a closest baseline subset of these flags. This does not apply for ppc64le where no flags are reported. Since there are data passed in the flags field other then flags (supported baseline CPUs), we use an arbitrary flag `powernv`. The machine type is then read from libvirt's capabilities XML in a same way as on x86_64.

### Machine Type Differences

#### Graphics

Various constraints must be considered when launching ppc64le VM. Most notably the SPICE is not supported, therefore VNC (with virtio-vga video) must be used.

#### CPU

The libvirt CPU format for ppc64le is quite different from ppc64le. Relevant information is that POWER8 is a magic constant in qemu, meaning 'select the most appropriate CPU for the host'. This is achieved by following XML. Also note that this mode currently allows migration between POWER8 hosts in the same cluster.

````xml
<cpu>
    <model>POWER8</model>
</cpu>
````

Using host-model is reserved for POWER compatibility modes. These are not used within VDSM.

````xml
<cpu mode="host-model">
    <model>POWER7</model>
</cpu>
````

#### Input

ppc64le uses USB instead of PS2 for mouse. Since the preferred way of interacting with VM is using absolute pointing device (tablet) that is USB on both platforms, this is mostly a fallback.

#### SMBIOS

Not relevant for ppc64le at all.

## Updating firmware from the OS

The following instructions are taken from [IBM's public wiki](https://www.ibm.com/developerworks/community/wikis/home?lang=en#!/wiki/W51a7ffcf4dfd_4b40_9d82_446ebc23c550/page/Updating%20firmware%20on%20a%20Power%20system%20running%20Ubuntu). This manual covers update from inside of the OS, no HMC or any other tools available.

*   1) Determine the model, serial number and firmware version(?) of the machine.

```bash
# cat /proc/cpuinfo  | grep model
model           : 8247-22L

# cat /proc/device-tree/system-id
<serial number>

# lsmcode | awk '{print $6}'
FW810.33
````

*   2) Enter the information obtained in 1) at <http://www-933.ibm.com/support/fixcentral/> and download the firmware version requested. The only required part is the rpm.
*   3) Install the rpm. The firmware image can be located at `/tmp/fwupdate`.

````bash
# rpm -Uvh --ignoreos 01SV810_133_081.rpm

Preparing...                          ################################# [100%]
Updating / installing...
   1:01SV810_133_081-1.1-1            ################################# [100%]
````

*   4) Verify the firmware.

````bash
# update_flash -v -f /tmp/fwupdate/01SV810_133_081.img
info: Current Temporary side will be committed to
Permanent side before being replaced with the new
image.

Projected Flash Update Results:
Current T Image: SV810_133
Current P Image: SV810_081
New T Image:     SV810_133
New P Image:     SV810_133
````

*   5) If everything seems correct, update the firmware.

````bash
# update_flash -f /tmp/fwupdate/01SV810_133_081.img
````

*   6) The script will reboot the machine and update the firmware. Do not do anything, wait for the process to finish.
*   7) The system will eventually boot up. After using it with the new firmware, decide whether to move the image to permanent firmware memory (erasing the previous version).


To move from temporary to permanent memory: `update_flash -c`<br/>
To revert the temporary flash update: `update_flash -r`

## FakeKVM / faqemu

There are few issues with FakeKVM. Faqemu should work fine. TBD: fakearch to fix these.

## Final Goal

Allow users to use POWER8 in oVirt with only minimal differences to x86_64.
