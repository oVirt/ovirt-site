---
title: UIPlugins
category: feature
authors: sahina, vszocs
wiki_category: Feature
wiki_title: Features/UIPlugins
wiki_revision_count: 55
wiki_last_updated: 2015-05-13
---

# UI Plugins

### Summary

This feature allows implementing custom User Interface (UI) plugins for oVirt web administration (WebAdmin) application.

### Owner

*   Name: [Vojtech Szocs](User:Vszocs)
*   Email: <vszocs@redhat.com>

### Current status

*   In progress: UI plugin architecture design draft

### Overview

oVirt WebAdmin application is a powerful tool to manage virtualization infrastructure, comprising components such as host and guest (virtual) machines, storage domains, etc.

There can be times when administrators want to expose additional features of their infrastructure through WebAdmin UI. This is achieved by writing custom plugins, which are invoked by WebAdmin application at key events during its runtime. As part of handling specific events, each plugin can extend or customize WebAdmin UI through the plugin API.

UI plugins are represented in [JavaScript](http://en.wikipedia.org/wiki/JavaScript) language. This allows WebAdmin to invoke plugins directly on the client (web browser).

Following code snippet shows a minimalistic plugin (cheers to [jQuery](http://jquery.com/) folks out there!):

    // Using JavaScript IIFE (Immediately Invoked Function Expression) to map $ sign to pluginApi global object
    (function( $ ) {

        // Each plugin registers itself into pluginApi.plugins object, where the name of the property is the name of the plugin
        $.plugins.myPlugin = {

            // Initialize the plugin, using an optional plugin configuration object, and report back when ready
            pluginInit: function(pluginConfig) {
                // Plugin lifecycle callback functions, such as the ready() function, are accessed through pluginApi object
                $(this).ready();
            },

            // Handle a specific application event, where the name of the function is the name of the event
            tableContextMenu: function(eventContext) {
                if (eventContext.entityType == 'VM') {
                    // The eventContext.addItem function is specific to tableContextMenu event
                    eventContext.addItem(
                        'Show VM name', // Item title
                        function() {    // Item click handler function
                            Window.alert('Selected VM name is ' + eventContext.entity.name);
                        }
                    );
                }
            }

        };

    })( pluginApi );

In addition to the actual plugin code, each plugin can optionally have a configuration object associated. Plugin configuration objects are represented as [JSON](http://en.wikipedia.org/wiki/JSON) data structures.

Following code snippet shows a sample plugin configuration object:

    {
        "customOption": "foo",
        "anotherOption": 123
    }

### Plugin lifecycle

Following steps illustrate main aspects of the plugin lifecycle:

1.  WebAdmin host page servlet detects all plugins
    -   Proposed plugin file location: `/usr/libexec/ovirt/webadmin/extensions` (should be configurable through `vdc_options`)
    -   Proposed plugin file name convention: `pluginName-version.js`

2.  WebAdmin host page servlet looks up (optional) configuration files for detected plugins
    -   Proposed plugin configuration file location: `/etc/ovirt/webadmin` (should be configurable through `vdc_options`)
    -   Proposed plugin configuration file name convention: `pluginName-version-conf.js`

3.  For each detected plugin, WebAdmin host page servlet embeds plugin code and configuration into the host page
4.  During WebAdmin startup, plugins are evaluated and registered into the global `pluginApi` object
    -   The `pluginApi` object is managed and exposed by WebAdmin
    -   The `pluginApi` object is the main entry point to plugin API

5.  WebAdmin will initialize all plugins by calling the `pluginInit` function
    -   The `pluginConfig` parameter represents the plugin configuration object
    -   Each plugin must report back as `ready()` before WebAdmin calls its event handling functions

6.  On key events during WebAdmin runtime, plugin event handling methods will be invoked on all plugins
    -   Each event has an `eventContext` object representing the context-specific API
    -   Global (context-agnostic) API can be accessed through the global `pluginApi` object

### Implementation details

Technical notes on plugin infrastructure implementation:

*   Create a dedicated (GIN-managed eager singleton) class for managing the global `pluginApi` object through [JSNI](https://developers.google.com/web-toolkit/doc/latest/DevGuideCodingBasicsJSNI)
*   Use [gwt-exporter](http://code.google.com/p/gwt-exporter/) for exporting GWT classes (including backend classes used in frontend) for use in UI plugins

### Open issues

*   How to handle plugin dependencies? (3rd party JavaScript libraries that might be required by some plugins)

### Documentation / External references

*   [WebAdmin UI plugin infrastructure: Design notes](http://rhevmf.pad.engineering.redhat.com/68)

### Comments and Discussion

*   Refer to <Talk:UIPlugins>

<Category:Feature>
