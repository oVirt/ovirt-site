---
title: ExternalTasks
category: feature
authors:
  - emesika
  - yair zaslavsky
---

# External Tasks

## Adding External Tasks Support

### Summary

Enable plug-in to inject tasks to the engine application using the REST API, change their statuses and track them from the UI.
A task may have other nesting sub-tasks under it.

### Owner

*   Name: James Rankin
*   Email: jrankin@redhat.com

### Current status

*   Last updated date: Feb 12, 2013

### Use Case

The main use case is for third party vendors, to integrate with oVirt. A vendor may have a set of external tasks that he may inject to the system in any flow. Multiple Vendors may integrate with the system at any given time.

### Detailed Description

Plug-ins using the REST API should be enable to inject and track external tasks to oVirt and see those tasks displayed in the oVirt UI.
* Tasks may be nested
* Tasks may run concurrently
* Sub-Tasks of the same Task may run concurrently
* Tasks/Sub-Tasks should support the following statuses:
  - Waiting
  - Started (only for the task)
  - Running
  - Completed
  - Failed

Solution should support setting percentage for the Task Started state
**Task Flow**

        Waiting -> Started (x %) |
                                 -> Completed
                                 |
                                 -> Failed 

**Sub Task Flow**

       Waiting -> Running        |
                                 -> Completed
                                 |
                                 -> Failed

**Operations**

* Adding a new task
* Adding a nested sub-task to an existing task
* Removing a task
* Updating a task/sub-task status

As in the Task Monitor that serves internal oVirt commands, Task should be displayed for a configurable time after competion and then vanished from the UI.

### Benefit to oVirt

The benefit of External Tasks injection is the ability to track tasks that are performed outside of oVirt or hybrid tasks when some of the sub-tasks are done by oVirt and some are external
this feature will enable all users to track the advance of a task that is not completely executed under oVirt.

Sample use-cases:
A user would like to clone a VM and cranks up our Rapid Cloning wizard. They fill in all the information and have selected a VM that is currently running. Upon clicking Ok, the information is sent to the server which starts performing a set of actions including the following

        a. Shutdown the VM (oVirt REST)
        b. Coalesce the disk (oVirt REST)
        c. Clone the disk (External)
        d. Update metadata in domain associated with new disk (External)
        e. Create new VM based on data from original VM (oVirt REST)
        f. Attach cloned disk to VM (oVirt REST)

Each of these items would be a subtask of the overall Cloning task. At the beginning of this process, we would create the Cloning task through REST in oVirt. We could potentially include all the subtasks in the initial creation or add them as needed.
 As the tasks are performed, we would make REST calls to update the started/ finished status as well as the percentage complete if that's supported.

### Dependencies / Related Features

See also [UI-Plugins](/develop/release-management/features/ux/uiplugins43.html)

### Documentation / External references

[RFE](https://bugzilla.redhat.com/show_bug.cgi?id=872719)




## Testing

### Test 1

      Create an external job which is marked as auto-cleared
       Add external steps and sub steps to the job
       Update on completed tasks and sub tasks 
       Check that job completes successfully and is cleared after the configured timeout 

### Test 2

       Repeat test 1 with auto-cleared = false
       After job completes verify that it is not cleared after the configured timeout from DB
       Clear the job manually

### Test 3

       Repeat test 1 with a job that includes a mix of internal and external steps , 
       Make sure that for internal steps the job/step parent id should be set in the URI parameters
       

### Test 4

       Repeat test 2 with a job that includes a mix of internal and external steps ,
       Make sure that for internal steps the job/step parent id should be set in the URI parameters

