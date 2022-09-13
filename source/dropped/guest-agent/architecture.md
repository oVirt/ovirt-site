---
title: Architecture
category: ovirt-guest-agent
authors: vfeenstr
---

<!-- TODO: Content review -->

# Architecture

## The communication between oVirt guest agent and the oVirt engine

![](/images/wiki/Guest_Agent_Achitecture.png)

The engine directs requests for the guest agent to VDSM.

VDSM communicates with the guest using a VirtIO channel using plain text commands in JSON format. Each command is terminated by a new line character.

## VDSM/Guest Agent message structure

Each message sent by VDSM has a mandatory field `__name__` which contains the command name.

All additional fields in the message are considered arguments to the command.
