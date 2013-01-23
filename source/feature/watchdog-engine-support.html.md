---
title: Watchdog engine support
category: feature
authors: doron, lhornyak, mlipchuk
wiki_category: Feature
wiki_title: Features/Watchdog engine support
wiki_revision_count: 48
wiki_last_updated: 2014-06-16
wiki_warnings: list-item?
---

# Watchdog support in Engine

### Summary

This feature adds [watchdog](https://en.wikipedia.org/wiki/Watchdog_Card) support to engine.

### Owner

*   Name: [Laszlo Hornyak](User:Lhornyak)
*   Email: <lhornyak at redhat dot com>

### Current status

*   Status: design and discussion
*   Last updated: ,

### Detailed Description

### Benefit to oVirt

Users will be able to add watchdog cards to their virtual machines. This will be especially important for highly available servers.

### Dependencies / Related Features

This feature depends on the [VDSM support for the watchdog cards](Add an option to create a watchdog device) (merged)

### Documentation / External references

#### User Interface

The watchdog support on the UI will be found on the new/edit VM/template window, on the high availablity tab, since mostly you need the watchdog in HA setups.

![](Neweditserverhawatchdogdisabled.png "Neweditserverhawatchdogdisabled.png")

![](Neweditserverhawatchdogenabled.png "Neweditserverhawatchdogenabled.png")

#### Backend changes

*   Both Vm and Template will have support for watchdog cards, therefore VmBase will be extended with a watchdog property.
*   New WatchDog class will represent the watchdog card and action. If watchdog is null in VmBase, it means that no watchdog is supported. Watchdog will have two properties: model and action
*   vdsbroker must be extended in order to send the watchdog parameters to vdsm uppon Vm start
*   VmTemplateDAODbFacadeImpl and VmDAODbFacadeImpl must be extended to support persistence of the Watchdog settings

#### Database changes

*   table vm_static must be extended with two new columns

    * wd_model varchar(8) default null - for the watchdog model

    * wd_action varchar(8) default null - for the watchdog action (it must be one of [reset, poweroff, pause, none, dump]) possibly the best available solution for this would be postgresql enums, and these actions **feedback is needed here**

*   Database stored procedures for update and add vm and template must be modified to handle the two above columns

#### REST Api changes

In REST API the VM and template will get a new optional tag **watchdog** directly under te vm tag. Watchdog tag will have two mandatory attributes: model and action

<vm id="87cd09df-88af-4958-8aba-87b14b92ca39" href="/api/vms/87cd09df-88af-4958-8aba-87b14b92ca39">
` `<name>`test`</name>
` `<description>`123456`</description>
` `<link rel="disks" href="/api/vms/87cd09df-88af-4958-8aba-87b14b92ca39/disks"/>
` `<link rel="nics" href="/api/vms/87cd09df-88af-4958-8aba-87b14b92ca39/nics"/>
` `<link rel="cdroms" href="/api/vms/87cd09df-88af-4958-8aba-87b14b92ca39/cdroms"/>
` `<link rel="snapshots" href="/api/vms/87cd09df-88af-4958-8aba-87b14b92ca39/snapshots"/>
` `<link rel="tags" href="/api/vms/87cd09df-88af-4958-8aba-87b14b92ca39/tags"/>
` `<link rel="permissions" href="/api/vms/87cd09df-88af-4958-8aba-87b14b92ca39/permissions"/>
` `<link rel="statistics" href="/api/vms/87cd09df-88af-4958-8aba-87b14b92ca39/statistics"/>
` `<link rel="reporteddevices" href="/api/vms/87cd09df-88af-4958-8aba-87b14b92ca39/reporteddevices"/>
` `<type>`server`</type>
` `<status>
` `<state>`down`</state>
` `</status>
` `<memory>`536870912`</memory>
       ...
       `<watchdog model="i6300esb" action="reset"/>` 
       ...
` `</vm>

**example needed here**

#### VDSM support

VDSM support for watchdog cards is already merged.

### Comments and Discussion

Please comment on the [Discussion page](Talk:Features/Watchdog_engine_support).

<Category:Feature> <Category:SLA>
