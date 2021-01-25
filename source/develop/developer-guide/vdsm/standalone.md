---
title: Vdsm Standalone
category: vdsm
authors: danken, dpkshetty
---

# Vdsm Standalone

Vdsm was designed to be driven by oVirt-engine and be its humble server. However, it can be used on its own right. Here there is a crude example on how Vdsm can be used to create and run a virtual machine backed on local storage. In order to use it, you should first have to install vdsm and vdsm-cli, and create a directoy to be used by it for storing VM images and metadata.

      #!/usr/bin/python
      # GPLv2+
      import sys
      import uuid
      import time
      sys.path.append('/usr/share/vdsm')
      import vdscli
      from storage.sd import LOCALFS_DOMAIN, DATA_DOMAIN
      from storage.volume import COW_FORMAT, SPARSE_VOL, LEAF_VOL, BLANK_UUID
      spUUID = str(uuid.uuid4())
      sdUUID = str(uuid.uuid4())
      imgUUID = str(uuid.uuid4())
      volUUID = str(uuid.uuid4())
      # you should manually create the following directory and
      # chown vdsm:kvm /tmp/localstoragedomain
      path = "/tmp/localstoragedomain"
      s = vdscli.connect()
      masterVersion = 1
      hostID = 1
      def vdsOK(d):
          print d
          if d['status']['code']:
         raise Exception(str(d))
          return d
      def waitTask(s, taskid):
          while vdsOK(s.getTaskStatus(taskid))['taskStatus']['taskState'] != 'finished':
              time.sleep(3)
          vdsOK(s.clearTask(taskid))
      vdsOK(s.connectStorageServer(LOCALFS_DOMAIN, "my favorite pet", [dict(id=1, connection=path)]))
      vdsOK(s.createStorageDomain(LOCALFS_DOMAIN, sdUUID, "my local domain", path, DATA_DOMAIN, 0))
      vdsOK(s.createStoragePool(LOCALFS_DOMAIN, spUUID, "pool name", sdUUID, [sdUUID], masterVersion))
      # connect to an existing pool, and become pool manager.
      vdsOK(s.connectStoragePool(spUUID, hostID, "scsikey", sdUUID, masterVersion))
      tid = vdsOK(s.spmStart(spUUID, -1, -1, -1, 0))['uuid']
      waitTask(s, tid)
      sizeGiB = 100
      tid = vdsOK(s.createVolume(sdUUID, spUUID, imgUUID, sizeGiB,
                                 COW_FORMAT, SPARSE_VOL, LEAF_VOL,
                                 volUUID, "volly",
                                 BLANK_UUID, BLANK_UUID))['uuid']
      waitTask(s, tid)
      vmId = str(uuid.uuid4())
      vdsOK(
          s.create(dict(vmId=vmId,
                        drives=[dict(poolID=spUUID, domainID=sdUUID, imageID=imgUUID, volumeID=volUUID)],
                        memSize=256,
               display="vnc",
                        vmName="vm1",
                       )
                  )
      )

The below example shows how glusterfs can be used as a DATA_DOMAIN by exploiting the SHAREDFS interface in Vdsm.

*   Pre-req:
    1.  latest kernel having O_DIRECT support for fuse is needed to be running on the host.
    2.  gluster volume must be pre-setup. In the below example assuming hostname as server.example.com, myvol is the name of the gluster volume that must be pre-created and started using gluster commands.

`

 #!/usr/bin/python
 # GPLv2+

 import sys
 import uuid
 import time

 sys.path.append('/usr/share/vdsm')

 import vdscli
 from storage.sd import SHAREDFS_DOMAIN, DATA_DOMAIN, ISO_DOMAIN
 from storage.volume import COW_FORMAT, SPARSE_VOL, LEAF_VOL, BLANK_UUID

 spUUID = str(uuid.uuid4())
 sdUUID = str(uuid.uuid4())
 imgUUID = str(uuid.uuid4())
 volUUID = str(uuid.uuid4())

 gluster_conn = "server.example.com:myvol"

 s = vdscli.connect()

 masterVersion = 1
 hostID = 1

 def vdsOK(d):
     print d
     if d['status']['code']:
         raise Exception(str(d))
     return d

 def waitTask(s, taskid):
     while vdsOK(s.getTaskStatus(taskid))['taskStatus']['taskState'] != 'finished':
         time.sleep(3)
     vdsOK(s.clearTask(taskid))

 vdsOK(s.connectStorageServer(SHAREDFS_DOMAIN, "my gluster mount", [dict(id=1, spec=gluster_conn, vfs_type="glusterfs", mnt_options="")]))

 vdsOK(s.createStorageDomain(SHAREDFS_DOMAIN, sdUUID, "my gluster domain", gluster_conn, DATA_DOMAIN, 0))

 vdsOK(s.createStoragePool(SHAREDFS_DOMAIN, spUUID, "my gluster pool", sdUUID, [sdUUID], masterVersion))

 # connect to an existing pool, and become pool manager.
 vdsOK(s.connectStoragePool(spUUID, hostID, "scsikey", sdUUID, masterVersion))
 tid = vdsOK(s.spmStart(spUUID, -1, -1, -1, 0))['uuid']
 waitTask(s, tid)

 sizeGiB = 100

 tid = vdsOK(s.createVolume(sdUUID, spUUID, imgUUID, sizeGiB,
                            COW_FORMAT, SPARSE_VOL, LEAF_VOL,
                            volUUID, "glustervol",
                            BLANK_UUID, BLANK_UUID))['uuid']
 waitTask(s, tid)

 vmId = str(uuid.uuid4())

 vdsOK(
     s.create(dict(vmId=vmId,
                   drives=[dict(poolID=spUUID, domainID=sdUUID, imageID=imgUUID, volumeID=volUUID)],
                   memSize=256,
                   display="vnc",
                   vmName="vm-backed-by-gluster",
                  )
             )
 )

`

