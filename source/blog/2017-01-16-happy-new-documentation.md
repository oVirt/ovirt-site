---
title: Happy New Documentation!
author: bkp
tags: community, documentation, howto
date: 2017-01-16 14:55:00 CET
comments: true
published: true
---

The oVirt Project is pleased to announce the availability of [all-new principal documentation](/documentation/) for the oVirt 4.0 branch.

There are many people out there who are content to use software without documentation, preferring to muddle through the software based on past experience with similar software or just the desire to put the software through its paces.

We all do this; I could not tell you the last time I looked at documentation for Firefox or Chrome, because I've been using browsers for over 20 years and seriously, what else is there to learn? Until I learn about a cool new feature from a friend or a web site.

READMORE

In a software community project, one of the biggest things a community must do is to provide proper onboarding to the project's result. This means:

* Explaining what the software is

* Providing a clear path to getting the software

* Demonstrating how to use the software

All three of these onboarding requirements must be done right in order for onboarding to work successfully. Documenation, then, fulfills the third requirement: showing how software can be used. Not every one will need it, but for those users who do need it, it is very nice to have.

To that end, the oVirt Project has, with the help of the Red Hat Content Services team, created a new and complete set of [documentation](/documentation/) based on the downstream documentation for Red Hat Virtualization 4.0.

You may be thinking that this is a backwards process. Shouldn't the upstream documentation be the basis of the downstream? And you would be right... normally that is how the flow of documentation, like code, goes. But the upstream documentation for oVirt has been incomplete and sadly out of sync for quite some time, so it was though that "bootstrapping" the downstream docs as a reset would be a good place to start.

Even these guides themselves are incomplete. Downstream references have been removed, but some still remain. And, since the feature set for oVirt is always a bit larger than its downstream products, there are sure to be features that have yet to be described. This is where, we hope, you come in.

Now that there is a strong base of documentation with which to work, we hope you will visit the oVirt site's [GitHub repo](https://github.com/oVirt/ovirt-site) and submit changes and additions as needed. In this way, the documention will be a living, breathing document that will not only provide oVirt users and admins a great reference, but also be the starting point for the multiple downstream products that use oVirt as their base.

The principal documentation includes:

* **[Quick Start Guide](/documentation/quickstart/quickstart-guide/).** This document is a step-by-step guide for first-time users to install and configure a basic oVirt environment and create virtual machines.

* **[oVirt Installation Guide](/documentation/install-guide/Installation_Guide).** The installation and configuration of an oVirt Engine, the installation and configuration of hosts and attaching existing FCP storage to your oVirt environment.

* **[oVirt Upgrade Guide](/documentation/upgrade-guide/upgrade-guide).** This guide covers updating your oVirt environment between minor releases, and upgrading to the next major version.

* **[oVirt Administration Guide](/documentation/admin-guide/administration-guide/).** A master guide to administering an oVirt environment.

* **[oVirt Virtual Machine Management Guide](/documentation/vmm-guide/Virtual_Machine_Management_Guide).** Most virtual machine tasks in oVirt can be performed in both the User Portal and Administration Portal. However, the user interface differs between each portal, and some administrative tasks require access to the Administration Portal. Tasks that can only be performed in the Administration Portal will be described as such in this guide.

* **[oVirt Introduction to the Administration Portal](/documentation/intro-admin/Introduction_to_the_Administration_Portal).** A straightforward howto for the Administration portal.

* **[oVirt Introduction to the User Portal](/documentation/intro-user/Introduction_to_the_User_Portal).** A straightforward howto for the User portal.

* **[oVirt Self-Hosted Engine Guide](/documentation/self-hosted/Self-Hosted_Engine_Guide).** A self-hosted engine is a virtualized environment in which the oVirt Engine runs on a virtual machine on the hosts managed by that engine. The virtual machine is created as part of the host configuration, and the Engine is installed and configured in parallel to the host configuration process. This guide will walk you through how to setup and run this feature.

* **[oVirt Data Warehouse Guide](/documentation/data-warehouse/Data_Warehouse_Guide).** The oVirt Engine includes a comprehensive management history database, which can be utilized by any application to extract a range of information at the data center, cluster, and host levels. Installing Data Warehouse creates the ovirt_engine_history database, to which the Engine is configured to log information for reporting purposes. The Data Warehouse component is optional, but if you want to use it, this guide will help.

The oVirt Project would specifically like to thank Derek Cadzow of Content Services and Shaun McCance of the Open Source and Standards teams for their invaluable assistance on this bootstrapping project! We hope you find this documentation useful and welcome any and all feedback as part of the ongoing efforts to make our onboarding process strong.
