---
title: Architecture
category: architecture
authors: abonas, alonbl, amuller, dneary, geoffoc, lhornyak, ovedo, sven, vszocs
---

![](/images/wiki/Ovirt-1024x698.png "Ovirt-1024x698.png")

# oVirt Architecture

A standard oVirt deployment consists of three things, primarily:

*   ovirt-engine which is used use to deploy, monitor, move, stop and create VM images, configure storage, network , etc.
*   One or more hosts (nodes), on which we run virtual machines (VMs)
*   One or more storage nodes, which hold the images and ISOs corresponding to those VMs

Also, usually an identity service is deployed aside the engine, to authenticate users and administrators for ovirt-engine.

The nodes are Linux distributions with VDSM and libvirt installed, along with some extra packages to easily enable virtualization of networking and other system services. The supported Linux distributions to date are Fedora 17 or oVirt-node, which is basically a stripped-down distribution containing just enough components to allow virtualization.

The storage nodes can use block or file storage, and can be local or remote, accessed via NFS. Storage technologies like Gluster are supported through the POSIXFS storage type. Storage nodes are grouped into storage pools, which can ensure high availability and redundancy. The [Vdsm Storage Terminology](Vdsm Storage Terminology) page has more details.

The different diagrams and descriptions below represent the architecture of the oVirt project, and its different components.

## Overall architecture

The following diagram shows the different components in the oVirt project:

![](/images/wiki/Architecture.png "Architecture.png")

These main components are:

1.  Engine (ovirt-engine) - manages the oVirt hosts, and allows system administrators to create and deploy new VMs
2.  Admin Portal - web based UI application on top of the engine, that sysadmins use to perform advanced actions.
3.  User Portal - a simplified web based UI application for simpler management use-cases.
4.  REST API - an API which allows applications to perform virtualization actions, which is used by the command line tools and the python SDK
5.  CLI/SDK - The command line interface and SDK provide a way to communicate with engine via script actions.
6.  Database - Postgres database is used by the engine to provide persistency for the configuration of the ovirt deployment.
7.  Host agent (VDSM) - the oVirt engine communicates with VSDM to request VM related actions on the nodes
8.  Guest Agent - The guest agent runs inside the VM, and provides information on resource usage to the oVirt engine. Communication is done over a virtualised serial connection.
9.  AD/IPA - directory services. Engine uses them to receive information on users and groups to be used with ovirt's permissions mechanism.
10. DWH (Data Warehouse) - The data warehouse component performs ETL on data extracted from the db using Talend , and inserts it to history DB.
11. Reports Engine - generates reports based on data in history DB, on system resource usage, using Jasper Reports
12. SPICE client - utility which allows users to access the VMs.

The sections below will give a description and architectural aspects for each such component.

## Engine

oVirt engine is a JBoss-based Java application (previously C#) which runs as a web service. This service talks directly to VDSM on the hosts to deploy, start, stop, migrate and monitor VMs, and it can also create new images on storage from templates.

It is a large scale, centralized management for server and desktop virtualization, based on leading performance, scalability and security infrastructure technologies.

Some features provided by the engine:

1.  VM lifecycle management
2.  Authentication via [Features/AAA](Features/AAA)
3.  Network management - adding logical networks, and attaching them to hosts
4.  Storage management - managing storage domains (NFS/iSCSI/Local), and virtual VM disks
5.  High Availability - restart guest VMs from failed hosts automatically on other hosts
6.  Live Migration - move running VM between hosts with zero downtime
7.  System Scheduler - continuously load balance VMs based on resource usage/policies
8.  Power Saver - concentrate virtual machines on fewer servers during off-peak hours
9.  Maintenance Manager - no downtime for virtual machines during planned maintenance windows.
10. Image Management - template based provisioning, thin provisioning and snapshots
11. Monitoring - for all objects in system – VM guests, hosts, networking, storage etc.
12. Export/Import - import and export VMs and templates using OVF files
13. V2V - convert VMs from VMware and RHEL/Xen environments to the oVirt environment

The following diagram shows the different layers in the oVirt engine component:

![](/images/wiki/Engine-arch.png "Engine-arch.png")

### Engine-Core Architecture

The following diagram shows the different components in the engine-core:

![](/images/wiki/Engine-arch2.png "Engine-arch2.png")

The main components in the engine core are:

*   DB Broker - responsible for all the DB related actions
*   VDS Broker - responsible for all actions that require communicating with VDSM
*   LDAP Broker - obsoleted and not used
*   Backend Bean - a Singleton bean responsible for running actions, queries and monitoring of the different entities

## Host Agent (VDSM)

VDSM is a component developed in Python, which covers all functionality required by oVirt Engine for host, VM, networking and storage management.

1.  The VDSM API is XML-RPC based (planned to move to REST API). This is how ovirt-engine communicates with VDSM.
2.  Configures host, networking and shared storage
3.  Uses libvirt for VM life cycle operations
4.  Multithreaded, multi-processes
5.  Speaks with its guest agent via virtio-serial
6.  Adds customized clustering support for LVM that scales to hundreds of nodes
7.  Implements a distributed image repository over the supported storage types (local directory, FCP, FCoE, iSCSI, NFS, SAS)
8.  Multihost system, one concurrent metadata writer
9.  Scales linearly in data writers

![](/images/wiki/Vdsm-arch.png "Vdsm-arch.png")

### Hooks mechanism

1.  Allows administrators to define scripts to modify VM operation eg. Add extra options such as CPU pinning, watchdog device, direct LUN access, etc.
2.  Allows oVirt to be extended for new KVM features before full integration is done
3.  An easy way to test a new kvm/libvirt/linux feature
4.  The hook mechanism is called before VDSM initiates the VM startup using libvirt.
5.  The hook changes the VM definition, and VDSM passes this definition to libvirt to start the VM.

The following diagram illustrates the Hook mechanism in the VM lifetime cycle:

![](/images/wiki/Hook-arch.png "Hook-arch.png")

### MOM integration

![ [MoM](MoM) Integration diagram with [VDSM](VDSM) ](/images/wiki/Mom-vdsm.png " MoM Integration diagram with VDSM ")

VDSM is integrated with [MoM](MoM). The behavior of MOM is configured with policies. With these policies users can fine tune the host for high memory overcommit or safe operation. In order to control its mom instance, vdsm does ship a mom configuration file and a mom policy file that sets mom's default behavior. At startup, vdsmd imports mom and initializes it with the configuration and policy files. From that point on, mom interacts with vdsm through the well-defined API in API.py and is controlling the memory balloons of each VM running on the host. The MOM Instance runs as a thread within the vdsm daemon.

## Web-based User Interface

Following diagram provides a high level overview of oVirt user interface architecture:

![](/images/wiki/Ovirt-ui-architecture.png "Ovirt-ui-architecture.png")

*   [Google Web Toolkit](http://www.gwtproject.org/overview.html): Java-based SDK providing tools and APIs for building web applications
*   [GWT Platform](https://github.com/ArcBees/GWTP): [Model-View-Presenter](http://en.wikipedia.org/wiki/Model_View_Presenter) framework following GWT [best](http://www.gwtproject.org/articles/mvp-architecture.html) [practices](http://www.gwtproject.org/articles/mvp-architecture-2.html) ([slides](http://courses.coreservlets.com/Course-Materials/pdf/ajax/GWT-MVP-Intro.pdf))
*   [GWT INjection](http://code.google.com/p/google-gin/wiki/GinTutorial): [dependency injection](http://en.wikipedia.org/wiki/Dependency_injection) framework for GWT
*   oVirt GWT-Common: module housing common components such as widgets, abstract and infra-level classes, etc.
*   [oVirt UI Plugins](UIPlugins): feature allowing WebAdmin UI to be extended by JavaScript-based plugins at runtime

Following diagram shows a typical GWT development workflow:

![](/images/wiki/Gwt-development-workflow.png "Gwt-development-workflow.png")

oVirt UI is designed around following concepts:

*   web browser as application platform, capable of delivering rich user experience through JavaScript-based applications
*   dependency injection and event bus to employ loosely-coupled component architecture
*   Model-View-Presenter for clean separation between presentation (View) and related business logic (Presenter)

## REST API

RESTful API for integration with oVirt Engine:

1.  REST interface exposed for all API functions
2.  REST stands for REpresentational State Transfer
3.  Modeling entity actions around HTTP verbs
    -   GET
    -   PUT
    -   POST
    -   DELETE

4.  Still uses 'actions' for some state changes
5.  Self describes – entity navigation and actions

REST Concepts:

1.  Client–server
2.  Stateless
3.  Cacheable
4.  Uniform interface

## CLI/SDK

CLI and SDK are using on the REST api mentioned above.

SDK:

1.  Python based SDK to allow performing actions on the different entities
2.  Complete protocol abstraction
3.  Full compliance with the oVirt API architecture
4.  Auto-completion
5.  Self descriptive
6.  Intuitive and easy to use
7.  Auto-Generated

CLI:

1.  Python based CLI to allow querying and performing actions on the different entities
2.  Complete protocol abstraction
3.  Full compliance with the oVirt API architecture
4.  Highly descriptive help for each operation
5.  Intuitive and easy to use
6.  Auto-Generated

## Reports Engine

1.  Based on Jasper Reports
2.  Jasper allows to import/export reports definitions
3.  Rich reporting engine
    -   Report scheduling
    -   Filters
    -   Export to various formats
    -   Report creation studio

## DWH

The DWH (data warehouse) component contains:

1.  ETL based on talendforge.org
2.  Periodic polling from operational DB
3.  Types of data
    -   Config with version tracking
    -   Statistics – aggregated hourly/daily

4.  API is view based

## Guest Agent

The guest agent provides additional information to oVirt Engine, such as guest memory usage, guest ip address, installed applications and sso.

Architectural details:

1.  Python code, available for both linux and windows guests
2.  Communication is done over virtio-serial
3.  SSO for windows is based on a gina module for XP and a credential provider for windows 7
4.  SSO for RHEL 6 is based on a PAM module with support for both KDE and Gnome

![](/images/wiki/Guest-agent-arch.png "Guest-agent-arch.png")

