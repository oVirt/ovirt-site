---
title: Engine Core - oVirt workshop November 2011
category: event/workshop
authors: dannfrazier, quaid, sejeff
---

# Engine Core - oVirt workshop November 2011

Edit this page and put session notes and other links on this page

## Backend Bean

*   anything user does is a command queries for information statistics, etc

## Entry Point

*   RunMultipleActions runs asynchronously
*   RunPublicQuery runs w/o Authentication

## VDS Broker

*   SPM = storage commands
*   Moves SPM owner at failover

## Transaction Management

*   RequresNew = suspend current transaction, complete new transaction, resume old transaction
*   Manual transaction management is necessary because of different contexts (user requested vm start vs. starting a vm as part of a large task - e.g. failover)
*   Transactions are about keeping the database consistent / not about tracking individual actions/processes

## Road Map (of non-obvious features)

*   Have all consumers consolidate on the REST API
*   Establish a BUS for communication on the backend
*   Networking: Integrate on Qbg/h manager
*   Task Management: Today, engine can't tell what is being executed by the backend
*   Command Prioritization: e.g. give HA VM commands priority over others
*   Abstract out policies in backend into existing policy engine
*   multiple DB vendors - e.g. MemoryHDB
*   HA: having an active/active deployment
*   Scale out - have multiple backends monitoring each host

## Questions & Answers

*   **Q**: How do oVirt nodes deal with a crashed/rebooting backend?
    -   **A**: VMs are not affected; they keep running. But a double failure can occur causing an HA VM to not get restarted. Possibly have oVirt engine send policy to each host so they know who their backups are.
*   **Q**: If Host crashes?
    -   **A**: Backend can fence the host and restart VMs elsewhere.
*   **Q**: How do we determine if a host is down?
    -   **A**: Engine polls VDSM every 2s; if host is unresponsive it goes into a trying-to-connect; after 60s host is considered non-responsive
*   **Q**: How often do we pull stats from the guest?
    -   **A**: We don't - we pull it from the host which aggregates data, and every 2s. Also get updates from the guest agent (don't remember the rate of updates for the guest)

[Category: Workshop November 2011](Category: Workshop November 2011)
