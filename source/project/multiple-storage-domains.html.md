---
title: Multiple storage domains
category: project
authors: jumper45
wiki_category: Project
wiki_title: Category:Multiple storage domains
wiki_revision_count: 17
wiki_last_updated: 2012-01-18
wiki_warnings: list-item?
---

# Multiple storage domains

The Multiple storage domain project aims to allow VMs to use disks located on more than one Storage Domain within the same Data Center.

*   Feature lead: [ Jon Choate](User: Jumper45)

:\*GUI Component lead: [ Gilad Chaplik](User: gchaplik)

:\*REST Component lead: [ Michael Pasternak](User: mpasternak)

:\*Backend Component lead: [ Jon Choate](User: Jumper45)

:\*VDSM Component lead: [ Dan Kenigsberg](User: danken)

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
| Add A disk to a VM          | 1                     | X       | X        | X        |            |
| Create a snapshot           | 1                     | X       | X        | X        |            |
| Restore a snapshot          | 1                     | X       | X        | X        |            |
| Create a template from a VM | 2                     | X       | X        | X        |            |
| Create a VM from a template | 2                     |         |          |          |            |
| Import a VM                 | 2                     | X       |          |          |            |
| Move a Disk                 | 4                     |         |          |          |            |
| verify export VM            | 1                     | X       | X        | N/A      |            |
| verify delete VM            | 1                     | X       | X        | X        | N/A        |
| verify remove disk          | 1                     | X       | X        | X        | N/A        |

*   Burndown (credited after testing - not really done until merged)

| | Date | | Target Effort Pts | | Acomplished Effort Pts | | Effort Pts Remaining | | Target Effort Pts Remaining |
|--------|---------------------|--------------------------|------------------------|-------------------------------|
| Jan 9  | 2                   | 3                        | 13                     | 14                            |
| Jan 10 | 2                   | 3                        | 10                     | 12                            |
| Jan 11 | 2                   | 2                        | 8                      | 10                            |
| Jan 12 | 2                   |                          |                        | 8                             |
| Jan 13 | 2                   |                          |                        | 6                             |
| Jan 16 | 2                   |                          |                        | 4                             |
| Jan 17 | 2                   |                          |                        | 2                             |
| Jan 18 | 2                   |                          |                        | 0                             |

*   Issues
    -   uncertainty regarding templates
    -   may need to negotiate change with REST team
    -   Need REST API documentation for some actions

__TOC__

<Category:Project>
