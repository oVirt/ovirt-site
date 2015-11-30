---
title: VM Migration
authors: ofrenkel
wiki_title: VM Migration
wiki_revision_count: 2
wiki_last_updated: 2012-07-08
---

# VM Migration

This is the state machine for VM migration process (WIP)

| Status as reported by src | Status as reported by Destination | VM Status      | Where       | Comments                                  |
|---------------------------|-----------------------------------|----------------|-------------|-------------------------------------------|
| Down                      | Down                              | Down           |             |                                           |
| Down                      | Up                                | Up             | Destination |                                           |
| Up                        | Down                              | Up             | Src         | trying to rerun migration on another host 
                                                                                                 failure migration message in event log    |
| Migrating From            | Down                              | Migrating From | Src         |                                           |
| Migrating From            | Up                                | Migrating From | Src         |                                           |
| Migrating From            | Migrating To                      | Migrating From | Src         |                                           |
| Down                      | Migrating To                      | Migrating From | Src         |                                           |
| Up                        | Migrating To                      | Migrating From | Src         |                                           |

The table of Vms statuses will be kept in memory - it means will be shared between all hosts.
The VM will be added to table during the Migrate-VM command or when the status of VM received from vdsm is MigratingTo or MigratingFrom.
After processing the host via fence treatment(automatic or manual) at case of success,all the status of VMs which has at Migrating Status will be updated to Down in the table. And the Vms will be processed during to the new states.
If engine is restarted in the middle of migration - the table will be empty, and will be re-fill according to statuses received from vdsm, if needed
The main idea - we will not report that migration is successes or fail until we get correct statuses from source and destination hosts, until that vm will be in the Migrating To status. It is mean that if one of the hosts is in unresponsive status and status of vm at that host is Migrating To or Migrating from vm will left in Migrating To status
