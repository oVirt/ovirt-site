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

Following code snippet shows a sample plugin:

    // Each plugin registers itself into pluginApi.plugins object, where the name of the property is the name of the plugin
    pluginApi.plugins.myPlugin = myPlugin = {

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

    // Initialize the plugin, using an optional plugin configuration object, and report back when ready
    var pluginLifecycle = pluginApi.lifecycle(myPlugin);
    var pluginConfig = pluginLifecycle.configObject();
    pluginLifecycle.ready();

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

### Local vs Remote plugins

Depending on the context from which plugins are invoked, there are two kinds of plugins: **local** and **remote**.

Local plugins  
Invocation context: WebAdmin host page

Plugin code registers the plugin into `pluginApi.plugins` object

<!-- -->

Remote plugins  
Invocation context: arbitrary page from same origin as WebAdmin host page (fetched through an `iframe` element)

Plugin code registers the plugin into `pluginApi.remotePlugins` object

Following code snippet shows a sample remote plugin:

    pluginApi.remotePlugins.myPlugin = {

        // Use pluginApi object to determine server base URL
        src: pluginApi.util().baseUrl() + "path/to/html/page/that/loads/the/plugin"

    };

The `src` value should point to HTML page that loads the actual plugin code (code that registers the plugin into `pluginApi.plugins` object). WebAdmin will fetch this page through an `iframe` element.

However, the actual plugin registration code needs to take the `iframe` context into account. For example:

    // This code will be invoked within the context of an iframe, we need to use 'parent' to access top-level pluginApi object
    var pluginApi = parent.pluginApi;

    // Register the plugin into pluginApi.plugins object
    pluginApi.plugins.myPlugin = myPlugin = {

        // tableContextMenu: function(eventContext) { ... }

    };

    // Report back as ready
    pluginApi.lifecycle(myPlugin).ready();

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
    -   The `pluginApi` object is exposed and managed by WebAdmin
    -   The `pluginApi` object is the main entry point to plugin API

7.  On key events during WebAdmin runtime, event handling methods will be invoked on all plugins that are ready
    -   Each plugin must report back as `ready()` before WebAdmin calls its event handling functions

### Plugin API

WebAdmin plugin API has two kinds of functions, based on the context from which these functions are called: **global** (context-agnostic) and **local** (context-specific).

#### Global API functions

These functions are accessible through the global `pluginApi` object.

Plugin lifecycle functions  
Proposed API: `pluginApi.lifecycle(pluginObject).*`

Purpose: allow asynchronous (non-blocking) plugin communication related to the plugin lifecycle

<!-- -->

WebAdmin action functions  
Proposed API: `pluginApi.action().*`

Purpose: allow plugins to invoke system-wide application actions, e.g. manipulate search string

<!-- -->

Plugin utility functions  
Proposed API: `pluginApi.util().*`

Purpose: provide various utility functions, e.g. access oVirt engine configuration

#### Local API functions

These functions are accessible through the `eventContext` object, which WebAdmin provides to each event handler function.

Following the sample plugin presented in the [Overview](#Overview) section:

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

Following code snippet shows the sample plugin presented in the [Overview](#Overview) section, modified for use with [jQuery](http://jquery.com/) and [jQuery UI](http://jqueryui.com/) libraries:

    // Using JavaScript IIFE (Immediately Invoked Function Expression) to map '$' sign to jQuery global object
    // We don't use global '$' jQuery alias to avoid conflicts with other libraries (e.g. Prototype library also defines '$' global variable)
    (function( $ ) {

        pluginApi.plugins.myPlugin = myPlugin = {

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

        pluginApi.lifecycle(myPlugin).ready();

    })( jQuery );

### Developing plugins with GWT

This section describes how to develop UI plugins using [Google Web Toolkit](https://developers.google.com/web-toolkit/).

Using GWT comes with some issues that need to be addressed:

*   GWT bootstrap sequence requires permutation selector script (`pluginApplication.nocache.js`) to be invoked first. Selector script determines the correct permutation (`hashName.cache.html`) and fetches it asynchronously from the same location.
*   Any kind of RPC based on `XMLHttpRequest` is subject to [Same Origin Policy](http://en.wikipedia.org/wiki/Same_origin_policy). This means that `pluginApplication`'s server-side code should be deployed on oVirt JBoss AS instance.

Following code snippet shows a sample plugin, represented as GWT application:

    package com.myplugin;

    public class MyPluginApp implements EntryPoint {

        public void void onModuleLoad() {
            registerPlugin();
        }

        private static native void registerPlugin() /*-{
            // This code will be invoked within the context of an iframe
            var pluginApi = $wnd.parent.pluginApi;

            // Do the plugin registration
            pluginApi.plugins.myPlugin = myPlugin = {

                tableContextMenu: function(eventContext) {
                    // Call Java static method to handle tableContextMenu event
                    @com.myplugin.MyPluginApp::onTableContextMenuEvent(Lcom/myplugin/TableContextMenuEventObject;)(eventContext); 
                }

            };

            // Report back as ready
            pluginApi.lifecycle(myPlugin).ready();
        }-*/;

        private static void onTableContextMenuEvent(TableContextMenuEventObject eventContext) {
            if ("VM".equals(eventContext.getEntityType())) {
                eventContext.addItem("Show VM name", getVmClickHandlerFunction(eventContext));
            }
        }

        // Too bad Java language doesn't treat methods (functions) as first class objects
        private static native JavaScriptObject getVmClickHandlerFunction(TableContextMenuEventObject eventContext) /*-{
            return function() {
                // Delegate to vmClickHandlerFunctionLogic static method
                @com.myplugin.MyPluginApp::vmClickHandlerFunctionLogic(Lcom/myplugin/TableContextMenuEventObject;)(eventContext); 
            }
        }-*/;

        private static void vmClickHandlerFunctionLogic(TableContextMenuEventObject eventContext) {
            Window.alert(eventContext.getEntityName());
        }

    }

    // JavaScript overlay type for tableContextMenu event's 'eventContext' object
    public class TableContextMenuEventObject extends JavaScriptObject {

        protected TableContextMenuEventObject() {}

        public final native String getEntityType() /*-{
            return this.entityType;
        }-*/;

        public final native String getEntityName() /*-{
            return this.entity.name;
        }-*/;

        public final native void addItem(String itemTitle, JavaScriptObject itemClickHandlerFunction) /*-{
            this.addItem(itemTitle, itemClickHandlerFunction);
        }-*/;

    }

To use this plugin in WebAdmin:

1.  Compile `pluginApplication` into JavaScript and have it bundled into `pluginApplication.war` file
2.  Deploy the `pluginApplication.war` file on JBoss AS instance (`JBOSS_HOME/standalone/deployments`)
3.  Create remote plugin file that references `pluginApplication` host page (relative to JBoss AS root context)

WebAdmin will detect the remote plugin, embed its code into WebAdmin host page and fetch `pluginApplication` host page through an `iframe` element. `pluginApplication` host page will load its selector script, which will in turn load the actual `pluginApplication` permutation, used to register the plugin into `pluginApi.plugins` object.

### Nice to have items

*   Implement WebAdmin dialog that lists active plugins, with the ability to turn them on/off
*   Implement plugin-safe mode, which disables all plugins during WebAdmin startup by default
*   Introduce WebAdmin plugin API compliance version, so that plugins can be written against specific plugin API version

### Documentation / External references

*   [Original design notes](Features/UIPluginsOriginalDesignNotes)

### Comments and Discussion

*   Refer to [discussion page](Talk:Features/UIPlugins).

<Category:Feature>
