### oVirt and containers
#### About
The aim here is to provide documentation for easy testing of various components that work with oVirt. 
Often components (e.g FreeIPA, ManageIQ, Ceph, Cinder etc) cannot be installed alongside oVirt due to conflicting 
dependencies. Using these applications in containers allows users to sidestep these issues while at the same time 
getting to deploy them for testing purposes on the same machine as oVirt. Such an approach also allows for separate 
upgrades of components, direct management of resources, as well as emulation of situations where these components are 
running separately such as in a production environment, even though we may be running the component containers on a single 
server. 

Some of the components that we're looking at include:
- PostgreSQL 
- Gluster 
- Ceph 
- OpenStack Glance/Cinder/Neutron 
- ManageIQ
- FreeIPA 

Another components that oVirt uses can be added as well to the list above. 
