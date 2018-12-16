---
title: Using the Administration Portal
---

# Using the Administration Portal

## What is the Administration Portal

The Administration Portal is the graphical administration interface of the oVirt Engine server. Administrators can monitor, create, and maintain all elements of the virtualized environment from web browsers. Tasks that can be performed from the Administration Portal include:

* Creation and management of virtual infrastructure (networks, storage domains)

* Installation and management of hosts

* Creation and management of logical entities (data centers, clusters)

* Creation and management of virtual machines

* oVirt user and permission management

## Browser Requirements

The following browser versions and operating systems can be used to access the Administration Portal and the VM Portal.

Browser support is divided into tiers:

* Tier 1: Browser and operating system combinations that are fully tested.

* Tier 2: Browser and operating system combinations that are partially tested, and are likely to work.

* Tier 3: Browser and operating system combinations that are not tested, but may work.

**Browser Requirements**

| Support Tier | Operating System Family | Browser |
|-
| Tier 1 | Enterprise Linux | Mozilla Firefox Extended Support Release (ESR) version |
| Tier 2 | Windows | Internet Explorer 11 or later |
|        | Any | Most recent version of Google Chrome or Mozilla Firefox |
| Tier 3 | Any | Earlier versions of Google Chrome or Mozilla Firefox |
|        | Any | Other browsers |

## Client Requirements

Virtual machine consoles can only be accessed using supported Remote Viewer (`virt-viewer`) clients on Enterprise Linux and Windows. To install `virt-viewer`, see "Installing Supported Components" in the [Virtual Machine Management Guide](/documentation/vmm-guide/Virtual_Machine_Management_Guide/). Installing `virt-viewer` requires Administrator privileges.

Virtual machine consoles are accessed through the SPICE protocol. The QXL graphical driver can be installed in the guest operating system for improved/enhanced SPICE functionalities. SPICE currently supports a maximum resolution of 2560x1600 pixels.

Supported QXL drivers are available on Enterprise Linux machines, Windows XP and Windows 7 machines.

SPICE support is divided into tiers:

* Tier 1: Operating systems on which remote-viewer has been fully tested.

* Tier 2: Operating systems on which remote-viewer is partially tested and is likely to work.

**Client Operating System SPICE Support**

| Support Tier | Operating System |
|-
| Tier 1 | Enterprise Linux 7.2 and later |
|        | Microsoft Windows 7        |
| Tier 2 | Microsoft Windows 8        |
|        | Microsoft Windows 10       |

### Graphical User Interface Elements

The oVirt Administration Portal consists of contextual panes and menus and can be used in two modes - tree mode, and flat mode. Tree mode allows you to browse the object hierarchy of a data center while flat mode allows you to view all resources across data centers in a single list.

**Key Graphical User Interface Elements**

![](/images/intro-admin/AdminPortal.png)

**Key Graphical User Interface Elements**

* ![Header](/images/intro-admin/172.png) Header Bar

    The header bar contains the name of the currently logged in user, the **Sign Out** button, the **About** button, the **Configure** button, and the **Guide** button. The **About** shows information on the version of oVirt, the **Configure** button allows you to configure user roles, and the **Guide** button provides a shortcut to the [oVirt Administration Guide](/documentation/admin-guide/administration-guide/).

* [Main Navigation Menu](/images/intro-admin/173.png) Main Navigation Menu

    The main navigation menu allows you to view the resources of the oVirt environment.

* ![Search Bar](/images/intro-admin/174.png) Search Bar

    The search bar allows you to build queries for finding resources such as hosts and clusters in the oVirt environment. Queries can be as simple as a list of all the hosts in the system, or more complex, such as a list of resources that match certain conditions. As you type each part of the search query, you are offered choices to assist you in building the search. The star icon can be used to save the search as a bookmark.

* ![Refresh Rate Button](/images/intro-admin/175.png) Refresh Rate Button

    The Refresh Rate drop-down button allows you to set the time, in seconds, between Administration Portal refreshes. To avoid the delay between a user performing an action and the result appearing the portal, the portal will automatically refresh upon an action or event regardless of the chosen refresh interval. You can set this interval by clicking the refresh symbol in top right of the portal.

* ![Results List](/images/intro-admin/176.png) Results List

    You can perform a task on an individual item, multiple items, or all the items in the results list by selecting the items and clicking the relevant action button.

    You can display or hide table columns in the results list. To do this, right-click any table heading to display the column control menu, and select or deselect the appropriate heading title. The column control menu can also be used to rearrange the order of columns by dragging and dropping the column to the required position within the menu.

    Click the name of a resource to go to its details view.

* ![More Actions Button](/images/intro-admin/177.png) More Actions Button

    You can use the More Actions button to perform additional tasks.

### Using the Guide Me Facility

When setting up resources such as data centers and clusters, a number of tasks must be completed in sequence. The context-sensitive **Guide Me** window prompts for actions that are appropriate to the resource being configured. The **Guide Me** window can be accessed at any time by clicking the **More Action** &rarr; **Guide Me** button on the resource toolbar.

**New Data Center Guide Me Window**

![](/images/intro-admin/GuideMe.png)

**Next:** [Chapter 2: Searches](chap-searches)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/introduction_to_the_administration_portal/chap-using_the_administration_portal)
