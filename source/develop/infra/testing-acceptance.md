---
title: Testing-acceptance
authors:
  - doron
  - koen12
---

# Testing-acceptance

## Acceptance

The tests where done on a ovirt 3.3.1 installation. With 2 hypervisors enabled.

| Test Case                                                                              | Result                                                                                  |
|----------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------|
| Create a new VM.                                                                       | Success. oVirt selects hypervisor and boots vm.                                         |
| Create a new VM from template                                                          | Success. oVirt selects hypervisor and boots vm.                                         |
| Create a new VM, start with “run once” and hostname enabled.                           
  Host name should be changed.                                                           | Success. But cloud-init should be installed on the template                             |
| Restart vdsmd service without losing ping to vms                                       | Success. No Ping was lost                                                               |
| Restart ovirt-management service without losing ping on vms                            | Success. No Ping was lost                                                               |
| Move Disk from StoragePool A to StoragePool B.                                         | Success, but VM needs to be shut down for this.                                         |
| Move VM to other hypervisor for maintenance on hypervisor                              
  without losing ping on vms                                                             | Success                                                                                 |
| Pull the plug out hypervisor                                                           | Success. VM is auto moved to other hypervisor (HA Active).                              
                                                                                           VM is unreachable for approx 2m29s. Hypervisor comes back online after approx. 10 min.  |
| Unplanned shutdown of hypervisor. VM Should move to other Hypervisor. Minimum downtime | Success. VM is auto moved to other hypervisor (HA Active).                              
                                                                                           VM is unreachable for approx 2m29s. Hypervisor comes back online after approx. 10 min.  |
| Restore folder from backup using NetBackup                                             | Success. No Issues                                                                      |
| Server Crash. Completely reinstalled and re-added to ovirt.                            | Time taken: +/- 1u30                                                                    |
| Server-crash --> VM’s are migrated to another hypervisor.                             | Success. VM is moved to other Hypervisor. It shutsdown for a moment                     
                                                                                           but boots up immediately (HA option needs to be enabled)                                |
| Disable 1 Fiber path on the host. Vms should still work.                               | Success. No Downtime. Everything stays up and running                                   |
| Disable 2 Fiber Paths. Vms should be migrated to the other Hypervisor                  | Fail. We had to intervene and move the vms manually                                     
                                                                                           to the other Hypervisor or restore at least one fibre path.                             |

The last test we did with removing the 2 Fiber channels to the hypervisor... This will put the VM's in a pause state. This is the reason:

      the KVM team advised this would be an unsafe migration. iirc, since IO can be stuck at kernel level,  <br />pending write to the storage, which would cause corruption if storage is recovered while the VM is now running on another machine. 
