---
title: oVirt Introduction to the Administration Portal
---

# oVirt Introduction to the Administration Portal

## Using the Administration Portal

### oVirt Engine Client Requirements

The following browser versions and operating systems can be used to access the Administration Portal and the User Portal.

Browser support is divided into tiers:

* Tier 1: Browser and operating system combinations that are fully tested.

* Tier 2: Browser and operating system combinations that are partially tested, and are likely to work.

* Tier 3: Browser and operating system combinations that are not tested, but may work.

**Browser Requirements**

| Support Tier | Operating System Family | Browser | Portal Access |
|-
| Tier 1 | Enterprise Linux | Mozilla Firefox Extended Support Release (ESR) version | Administration Portal and User Portal |
| Tier 2 | Windows | Internet Explorer 10 or later | Administration Portal and User Portal |
|        | Any | Most recent version of Google Chrome or Mozilla Firefox | Administration Portal and User Portal |
| Tier 3 | Any | Earlier versions of Google Chrome or Mozilla Firefox | Administration Portal and User Portal |
|        | Any | Other browsers | Administration Portal and User Portal |

Virtual machine consoles can only be accessed using supported Remote Viewer (`virt-viewer`) clients on Enterprise Linux and Windows. To install `virt-viewer`, see "Installing Supported Components" in the [Virtual Machine Management Guide](/documentation/vmm-guide/Virtual_Machine_Management_Guide/). Installing `virt-viewer` requires Administrator privileges.

SPICE console access is only available on other operating systems, such as OS X, through the unsupported SPICE HTML5 browser client.

Supported QXL drivers are available on Enterprise Linux machines, Windows XP and Windows 7 machines.

SPICE support is divided into tiers:

* Tier 1: Operating systems on which remote-viewer has been fully tested.

* Tier 2: Operating systems on which remote-viewer is partially tested and is likely to work.

**Client Operating System SPICE Support**

| Support Tier | Operating System | SPICE Support |
|-
| Tier 1 | Enterprise Linux 7 | Fully supported on Enterprise Linux 7.2 and above |
|        | Microsoft Windows 7        | Fully supported on Microsoft Windows 7 |
| Tier 2 | Microsoft Windows 8        | Supported when spice-vdagent is running on these guest operating systems |
|        | Microsoft Windows 10       | Supported when spice-vdagent is running on these guest operating systems |

### Graphical User Interface Elements

The oVirt Administration Portal consists of contextual panes and menus and can be used in two modes - tree mode, and flat mode. Tree mode allows you to browse the object hierarchy of a data center while flat mode allows you to view all resources across data centers in a single list.

**Key Graphical User Interface Elements**

![](/images/intro-admin/7336.png)

**Key Graphical User Interface Elements**

* ![Header](/images/intro-admin/172.png)

    The header bar contains the name of the currently logged in user, the **Sign Out** button, the **About** button, the **Configure** button, and the **Guide** button. The **About** shows information on the version of oVirt, the **Configure** button allows you to configure user roles, and the **Guide** button provides a shortcut to the [oVirt Administration Guide](/documentation/admin-guide/administration-guide/).

* ![Search Bar](/images/intro-admin/173.png)

    The search bar allows you to build queries for finding resources such as hosts and clusters in the oVirt environment. Queries can be as simple as a list of all the hosts in the system, or more complex, such as a list of resources that match certain conditions. As you type each part of the search query, you are offered choices to assist you in building the search. The star icon can be used to save the search as a bookmark.

* ![Resource Tabs](/images/intro-admin/174.png)

    All resources can be managed using their associated tab. Moreover, the **Events** tab allows you to view events for each resource. The Administration Portal provides the following tabs: **Dashboard**, **Data Centers**, **Clusters**, **Hosts**, **Networks**, **Storage**, **Disks**, **Virtual Machines**, **Pools**, **Templates**, **Volumes**, **Users**, and **Events**.

* ![Results List](/images/intro-admin/175.png)

    You can perform a task on an individual item, multiple items, or all the items in the results list by selecting the items and clicking the relevant action button. Information on a selected item is displayed in the details pane.

* ![Details Pane](/images/intro-admin/176.png)

    The details pane shows detailed information about a selected item in the results list. If no items are selected, this pane is hidden. If multiple items are selected, the details pane displays information on the first selected item only.

* ![System/Bookmarks/Tags Pane](/images/intro-admin/177.png)

    The system pane displays a navigable hierarchy of the resources in the virtualized environment. Bookmarks are used to save frequently used or complicated searches for repeated use. Bookmarks can be added, edited, or removed. Tags are applied to groups of resources and are used to search for all resources associated with that tag. The System/Bookmarks/Tags Pane can be minimized using the arrow in the upper right corner of the panel.

* ![Alerts/Events Pane](/images/intro-admin/178.png)

    The **Alerts** tab lists all high severity events such as errors or warnings. The **Events** tab shows a list of events for all resources. The **Tasks** tab lists the currently running tasks. You can view this panel by clicking the maximize/minimize button.

* ![Refresh Rate](/images/intro-admin/5114.png)

    The refresh rate drop-down menu allows you to set the time, in seconds, between Administration Portal refreshes. To avoid the delay between a user performing an action and the result appearing the portal, the portal will automatically refresh upon an action or event regardless of the chosen refresh interval. You can set this interval by clicking the refresh symbol in top right of the portal.

### Tree Mode and Flat Mode

The Administration Portal provides two different modes for managing your resources: tree mode and flat mode. Tree mode displays resources in a hierarchical view per data center, from the highest level of the data center down to the individual virtual machine. Working in tree mode is highly recommended for most operations.

**Tree Mode**

![](/images/intro-admin/6127.png)

Flat mode allows you to search across data centers, or storage domains. It does not limit you to viewing the resources of a single hierarchy. For example, flat mode makes it possible to find all virtual machines that are using more than 80% CPU across clusters and data centers, or locate all hosts that have the highest utilization. In addition, certain objects, such as **Pools** and **Users** are not in the data center hierarchy and can be accessed only in flat mode.

To access flat mode, click on the **System** item in the **Tree** pane on the left side of the screen. You are in flat mode if the **Pools** and **Users** resource tabs appear.

**Flat Mode**

![](/images/intro-admin/6128.png)

### Using the Guide Me Facility

When setting up resources such as data centers and clusters, a number of tasks must be completed in sequence. The context-sensitive **Guide Me** window prompts for actions that are appropriate to the resource being configured. The **Guide Me** window can be accessed at any time by clicking the **Guide Me** button on the resource toolbar.

**New Data Center Guide Me Window**

![](/images/intro-admin/251.png)

### Performing Searches in oVirt

The Administration Portal enables the management of thousands of resources, such as virtual machines, hosts, users, and more. To perform a search, enter the search query (free-text or syntax-based) into the search bar. Search queries can be saved as bookmarks for future reuse, so you do not have to reenter a search query each time the specific search results are required. Searches are not case sensitive.

### Saving a Query String as a Bookmark

A bookmark can be used to remember a search query, and shared with other users.

**Saving a Query String as a Bookmark**

1. Enter the desired search query in the search bar and perform the search.

2. Click the star-shaped **Bookmark** button to the right of the search bar to open the **New Bookmark** window.

    **Bookmark Icon**

    ![](/images/intro-admin/6129.png)

3. Enter the **Name** of the bookmark.

4. Edit the **Search string** field (if applicable).

5. Click **OK** to save the query as a bookmark and close the window.

6. The search query is saved and displays in the **Bookmarks** pane.

You have saved a search query as a bookmark for future reuse. Use the **Bookmark** pane to find and select the bookmark.
