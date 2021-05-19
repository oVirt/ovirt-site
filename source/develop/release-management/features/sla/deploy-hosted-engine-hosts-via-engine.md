---
title: Deploy Hosted Engine Hosts via Engine
authors: rgolan
category: feature
---

# overview
In 4.0 onward adding more hosts to the hosted engine cluster is supported only via the engine.
This has various advantages:
1. It's one place, that takes advantage of SDK, REST, UI. validations etc.
2. The hosts are now part of the cluster and datacenter with regards to host_id - there will be no collision/distinction between hosted engine or other
host that try to monitor domains.

# High level
To deploy hosted engine we extended the host-deploy subsystem API to support an action - `deploy/remove` and default `none`.

The engine, when it invokes host-deploy that installs vdsm RPMs, will now also install the hosted engine RPMs.  In addition, it will take the hosted-engine.conf as an argument and will place it under /etc.
This is enough to get a host into the HA cluster.

To un-deploy or remove the hosted engine role of a host the engine passes action=remove and then host-deploy empties the configuration files so the HA agent is practically non-functional.

# Detailed flow
Supply detailed into on how to get the info from the disk, and what is the host-deploy enums we use

# UI side dialog tab
The UI of 'Add' and 'Reinstall' host has a new side panel named 'Hosted-Engine'. It supplies 3 options for the deployment of a host:
- 'None' meaning don't touch the hosted-engine components
- 'Deploy' meaning install the ovirt-hosted-engine-ha rpms, place a custom hosted-engine.conf under /etc and start the service
- 'Undeploy' Remove the hosted-engine.conf and rpms. That action decomissions a host from the HA cluster of hosted engine.

# REST request parameters
The API exposes those URLs to implement the 3 proposed actions as the UI:
* Add Host
 - None - done pass any argument
 - Deploy
   - POST .../hosts?deploy_hosted_engine                         
   - POST .../hosts?deploy_hosted_engine=true
 - Undeploy
   - POST .../hosts?undeploy_hosted_engine
   - POST .../hosts?undeploy_hosted_engine=true

* Install Host
 - None - done pass any argument
 - Deploy
   - POST .../hosts/xxx/install?deploy_hosted_engine
   - POST .../hosts/xxx/install?deploy_hosted_engine=true
 - Undeploy
   - POST .../hosts/xxx/install?undeploy_hosted_engine
   - POST .../hosts/xxx/install?undeploy_hosted_engine=true
