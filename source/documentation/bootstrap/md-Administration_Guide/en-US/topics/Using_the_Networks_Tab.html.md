# Using the Networks Tab

The **Networks** resource tab provides a central location for users to perform logical network-related operations and search for logical networks based on each network's property or association with other resources.

All logical networks in the Red Hat Virtualization environment display in the results list of the **Networks** tab. The **New**, **Edit** and **Remove** buttons allow you to create, change the properties of, and delete logical networks within data centers.

Click on each network name and use the **Clusters**, **Hosts**, **Virtual Machines**, **Templates**, and **Permissions** tabs in the details pane to perform functions including:

* Attaching or detaching the networks to clusters and hosts

* Removing network interfaces from virtual machines and templates

* Adding and removing permissions for users to access and manage networks

These functions are also accessible through each individual resource tab.

**Warning:** Do not change networking in a data center or a cluster if any hosts are running as this risks making the host unreachable.

**Important:** If you plan to use Red Hat Virtualization nodes to provide any services, remember that the services will stop if the Red Hat Virtualization environment stops operating.

This applies to all services, but you should be especially aware of the hazards of running the following on Red Hat Virtualization:

* Directory Services

* DNS

* Storage
