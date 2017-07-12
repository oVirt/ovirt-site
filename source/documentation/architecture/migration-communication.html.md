---
title: Communication of Engine with Vdsm during migrations
category: architecture
authors: mzamazal
---

# Communication of Engine with Vdsm during migrations

This document provides overview of communication between Engine and Vdsm on migrations.  It serves as a developer reference to the migration process coordination.

The entities involved in the migration are Engine, Vdsm on the source host and Vdsm on the destination host.  At each phase of the migration some coordination between the involved entities happens.  The given migration phases are initiation of the migration, contingent switching to the post-copy mode, successful completion in the pre-copy or post-copy phases, failure in the pre-copy or post-copy phases.

The status changes of the VMs are reported to Engine via events or Engine can detect them by polling (when the event is not emitted or it is lost for some reason).

## Source Host

On migration initiation:

- `VM.migrate` call from Engine.
- The VM status is changed to "migration source" and a status event is sent to Engine.

On pre-copy success:

- The VM status is changed to "down" status with exit status Normal (and with the reason: migration succeeded) attached and a status event is sent to Engine.
- `VM.destroy` call from Engine, once Engine detects the VM in "down" status.
- VM cleanup is performed, including the Vdsm internal VM object, and the `VM.destroy` call is answered with a success/error response.

On pre-copy failure:

- The VM status is changed to "up" and a status event is sent to Engine.
- `VM.destroy` request is sent to the destination.

On switch to post-copy:

- The VM status remains "migration source" internally, but it is presented as "paused" with `POSTCOPY` paused-reason to Engine and a corresponding status event is sent to Engine.  Note that a VM may be in a "paused" status for completely different reasons, do not confuse those situations with `POSTCOPY` paused-reason.

On post-copy success:

- VM cleanup is performed automatically, including the Vdsm internal VM object.

On post-copy failure:

- The VM status is changed to "down" with exit status Error (and with the reason: post-copy failure) attached and a status event is sent to Engine.
- The VM is destroyed immediately afterwards, including the Vdsm internal VM object.

Summary of possible VM migration statuses as reported to Engine:

- Migration source: pre-copy migration
- Paused: post-copy migration
- Down: migration completed, post-copy migration failure
- Up: pre-copy migration failure

## Destination Host

On migration initation:

- The VM is created with status "migration destination" and a status event is sent to Engine.

On pre-copy success:

- The VM status is changed to "up" and a status event is sent to Engine.

On pre-copy failure:

- The VM status is changed to "down" with exit status Error (and with the reason: migration failed) and a status event is sent to Engine.
- `VM.destroy` call from the source host.

On switch to post-copy:

- No action, the VM remains in "migration destination" status.

On post-copy success:

- The VM status is changed to "up" and a status event is sent to Engine.

On post-copy failure:

- The VM status is changed to "down" with exit status Error (and with the reason: post-copy failure) and a status event is sent to Engine.
- The VM is destroyed immediately afterwards but the Vdsm internal VM object is retained.
- `VM.destroy` call from Engine, once the Engine detects the VM in down status.
- VM cleanup is performed, including the Vdsm internal VM object, and the VM.destroy call is answered with a success/error response.

Summary of possible VM migration statuses as reported to Engine:

- Migration destination: during migration
- Up: migration completed
- Down: migration failed

## Engine

On migration initiation:

- Migration request is sent to Vdsm.
- If the request is answered positively, the VM is set to "migration source" status.

During any migration:

- Engine watches for events and status changes from the hosts.
- Reports from the source with "paused" status and `POSTCOPY` paused-reason are ignored.
- Reports from the destination with "migration destination" status are ignored.

During pre-copy phase:

- Engine gets stats from the source, they contain `postcopy` flag set to false.

On switch to post-copy (detected, or "paused" status event with a `POSTCOPY` paused-reason from the source):

- The VM is set to "migration destination" status.
- `run_on_vds` is set to the destination.

During post-copy phase:

- Engine gets stats from the destination, except for migration progress.
- Engine receives migration progress events from the source, they contain `postcopy` flag set to true.
- The migration may not be canceled.

On pre-copy success (detected, or "down" status event from the source):

- `run_on_vds` is set to the destination.
- Engine receives final migration stats (downtime) event from the source.
- Engine sets the VM to running status ("up", "powering up" or "powering down").
- Engine sends `VM.destroy` request to the source host.

On pre-copy failure (detected, or running-status event from the source):

- Engine sets the VM to running status ("up", "powering up" or "powering down").

On post-copy success (detected, or running-status event from the destination):

- Engine receives final migration stats (downtime) event from the source.  Note: post-copy downtime value has different meaning than pre-copy downtime value.
- Engine sets the VM to the corresponding running status.

On post-copy failure (detected, or "down" status event with `POSTCOPY` reason from the destination):

- Engine sets the VM to "down" status.

Regular status combinations (source / destination):

- initial state: (up / down)
- pre-copy: (migration source / migration destination)
- post-copy: (paused / migration destination)
- completed: (down / up)
- pre-copy failure: (up / down)
- post-copy failure: (down / down)

Temporary interim status combinations are possible when one of the hosts changes the status while the other one not yet.  For example, "down / migration destination" status combination may occur when switching from "migration source / migration destination" to "down / up".

## Note on Vdsm recovery

If Vdsm is restarted during the migration, either on the source or on the destination host, the migration process may be disrupted in several ways.  Vdsm tries to keep just the basic sanity in such a case, that means it tries not to lie about the VM status to Engine.  But even that is not 100% guaranteed.
