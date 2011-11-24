---
title: SDK
authors: apuimedo, mgoldboi, michael pasternak
wiki_title: SDK
wiki_revision_count: 66
wiki_last_updated: 2012-12-02
---

oVirt SDK package a software development kit for the oVirt engine api.

[Notes from workshop in November 2011](API - oVirt workshop November 2011 Notes).

__TOC__

# SDK Concepts

*   Complete protocol abstraction.
*   Full compliance with the oVirt api architecture.
*   Auto-completion.
*   Self descriptive.
*   Intuitive and easy to use.
*   Auto-Generated

# Examples

from ovirtsdk.api import API from ovirtsdk.xml import params

*   create proxy

api = API(url='[http://host:port](http://host:port)', username='user@domain', password='password')

*   list entities

vms1 = api.vms.list()

*   list entities using query

vms2 = api.vms.list(query='name=python_vm')

*   search vms by property constraint

vms3 = api.vms.list(memory=1073741824)

*   update resource

vm1 = api.vms.get(name='python_vm')

vm1.description = 'updated_desc'

vm2 = vm1.update()

*   list by constraints

vms4 = api.vms.list(name='pythond_sdk_poc2')

*   get by name

vm4 = api.vms.get(name='pythond_sdk_poc2')

*   get by constraints

vm5 = api.vms.get(id='02f0f4a4-9738-4731-83c4-293f3f734782')

*   add resource

cluster = params.Cluster(name='Default_iscsi')

template = params.Template(name='Template2_iscsi')

param = params.VM(name='pythond_sdk_poc2', cluster=cluster, template=template, memory=1073741824)

vm6 = api.vms.add(param)

*   add sub-resource to resource

network = params.Network(name='rhevm')

nic = params.NIC(name='eth0', network=network, interface='e1000')

vm6.nics.add(nic)

*   list sub-resources

nics1 = vm6.nics.list()

*   list sub-resources using constraint/s

nics2 = vm6.nics.list(name='eth0')

nics3 = vm6.nics.list(interface='e1000')

*   get sub-resource

nic1 = vm6.nics.get(name='eth0')

*   update sub-resource

nic1.name = 'eth01'

nic2 = nic1.update()

nic3 = vm6.nics.get(name='eth01')

nic4 = vm6.nics.get(name='eth0')

--

Michael Pasternak RedHat, ENG-Virtualization R&D

<Category:SDK>
