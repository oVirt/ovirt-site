---
title: hosted-engine-edit-configuration-on-shared-storage
category: feature
authors: jtokar
---

# Allow updating Hosted Engine configuration on shared storage

## Summary
Currently the hosted engine configuration is saved in a tar archive on a shared storage without any way of editing or updating it. This will allow users to easily update and get the shared configuration. 

Currently there are two configuration archives on the shared storage, one contains the vm ovf and the other contains the hosted engine configuration.
For the first stage this feature will provide the ability to edit broker.conf (that is located inside the configuration archive), for the second stage support for editing parts of the vm ovf will be added.

## Detailed Description
To achieve this new functionalities will be added to the hosted engine client:

### Already implemented:
 1. Set a new value
 2. Get the current value for a specific key
 
### Future functionality:
 1. Get a list of all keys and their current value
 2. Download a configuration archive
 3. Upload a configuration archive

### Handling keys collisions:
Since there are two (and some day maybe more) editable files, the get and set methods will receive an optional argument: “type”.
This argument can be one of two options:

1.  broker
2.  vm

Currently only broker is supported.

In case of a collision the methods will return an error message with a request to use the desired type: “Duplicate key, please specify the key type.”


### Handling synchronization on the shared storage - optimistic locking:
To avoid sync issues, before updating the archive, an md5 checksum will be calculated. A new archive will be created, and after that if the checksum of the original archive remained the same, the new archive will be moved instead of the old one.
In case the checksum is different an error will be returned: “Update failed. The configuration file was changed by somebody else, try again.“


### Editable keys for the first stage:
Broker.conf:

 1.  smtp-server
 2.  smtp-port
 3.  source-email
 4.  destination-emails
 5.  state_transition

## Usage examples:

### For non duplicate keys:
      hosted-engine --set-shared-config key value
      sets the value, returns nothing

      hosted-engine --set-shared-config key value --type broker
      sets the value, returns nothing
  
      hosted-engine --get-shared-config key
      returns: key: value type

      hosted-engine --get-shared-config key --type broker
      returns: key:  value type

### For duplicate keys:
      hosted-engine --set-shared-config key value
      returns an error: Duplicate key, please specify the key type.

      hosted-engine --set-shared-config key value --type broker
      sets the value, returns nothing

      hosted-engine --get-shared-config key
      returns an error: Duplicate key, please specify the key type.

      hosted-engine --get-shared-config key --type broker
      returns: key:  value type

### For missing keys:
      hosted-engine --set-shared-config missing_key --type=broker
      returns an error:
      Invalid configuration key missing_key.
      Available keys are:
      broker : ['smtp-port', 'destination-emails', 'smtp-server', 'source-email', 'state_transition']
      
      hosted-engine --set-shared-config missing_key
      returns an error:
      Invalid configuration key missing_key.
      Available keys are:
      broker : ['smtp-port', 'destination-emails', 'smtp-server', 'source-email', 'state_transition']
      
      hosted-engine --get-shared-config key --type=missing_type
      returns an error:
      Invalid configuration type missing_type, supported types are: broker

### In case the archive was changed during update:
      hosted-engine --set-shared-config key value
      returns an error: Update failed. The configuration file was changed by somebody else, try again.

### To get all keys and values (not yet implemented):
        hosted-engine --get-all-config
        returns:
          type: broker  
          key: value
          key2: value

## Detailed Design

### ovirt-hosted-engine-ha

#### Client.py

1. Add a new method: set_config(key,value), the method will get a key and value that the user wants to update.
2. Add a new method get_config(), the method will return the current configuration for the editable files (currently broker.conf).

#### Config.py

1. Add a new set of sharedStorageFiles that will contain the names of the editable files that are stored in the shared storage archive
2. Add a new dictionary: {type -> {key -> fileName}}
3. Load the dictionary in the init method:
  Iterate over the editable files (defined in the sharedStorageFiles set), extract the keys and the files’ names.
4. Add a new method setSharedConfig that will use the methods that already exist in  heconflib.py:
 1. Verify the file is editable.
 2. Load the configuration archive, get the md5 checksum.
 3. Locate the needed file according to the files names dictionary:
 4. If type is provided, extract the file from the dictionary
 5. If type is not provided, go over the dictionaries and extract the file name,
 6. If there is a collision raise an exception
 7. Extract the needed file and update as needed.
 8. Create a temporary configuration archive.
 9. Load the configuration archive again, verify  the md5 checksum hasn’t changed. If it was changed raise an error to the user. If not rename the temp archive to the real name.
5. Add a new method getConfig that will use the methods that already exist in  heconflib.py, and will return the current shared configuration.

### ovirt-hosted-engine-setup

#### Hosted-engine.in
Add a new command set-config
Add a new command get-config
Add a new command download-archive
Add a new command upload-archive

#### Set-config.py
A new file with a new class that will use the he client code to set the configuration.

#### Get-config.py
A new file with a new class that will use the he client code to get the shared configuration

#### Download-archive.py
A new file with a new class that will use the he client code to download the shared configuration

#### Upload-archive.py
A new file with a new class that will use the he client code to upload the shared configuration

## Second stage: Add support for editing vm ovf
Editing the ovf can be dangerous, so extra care is needed for this feature.

To support editing the vm we will have to add an interactive warning to the user as part of the setting of the configuration, as well as a force option for automatic tools that want to run it.
Also, since the ovf is in a different format than the broker we will need to add a different handling for the setting and getting of the configuration.

### Editable keys:
Vm ovf:

 1. Num of sockets
 2. Cpu per socket
 3. Threads per cpu
 4. Min allocated memory
 5. Memory size
 6. Nic parameters
