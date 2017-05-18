---
title: Architecture
category: ovirt-guest-agent
authors: vfeenstr
---

<!-- TODO: Content review -->

# Architecture

## The communication between oVirt guest agent and the oVirt engine

<!-- TODO: image too large, needs fixing
![](/images/wiki/Guest_Agent_Achitecture.png "Guest_Agent_Achitecture.png")
-->

The engine directs requests for the guest agent to VDSM.

VDSM communicates with the guest using a VirtIO channel using plain text commands in JSON format. Each command is terminated by a new line character.

## VDSM/Guest Agent message structure

Each message sent by VDSM has a mandatory field '__name__' which contains the command name.

All additional fields in the message are considered arguments to the command. Please see the [OVirt_Guest_Agent/Command Definitions](OVirt_Guest_Agent/Command Definitions) page for detailed information about supported commands and their arguments.
<!-- TODO: above link is broken, where should it point to? -->
