---
title: Hosted Engine configuration on shared storage
category: feature
authors:
  - sandrobonazzola
  - stirabos
---

# Hosted Engine configuration on shared storage

## Summary

Move Hosted Engine configuration to shared storage

## Owner

*   Name: [Sandro Bonazzola](https://github.com/sandrobonazzola)
*   Email: <sbonazzo@redhat.com>

## Detailed Description

*   Create an additional volume on the shared storage; directly write a tar file over that (as we do for the OVF_STORE)
*   Move the initial VM configuration from vm.conf to the additional volume on shared storage
*   The engine VM configuration could be edited from the engine itself, the engine will save it in the OVF_STORE. So if present the agent will read the most recent configuration from the OVF_STORE, if not it will fall back to the original configuration on the shared volume
*   Move broker.conf (with the notification configuration) to shared storage; a fall-back copy should be keep on the local storage to be able to send notifications also when the shared storage is down
*   An upgrade path must move the existing configuration to shared storage
*   To ensure that the engine VM will preferably run on a 3.6 hosts, 3.6 hosts will have an higher maximum score

## Benefit to oVirt

*   Will allow to deploy additional hosts from Web UI more easily cause the configuration is already on the shared storage for all the hosts
*   Will allow to avoid to manually copy configuration changes to all the host in the hosted engine cluster making possible to simply edit the configuration from the web UI

## Dependencies / Related Features

*   ovirt-hosted-engine-setup and ovirt-hosted-engine-ha must be adapted to the new configuration location
*   A tracker bug has been created for tracking issues:

## Documentation / External references

None

## Testing

the configuration should be migrated to the shared storage. You can check it this way:

      sdUUID_line=$(grep sdUUID /etc/ovirt-hosted-engine/hosted-engine.conf)
      sdUUID=${sdUUID_line:7:36}
      conf_volume_UUID_line=$(grep conf_volume_UUID /etc/ovirt-hosted-engine/hosted-engine.conf)
      conf_volume_UUID=${conf_volume_UUID_line:17:36}
      conf_image_UUID_line=$(grep conf_image_UUID /etc/ovirt-hosted-engine/hosted-engine.conf)
      conf_image_UUID=${conf_image_UUID_line:16:36}
      dd if=/rhev/data-center/mnt/192.168.1.115:_Virtual_ext35u36/$sdUUID/images/$conf_image_UUID/$conf_volume_UUID 2>/dev/null| tar -xOf - vm.conf

please substitute '192.168.1.115:_Virtual_ext35u36' with your mount point. It should extract your vm.conf

## Contingency Plan

*   The configuration will still remain on the hosts and related patches will be reverted.

## Release Notes

Hosted-engine VM configuration is now saved on the shared storage to enable subsequent features.

      == Hosted Engine ==
      Hosted Engine configuration has been moved to its shared storage allowing to centralize any configuration change without the need of manually copy the configuration to all the hosts in its cluster.




