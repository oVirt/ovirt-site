---
title: ApiDataCenterNetworks
category: feature
authors: rnori
---

# Api Data Center Networks

## API Networks Subcollection Under Data Center

### Summary

"Api Data Center Networks" provides a way to add, delete, retrieve and update the networks attached to a data center using rest api.

### Owner

*   Name: Ravi Nori (RNori)

### Current status

*   Currently merged (http://gerrit.ovirt.org/#/c/11707)

### Detailed Description

Adds new api rest end points to retrieve and maniplutale the networks attached to a data center.

The following are the list of new rest end points

1.  List All Networks attached to a data center:
    ```console
    wget -O - --auth-no-challenge --http-user=admin@internal --http-passwd='<password>' head='Accept: application/xml' http://127.0.0.1:8080/api/datacenters/<data-center-id>/networks
    ```

2.  List Details of a Network attached to a data center:
    ```console
    wget -O - --auth-no-challenge --http-user=admin@internal --http-passwd='<password>' head='Accept: application/xml' http://127.0.0.1:8080/api/datacenters/<data-center-id>/networks/<network-id>
    ```

3.  Add new network to Data Center:
    ```console
    curl -X POST --data '<network><name>test2</name></network>' -u admin@internal:<password> -H "Accept: application/xml" -H "Content-Type: application/xml" http://127.0.0.1:8080/api/datacenters/<data-center-id>/networks
    ```

4.  Update a network attached to a data center:
    ```console
    curl -X PUT --data '<network><name>test_update</name></network>' -u admin@internal:<password> -H "Accept: application/xml" -H "Content-Type: application/xml" http://127.0.0.1:8080/api/datacenters/<data-center-id>/networks/<network-id>
    ```

5.  Delete a network attached to a datacenter:
    ```console
    curl -X DELETE -u admin@internal:<passwd> -H "Accept: application/xml" -H "Content-Type: application/xml" http://127.0.0.1:8080/api/datacenters/<data-center-id>/networks/<network-id>
    ```
