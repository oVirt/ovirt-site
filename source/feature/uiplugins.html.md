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
*   IRC: vszocs at #ovirt (irc.oftc.net)

### Current status

*   In progress: Design draft
*   Pending: Design implementation
*   Pending: User (plugin authoring) documentation

### Overview

oVirt WebAdmin application is a powerful tool to manage virtualization infrastructure, comprising components such as host and guest (virtual) machines, storage domains, etc.

There can be times when administrators want to expose additional features of their infrastructure through WebAdmin UI. This is achieved by writing custom plugins, which are invoked by WebAdmin application at key events during its runtime. As part of handling specific events, each plugin can extend or customize WebAdmin UI through the plugin API.

UI plugins are represented in [JavaScript](http://en.wikipedia.org/wiki/JavaScript) language. This allows WebAdmin to invoke plugins directly on the client (web browser).

Following code snippet shows a minimalistic plugin:

    // Each plugin registers itself into pluginApi.plugins object, where the name of the property is the name of the plugin
    pluginApi.plugins.myPlugin = {

        // Initialize the plugin, using an optional plugin configuration object, and report back when ready
        pluginInit: function(pluginConfig) {
            // Plugin lifecycle callback functions, such as the ready() function, are accessed through pluginApi object
            pluginApi.lifecycle(this).ready();
        },

        // Handle a specific application event, where the name of the function is the name of the event
        tableContextMenu: function(eventContext) {
            if (eventContext.entityType == 'VM') {
                // The eventContext.addItem function is specific to tableContextMenu event
                eventContext.addItem(
                    'Show VM name and edit VM', // Item title
                    function() {                // Item click handler function
                        Window.alert(eventContext.entity.name);
                        eventContext.itemAction('edit');
                    }
                );
            }
        }

    };

In addition to the actual plugin code, each plugin can optionally have a configuration object associated. Plugin configuration objects are represented as [JSON](http://en.wikipedia.org/wiki/JSON) data structures.

Following code snippet shows a sample plugin configuration object:

    {
        "customOption": "foo",
        "anotherOption": 123
    }

Last but not least, each plugin can optionally declare dependencies to 3rd party JavaScript libraries. Just like plugin configuration objects, plugin dependency declarations are represented as JSON data structures.

Following code snippet shows a sample plugin dependency declaration:

    {

        // Fetch jQuery library from remote URL
        "jQuery": "https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js",

        // Fetch fooBar library from local filesystem (relative to plugin dependency declaration file location)
        "fooBar": "file://plugin-deps/foobar10.js"

    }

### Plugin lifecycle

Following steps illustrate main aspects of the plugin lifecycle:

1.  User requests WebAdmin host page via web browser
2.  WebAdmin host page servlet detects all plugins
    -   Proposed plugin file location: `/usr/libexec/ovirt/webadmin/extensions` (should be configurable through `vdc_options` table)
    -   Proposed plugin file name convention: `pluginName-version.js`

3.  WebAdmin host page servlet looks up (optional) configuration files for detected plugins
    -   Proposed configuration file location: `/etc/ovirt/webadmin` (should be configurable through `vdc_options` table)
    -   Proposed configuration file name convention: `pluginName-version-conf.json`

4.  WebAdmin host page servlet looks up (optional) dependency declaration files for detected plugins
    -   Proposed dependency file location: same as configuration file location
    -   Proposed dependency file name convention: `pluginName-version-dep.json`

5.  For each detected plugin, WebAdmin host page servlet embeds plugin code, configuration and dependency information into the host page
    -   Plugin code is wrapped in IIFE (Immediately Invoked Function Expression) for later execution
    -   Plugin configuration is embedded unchanged (already a JSON object)
    -   Plugin dependencies are parsed and processed in the following way:
        -   For each remote URL dependency, a `script` tag with `src` attribute will be added to HTML `head` section of the host page
        -   For each local filesystem dependency, a `script` tag containing library content will be added to HTML `head` section of the host page
        -   Dependency object name will be used to avoid referencing the same dependency multiple times (as multiple plugins might have the same dependency)

6.  During WebAdmin startup, plugins are evaluated and registered into the global `pluginApi` object
    -   The `pluginApi` object is managed and exposed by WebAdmin
    -   The `pluginApi` object is the main entry point to plugin API

7.  WebAdmin will initialize all plugins by calling the `pluginInit` function
    -   The `pluginConfig` parameter represents the (optional) plugin configuration object
    -   Each plugin must report back as `ready()` before WebAdmin calls its event handling functions

8.  On key events during WebAdmin runtime, plugin event handling methods will be invoked on all plugins

### Plugin API

WebAdmin plugin API has two kinds of functions, based on the context from which these functions are called: **global** (context-agnostic) and **local** (context-specific).

#### Global API functions

These functions are accessible through the global `pluginApi` object.

Plugin lifecycle callback functions  
Proposed API: `pluginApi.lifecycle(pluginObject).*`

Purpose: allow asynchronous (non-blocking) plugin communication, related to the plugin lifecycle

<!-- -->

WebAdmin global action functions  
Proposed API: `pluginApi.action().*`

Purpose: allow plugins to invoke system-wide application actions, e.g. manipulate search string

<!-- -->

Plugin utility functions  
Proposed API: `pluginApi.util().*`

Purpose: provide various utility functions, e.g. access oVirt engine configuration

#### Local API functions

These functions are accessible through the `eventContext` object, which WebAdmin provides to each event handler function.

Following the sample plugin presented in the [#Overview](#Overview) section:

*   `tableContextMenu` event triggers when the user right-clicks on selected item(s) within a data table (table context menu is about to be shown)
*   `eventContext` object represents both event data (e.g. `eventContext.entityType`) and context-specific plugin API (e.g. `eventContext.addItem`)

API functions exposed by the `eventContext` object always depend on the corresponding application event.

### Application event types

Generally speaking, each event represents an extension point, exposed by WebAdmin and consumed by plugins.

Here are some ideas for different event types:

`uiInit`  
Triggered when WebAdmin UI is fully initialized

Sample use case: add custom main tab to WebAdmin UI

<!-- -->

`tableContextMenu`  
Triggered when a table context menu is about to be shown to the user

Sample use case: add custom item to table context menu

Feel free to [discuss](Talk:Features/UIPlugins) additional event types.

### Implementation details

Technical notes on plugin infrastructure implementation:

*   Create a dedicated (GIN-managed eager singleton) class for managing the global `pluginApi` object through [JSNI](https://developers.google.com/web-toolkit/doc/latest/DevGuideCodingBasicsJSNI)
*   Use [gwt-exporter](http://code.google.com/p/gwt-exporter/) for exporting GWT classes (including backend classes used in frontend) for use in UI plugins

### Integration with 3rd party JavaScript libraries

Following code snippet shows the sample plugin presented in the [#Overview](#Overview) section, modified for use with [jQuery](http://jquery.com/) and [jQuery UI](http://jqueryui.com/) libraries:

    // Using JavaScript IIFE (Immediately Invoked Function Expression) to map '$' sign to jQuery global object
    // We don't use global '$' jQuery alias to avoid conflicts with other libraries (e.g. Prototype library also defines '$' global variable)
    (function( $ ) {

        pluginApi.plugins.myPlugin = {

            pluginInit: function(pluginConfig) {
                pluginApi.lifecycle(this).ready();
            },

            tableContextMenu: function(eventContext) {
                if (eventContext.entityType == 'VM') {
                    eventContext.addItem('Show VM name and edit VM', function() {
                        // Show a jQuery UI modal dialog
                        $('<div/>')
                            .html(eventContext.entity.name)
                            .dialog({
                                title: 'VM name',
                                modal: true,
                                buttons: {
                                    'OK': function() {
                                        $(this).dialog('close');
                                        eventContext.itemAction('edit');
                                    }
                                }
                            });
                    });
                }
            }

        };

    })( jQuery );

### Documentation / External references

*   [WebAdmin UI plugin infrastructure: Original design notes](http://rhevmf.pad.engineering.redhat.com/68)

### Comments and Discussion

*   Refer to [discussion page](Talk:Features/UIPlugins).

<Category:Feature>
