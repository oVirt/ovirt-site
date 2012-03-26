---
title: ReloadableConfiguration
category: template
authors: lpeer, msalem
wiki_category: Template
wiki_title: Features/ReloadableConfiguration
wiki_revision_count: 37
wiki_last_updated: 2012-06-28
wiki_warnings: list-item?
---

# Reloadable Configuration

------------------------------------------------------------------------

### Summary

The Reloadable Configuration feature will allow the admin to change core configurations through the engine-config tool without restarting the machine.

### Owner

*   Feature owner: [ Muli Salem](User:msalem)

    * Backend Component owner: [ Muli Salem](User:msalem)

    * GUI Component owner: [ ?](User:?)

    * QA Owner: [ ?](User:?)

*   Email: msalem@redhat.com

### Current status

*   Status: Design

### Detailed Description

Caching of the config values of the vdc_options table, is currently done once, in the initialization of the Backend class. Therefore, if a config value is changed, the machine needs to be restarted for the change to take place.

The Reloadable Configuration feature will allow updating **some** of the values, without restarting the machine.

### PRD

The requirements are the following:

1.  Enable the updating of configurations in vdc_options, while the machine is up.
2.  This should be enabled for keys that can be changed in runtime without harming the system, and keys that can actually be updated.
3.  The update does not have to take place immediately upon configuration change, but rather can happen periodically.

### Design

Today the config values from vdc_options are cached in a map of type DBConfigUtils, that is held in the Config class. Caching of the config values of the table, are done only in the initialization of the Backend class.

New Design:

1.  Creating a periodic job that refreshes the cached map from the DB, once a minute.
2.  Adding a reloadable column in vdc_options. This field will distinguish between keys that can be reloaded in runtime, and keys that should only change when the machine is restarted. The field itself is not updatable by the admin,to prevent de-stabilizing of the system.
    1.  The table in the following link, holds the list of vdc_options keys and whether or not they should be reloadable. It also shows which values are currently exposed through the engine-config tool, since they are in the properties file: <http://www.ovirt.org/wiki/Features/ReloadableConfiguration/keys_table>
    2.  We divide the config keys into 4 types:
        1.  Keys that are fetched from the cache every time they are used - for example keys that are used in a command: These keys will remain untouched.
        2.  Keys that are cached locally, for example in static members: The reloadable keys of this type will be changed to look up the key in the cached map, every time they are needed.
        3.  Keys that are cached locally, for example in static members, however fetching their values demands some work (such as parsing).
        4.  Quartz services that are setup on startup and cannot be changed afterwords.

<span style="color:Teal">**New Column**</span>:
{|class="wikitable sortable" !border="1"| Column Name ||Column Type ||Null? / Default ||Description |- |is_reloadable || boolean ||not null / default False ||Is this key reloadable |- |}

We will add the following config value for this job: <span style="color:Teal">**New config key**</span>:
{|class="wikitable sortable" !border="1"| config key || config type ||Null? / Default ||Description |- |ConfigurationsRefreshIntervalInSeconds || smallint ||60||The size of interval between refreshes of configurations from vdc_options. |}

### Open Issues

1.  How to update the scheduled jobs.
2.  Whether or not to update the values that demand work for fetching, such as parsing.

### Dependencies / Related Features

Affected engine projects:

*   core
*   Webadmin
*   User Portal

### Documentation / External references

### Comments and Discussion

------------------------------------------------------------------------

<Category:Template> <Category:Feature>
