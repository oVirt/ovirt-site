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

| Type name     | Use                                                                           | Specification                                                                                                        |
|---------------|-------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------|
| DriveSpec_t  | Uniquely identifies a storage volume for use as a drive for a virtual machine | { spUUID, sdUUID, imgUUID, volUUID } #Standard UUID quartet                                                          

                                                                                                 **or**                                                                                                                

                                                                                                     { GUID } # Device mapper GUID                                                                                     

                                                                                                 **or**                                                                                                                

                                                                                                     { UUID } # blkid-based UUID                                                                                       |
| VM_Create_t | Contains all parameters needed to create a new virtual machine                | {                                                                                                                    
                                                                                                       'hiberVolHandle' # The volume UUID containing hibernation data (if present)                                     
                                                                                                                        # A comma-separated list: sdUUID,spUUID,stateImageID,stateVolumeID,paramImageID,paramVolumeID  
                                                                                                       'restoreState' # A volume containing migration restore data. DriveSpec_t                                        
                                                                                                       'memSize' # The desired amount of memory (in megabytes)                                                         
                                                                                                       'display' # The type of display.  String: 'qxl', 'vnc', 'qxlnc', 'local'                                        
                                                                                                       'boot' # The desired boot device. String: 'a', 'c', 'd', 'n'                                                    
                                                                                                       'vmType' # The type of VM to create.  String: 'kvm'                                                             
                                                                                                       'floppy' # Set the floppy disk volume. DriveSpec_t                                                              
                                                                                                       'cdrom' # Set the cdrom volume. DriveSpec_t                                                                     
                                                                                                       'sysprepInf'                                                                                                    
                                                                                                       'nicModel'                                                                                                      
                                                                                                       'recover'                                                                                                       
                                                                                                       'smp'                                                                                                           
                                                                                                       'drives'                                                                                                        

                                                                                                     }                                                                                                                 |
