---
title: Hosted Engine add hosts with Web UI
category: feature
authors: sandrobonazzola
feature_name: 'Hosted Engine: add hosts with Web UI'
feature_modules: all
feature_status: NEW
---

# Hosted Engine: add hosts with Web UI

## Summary

Allow to deploy additional hosts for Hosted Engine using Web UI

## Owner

*   Name: Sandro Bonazzola
*   Email: <sbonazzo@redhat.com>

## Detailed Description

*   ovirt-host-deploy must allow to deploy and configure ovirt-hosted-engine-ha daemons
*   ovirt-engine web UI must be changed for allowing the user to set an host as part of Hosted Engine HA cluster

## Benefit to oVirt

*   will simplify Hosted Engine deployment on additional hosts

## Dependencies / Related Features

*   Depends on [Features/Hosted_Engine_configuration_on_shared_storage](/develop/release-management/features/sla/hosted-engine-configuration-on-shared-storage.html)
*   A tracker bug has been created for tracking issues:hosted-engine-configuration-on-shared-storage

## Documentation / External references



## Testing

In order to test the ovirt host deploy part, the following content can be added to  '''/etc/ovirt-host-deploy.conf.d/hosted_engine.conf''' on the host, adapting it with the data from first host deployed:

      [environment:default]
      HOSTED_ENGINE/enable=bool:true
      HOSTED_ENGINE_CONFIG/fqdn=str:topolino.localdomain
      HOSTED_ENGINE_CONFIG/vm_disk_id=str:c00e477d-97bb-4cf9-95e0-a02232d84e26
      HOSTED_ENGINE_CONFIG/vm_disk_vol_id=str:859a498a-5e7b-4dc0-af59-4de015c562ee
      HOSTED_ENGINE_CONFIG/vmid=str:67f3f110-f076-4802-b9e2-077a537849f4
      HOSTED_ENGINE_CONFIG/storage=str:192.168.1.115:/Virtual/exthe7
      HOSTED_ENGINE_CONFIG/conf=str:/var/run/ovirt-hosted-engine-ha/vm.conf
      HOSTED_ENGINE_CONFIG/host_id=str:2
      HOSTED_ENGINE_CONFIG/console=str:vnc
      HOSTED_ENGINE_CONFIG/domainType=str:nfs4
      HOSTED_ENGINE_CONFIG/spUUID=str:029c8ec6-0bb3-4e02-a2e1-2f23be68fee3
      HOSTED_ENGINE_CONFIG/sdUUID=str:906222d7-7337-4b0b-b5fe-45073b1c9590
      HOSTED_ENGINE_CONFIG/connectionUUID=str:ec4ebf7a-54cc-4f8c-bcac-1c5653f74c51
      HOSTED_ENGINE_CONFIG/ca_cert=str:/etc/pki/vdsm/libvirt-spice/ca-cert.pem
      HOSTED_ENGINE_CONFIG/ca_subject=str:"O=localdomain, CN=c71ghe1.localdomain"
      HOSTED_ENGINE_CONFIG/vdsm_use_ssl=str:true
      HOSTED_ENGINE_CONFIG/gateway=str:192.168.1.1
      HOSTED_ENGINE_CONFIG/bridge=str:ovirtmgmt
      HOSTED_ENGINE_CONFIG/metadata_volume_UUID=str:c1e0abc2-b751-482f-8fe2-91d2ed3c1843
      HOSTED_ENGINE_CONFIG/metadata_image_UUID=str:29cc397b-f589-4968-9414-2ba1f9d0dcb1
      HOSTED_ENGINE_CONFIG/lockspace_volume_UUID=str:7f37194b-6143-4a5f-94d0-bda3e80433b2
      HOSTED_ENGINE_CONFIG/lockspace_image_UUID=str:4d729489-11b7-464c-b0e4-f463dc595f11
      HOSTED_ENGINE_CONFIG/conf_volume_UUID=str:2f15641b-f94a-4d13-962d-87f28048f537
      HOSTED_ENGINE_CONFIG/conf_image_UUID=str:5963872c-e756-47d8-ac41-30e837280cf2
      HOSTED_ENGINE_CONFIG/iqn=str:
      HOSTED_ENGINE_CONFIG/portal=str:
      HOSTED_ENGINE_CONFIG/user=str:
      HOSTED_ENGINE_CONFIG/password=str:
      HOSTED_ENGINE_CONFIG/port=str:


## Contingency Plan

*   The additional hosts will still be deployed by running hosted-engine --deploy and related patches will be reverted.

## Release Notes

      == Hosted Engine ==
      Hosted Engine additional hosts can now be deployed using the Web UI



