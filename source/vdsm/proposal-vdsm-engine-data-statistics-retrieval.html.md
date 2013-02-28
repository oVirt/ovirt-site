---
title: Proposal VDSM - Engine Data Statistics Retrieval
category: vdsm
authors: danken, vfeenstr
wiki_title: Proposal VDSM - Engine Data Statistics Retrieval
wiki_revision_count: 9
wiki_last_updated: 2013-07-08
---

# Proposal VDSM - Engine Data Statistics Retrieval

== VDSM <=> Engine data retrieval optimization ==

### Motivation:

Currently the RHEVM engine is polling the a lot of data from VDSM every 15 seconds. This should be optimized and the amount of data requested should be more specific.

For each VM the data currently contains much more information than actually needed which blows up the size of the XML content quite big. We could optimize this by splitting the reply on the getVmStats based on the request of the engine into sections. For this reason Omer Frenkel and me have split up the data into parts based on their usage. Constant:

This data should never change during the life of a VM and therefore it can be considered constant.

         acpiEnable = true
         vmType = kvm
         guestName = W864GUESTAGENTT
         displayType = qxl
         guestOs = Win 8
         kvmEnable = true

### Dynamic:

This data can and usually does change during the lifetime of the VM.

#### Rarely Changed:

This data is change not very frequent and it should be enough to update this only once in a while. Most commonly this data changes after changes made in the UI or after a migration of the VM to another Host.

             Status = Running
             pauseCode = NOERR
             monitorResponse = 0
             session = Locked # unused
             netIfaces = [{'name': 'Realtek RTL8139C+ Fast Ethernet NIC', 'inet6':                                        ['fe80::490c:92bb:bbcc:9f87'], 'inet': ['10.34.60.148'], 'hw': '00:1a:4a:22:3c:db'}]
             appsList = ['RHEV-Tools 3.2.4', 'RHEV-Agent64 3.2.3', 'RHEV-Serial64 3.2.3', 'RHEV-                     Network64 3.2.2', 'RHEV-Network64 3.2.3', 'RHEV-Block64 3.2.3', 'RHEV-                  Balloon64 3.2.3', 'RHEV-Balloon64 3.2.2', 'RHEV-Agent64 3.2.2', 'RHEV-USB                   3.2.3', 'RHEV-Block64 3.2.2', 'RHEV-Serial64 3.2.2']
         
             pid = 11314
             guestIPs = 10.34.60.148 # duplicated info 
         
             displayIp = 0
             displayPort = 5902
             displaySecurePort = 5903

#### Often Changed:

This data is changed quite often however it is not necessary to update this data every 15 seconds. As this is cumulative data and reflects the current status, and it does not need to be snapshotted every 15 seconds to retrieve statistics. The data can be retrieved in much more generous time slices. (e.g. Every 5 minutes)

         network = {'vnet1': {'macAddr': '00:1a:4a:22:3c:db', 'rxDropped': '0', 'txDropped': '0', 'rxErrors': '0', 'txRate': '0.0', 'rxRate': '0.0', 'txErrors': '0', 'state': 'unknown', 'speed': '100', 'name': 'vnet1'}}
         disksUsage = [{'path': 'c:\', 'total': '64055406592', 'fs': 'NTFS', 'used': '19223846912'}, {'path': 'd:\', 'total': '3490912256', 'fs': 'UDF', 'used': '3490912256'}]
         
         # Unused
         This data does not seem to be used in the engine at all. It might be used in the data warehouse     though.
         
         memoryStats = {'swap_out': '0', 'majflt': '0', 'mem_free': '1466884', 'swap_in': '0', 'pageflt': '0', 'mem_total': '2096736', 'mem_unused': '1466884'} 
         balloonInfo = {'balloon_max': 2097152, 'balloon_cur': 2097152}
         
         disks = {'vda': {'readLatency': '0', 'apparentsize': '64424509440', 'writeLatency': '1754496',  'imageID': '28abb923-7b89-4638-84f8-1700f0b76482', 'flushLatency': '156549',  'readRate': '0.00', 'truesize': '18855059456', 'writeRate': '952.05'}, 'hdc': {'readLatency': '0', 'apparentsize': '0', 'writeLatency': '0', 'flushLatency': '0', 'readRate': '0.00', 'truesize': '0', 'writeRate': '0.00'}}

#### Very frequent uppdates needed by webadmin portal:

This data is mostly needed for the webadmin portal and might be required to be updated quite often. An exception here is the statsAge field, which seems to be unused by the Engine. This data could be requested every 15 seconds to keep things as they are now.

         timeOffset = 14422
         elapsedTime = 68591
         hash = 2335461227228498964
         statsAge = 0.09 # unused
         
         cpuSys = 2.32
         cpuUser = 1.34
         memUsage = 30
         
         username = user@W864GUESTAGENTT
         clientIp = 
         lastLogin = 1361976900.67

## Proposed Solution for VDSM & Engine:

We will introduce a new optional parameter to getVmStats and getAllVmStats to allow a finer grained specification of data which should be included.

**Parameter:** **statsType**=***<string>*** **Allowed values:**

*   full (default to keep backwards compatibility)
*   app-list (Just send the application list)
*   rare (include everything from rarely changed to very frequent)
*   often (include everything from often changed to very frequent)
*   frequent (only send the very frequently changed items)

### Additional Change:

Besides the introduction of the new parameter for getVmStats and getAllVmStats it might make sense to include a hash for the appList into the rarely changed section of the response which would allow to identify changes and avoid having to sent the complete appList every so often and only if the hash known to the client is outdated.

Note: The appList (Application List) reported by the guest agent could be fully implemented on request only, as long as the guest agent installed supports this. As there seems to be a request to have the complete list of installed applications on all guests this data could be quite extensive and a huge list. On the other hand this data is only rarely visible and therefore it should not be requested all the time and only on demand.

### Improvement of the Guest Agent:

As part of the proposed solution it is necessary to improve the guest agent as well. For the full application list there should be implemented a caching system which will be fully reactive and should not poll the application list for example all the time. The guest can create a prepared data file containing all data in the JSON format (as used for the communication with VDSM via VIO) and just have to read that file from disk and directly sends it to VDSM. However it is quite possible that this list is to big and it might have to be chunked into pieces. (Multiple messages, which would have to be supported by VDSM then as well) The solution for this is to make VDSM request this data and it will retrieve the data necessary on request only.
