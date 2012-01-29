---
title: Jumbo frames
authors: drankevi, ecohen, roy
wiki_title: Features/Design/Network/Jumbo frames
wiki_revision_count: 12
wiki_last_updated: 2012-04-16
---

# Jumbo frames

Typically, just another parameter for a network configuration to determine the [MTU](http://en.wikipedia.org/wiki/Maximum_transmission_unit).

### Code Change

1.  Add MTU : String to network entity
2.  Add deserialization to MTU field in VdsBrokerObjectsBuilder.java. Serialise as String and not Int.
3.  DB - add field in to vds_interface and vds_interface_view
4.  DAO - add field to VdsInterfaceDao CRUD actions

### Backward Compatibility

Same as for bridge-less feature.
