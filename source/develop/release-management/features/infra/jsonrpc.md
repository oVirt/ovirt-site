---
title: JsonRpc
category: feature
authors:
  - adahms
  - apuimedo
  - pkliczewski
  - sandrobonazzola
  - smizrahi
  - ybronhei
---

# Json Rpc

## Introduction of messaged based communication using JSON-RPC on top of various transport protocols

### Summary

Using a phased approach, we are going to a point where messaging is the main communication model between the engine and VDSM as well as the numerous VDSM subsystems. The biggest difference between current implementation and the goal is communication model change from synchronous HTTP to asynchronous TCP. The XML message format is going to be replaced with JSON, which will reduce parsing time.

### Advantages Of JsonRPC Over XmlRPC

*   Less data send over the wire
*   Faster parsing of message content
*   Asynchronous communication
*   Enable broker usage by using stomp 1.2 protocol
*   Maintains connection and uses heart beats to check its health

### Owner

*   Name: Saggi Mizrahi (smizrahi)
*   Email: <smizrahi@redhat.com>

### Current status

*   Last updated on -- by (WIKI)
*   Were currently in [Phase 1](#phase-1)

## Phases

### Phase 0

Below is prior state to the messaging changes. The engine uses XML-RPC over HTTP to communicate with the VDSM. There are two connections active between the engine and a VDSM.

![](/images/wiki/Jsonrpc_phase0.png)

### Phase 1

This phase is intermediate development milestone which is not meant to be released. It makes introduction of new protocols easier and it paves the way for engine/vdms asynchronous communication. VDSM would listen on a different port for each supported transport.

The engine sends messages by using one of the protocol reactors or apache http client for xml-rpc. VDSM parses messages using appropriate transport reactor and the message body is passed to a json-rpc server for processing. The Server parses json data and calls the appropriate method on the bridge which is mapped to corresponding vdsm object responsible for performing the command.

AMQP protocol is available but not usable due to instability of the protocol implementation used.

![](/images/wiki/Jsonrpc_phase1.png)

### Phase 2

For this phase the main addition is protocol detection. Instead of having a dedicated port per protocol there is single port used by protocol detector. It is responsible for performing SSL handshake and peeking at the first message to recognize which reactor should handle communication. After detecting the protocol it passes a socket to the correct reactor for further message processing.

This is going to be released for 3.5

![](/images/wiki/Jsonrpc_phase2.png)

### Phase 3 (To be done)

For VDSM the main addition in this phase is a broker. Up until this point protocol reactors ignored brokering semantics. This change adds an actual entity with brokering semantics.

For the engine the main change is to reduce number of active connections to single VDSM. IRS and VDS will share a client using particular protocol.

Broker Features:

*   Subscriptions
*   Topics

Low Priority Features:

*   Queues
*   Message acknowledgment\\settlement (provided by AMQP 1.0)

There is a possibility this phase would be skipped and we would just use existing broker implementation.

![](/images/wiki/Jsonrpc_phase3.png)

### Phase 4 (To be done)

In this phase VDSM subsystems would start using json-rpc communication and manage their own topics. There would still be the legacy interface but there will be a move towards a segmented and separate task management per subsystem.

![](/images/wiki/Jsonrpc_phase4.png)

### Phase 5 (To be done)

In this phase internal broker will be pulled out (if we are not already using standalone broker implementation). We will remove the xml-rpc interface entirely and more subsystems are being separated. It is encouraged for VDSM subsystems to run in their own processes in this phase.

![](/images/wiki/Jsonrpc_phase5.png)

## External links

*   [STOMP](http://stomp.github.io)
*   [JSON-RPC](http://www.jsonrpc.org/)
*   [AMQP](http://www.amqp.org/)

## Attachments

*   [ schema ](http://resources.ovirt.org/old-site-files/wiki/Schemas.tgz) ([dia](https://wiki.gnome.org/Apps/Dia/) file containing the schema sources)

[JsonRpc](/develop/release-management/features/) [JsonRpc](/develop/release-management/releases/3.5/feature.html)
