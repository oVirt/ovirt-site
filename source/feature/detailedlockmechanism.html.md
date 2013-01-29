---
title: DetailedLockMechanism
category: feature
authors: mkublin, sandrobonazzola, yair zaslavsky
wiki_category: Feature|LockMechanism
wiki_title: Features/DetailedLockMechanism
wiki_revision_count: 29
wiki_last_updated: 2015-01-16
---

# Detailed Lock Mechanism

## Internal Locking Mechanism

### Summary

The following feature should solve collisions which are occurring between sententious flows

Add a link to the main feature page as well: [Your feature name](Your feature name)

### Owner

*   Name: [ Michael Kublin](User:mkublin)

<!-- -->

*   Email: mkublin@redhat.com

### Current status

*   Target Release: 3.2
*   Status: Design of additional functionality
*   Previous status: merged
*   Last updated date: 29.01.13

### Detailed Description

These is design of **additional** functionality which should allow the following:
1. A locks can be keep until end of the execution of all asynchronous task of the command
2. Improve error messages for cases when lock can not be acquired
3. Integration with AsyncTask manager in order to solve a problem of restart , when there are left command with asynchronous tasks
The following feature **already exists and implemented** as in memory generic locking mechanism.
A locking mechanism can be used all over bll in order to not allow to occurred for some flows sententiously.
The feature will include :
1. Implementation of locking mechanism, implementation will be memory based
2. Introducing it all over a bll logic
3. A lock will be short term, and should be released after the appropriate entity was updated in DB (For example, during canDoAction of ActivateStorageDomain we locked domain by internal in memory, and when the canDoAction successes we update status of domain to 'Locked' and released an internal in memory lock)

#### Entity Description

Existing entity : EngineLock.
The entity is represent a logical representation of the all objects needed to be locked.
An entity will contains a lists of "read locked" entities and "write locked" entites

#### CRUD

No need for new CRUID.

#### User Experience

No GUI required

#### Installation/Upgrade

No impact

#### User work-flows

The implementation will be based on the following algorithm :
1. The lock command will be marked by annotation and lock of object will be done before canDoAction
2. If needed additional treatment appropriate command will override getReadLocks() and getWriteLocks() methods of CommandBase
3. At the end of command the locked will be released (if failure occurred during canDoAction - a lock will be released immediately), if new option is not used
4. Additional option will be introduced inside annotation - don't release lock after end of the execute(). 5. If command is marked by these option a lock will be released at the end of endAction()

**Explanation on regular flow**:
1. We are running activate/detach/remove/etc domain
2. The entry with domainId will be handled as required lock entity
3. The entry with poolId will be handled as read lock, if it is already exists: we will try to update count = count+1 when not write lock is acquired on that entity
4. Start Activate Domain.
 Now we want to start Reconstruct:
5. The entry with poolId will be handled as write lock. At case that lock on entity can not be acquired - meaning that one of the domains is Locked.
The same issue is regarding HandleFailedStorageDomain because of it can lead to Reconstruct.
 **Explanation on flow with asynchronous tasks**:
1. We are running create vm from template
2. The entity with templateId will be handled as required read lock entity
3. During execution command the status of template will not be changed in DB
4. After finishing all tasks for creation vm - a read lock will be released during a call to AddVmFromTemplateCommand.endAction()
If during a run we will run for example RemoveTemplate, these command should try to acquire exclusive lock on templateId and it will fail.
 **The major change** is that from now all statuses which today is persisted to DB like: status of disk, template, vm will be used only for representative purpose and in memory locks should be used in order to determine if the operation can be run or not.

#### Failures

During restart of JBOSS a following improvements will be done in AsyncTaskManger
1. All task which are kept in DB will be loaded to memory (Should be done at any case, in order to improve AsyncTaskManager)
2. During load of tasks, appropriate objects will be created, because of such object are representing a tasks - all appropriate locks will be acquired again
3. If task is not found in DB , but exists in VDSM - no problems , locks will not be acquired - should solve a problem of locked objects forever
4. If task found in DB and not found in VDSM - appropriate mechanism in AsyncTaskManager will clean a task and will release all locks (The following mechanism should be improved , with out any connection to following feature)
The described changes will solve a problem of lack persistence (The locks are in memory locks).

#### Events

In case that user did not successes to acquire a lock appropriate canDoaction message should appeared to user. In order to improve user experience will be added an options to specify error message for chosen lock.

### Dependencies / Related Features and Projects

The following feature will provide a generic mechanism for synchronization different flows in ovirt, by default it will be applied only on known problematic flows , like: storage, vms and permissions flows.

### Documentation / External references

NA

### Comments and Discussion

### Open Issues

<Category:Template> <Category:Feature>
