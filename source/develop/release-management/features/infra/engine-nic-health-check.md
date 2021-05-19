---
title: engine NIC health check
authors: mmucha
category: feature
---

# Engine NIC health check

## Summary

Fencing can occur on healthy hosts, just as a result of failing NIC of engine or other problem while communicating with hosts. Fencing should occur after most of these potential problems are checked and unconfirmed. This feature aims at engine nics health.

## Owner

*   Name: Martin Mucha (mmucha)
*   Email: <mmucha@redhat.com>
*   IRC: mmucha at #ovirt (irc.oftc.net)

## Benefit to oVirt

In case that specific NIC(s) of engine is 'not healhy', QoS will be improved, since unhurt hosts will not be (improperly) fenced. NIC is reported as not healthy, when it was not present at all, or it's status was anything else but up at least once for given period of time. This feature does not solve routing problems, defective hw, or configuration issues, when improper fence still can occur regardless of this feature.

## Implementation

*   engine will periodically check health of it's own nics
*   gathered data over last period is recorded, and stored in db, just for case engine restart so we cannot lose that data. Data are stored in table:

CREATE TABLE engine_nics_health ( id CHARACTER VARYING(255) NOT NULL PRIMARY KEY, healthy BOOLEAN NOT NULL, last_failure TIMESTAMP NOT NULL);

where id is name of NIC and last_failure is moment when given nic become unhealthy. From this table is fed hashmap on startup and all successive queries proceed in memory only. Only when nic change it's health, db is updated.

*   if there's need to fence some host, due to its unresponsiveness, it will be performed if and only if there wasn't any problem in any given (by configuration) engine NIC during last N minutes. Check for NIC status will be performed each 5 seconds. If there's fence request, it will be performed only if during last N minutes all NICs was always up. Number of minutes wasn't decided yet, see Opened Issues section.
*   User denotes NICs to be periodically checked using engine-config property "EngineNics", only NICs specified here will be scanned. Multiple NICs are separated by comma. If engine machine contains multiple NICs, but only some of them are used by engine, then user will specify only significant NICs, others won't be scanned. By default "EngineNics" property is unset, NICs won't be scanned at all, providing backward compatibility. If inexisting NICs are provided i "EngineNics" property, they're simply ignored.
*   regular scanning will be implemented using quartz job
*   for simplicity reasons NIC status will be read using java.net.NetworkInterface#isUp. This method does not return actual NIC status, but we do not need that at this moment and do not want to add new dependency to the project. As a sideeffect of java.net.NetworkInterface#isUp NICs without IP address will not be considered as valid ones as well as not being able to get current status.
*   check, whether engine NICs are healthy and fencing should proceed will be done in org.ovirt.engine.core.bll.VdsEventListener#vdsNotResponding and org.ovirt.engine.core.bll.VdsNotRespondingTreatmentCommand#shouldFencingBeSkipped
*   frequency of NIC checking can be specified via engine-config property "EngineNicsHealthCheckDelay" in seconds grade.
*   time interval during which there must be no problems to allow fencing can be specified via engine-config property "EngineNicsHaveToBeUpAtLeast" in seconds grade. Suggestions for better name are welcomed.

## UX

This feature options currently cannot be set from gui, since there's no 'engine' related tab to accommodate this feature. NICs to be monitored has to be setup via engine-config.

Example: Depending where you've installed oVirt to you can issue either:

$HOME/ovirt-engine/bin/engine-config -s EngineNics="eno1,eno2" or /usr/local/ovirt-engine/bin/engine-config -s EngineNics="eno1,eno2"

## Opened Issues

*   for how long (n minutes) all monitored NICs must be always up so the fencing can occur?
