---
title: Events
category: event
authors: ovedo, pkliczewski
wiki_title: Features/Design/Events
wiki_revision_count: 15
wiki_last_updated: 2015-04-27
feature_name: Event mechanism to send events from the host to the engine
feature_modules: vdsm, engine
feature_status: In Development
---

# Event processing built on top of JSON-RPC

### Summary

Engine to vdsm communication was always initiated by an engine. Even when we execute long running tasks on vdsm there is polling mechanism to check status of a task. This behavior creates communication overhead and we want to address this issue by sending messages from vdsm and breaking current mechanism of rpc. This feature provides infrastructure to send messages from vdsm and to receive them on an engine side. We are not going to modify existing xmlrpc and it is still supported in 3.6.

### Owner

*   Name: [ Piotr Kliczewski](User:Pkliczewski)
*   Email: <pkliczew@redhat.com>

### Current status

*   Last updated on -- by [ WIKI}}](User:{{urlencode:{{REVISIONUSER}})

### Overview
