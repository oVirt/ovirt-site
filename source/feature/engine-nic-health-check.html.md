---
title: engine NIC health check
authors: mmucha
wiki_title: Features/engine NIC health check
wiki_revision_count: 20
wiki_last_updated: 2014-10-18
feature_name: Engine NIC health check
feature_modules: engine,network
feature_status: To be Released
---

# Engine NIC health check

### Summary

Fencing can occur on healthy hosts, just as a result of failing NIC of engine or other problem while communicating with hosts. Fencing should occur after most of these potential problems are checked and unconfirmed. This feature aims at engine nics health.

### Owner

*   Name: [Martin Mucha](User:mmucha)
*   Email: <mmucha@redhat.com>
*   IRC: mmucha at #ovirt (irc.oftc.net)

### Benefit to oVirt

In case that specific NIC(s) of engine is 'not healhy', QoS will be improved, since unhurt hosts will not be (improperly) fenced. NIC is reported as not healthy, when it was not present at all, or it's status was anything else but up at least once for given period of time. This feature does not solve routing problems, defective hw, or configuration issues.

### Implementation

*   engine will periodically check health of it's own nics
*   gathered data over last period is recorded, and stored in db, just for case engine restart so we cannot loose that data. If preferred can be also stored in MQ subsystem.
*   if there's need to fence some host, due to its unresponsiveness, it will be performed if and only if there wasn't any problem in any engine NIC during last N minutes. Example: we can check NIC status each minute and if there's fence request it will be performed only if during last 15 minutes all NICs was always up.
*   If engine machine contains multiple NICs, but only some of them are used by engine, then user should be able to restrict which NICs should be scanned as described. This can be done via engine-config property "EngineNics"; if specified by user, only specified NICs will be scanned. In not set or incorrect(any of specified NICs exist), all NICs will be scanned instead
*   regular scanning will be implemented using quartz job
*   for simplicity reasons NIC status will be read using java.net.NetworkInterface#isUp. This method does not return actual NIC status, but we do not need that at this moment and do not want to add new dependency to the project. As a sideeffect of java.net.NetworkInterface#isUp NICs without IP address will not be considered as valid ones.
*   check, whether engine NICs are healthy and fencing should proceed will be done in org.ovirt.engine.core.bll.VdsEventListener#vdsNotResponding and org.ovirt.engine.core.bll.VdsNotRespondingTreatmentCommand#shouldFencingBeSkipped

### UX

This feature options currently cannot be set from gui, since there's no 'engine' related tab. NICs to be monitored has to be setup via engine-setup
