---
title: Watchdog engine support
category: feature
authors: doron, lhornyak, mlipchuk
---

# Watchdog support in Engine

## Summary

This feature adds [watchdog](https://en.wikipedia.org/wiki/Watchdog_Card) support to engine. The feature will be available in server VM's and especially useful when used with high availability.

## Owner

*   Name: Laszlo Hornyak (Lhornyak)
*   Email: <lhornyak at redhat dot com>

## Current status

*   Status: implementation
*   Last updated: ,
*   patchset

<http://gerrit.ovirt.org/13057> - DB and entities changes, logic changes in BLL and vdsbroker

<http://gerrit.ovirt.org/13059> - frontend

<http://gerrit.ovirt.org/13060> - rest-api support

## Detailed Description

## Benefit to oVirt

Users will be able to add watchdog cards to their virtual machines. This will be especially important for highly available servers.

## Dependencies / Related Features

This feature depends on the [VDSM support for the watchdog cards](/develop/sla/watchdog-device.html) (merged) The related patches:

*   [device support](http://gerrit.ovirt.org/7535)
*   [watchdog events support](http://gerrit.ovirt.org/9429)

## Documentation / External references

For libvirt support, please see [libvirt's documentation on watchdog support](http://libvirt.org/formatdomain.html#elementsWatchdog).

### User Interface

The watchdog support on the UI will be found on the new/edit VM/template window, on the high availablity tab, since mostly you need the watchdog in HA setups.

![](/images/wiki/Neweditserverhawatchdogenabled.png) ![](/images/wiki/Neweditserverhawatchdogdisabled.png)

You can also find a [user interface live demo on Youtube](https://www.youtube.com/watch?v=-dJLmLxXn4o)

#### Desktop

The desktop will have the very same HA tab as the server. This is a somewhat unrelated change, but the difference between desktop and server VM's is about to be removed.

### Backend changes

*   Both Vm and Template will have support for watchdog cards
*   Watchdog card is represented by a VmDevice

### Watchdog notifications

*   Since users must be aware of the watchdog operations, vdsm reports the last action taken by a watchdog for each VM in getVmStats.
*   This actions should be translated into system events

       * An event will show up in the Web Admin.
       * Users should be able to subscribe to watchdog event, so they will get a notification via the notification service.

### Database changes

*   none

### REST Api changes

In REST API the VM and template will get a new optional tag **watchdog** directly under te vm tag. Watchdog tag will have two mandatory attributes: model and action
{% highlight xml %}
<vm id="87cd09df-88af-4958-8aba-87b14b92ca39" href="/api/vms/87cd09df-88af-4958-8aba-87b14b92ca39">
 <name>test</name>
 <description>123456</description>
 <link rel="disks" href="/api/vms/87cd09df-88af-4958-8aba-87b14b92ca39/disks"/>
 <link rel="nics" href="/api/vms/87cd09df-88af-4958-8aba-87b14b92ca39/nics"/>
 <link rel="cdroms" href="/api/vms/87cd09df-88af-4958-8aba-87b14b92ca39/cdroms"/>
 <link rel="snapshots" href="/api/vms/87cd09df-88af-4958-8aba-87b14b92ca39/snapshots"/>
 <link rel="tags" href="/api/vms/87cd09df-88af-4958-8aba-87b14b92ca39/tags"/>
 <link rel="permissions" href="/api/vms/87cd09df-88af-4958-8aba-87b14b92ca39/permissions"/>
 <link rel="statistics" href="/api/vms/87cd09df-88af-4958-8aba-87b14b92ca39/statistics"/>
 <link rel="reporteddevices" href="/api/vms/87cd09df-88af-4958-8aba-87b14b92ca39/reporteddevices"/>
 <type>server</type>
 <status>
 <state>down</state>
 </status>
 <memory>536870912</memory>
       ...
**<link rel="watchdogs" href="/api/vms/87cd09df-88af-4958-8aba-87b14b92ca39/watchdogs"/>**
       ...
</vm>
{% endhighlight %}

and then in the referenced watchdog url you will see something like this

{% highlight xml %}
<watchdogs>
 <watchdog>
   <model>i6300esb</model>
   <action>reset</action>
 </watchdog>
<watchdogs>
{% endhighlight %}

Note here that there can be only one watchdog.

The watchdog cards and available actions will also get a list in the engine capabilities list (api/capabilities)
{% highlight xml %}
<watchdog_models>
 <watchdog_model>i6300esb</watchdog_model>
 <watchdog_model>ib700</watchdog_model>
</watchdog_models>

<watchdog_actions>
 <watchdog_action>dump</watchdog_action>
 <watchdog_action>reset</watchdog_action>
 <watchdog_action>none</watchdog_action>
       ....
</watchdog_actions>
{% endhighlight %}

### Watchdog behavior

In any case when the watchdog event is triggered, users will receive a \*\*warning\*\* level audit log entry associated with the VM.

*   poweroff - shuts down the VM immediately. Not that if the VM is HA, it will be started automatically by the engine - possibly on another host.
*   reset - restarts the VM. The engine will also be notified about the VM rebooting.
*   pause - pauses the VM. User can resume the VM.
*   dump - dumps and the VM goes to pause state
*   none - no action is taken, but the watchdog event appears in the audit log

### VDSM support

VDSM support for watchdog cards is already merged.



## TODO

New features requested by Gilad Chaplik

*   Adding watchdog data in vm general subtab
*   Enabling watchdog fields according to supported compatibility version (iirc Missing in add watchdog canDoAction)
*   Watchdog filtered events sub-tab for VM main tab (visible when watchdog is enabled)
*   Search vms by last_event != null (> date (dream))
*   Icon in VM grid (main tab) when watchdog is enabled or has event (in the last YYY time)

## Test cases

*   detecting the watchdog
    -   i6300esb is a pci device, the command *\lspci | grep watchdog -i\* in a guest linux OS will show you the watchdog card if it is installed
    -   ib700: TODO

<!-- -->

*   triggering the watchdog
    -   to crash the kernel: <big>echo c > /proc/sysrq-trigger</big>
    -   to trigger watchdog: <big>kill -9 \pgrep watchdog\</big>

### Create VM with watchdog (UI)

1.  Create a server VM
2.  set VM name
3.  click on "High Availability"
4.  set watchdog card to **'i6300esb** and watchdog action to **reset**
5.  save VM
6.  click on the new VM in the list
7.  click **edit**
8.  check if the watchdog device is set correctly
9.  use the rest api to see if the VM has the watchdog card
10. click cancel
11. start the VM
12. click on the console icon to open SPICE console
13. boot any linux distribution on the VM
14. see if watchdog card is installed

### Remove watchdog from VM (UI)

Depends on [Create VM with watchdog (UI)](#create-vm-with-watchdog-ui)

1.  create vm with watchdog (see above)
2.  edit vm
3.  go to **high availablity** tab
4.  set the watchdog model to empty
5.  save VM
6.  check on restapi, the watchdog tag must not appear now on the VM

### Create template with watchdog (UI)

Dependens on [Create VM with watchdog (UI)](#create-vm-with-watchdog-ui)

1.  Create a server VM
2.  set VM name
3.  click on "High Availability"
4.  set watchdog card to **'i6300esb** and watchdog action to **reset**
5.  save VM
6.  create template from vm
7.  go to the templates tab
8.  click on the newly created template
9.  click on **edit**
10. click on **high availablity**
11. check if watchdog is set correctly

### Create vm with watchdog from template (UI)

Depends: [Create vm with watchdog from template (UI)](#create-vm-with-watchdog-from-template-ui)

1.  go to the **Virtual Machines** tab
2.  click on the **new server** button
3.  select the template with watchdog as template
4.  save the VM
5.  edit the newvly created VM
6.  go to the **high availability** tab
7.  check that the watchdog settings are the same as in the template

### Create vm with watchdog (REST-API)

1.  use the rest api to create a vm with a <watchdog> tag ([see above](#rest-api-changes))
2.  check on the rest api if the watchdog card is persisted

### Add watchdog to existing VM (REST-API)

1.  use the rest api to create a vm with a <watchdog> tag ([see above](#rest-api-changes))
2.  check on the rest api if the watchdog card is persisted

### Remove watchdog from VM (REST-API)

