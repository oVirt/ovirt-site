---
title: HSM Async Tasks
category: feature
authors: amureini, danken
wiki_category: Feature
wiki_title: Features/HSM Async Tasks
wiki_revision_count: 2
wiki_last_updated: 2014-03-03
---

# HSM Async Tasks

## Summary

In oVirt 3.3 and below, async tasks exist only for SPM (i.e., storage management) tasks. Other tasks, now matter how long they potentially take, are treated as synchronous task (and may just time out). This feature suggestion is to enable such a mechanism for HSM operations too.

## Owner

*   Name: TBD
*   Email:

## Current status

*   No such feature in implemented in 3.3
*   Last updated: ,

## Detailed Description

*   Each (relevant) VDSM verb will gain an additional parameter (runAsync=False), in order to continue running verbs in backwards compatibility mode
*   For the first release, we will only allow VM level async tasks. The engine will send a call, and provide an additional callback to VdsUpdateRuntimeInfo that will return the task's completion status (running, endSuccessfully, endWithFailure) according to its business logic based on the runtime data collected for the VM.

## Benefit to oVirt

*   Allow long running on HSM without them timing out (current limitation: 3:00 minutes with the default configuration)
*   Move some of the asynchronous tasks from SPM to HSM, and reduce the load on the SPOF.
*   Improve current VM-centric features like [Storage Live Migration](Features/Storage Live Migration)
*   Facilitate future features such as live merge

List of possible users:

1.  Live merge
2.  setupNetwork with slow DHCP servers
3.  VM start up
4.  migration

## Dependencies / Related Features

*   See above

## Documentation / External references

## Testing

TBD

## Comments and Discussion

*   Refer to [Talk:HSM Async Tasks](Talk:HSM Async Tasks)

<Category:Feature>
