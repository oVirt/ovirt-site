---
title: About: oVirt and containers
authors: leni1
---
### oVirt and containers
#### About
This is documentation of how to use the oVirt Engine with the different software components that are commonly used with it via containers. Often components (e.g FreeIPA, ManageIQ, Ceph, Cinder etc) cannot be installed alongside the oVirt Engine on the same machine due to conflicting dependencies. In some cases, these components are designed for installation and usage on a server separate from the one hosting the oVirt Engine. 

The aim here is to demonstrate how containers of these components can be used with the oVirt Engine. Using containers allows users to sidestep the issues described briefly above while simplifying what is required to spin up a testing environment. This approach allows for separate upgrades of components, direct management of resources, as well as emulation of situations where these components are running separately e.g. in a production environment, even though we may be running the component containers on a single server. 

Some of the components that we're looking at include:
- PostgreSQL 
- Gluster 
- Ceph 
- OpenStack Glance/Cinder/Neutron 
- ManageIQ
- FreeIPA 

Other components that the oVirt Engine uses can be added to the list above with time. 
