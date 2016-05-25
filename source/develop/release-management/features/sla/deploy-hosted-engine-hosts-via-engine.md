# overview
In 4.0 onward adding more hosts to the hosted engine cluster is supported only via the engine.
This has various advantages:
1. Its one place, that takes advanteges or SDK, REST, UI. validations etc 2. The hosts are now part
of the cluster and datacenter with regards to host_id - there will be no collision/distinction between hosted engine or other 
host that try to monitor domains.

# High level
To deploy hosted engine we extended the host-deploy subsystem API to support an action - `deploy/remove` and default `none`
The engine, when it invokes host-deploy that install vdsm rpms will now also install the hosted engine rpms and will
take the hosted-engine.conf as an argument and will put it under etc. This is enough to get a host into the HA cluster.

To undeploy or remove the hosted engine role of a host the engine simply passes action=remove and then host-deploy
simply empties the configuration files so the HA agent is practically infunctional.

# Detailed flow
Supply detailed into on how to get the info from the disk, and what is the host-deploy enums we use

# UI side dialog tab

# REST request parameters
