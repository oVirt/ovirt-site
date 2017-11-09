---
title: Introducing High Performance Virtual Machines
author: jmarks
tags: 4.2.0, high performance VMs, oVirt
date: 2017-10-02 11:00:00 CET
comments: true
published: true
---

Bringing high performance virtual machines to oVirt!

Introducing a new VM type in oVirt 4.2.0 Alpha. A newly added checkbox in the all-new Administration Portal delivers the highest possible virtual machine performance, very close to bare metal.

READMORE

#### What does it do?

Some of the magic includes:

- Enable Headless Mode and enable Serial console
- Disable all USB devices
- Disable the Sound Card device

For the full feature set, see the very detailed [High Performance VM feature page](/develop/release-management/features/virt/high-performance-vm/)

#### Count me in! How do I set it up?
Simple. Go to the **Administration Portal** and from the vertical menu select **Compute** > **Virtual machines**. Click the **New VM** tab to open up the New Virtual Machine dialog box. In the General tab next to the **Optimized for** field, click the drop down menu and select **High Performance**. Click **OK**. Depending on your current configurations, a smart pop-up may open with a list of additional recommended manual configurations, specific to your setup. To address these recommended changes, click **Cancel**.  

*New Virtual Machine dialog box with the High Performance VM type highlighted*
![](/images/intro-admin/adminportal_compute_vms_new_highperformance.png)
