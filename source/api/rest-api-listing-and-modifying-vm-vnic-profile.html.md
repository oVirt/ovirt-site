---
title: REST-Api listing and modifying VM vNic profile
category: api
authors: kianku
wiki_category: Api
wiki_title: REST-Api listing and modifying VM vNic profile
wiki_revision_count: 7
wiki_last_updated: 2014-03-16
---

# REST-Api listing and modifying VM vNic profile

## List all Nic Profiles via Rest Api

Use the Get method to access [http://yourServer:port/ovirt-engine/api/vnicprofiles/](http://yourServer:port/ovirt-engine/api/vnicprofiles/)

An example using google’s simple rest client: [file: List_of_vNic_profiles.png](file: List_of_vNic_profiles.png)

## Change Nic Profile for a specific VM

Use the Put method to change the VM’s nic profile at [http://yourServer:port/ovirt-engine/api/vms/specificVmId/nics/specificNicID](http://yourServer:port/ovirt-engine/api/vms/specificVmId/nics/specificNicID)

Add a header for using xml: Content-Type: application/xml

Add a body(data) with your desired profile(taken from the list above): For example:
<nic>
<vnic_profile href="/ovirt-engine/api/vnicprofiles/874a3706-62af-40ca-9c0e-7d1a1e92ae02" id="874a3706-62af-40ca-9c0e-7d1a1e92ae02"> </vnic_profile>
</nic>

An example using google’s simple rest client: [file: Change_vm_vnic_profile.png](file: Change_vm_vnic_profile.png)

<Category:Api>
