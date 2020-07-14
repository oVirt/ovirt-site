---
title: Hosted engine metadata
category: sla
authors: msivak
---

# Hosted engine metadata

Hosted engine agents communicate using a shared "whiteboard". Each agent can only write to a reserved section (protected by sanlock) and read the whole board.

## Files

All hosted engine files related to the shared metadata are located in /rhev:

*   /rhev/data-center/mnt/<NFS>/<DOMAIN ID>/ha_agent/hosted-engine.lockspace
*   /rhev/data-center/mnt/<NFS>/<DOMAIN ID>/ha_agent/hosted-engine.metadata

and the formats are described below.

### ha_agent.lockspace

This file holds the sanlock lockspace used to protect the reserved sections from concurrent writes. The default capacity is 2000 nodes (disk size is 1 MB) and the lockspace is initialized using:

      #!/usr/bin/env python
      import sanlock
      sanlock.write_lockspace(lockspace="hosted-engine", path=lockspace_file, offset=0)

### ha_agent.metadata

This file holds the metadata published by all hosted engine agents. It is organized into 2kiB blocks where the first 512B contains the machine readable format and the rest is used for human readable and auxiliary data. The machine readable block MUST be written and distributed across network atomically.

The first block (index 0) is used for global cluster settings. Currently only the global maintenance flag is being saved there as:

      maintenance=1

The additional blocks then contain the following fields separated by '|' character (the pipe):

| name                         | expected value                                                                                | description                                                                                      |
|------------------------------|-----------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------|
| parse version                | 1                                                                                             |                                                                                                  |
| feature version              | 1                                                                                             |                                                                                                  |
| collection started timestamp | seconds since start                                                                           | start can be either epoch (1st of Jan 1970) or system start when relative time is used (default) |
| host id                      | <unique integer 1...2000>                                                                     | MUST match the block id (offset in the file modulo 2048)                                         |
| score                        | integer                                                                                       | usually 0 .. 2400                                                                                |
| engine health report         | {"reason": "vm not running on this host", "health": "bad", "vm": "down", "detail": "unknown"} | vm represent the state of the engine VM, health the state of the ovirt-engine service            |
| hostname                     | the node's hostname                                                                           |                                                                                                  |
| local maintenance            | 0|1                                                                                           |                                                                                                  |
| stopped                      | 0|1                                                                                           | usually 0, but is set to 1 by the agent during proper ha_agent shutdown                          |
| crc32                        | 8 hex characters                                                                              | CRC32 checksum of the whole 512B block (without trailing zeros) with crc field set to 00000000   |

