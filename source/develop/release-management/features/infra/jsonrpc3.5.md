---
title: JSON RPC 3.5
authors: pkliczewski
category: feature
---

# Json Rpc 3.5

## Summary

The main goal for introducing new communication protocol was performance improvement. Xmlrpc works in synchronous way and it allows only for one way communication. System interaction is triggered by a client which uses apache http client. We designed new solution to be asynchronous and to enable two way communication. We decided to use stomp as means to send jsonrpc protocol which invokes remote methods. By using json over xml we send smaller messages and we reduced frame parsing time.

## Implementation details

Client and server implementation follow concept of single threaded event loop. Events are generated whenever there is a need to send or receive tpc frame(s). Engine (client) implementation uses java NIO based on selector whereas vdsm (server) implementation uses python asyncore. The code is protocol agnostic because we introduced abstraction over low level tpc communication. Currently we have single jsonrpc over stomp implementation but we can easily add other protocols like AMQP.

### Protocol detection

We support both protocol but the server opens single port. When connection is established the server performs ssl handshake and peeks a stream of data to recognize which protocol is being used and passes accepted socket to protocol specific handler. This approach reduces backward compatibility issues.

### Stomp

Stomp gives us connection negotiation, frame level meta data and heartbeats. During connecting to a server we agree on heartbeat timeout. Current implementation supports only server to client heartbeat. Intention of heartbeat implementation is to make sure that the connection is active and healthy at all times. Whenever client do not receive any stomp frame for time agreed during connection negotiation a client closes the connection and attempts to reconnect to keep it healthy. There is 10% grace period between having no stomp frames and reconnection.

### JSONRPC

We use jsonrpc protocol for calling remote procedures. The protocol defines how request parameters, responses and error codes are send between a client and a server.
