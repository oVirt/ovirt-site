---
title: Vdsm datatypes
category: vdsm
authors: aglitke
wiki_title: Vdsm datatypes
wiki_revision_count: 32
wiki_last_updated: 2011-12-22
---

# Vdsm datatypes

| Type name    | Use                                                                           | Specification                                           |
|--------------|-------------------------------------------------------------------------------|---------------------------------------------------------|
| DriveSpec_t | Uniquely identifies a storage volume for use as a drive for a virtual machine | Standard UUID quartet: spUUID, sdUUID, imgUUID, volUUID 

                                                                                                **or**                                                   

                                                                                                Device mapper GUID                                       

                                                                                                **or**                                                   

                                                                                                blkid UUID                                               |
