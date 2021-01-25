---
title: REST-Api listing and modifying VM vNic profile
category: api
authors: kianku
---

# REST-Api listing and modifying VM vNic profile

## List all Nic Profiles via Rest Api

Use the Get method to access `http://yourServer:port/ovirt-engine/api/vnicprofiles/`

An example using CURL client:

    curl -v -u admin@internal:1 -H Content-type: application/xml -X GET http://localhost:8080/ovirt-engine/api/vnicprofiles/

```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
   <vnic_profiles>
       <vnic_profile
         href="/ovirt-engine/api/vnicprofiles/98f90377-18d8-429d-b412-d9c9549974ac"
         id="98f90377-18d8-429d-b412-d9c9549974ac">
           <name>ovirtmgmt</name>
           <link
             href="/ovirt-engine/api/vnicprofiles/98f90377-18d8-429d-b412-d9c9549974ac/permissions"
             rel="permissions"/>
           <network
             href="/ovirt-engine/api/networks/bdd8f487-9b05-4fd8-8c45-136bd1ac5a23"
             id="bdd8f487-9b05-4fd8-8c45-136bd1ac5a23"/>
           <port_mirroring>false</port_mirroring>
       </vnic_profile>
       <vnic_profile
         href="/ovirt-engine/api/vnicprofiles/0000000e-000e-000e-000e-00000000000e"
         id="0000000e-000e-000e-000e-00000000000e">
           <name>ovirtmgmt</name>
           <link
             href="/ovirt-engine/api/vnicprofiles/0000000e-000e-000e-000e-00000000000e/permissions"
             rel="permissions"/>
           <network
             href="/ovirt-engine/api/networks/00000000-0000-0000-0000-000000000009"
             id="00000000-0000-0000-0000-000000000009"/>
           <port_mirroring>false</port_mirroring>
       </vnic_profile>
       <vnic_profile
         href="/ovirt-engine/api/vnicprofiles/874a3706-62af-40ca-9c0e-7d1a1e92ae02"
         id="874a3706-62af-40ca-9c0e-7d1a1e92ae02">
           <name>ovirtmgmt_profile_qos2</name>
           <link
             href="/ovirt-engine/api/vnicprofiles/874a3706-62af-40ca-9c0e-7d1a1e92ae02/permissions"
             rel="permissions"/>
           <network
             href="/ovirt-engine/api/networks/2cd31372-3700-4f80-a71d-62ab6086193f"
             id="2cd31372-3700-4f80-a71d-62ab6086193f"/>
           <port_mirroring>false</port_mirroring>
       </vnic_profile>
       <vnic_profile
         href="/ovirt-engine/api/vnicprofiles/3ffd219b-cf02-44a5-817b-743d8c60709a"
         id="3ffd219b-cf02-44a5-817b-743d8c60709a">
           <name>ovirtmgmt_profile_qos1</name>
           <link
             href="/ovirt-engine/api/vnicprofiles/3ffd219b-cf02-44a5-817b-743d8c60709a/permissions"
             rel="permissions"/>
           <network 
             href="/ovirt-engine/api/networks/2cd31372-3700-4f80-a71d-62ab6086193f"
             id="2cd31372-3700-4f80-a71d-62ab6086193f"/>
           <port_mirroring>false</port_mirroring>
       </vnic_profile>
       <vnic_profile
         href="/ovirt-engine/api/vnicprofiles/8938f00f-6108-4196-aa86-f8f6721f4367"
         id="8938f00f-6108-4196-aa86-f8f6721f4367">
           <name>ovirtmgmt</name>
           <link 
            href="/ovirt-engine/api/vnicprofiles/8938f00f-6108-4196-aa86-f8f6721f4367/permissions"
            rel="permissions"/>
           <network
            href="/ovirt-engine/api/networks/2cd31372-3700-4f80-a71d-62ab6086193f"
            id="2cd31372-3700-4f80-a71d-62ab6086193f"/>
           <port_mirroring>false</port_mirroring>
       </vnic_profile>
   </vnic_profiles>
```

## Change Nic Profile for a specific VM

Use the Put method to change the VM’s nic profile at `http://yourServer:port/ovirt-engine/api/vms/specificVmId/nics/specificNicID`

Add a header for using xml: Content-Type: application/xml

Add a body(data) with your desired profile(taken from the list above): For example:
```xml
<nic>
<vnic_profile
    href="/ovirt-engine/api/vnicprofiles/874a3706-62af-40ca-9c0e-7d1a1e92ae02"
    id="874a3706-62af-40ca-9c0e-7d1a1e92ae02"> </vnic_profile>
</nic>
```

An example using CURL client:

    cat update.txt

```xml
    <nic>
    <vnic_profile
        href="/ovirt-engine/api/vnicprofiles/874a3706-62af-40ca-9c0e-7d1a1e92ae02"
        id="874a3706-62af-40ca-9c0e-7d1a1e92ae02"> </vnic_profile>
    </nic>
```
    curl -v -u admin@internal:1 -H Content-type: application/xml \
    -T update.txt GET http://localhost:8080/ovirt-engine/api/vms/f971c08b-53b6-433a-8b95-e7e1b6f47369/nics/141e8418-4f1e-4e64-8ed5-0257844b7905

```xml
    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
    <nic
      href="/ovirt-engine/api/vms/f971c08b-53b6-433a-8b95-e7e1b6f47369/nics/141e8418-4f1e-4e64-8ed5-0257844b7905"
      id="141e8418-4f1e-4e64-8ed5-0257844b7905">
        <actions>
            <link
                href="/ovirt-engine/api/vms/f971c08b-53b6-433a-8b95-e7e1b6f47369/nics/141e8418-4f1e-4e64-8ed5-0257844b7905/deactivate"
                rel="deactivate"/>
            <link
                href="/ovirt-engine/api/vms/f971c08b-53b6-433a-8b95-e7e1b6f47369/nics/141e8418-4f1e-4e64-8ed5-0257844b7905/activate"
                rel="activate"/>
        </actions>
        <name>vmNic</name>
        <link
            href="/ovirt-engine/api/vms/f971c08b-53b6-433a-8b95-e7e1b6f47369/nics/141e8418-4f1e-4e64-8ed5-0257844b7905/statistics"
            rel="statistics"/>
        <vm
            href="/ovirt-engine/api/vms/f971c08b-53b6-433a-8b95-e7e1b6f47369"
            id="f971c08b-53b6-433a-8b95-e7e1b6f47369"/>
        <network
            href="/ovirt-engine/api/networks/2cd31372-3700-4f80-a71d-62ab6086193f"
            id="2cd31372-3700-4f80-a71d-62ab6086193f"/>
        <linked>true</linked>
        <interface>virtio</interface>
        <mac address="00:01:a4:a7:45:72"/>
        <active>true</active>
        <plugged>true</plugged>
        <vnic_profile
            href="/ovirt-engine/api/vnicprofiles/874a3706-62af-40ca-9c0e-7d1a1e92ae02"
            id="874a3706-62af-40ca-9c0e-7d1a1e92ae02"/>
    </nic>
```
