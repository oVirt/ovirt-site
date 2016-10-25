---
title: Subclusters in oVirt 4.0 - Label-Based VM to Host Affinity
author: msivak
tags: community, documentation, infrastructure
date: 2016-07-25 15:00:00 CEST
comments: true
published: true
---

Before I start discussing the feature itself I have to explain a bit about the use cases that we were trying to solve.

* Let us imagine you have a special piece of software with a node-licensing model that only cares about physical machines when counting the number of licenses needed. This specifically allows you to run that software in virtual machines, but you need to control the physical host on which the VMs are running.

* The other case is basically related to hardware capabilities. Some NICs might be faster than others and you want to place all high traffic VMs on hosts that have them. Or a special custom device is needed and VMs that need it won’t run on a host that does not have it.

READMORE

Both cases follow the same basic scenario: There is a small subset of VMs that need a special capability (license, device), but there are not enough of them to fully utilize a separate cluster. To achieve efficient utilization of your cluster, you need to add many common VMs with no special needs and some hosts to handle the full load. But… how do you keep the special VMs from migrating to the hosts without the special capabilities?

We already had [VM to host pinning](http://www.ovirt.org/documentation/admin-guide/administration-guide/#affinity-groups) that allowed limiting VM placement to [single or multiple hosts](http://www.ovirt.org/develop/release-management/features/vmpinningtomultiplehosts/), but with no migration enabled for that VM. Our team also just implemented a new feature that allows you to define pinning and still keep migration enabled. Affinity labels allow you to take a subset of hosts and attach a label to them. Any VM with the same affinity label will be then constrained to the labeled hosts. Standard VMs with no labels won’t notice anything and will still happily run anywhere according to the normal oVirt scheduling rules.

Now the bad news, there is no edit enabled user interface for now and all changes need to be done using the oVirt engine REST API. We have a development version of read only view for host and VM to affinity label assignments for getting a quick overview of the configuration and we plan to have full fledged UI in the future.

The rest of this post will show you how to implement an example setup with three groups of hosts: webserver, storage and applications:

![Example affinity groups layout](/images/affinity-label-example-diagram.png)

I will be using my local server `localhost:8080`, `curl`, `jq`, and a specially crafted shell alias to avoid repeating the login and content type parameters in every example call. Tweak the admin@internal user and letmein password to match the user you will be using. Please note that if you are not using the admin account then you need to make sure the user has the *TagManager* permissions.

```
alias cengine='curl -s -u admin@internal:letmein -H "Content-Type: application/json" -H "Accept: application/json"'
```

## Creating and Updating a Label

Creating a new affinity label is a straightforward operation, just send a POST request to the right endpoint while saving the ID to a variable:

```
$ STORAGELABEL=$(cengine -f -X POST -d '{"name": "test"}' http://localhost:8080/ovirt-engine/api/affinitylabels | jq -r '.id'); echo $STORAGELABEL

cc8bcf08-bc78-40e9-a01a-38a0fe99ea26
```

Operations for listing all labels and updating a label’s name are also supported, of course:

```
cengine -f http://localhost:8080/ovirt-engine/api/affinitylabels | jq -r '.affinity_label[] | {id, name}'

{
  "id": "cc8bcf08-bc78-40e9-a01a-38a0fe99ea26",
  "name": "test"
}

cengine -X PUT -d '{"name": "storage_subcluster"}' http://localhost:8080/ovirt-engine/api/affinitylabels/$STORAGELABEL | jq -r '{id, name}'

{
  "id": "cc8bcf08-bc78-40e9-a01a-38a0fe99ea26",
  "name": "storage_subcluster"
}
```

## Attaching Hosts and VMs to a Label

Affinity labels reference all labeled objects using their id, although the API accepts the full object representation. It will ignore all fields except id, though. There are two ways to manipulate affinity label assignments to hosts and VMs:

- Posting the host or VM to the proper affinity label subcollection
- Posting the affinity label to the host’s or VM’s affinitylabels subcollection

We need some VMs and Hosts for the following examples so create hosts red, green, and blue as well as some VMs: webserver, storage, application1, and application2.

I will now show you how to express the following rules using the affinity labels:

- Webserver VM should be allowed to run anywhere
- Storage VM should be restricted to host red (special HBA card maybe?)
- Application VMs should be restricted to hosts red and blue (as you have license for two physical nodes, for example)

We will first attach the storage VM and the red host to the already created storage_subcluster affinity label:

```
$ cengine -f -X POST -d "{\"id\": \"$REDHOSTID\"}" http://localhost:8080/ovirt-engine/api/affinitylabels/$STORAGELABEL/hosts | jq -r '.status'

complete

$ cengine -f -X POST -d "{\"id\": \"$STORAGEVMID\"}" http://localhost:8080/ovirt-engine/api/affinitylabels/$STORAGELABEL/vms | jq -r '.status'

complete
```

Now we can create the application affinity group and attach the necessary hosts and VMs:

```
$ APPLABEL=$(cengine -f -X POST -d '{"name": "app_subcluster"}' http://localhost:8080/ovirt-engine/api/affinitylabels | jq -r '.id'); echo $APPLABEL

d7d91849-262d-4274-bb47-3ad711566fc7

$ for host in $REDHOSTID $BLUEHOSTID; do cengine -f -X POST -d "{\"id\": \"$APPLABEL\"}" http://localhost:8080/ovirt-engine/api/hosts/$host/affinitylabels | jq -r '.status'; done

completed
completed

$ for vm in $APP1VMID $APP2VMID; do cengine -f -X POST -d "{\"id\": \"$APPLABEL\"}" http://localhost:8080/ovirt-engine/api/vms/$vm/affinitylabels | jq -r '.status'; done

completed
completed
```

## Deleting Labels or Assignments

That concludes the setup. You can use a standard REST DELETE call in case you need to remove a label to host assignment (just replace hosts with VMs to make it work for label to VM assignments):

```
cengine -f -X DELETE http://localhost:8080/ovirt-engine/api/hosts/$hostid/affinitylabels/$labelid | jq -r '.status'
```

or

```
cengine -f -X DELETE http://localhost:8080/ovirt-engine/api/affinitylabels/$labelid/hosts/$hostid | jq -r '.status'
```

## The Result

The situation now is as described at the beginning, and will be obeyed during VM startups and VM migrations.

```
$ cengine -f http://localhost:8080/ovirt-engine/api/affinitylabels | jq -r '.affinity_label[] | {id, name, vms, hosts}'

{
  "id": "cc8bcf08-bc78-40e9-a01a-38a0fe99ea26",
  "name": "storage_subcluster",
  "vms": {
    "vm": [
      {“id": "bd6e32cd-1df5-4c5c-a44e-371371e44168"}
    ]
  },
  "hosts": {
    "host": [
      {"id": "4d711089-a3e3-45b7-935a-dc66c4c4ccef"}
    ]
  }
}
{
  "id": "d7d91849-262d-4274-bb47-3ad711566fc7",
  "name": "app_subcluster",
  "vms": {
    "vm": [
      {"id": "a98d58ee-73e4-40be-95f8-bf360e646473"},
      {"id": "7506d8f9-7b40-4ee2-85be-6a7b02024729"}
    ]
  },
  "hosts": {
    "host": [
      {"id": "e2715dfc-5e21-45c1-9e9e-c2d316dc51dd"},
      {"id": "4d711089-a3e3-45b7-935a-dc66c4c4ccef"}
    ]
  }
}
```

I hope this new feature will be useful for you, and should you have any questions, do not hesitate to ask on [users@ovirt.org](mailto:users@ovirt.org).
