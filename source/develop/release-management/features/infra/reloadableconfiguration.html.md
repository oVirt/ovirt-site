---
title: ReloadableConfiguration
category: template
authors: lpeer, msalem
---

# Reloadable Configuration

------------------------------------------------------------------------

## Summary

The Reloadable Configuration feature will allow the admin to change core configurations through the engine-config tool without restarting the ovirt engine.

## Owner

*   Feature owner: Muli Salem (msalem)

    * Backend Component owner: Muli Salem (msalem)

    * GUI Component owner: [ ?](User:?)

    * QA Owner: [ ?](User:?)

*   Email: msalem@redhat.com

## Current status

*   Status: Design

## Detailed Description

Caching of the config values of the vdc_options table, is currently done once, in the initialization of the Backend class. Therefore, if a config value is changed, the machine needs to be restarted for the change to take place.

The current implementation of reloadable configuration allows updating **some** of the values, without restarting the machine, going forward we would like to support reloading all the configuration values.

## PRD

The requirements are the following:

1.  Enable the updating of configurations in vdc_options, while the machine (engine server) is up.
2.  In the first phase of the implementation this should be enabled for keys that support the upload feature, these keys will be exposed to the user as reloadable.
3.  The update will take place upon admin explicit request, through the engine-config CLI (and after engine restart, like we have today).

## Design

Today the config values from vdc_options are cached in a map of type DBConfigUtils, that is held in the Config class. Caching of the config values of the table, are done only in the initialization of the Backend class.

New Design:

1.  Since configuration values are changed through the engine-config CLI, we will add a command to the CLI - "reload", which will reload all reloadable configuration values to the engine.
2.  Also, we will add a flag "--only-reloadable" to the "--list" action in the CLI. This action will return a list of all reloadable configurations.
3.  Adding a new Annotation @Reloadable to be used in ConfigValues to distinguish between keys that are reloadable and keys that are not.

<!-- -->

1.  1.  The table in the following link, holds the list of vdc_options keys and whether or not they should be reloadable. It also shows which values are currently exposed through the engine-config tool, since they are in the properties file: [Features/ReloadableConfiguration/keys table](/develop/release-management/features/infra/reloadable-configuration/keys-table/)
    2.  We divide the config keys into 4 types:
        1.  Keys that are fetched from the cache every time they are used - for example keys that are used in a command: These keys will remain untouched.
        2.  Keys that are cached locally, for example in static members: The reloadable keys of this type will be changed to look up the key in the cached map, every time they are needed.
        3.  Keys that are cached locally, for example in static members, however fetching their values demands some work (such as parsing). These keys will be dealt with one by one, considering the cost-effectiveness of having them reloadable.
        4.  Quartz services that are setup on startup - upon scheduling, we can send the reloadable key and keep it in the map, that is looked up every time the job is fired.

## Open Issues

1.  How to update the scheduled jobs - the current solution will be to use the scheduler's map to update things like interval size.
2.  Which keys to define as reloadable, of the ones who demand work for fetching, such as parsing.

## Dependencies / Related Features

Affected engine projects:

*   core
*   Webadmin
*   User Portal

## Documentation / External references


------------------------------------------------------------------------

