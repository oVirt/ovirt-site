---
title: Self Hosted Engine iSCSI Support
category: feature
authors: doron, jmoskovc, sandrobonazzola
feature_name: Self Hosted Engine iSCSI Support
feature_modules: ovirt-hosted-engine-setup,ovirt-hosted-engine-ha
feature_status: Completed
---

# Self Hosted Engine iSCSI Support

## Summary

This feature enable the user to use iSCSI storage for Hosted Engine data domain.

## Owner

*   Installation: [Sandro Bonazzola](https://github.com/sandrobonazzola) e-mail: <sbonazzo@redhat.com>
*   HA agent: Jiri Moskovcak (jmoskovc) e-mail: <jmoskovc@redhat.com>

## Current status

*   Status: Completed
*   Last updated on -- by (WIKI)

## Detailed Description

### UX changes

Current:

               --== STORAGE CONFIGURATION ==--
              
               During customization use CTRL-D to abort.
               Please specify the storage you would like to use (nfs3, nfs4)[nfs3]:

Will become:

               --== STORAGE CONFIGURATION ==--
              
               During customization use CTRL-D to abort.
               Please specify the storage you would like to use (iscsi, nfs3, nfs4)[nfs3]:

if iscsi will be selected:

               Please specify the iSCSI portal IP address:
               Please specify the iSCSI portal port [3260]: 
               Please specify the iSCSI portal user:
               Please specify the iSCSI portal password:
               Please specify the target name (values) [default]:

The target name list can be obtained by the portal and a default can be set if only one is found or just the first of the list

### Config files changes

*   hosted-engine.conf may need to store some of the above iSCSI portal / target parameters
*   answer file will need to store answers for all of the above questions except for portal password

### VDSM commands involved

If device is not already attached / known:

      discoverSendTargets(con={'connection': '192.168.1.105', 'password': '******', 'port': '3260', 'user': ''}, options=None)
      discoverSendTargets, Return response: {'fullTargets': ['192.168.1.105:3260,1 iqn.2009-02.com.example:for.all'], 'targets': ['iqn.2009-02.com.example:for.all']}
      connectStorageServer(domType=3, spUUID='00000000-0000-0000-0000-000000000000', conList=[{'connection': '192.168.1.105', 'iqn': 'iqn.2009-02.com.example:for.all', 'portal': '0', 'user': '', 'password': '******', 'id': '00000000-0000-0000-0000-000000000000', 'port': '3260'}], options=None)
      connectStorageServer, Return response: {'statuslist': [{'status': 0, 'id': '00000000-0000-0000-0000-000000000000'}]}
      getDeviceList(storageType=3, options={})
      getDeviceList, Return response: {'devList': [{'status': 'free', 'vendorID': 'IET', 'capacity': '31457280000', 'fwrev': '0001', 'vgUUID': '', 'pathlist': [{'initiatorname': 'default', 'connection': '192.168.1.105', 'iqn': 'iqn.2009-02.com.example:for.all', 'portal': '1', 'password': '******', 'port': '3260'}], 'logicalblocksize': '512', 'pathstatus': [{'physdev': 'sdb', 'type': 'iSCSI', 'state': 'active', 'lun': '1'}], 'devtype': 'iSCSI', 'physicalblocksize': '4096', 'pvUUID': '', 'serial': 'SIET_VIRTUAL-DISK', 'GUID': '33000000100000001', 'productID': 'VIRTUAL-DISK'}]}
      repoStats(options=None)
      repoStats, Return response: {}
      createVG(vgname='c2584832-b153-4653-8406-563938021849', devlist=['33000000100000001'], force=False, options=None)
      createVG, Return response: {'uuid': 'kBndaS-Or6z-v25k-Kq8e-Dfk2-sExp-CejaBF'}
      createStorageDomain(storageType=3, sdUUID='c2584832-b153-4653-8406-563938021849', domainName='iscsi', typeSpecificArg='kBndaS-Or6z-v25k-Kq8e-Dfk2-sExp-CejaBF', domClass=1, domVersion='3', options=None)
      createStorageDomain, Return response: None
      getStorageDomainStats(sdUUID='c2584832-b153-4653-8406-563938021849', options=None)
      getStorageDomainStats, Return response: {'stats': {'mdasize': '134217728', 'mdathreshold': False, 'mdavalid': True, 'diskfree': '26977763328', 'disktotal': '31138512896', 'mdafree': '0'}}
      getVGInfo(vgUUID='kBndaS-Or6z-v25k-Kq8e-Dfk2-sExp-CejaBF', options=None)
      getVGInfo, Return response: {'info': {'state': 'OK', 'vgsize': '31138512896', 'name': 'c2584832-b153-4653-8406-563938021849', 'vgfree': '26977763328', 'vgUUID': 'kBndaS-Or6z-v25k-Kq8e-Dfk2-sExp-CejaBF', 'pvlist': [{'vendorID': 'IET', 'capacity': '31138512896', 'fwrev': '0000', 'vgUUID': 'kBndaS-Or6z-v25k-Kq8e-Dfk2-sExp-CejaBF', 'pathlist': [{'connection': '192.168.1.105', 'iqn': 'iqn.2009-02.com.example:for.all', 'portal': '1', 'port': '3260', 'initiatorname': 'default'}], 'pathstatus': [{'physdev': 'sdb', 'type': 'iSCSI', 'state': 'active', 'lun': '1'}], 'devtype': 'iSCSI', 'pvUUID': 'XsT0GW-NfZ4-jomf-SfWy-7feS-IvmJ-uzA1tK', 'serial': 'SIET_VIRTUAL-DISK', 'GUID': '33000000100000001', 'devcapacity': '31457280000', 'productID': 'VIRTUAL-DISK'}], 'type': 3, 'attr': {'allocation': 'n', 'partial': '-', 'exported': '-', 'permission': 'w', 'clustered': '-', 'resizeable': 'z'}}}
      connectStorageServer(domType=3, spUUID='9bfe34ee-444c-4171-a69b-4b99da61ea39', conList=[{'connection': '192.168.1.105', 'iqn': 'iqn.2009-02.com.example:for.all', 'portal': '1', 'user': '', 'password': '******', 'id': '40362546-4363-40e8-ae9d-29f519a94573', 'port': '3260'}], options=None)
      connectStorageServer, Return response: {'statuslist': [{'status': 465, 'id': '40362546-4363-40e8-ae9d-29f519a94573'}]}
      createStoragePool(poolType=None, spUUID='9bfe34ee-444c-4171-a69b-4b99da61ea39', poolName='iscsi', masterDom='c2584832-b153-4653-8406-563938021849', domList=['c2584832-b153-4653-8406-563938021849'], masterVersion=1, lockPolicy=None, lockRenewalIntervalSec=5, leaseTimeSec=60, ioOpTimeoutSec=10, leaseRetries=3, options=None)

If device is already attached / known

      getDeviceList(storageType=3, options={})
      getDeviceList, Return response: {'devList': [{'status': 'free', 'vendorID': 'IET', 'capacity': '33554432000', 'fwrev': '0001', 'vgUUID': '', 'pathlist': [{'initiatorname': 'default', 'connection': '192.168.1.105', 'iqn': 'iqn.2009-02.com.example:for.all', 'portal': '1', 'password': '******', 'port': '3260'}], 'logicalblocksize': '512', 'pathstatus': [{'physdev': 'sdb', 'type': 'iSCSI', 'state': 'active', 'lun': '1'}], 'devtype': 'iSCSI', 'physicalblocksize': '512', 'pvUUID': '', 'serial': 'SIET_VIRTUAL-DISK', 'GUID': '1IET_00010001', 'productID': 'VIRTUAL-DISK'}]}
      createVG(vgname='139ce2bb-e1dc-4757-add6-37ce8f410c4a', devlist=['1IET_00010001'], force=False, options=None)
      createVG, Return response: {'uuid': 'hDcdS7-MkjM-oXm3-yP8M-KmqM-glYC-c9YoLw'}
      createStorageDomain(storageType=3, sdUUID='139ce2bb-e1dc-4757-add6-37ce8f410c4a', domainName='virtiscsi', typeSpecificArg='hDcdS7-MkjM-oXm3-yP8M-KmqM-glYC-c9YoLw', domClass=1, domVersion='3', options=None)
      createStorageDomain, Return response: None
      getStorageDomainStats(sdUUID='139ce2bb-e1dc-4757-add6-37ce8f410c4a', options=None)
      getStorageDomainStats, Return response: {'stats': {'mdasize': '134217728', 'mdathreshold': True, 'mdavalid': True, 'diskfree': '28991029248', 'disktotal': '33151778816', 'mdafree': '67104768'}}
      getVGInfo(vgUUID='hDcdS7-MkjM-oXm3-yP8M-KmqM-glYC-c9YoLw', options=None)
      getVGInfo, Return response: {'info': {'state': 'OK', 'vgsize': '33151778816', 'name': '139ce2bb-e1dc-4757-add6-37ce8f410c4a', 'vgfree': '28991029248', 'vgUUID': 'hDcdS7-MkjM-oXm3-yP8M-KmqM-glYC-c9YoLw', 'pvlist': [{'vendorID': 'IET', 'capacity': '33151778816', 'fwrev': '0000', 'vgUUID': 'hDcdS7-MkjM-oXm3-yP8M-KmqM-glYC-c9YoLw', 'pathlist': [{'connection': '192.168.1.105', 'iqn': 'iqn.2009-02.com.example:for.all', 'portal': '1', 'port': '3260', 'initiatorname': 'default'}], 'pathstatus': [{'physdev': 'sdb', 'type': 'iSCSI', 'state': 'active', 'lun': '1'}], 'devtype': 'iSCSI', 'pvUUID': '9wnpis-e9qR-8yTx-SqcV-dqC1-tzCy-Yzc4Ug', 'serial': 'SIET_VIRTUAL-DISK', 'GUID': '1IET_00010001', 'devcapacity': '33554432000', 'productID': 'VIRTUAL-DISK'}], 'type': 3, 'attr': {'allocation': 'n', 'partial': '-', 'exported': '-', 'permission': 'w', 'clustered': '-', 'resizeable': 'z'}}}
      connectStorageServer(domType=3, spUUID='00000002-0002-0002-0002-000000000251', conList=[{'connection': '192.168.1.105', 'iqn': 'iqn.2009-02.com.example:for.all', 'portal': '1', 'user': '', 'password': '******', 'id': 'febf9441-2745-456b-8362-87186a341258', 'port': '3260'}], options=None)
      connectStorageServer, Return response: {'statuslist': [{'status': 0, 'id': 'febf9441-2745-456b-8362-87186a341258'}]}
      getVGInfo(vgUUID='hDcdS7-MkjM-oXm3-yP8M-KmqM-glYC-c9YoLw', options=None)
      getVGInfo, Return response: {'info': {'state': 'OK', 'vgsize': '33151778816', 'name': '139ce2bb-e1dc-4757-add6-37ce8f410c4a', 'vgfree': '28991029248', 'vgUUID': 'hDcdS7-MkjM-oXm3-yP8M-KmqM-glYC-c9YoLw', 'pvlist': [{'vendorID': 'IET', 'capacity': '33151778816', 'fwrev': '0000', 'vgUUID': 'hDcdS7-MkjM-oXm3-yP8M-KmqM-glYC-c9YoLw', 'pathlist': [{'connection': '192.168.1.105', 'iqn': 'iqn.2009-02.com.example:for.all', 'portal': '1', 'port': '3260', 'initiatorname': 'default'}], 'pathstatus': [{'physdev': 'sdb', 'type': 'iSCSI', 'state': 'active', 'lun': '1'}], 'devtype': 'iSCSI', 'pvUUID': '9wnpis-e9qR-8yTx-SqcV-dqC1-tzCy-Yzc4Ug', 'serial': 'SIET_VIRTUAL-DISK', 'GUID': '1IET_00010001', 'devcapacity': '33554432000', 'productID': 'VIRTUAL-DISK'}], 'type': 3, 'attr': {'allocation': 'n', 'partial': '-', 'exported': '-', 'permission': 'w', 'clustered': '-', 'resizeable': 'z'}}}
      createStoragePool(poolType=None, spUUID='00000002-0002-0002-0002-000000000251', poolName='Default', masterDom='139ce2bb-e1dc-4757-add6-37ce8f410c4a', domList=['139ce2bb-e1dc-4757-add6-37ce8f410c4a'], masterVersion=1, lockPolicy=None, lockRenewalIntervalSec=5, leaseTimeSec=60, ioOpTimeoutSec=10, leaseRetries=3, options=None)
      createStoragePool, Return response: True
      connectStorageServer(domType=3, spUUID='00000002-0002-0002-0002-000000000251', conList=[{'connection': '192.168.1.105', 'iqn': 'iqn.2009-02.com.example:for.all', 'portal': '1', 'user': '', 'password': '******', 'id': 'febf9441-2745-456b-8362-87186a341258', 'port': '3260'}], options=None)
      connectStorageServer, Return response: {'statuslist': [{'status': 0, 'id': 'febf9441-2745-456b-8362-87186a341258'}]}
      getVGInfo(vgUUID='hDcdS7-MkjM-oXm3-yP8M-KmqM-glYC-c9YoLw', options=None)
      getVGInfo, Return response: {'info': {'state': 'OK', 'vgsize': '33151778816', 'name': '139ce2bb-e1dc-4757-add6-37ce8f410c4a', 'vgfree': '28991029248', 'vgUUID': 'hDcdS7-MkjM-oXm3-yP8M-KmqM-glYC-c9YoLw', 'pvlist': [{'vendorID': 'IET', 'capacity': '33151778816', 'fwrev': '0000', 'vgUUID': 'hDcdS7-MkjM-oXm3-yP8M-KmqM-glYC-c9YoLw', 'pathlist': [{'connection': '192.168.1.105', 'iqn': 'iqn.2009-02.com.example:for.all', 'portal': '1', 'port': '3260', 'initiatorname': 'default'}], 'pathstatus': [{'physdev': 'sdb', 'type': 'iSCSI', 'state': 'active', 'lun': '1'}], 'devtype': 'iSCSI', 'pvUUID': '9wnpis-e9qR-8yTx-SqcV-dqC1-tzCy-Yzc4Ug', 'serial': 'SIET_VIRTUAL-DISK', 'GUID': '1IET_00010001', 'devcapacity': '33554432000', 'productID': 'VIRTUAL-DISK'}], 'type': 3, 'attr': {'allocation': 'n', 'partial': '-', 'exported': '-', 'permission': 'w', 'clustered': '-', 'resizeable': 'z'}}}
      connectStoragePool(spUUID='00000002-0002-0002-0002-000000000251', hostID=1, msdUUID='139ce2bb-e1dc-4757-add6-37ce8f410c4a', masterVersion=1, domainsMap=None, options=None)
      connectStoragePool, Return response: True
      spmStart(spUUID='00000002-0002-0002-0002-000000000251', prevID=-1, prevLVER='-1', maxHostID=250, domVersion='3', options=None)
      spmStart, Return response: None
      clearTask(taskID='3ab8e451-e819-4c6c-8921-efaa66ecea9b', spUUID=None, options=None)
      clearTask, Return response: None
      activateStorageDomain(sdUUID='139ce2bb-e1dc-4757-add6-37ce8f410c4a', spUUID='00000002-0002-0002-0002-000000000251', options=None)
      activateStorageDomain, Return response: None
      connectStoragePool(spUUID='00000002-0002-0002-0002-000000000251', hostID=1, msdUUID='139ce2bb-e1dc-4757-add6-37ce8f410c4a', masterVersion=1, domainsMap=None, options=None)
      connectStoragePool, Return response: True

## Benefit to oVirt

Users will be able to use iSCSI storage as data domain for Hosted Engine.

## Dependencies / Related Features

*   ovirt-hosted-engine-ha provides a new class **FilesystemBackend** which provides the API for all the storage actions specific for the hosted engine
*   the existing setup code has been ported to use this API

## Documentation / External references

*   scsi-target-utils configuration:
    -   <https://fedoraproject.org/wiki/Scsi-target-utils_Quickstart_Guide>
    -   <https://fedorahosted.org/ovirt/wiki/ISCSISetup>
    -   <https://bugzilla.redhat.com/show_bug.cgi?id=738239>
    -   <http://www.linuxjournal.com/content/creating-software-backed-iscsi-targets-red-hat-enterprise-linux-6>

### Test Cases

*   [QA:TestCase Hosted Engine iSCSI Multiple LUN Support](/develop/infra/testing/test-cases/hosted-engine-iscsi-multiple-lun-support.html)



[Self Hosted Engine iSCSI Support](/develop/release-management/features/) [Self Hosted Engine iSCSI Support](/develop/release-management/releases/3.5/feature.html) [Self Hosted Engine iSCSI Support](Category:Integration)
