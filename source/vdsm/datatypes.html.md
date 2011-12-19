---
title: Vdsm datatypes
category: vdsm
authors: aglitke
wiki_title: Vdsm datatypes
wiki_revision_count: 32
wiki_last_updated: 2011-12-22
---

# Vdsm datatypes

vdsm uses various complex types throughout its API. Currently these are expressed as free-form dictionaries and/or strings with magic values. This wiki page attempts to capture a comprehensive list of these types for reference and to serve as a base for discussion on creating a more formalized specification of the types for the next generation API.

| Type name    | Use                                                                           | Specification                                           |
|--------------|-------------------------------------------------------------------------------|---------------------------------------------------------|
| DriveSpec_t | Uniquely identifies a storage volume for use as a drive for a virtual machine | Standard UUID quartet: spUUID, sdUUID, imgUUID, volUUID 

                                                                                                **or**                                                   

                                                                                                Device mapper GUID                                       

                                                                                                **or**                                                   

                                                                                                blkid UUID                                               |
