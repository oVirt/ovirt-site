---
title: JsonRpc
category: feature
authors: adahms, apuimedo, pkliczewski, sandrobonazzola, smizrahi, ybronhei
wiki_category: Feature|JsonRpc
wiki_title: Features/Design/JsonRpc
wiki_revision_count: 34
wiki_last_updated: 2015-06-10
feature_name: Introduce Messaged communication to VDSM using JSON-RPC on top of various
  transport protocols
feature_modules: vdsm, engine
feature_status: In Development
---

# Json Rpc

## Introduce Messaged communication to VDSM using JSON-RPC on top of various transport protocols

### Summary

Using a phased approach we are going to move VDSM to a point where messaging is the main communication model between the engine and VDSM as well as the numerous VDSM subsystems.

### Owner

*   Name: [ Saggi Mizrahi](User:smizrahi)
*   Email: <smizrahi@redhat.com>

### Current status

*   Last updated on -- by [ WIKI}}](User:{{urlencode:{{REVISIONUSER}})
*   Were currently in [Phase 1](#Phase_1)

### Phases

#### Phase 0

The is how VDSM communicated with the engine before any messaging was implemented.

![](jsonrpc_phase0.png "jsonrpc_phase0.png")

The engine uses XML-RPC over HTTP to make API requests.

#### Phase 1

This is an phase not meant to be released in any version. Instead it it is meant to be used in development so integration with the engine could start.

VDSM would listen in a different port for each supported transport. Messages are parsed by the appropriate transport reactor and the message boydy is passed to the JSON-RPC Server. The Server than parses the json data and calls the appropriate method on the bridge that maps to the vdsm object responsible for performing the command.

![](jsonrpc_phase1.png "jsonrpc_phase1.png")

#### Phase 2

**in progress**

For this phase the main addition is protocol detection. Instead of having a dedicated port per protocol the protocol detector handles SSL negotiation and peeks at the stream. After detecting the protocol it passes the socket to the correct part of the system.

This is going to be released for 3.5

![](jsonrpc_phase2.png "jsonrpc_phase2.png")

#### Phase 3

The main edition for this phase is the broker. Up until this point the messaging reactors "faked" having a brokering semantics. This change adds an actual entity with brokering semantics.

Broker Features:

*   Topics
*   Subscriptions

Low Priority Features:

*   Queues
*   Message acknowledgment\\settlement
*   Retrying policy

There is a possibility this phase would be skipped and we would just use a ready made broker.

![](jsonrpc_phase3.png "jsonrpc_phase3.png")

#### Phase 4

At this point Subsystems would start managing their own topics. There would still be the legacy interface but there will be a move towards a segmented and seperate task management per subsystem.

![](jsonrpc_phase4.png "jsonrpc_phase4.png")

#### Phase 5

At this point the broker will be pulled out (if we are not already using a standard broker. We remove the XML-RPC interface entirely and more subsystems are being seperated.

Hopefully some subsystems are even running in their own processes.

![](jsonrpc_phase5.png "jsonrpc_phase5.png")

### See also

*   [STOMP](http://stomp.github.io)
*   [JSON-RPC](http://www.jsonrpc.org/)
*   [AMQP](http://www.amqp.org/)

### Attachments

*   ![schema](schemas.dia.gz "fig:schema") ([dia](https://wiki.gnome.org/Apps/Dia/) file)
