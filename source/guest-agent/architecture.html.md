---
title: Architecture
category: ovirt-guest-agent
authors: vfeenstr
wiki_category: Ovirt guest agent
wiki_title: OVirt Guest Agent/Architecture
wiki_revision_count: 5
wiki_last_updated: 2013-05-20
---

# Architecture

## The communication between oVirt guest agent and the oVirt engine

![](Guest_Agent_Achitecture.png "Guest_Agent_Achitecture.png")

The engine directs requests for the guest agent to VDSM.

VDSM communicates with the guest using a VirtIO channel using plain text commands in JSON format. Each command is terminated by a new line character.

## Message structure

[Category:Ovirt guest agent](Category:Ovirt guest agent)
