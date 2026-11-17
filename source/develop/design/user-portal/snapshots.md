---
title: Snapshots
authors:
  - lizsurette
  - sandrobonazzola
---

# Snapshots

Users will have the ability to manage snapshots for each VM.

## View Snapshots

Within the details page, the user will be able to see a card that lists all of the snapshots for the VM.
![snapshots](img/snapshots.png)

The user can hover over the information icon to view some high level details about that snapshot.
![snapshotdetails](img/snapshot-details.png)

## Restore Snapshot

If the user wants to restore a snapshot, they will be given a confirmation modal before proceeding.
![restore](img/restore.png)

![restoreconfirmation](img/restore-confirmation.png)

## Create Snapshot

One of the options in the Snapshots card is for the user to Create a Snapshot.
![createsnapshot](img/create-snapshot.png)

![createsnapshot2](img/create-snapshot2.png)

![createsnapshot3](img/create-snapshot3.png)

## Delete Snapshot(s)

Deleting a snapshot should give the user a confirmation dialog. In some cases, other dependent snapshots would be deleted as well and this should be clear to the user.
![deletesnapshot](img/delete-snapshot.png)

[![SPDX-License-Identifier: Apache-2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
