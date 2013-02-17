---
title: AsyncTaskManagerChanges
category: feature
authors: ravi nori, yair zaslavsky
wiki_category: Feature
wiki_title: Wiki/AsyncTaskManagerChanges
wiki_revision_count: 26
wiki_last_updated: 2013-04-10
---

# Async Tasks improvements

### Summary

This Wiki page is going to summarize required changes for Async Task mechanism.

### Owner

*   Name: [ Yair Zaslavsky](User: Yair Zaslavsky)

<!-- -->

*   Email: yzaslavs@redhat.com

### Current status & Motivation

We should invest an ongoing effort to improve our Async Tasks mechanism at engine side.
The following bullets present topics we should handle, based on current status + what we would like to obtain.

*   Modularization - all of Async Tasks code is located at BLL package. We should extract this to a different module/jar
*   Separation of the Async Tasks monitoring (i.e - job/step framework) from the Async Task Management part (AsyncTaskManager class and the VDSM tasks monitoring) - this should be revisited.
*   Task parameters - task parameters are actually parameters of parent commands that invoke the child commands that create the tasks. Upon endAction, there is a calculation at the parent command on the persisted parameters that re-creates the child command parameters and ends them as well.

This mechanism is too complex and is error prone. We should instead persist the commands and their parameters - have a commands table, and for each command keep its parameters.

*   Command objects are re-created at endAction stage - the commands are created using Reflection and the parameters that are associate with the task - once again, this is error prone.

We should reuse command objects, and consider having Commands repository (hold in memory structure to hold ) - commands should be retrieved and re-used from this in memory data structure using their identifier (i.e - command ID)

*   Simultaneous command group vs sequential execution - Currently we have the live storage migration feature which uses the serial execution mechanism - the code of this mechanism should be modified according to other improvements that are suggested in this page.
*   Provide a mechanism for a command to know the number of tasks it is supposed to create - see [this bug](https://bugzilla.redhat.com/show_bug.cgi?id=873546) in order to not have a "premature end" of commands.
*   Support backwards compatibility of command parameters - currently, due to the fact that Java is strongly typed + we have a hierarchy of command parameters. Changes to parameters classes may yield problems when performing system upgrade in cases where parameters information is persisted based on old parameters class structure, and needs to be deserialized in newer version with newer code of the class.

### Working on the changes

*   Working on the changes of this mechanism should be done in stages in such a way that we can graduately move commands , and not apply the changes to all commands at once.

### Feature tracking

=

*   Last updated date: Feb 17, 2013

<Category:Feature> <Category:Template>
