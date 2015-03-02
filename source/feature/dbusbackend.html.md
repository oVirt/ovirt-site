---
title: DbusBackend
category: feature
authors: rbarry
wiki_category: Feature
wiki_title: Features/Node/DbusBackend
wiki_revision_count: 3
wiki_last_updated: 2015-03-05
feature_name: Dbus Backend
feature_modules: node
feature_status: In Progress
---

# Dbus Backend

## oVirt Node Dbus Backend

### Summary

This features adds a Dbus configuration backend for oVirt Node.

### Owner

*   Name: [ Ryan Barry](User:rbarry)

<!-- -->

*   Email: rbarry AT redhat DOT com
*   IRC: rbarry

### Detailed Description

Th main reason for this change it to adopt a common used UI for the oVirt Node.
The use of Dbus will provide control of oVirt Node in manner that is familiar to many developers out of the oVirt community.
Lastly, we can utilize common platform code and reduce the amount of duplicated work.

The Dbus provider will run as a separate service not tied to invocation of the TUI.

### Benefit to oVirt

Moving further away from tight coupling with the TUI and onto Dbus allows easy access to the configuration API from any frontend or language that has Dbus bindings. Additionally, moving towards Dbus means less logical separation when we start using Dbus interfaces not provided by Node.

### Dependencies / Related Features

Having a usable Dbus backend makes integration with [ Cockpit](Features/Node/Cockpit) much better.

### Testing

Classes from ovirt.node.config.defaults should be visible on the Dbus Session Bus Activation of methods with dbus-send or python-dbus (example Python to follow later) will work, and trigger the appropriate backend classes.

### Documentation / External references

<https://bugzilla.redhat.com/show_bug.cgi?id=1191962>

### Comments and Discussion

Comments and discussion can be posted on mailinglist or the referenced bug.

<Category:Feature> <Category:Node>
