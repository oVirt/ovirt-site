---
title: Entity Configuration Management
category: feature
authors: shtripat
wiki_category: Feature
wiki_title: Features/Entity Configuration Management
wiki_revision_count: 10
wiki_last_updated: 2013-07-25
---

# Entity Configuration Management

## Summary

This feature allows the administrator to create, modify and delete the configuration parameters at entity level. With this the administrator can create set of configuration parameters specific to an entity as key value pair and at a later stage the same can be modified or deleted as well.

Currently all the entities maintain its own ways for maintenance of configurations. This feature would standardize the way the configurations are maintained for entities. On top of this generic way for maintenance of configurations, the specific entities maintenance options can optionally have mechanism for modification and deletion of the configurations.

## Owner

*   Feature owner: Shubhendu Tripathi <shtripat@redhat.com>
    -   GUI Component owner: Kanagaraj Mayilsamy <kmayilsa@redhat.com>
    -   Engine Component owner: Shubhendu Tripathi <shtripat@redhat.com>
    -   VDSM Component owner:
    -   QA Owner: Sudhir Dharanendraiah <sdharane@redhat.com>

## Current Status

*   Status: Not started
*   Last updated date:

## Detailed Description

Currently the individual entity options provide its own ways for maintenance of configuration parameters, and there is not standardization available for the same. The proposed design introduces a standard and common mechanism for maintenance of configuration parameters for different entities in oVirt engine.

With this feature the user will be able to

*   Create a new configuration parameter for an entity from common UI of Entity Configuration Management
*   Update the value of existing configuration parameter UI of Entity Configuration Management
*   Delete an existing configuration parameter UI of Entity Configuration Management
*   Update/Delete the the configuration parameters for entity specific UI screens

## Design

The Entity Configuration Management feature is designed to enable common standard mechanism for maintenance of entity specific configuration parameters. The configuration parameters can later be updated / deleted even from entity specific screens if needed (parameters specific to the entity only can be managed).

### Entity Description

The entity description for the generic configuration management system is as below -

| Column name                   | Type   | Description                                                         |
|-------------------------------|--------|---------------------------------------------------------------------|
| Entity Id                     | UUID   | Id of the entity for which the configuration is maintained          |
| Configuration Category        | String | There could be broad categorization of the configuration parameters |
| Configuration Parameter Name  | String | Name of the configuration parameter                                 |
| Configuration Parameter Value | String | Value of the configuration parameter                                |

Valid entity types would be evaluated against the Entity Types defined in oVirt engine. The administrator can decide on the categories of the configurations based on entity types.

### User Experience

#### Add / Create a new configuration parameter

#### Modify a configuration parameter

#### Delete a configuration parameter

## Dependencies / Related Features and Projects

## Test Cases

## Documentation / External references

## Comments and Discussion

<http://www.ovirt.org/Talk:Features/Gluster_Geo_Replication>

## Open Issues

<Category:Feature>
