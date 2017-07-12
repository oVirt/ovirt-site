---
title: Multiple storage domains
category: project
authors: jumper45
---

# Multiple storage domains

The Multiple storage domain project aims to allow VMs to use disks located on more than one Storage Domain within the same Data Center.

*   Feature lead: Jon Choate (Jumper45)

:\*GUI Component lead: Gilad Chaplik (gchaplik)

:\*REST Component lead: Michael Pasternak (mpasternak)

:\*Backend Component lead: Jon Choate (Jumper45)

:\*VDSM Component lead: Dan Kenigsberg (danken)

:\*QA lead:

## Goal

Allow VMs to have disks on multiple storage domains within their Data Center.

# Current status

*   Target Release:
*   Status: Design Stage

<!-- -->

*   Backend Status

| | Task                      | | Relative Effort Pts | | Coded | | Tested | | Pushed | | Reviewed |
|-----------------------------|-----------------------|---------|----------|----------|------------|
| Add A disk to a VM          | 1                     | X       | X        | X        | X          |
| Create a snapshot           | 1                     | X       | X        | X        | X          |
| Restore a snapshot          | 1                     | X       | X        | X        | X          |
| Create a template from a VM | 2                     | X       | X        | X        | X          |
| Create a VM from a template | 2                     | X       | X        | X        |            |
| Import a VM                 | 2                     | X       | X        | X        |            |
| Move a Disk                 | 4                     |         |          |          |            |
| import template             | 2                     | X       | X        | X        |            |
| clone template              | 2                     | N/A     | N/A      | N/A      | N/A        |
| verify export VM            | 1                     | X       | X        | X        | N/A        |
| verify delete VM            | 1                     | X       | X        | X        | N/A        |
| verify remove disk          | 1                     | X       | X        | X        | N/A        |

*   Burndown (credited after testing - not really done until merged)

| | Date | | Target Effort Pts | | Acomplished Effort Pts | | Effort Pts Remaining | | Target Effort Pts Remaining |
|--------|---------------------|--------------------------|------------------------|-------------------------------|
| Jan 9  | 2.5                 | 3                        | 17                     | 17.5                          |
| Jan 10 | 2.5                 | 3                        | 14                     | 15                            |
| Jan 11 | 2.5                 | 2                        | 12                     | 12.5                          |
| Jan 12 | 2.5                 | 0                        | 12                     | 10                            |
| Jan 13 | 2.5                 | 4                        | 8                      | 7.5                           |
| Jan 16 | 2.5                 | 4                        | 4                      | 5                             |
| Jan 17 | 2.5                 | 0                        | 4                      | 2.5                           |
| Jan 18 | 2.5                 |                          |                        | 0                             |

*   Issues
    -   may need to negotiate change with REST team

__TOC__

