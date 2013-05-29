---
title: AsyncTaskManagerChangesDetailed
authors: rnori
wiki_title: Wiki/AsyncTaskManagerChangesDetailed
wiki_revision_count: 12
wiki_last_updated: 2013-05-29
---

# Async Task Manager Changes Detailed

## Details of Aysnc Task Manager Changes

### Persists Task Place Holder Before Submitting Task to VDSM

One of the issues addressed in these changes is the ability to fail a command if the server has been restarted during the execution of the command. In order for the server to determine that the task has been partially executed and needs to be failed, we need to determine the number of child tasks that need to be execute. This change inserts place holders in to the database table async_tasks for all child tasks of a command in a single transaction. The task id for each place holder is generated on the engine. Once the job has been submitted to the vdsm, the place holder is updated with the vdsm taskid. If the server is restarted during the execution of the command, on server restart we fail all commands that have place holders in the database with out a vdsm task id.

In order to achive this a few changes have been made to the uinder lying code in the engine.
