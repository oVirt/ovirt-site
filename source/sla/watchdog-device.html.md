---
title: Watchdog Device
category: sla
authors: doron, sfeng
wiki_category: SLA
wiki_title: Sla/Watchdog Device
wiki_revision_count: 27
wiki_last_updated: 2013-03-05
---

# Watchdog Device

## Add an option to create a watchdog device.

## **VDSM side**

**1) support watchdog device**

A virtual hardware watchdog device can be added to the guest via the the "devices" configuration. And only one watchdog device is supported for each VM.

When a watchdog device is active and take action, the vdsm will log this event.

The watchdog device requires an additional driver and management daemon in the guest. Just enabling the watchdog in the vdsm "devices" configuration does not do anything useful on its own.

**model of watchdog:**

The required model attribute specifies what real watchdog device is emulated. Valid values are specific to the underlying hypervisor.

      'i6300esb'    default model, emulating a PCI Intel 6300ESB
      'ib700'       emulating an ISA iBase IB700

**action of watchdog timeout:**

The optional action attribute describes what action to take when the watchdog expires. Valid values are specific to the underlying hypervisor.

      'reset'          forcefully reset the guest 'shutdown' gracefully shutdown the guest (not recommended)
      'poweroff'       forcefully power off the guest
      'pause'          pause the guest
      'none'           default, do nothing
      'dump'           automatically dump the guest

The watchdog device can be used to detect guest crash or hang, and if 'dump' is chosen for the action of watchdog timeout, libvirt will dump guest's memory on timeout automatically. And the directory to save dump files can be configured by auto_dump_path in file /etc/libvirt/qemu.conf.

you can add the watchdog to the vm parameter when create a vm as follow:

      import vdscli
      s = vdscli.connect()
      # add a wathdog device parameter
      dev_list = [{'device': 'watchdog', 'type': 'watchdog', 'specParams': {'model': 'i6300esb', 'action': "none"}}
      s.create(dict(vmId=vmId,
                   drives=[dict(poolID=spUUID, domainID=sdUUID, imageID=imgUUID, volumeID=volUUID)],
                   memSize=256, display="vnc", vmName="vm1", devices = dev_list,)

**2) report the watchdog event**

## **Engine side**

**1) UI for user to add a watchdog device** **2) report the watchdog event to user**

<Category:SLA> <Category:Vdsm>
