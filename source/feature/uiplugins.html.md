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

This feature provides an infrastructure and API for implementing and deploying custom user interface (UI) plugins for oVirt web administration application.

### Owner

*   Name: [Vojtech Szocs](User:Vszocs)
*   Email: <vszocs@redhat.com>
*   IRC: vszocs at #ovirt (irc.oftc.net)

### Current status

*   Plugin infrastructure implementation complete and working
*   Plugin API to be improved in near future
*   Sample plugins showcasing supported API to be contributed in near future

### Overview

oVirt web administration application (WebAdmin) is the main UI for managing all components of a virtual system infrastructure. In addition to existing WebAdmin functionality, there can be times when administrators want to expose additional features or to integrate with other systems through WebAdmin UI. This is where UI plugins come into play: each plugin represents a set of user interface extensions that can be packaged and distributed for use with oVirt Engine via WebAdmin.

### Introduction

UI plugins integrate with WebAdmin directly on the client (web browser) using [JavaScript](http://en.wikipedia.org/wiki/JavaScript) programming language. Plugin invocation is driven by WebAdmin and happens right within the context of web browser's JavaScript runtime, using JavaScript language as the lowest common denominator between WebAdmin ([GWT](http://en.wikipedia.org/wiki/Google_Web_Toolkit)) and individual plugins. UI plugins can take full advantage of JavaScript language and its rich ecosystem of libraries.

At key events during runtime, WebAdmin invokes individual plugins via [event handler functions](#Supported_application_events) representing WebAdmin → plugin communication. Even though WebAdmin supports multiple event handler functions, a plugin only declares functions which are of interest to its implementation. Each plugin must register relevant event handler functions as part of [plugin bootstrap sequence](#Plugin_bootstrap_sequence), before the plugin is put to use by WebAdmin.

To facilitate plugin → WebAdmin communication that drives UI extension, WebAdmin exposes [plugin API](#Supported_API_functions) as global (top-level) `pluginApi` JavaScript object for individual plugins to consume. Each plugin obtains specific `pluginApi` instance, allowing WebAdmin to control plugin API function invocation per each plugin with regard to [plugin lifecycle](#Plugin_lifecycle).

### Discovering plugins

Before a plugin can be [loaded](#Loading_plugins) and [bootstrapped](#Plugin_bootstrap_sequence) by WebAdmin, it has to be discovered by UI plugin infrastructure in the first place.

![Discovering plugins](Discovering-plugins.png "Discovering plugins")

[Plugin descriptor](#Plugin_descriptor) is the entry point to [plugin discovery](#Discovering_plugins) process, containing important plugin meta-data as well as (optional) default plugin-specific configuration.

As part of handling WebAdmin HTML page request (1), UI plugin infrastructure attempts to discover and load plugin descriptors from local file system (2). For each plugin descriptor, the infrastructure also attempts to load corresponding [plugin user configuration](#Plugin_user_configuration) used to override default plugin-specific configuration (if any) and tweak plugin runtime behavior. Note that providing plugin user configuration is completely optional. After loading descriptors and corresponding user configuration files, oVirt Engine aggregates UI plugin data and embeds it into WebAdmin HTML page for runtime evaluation (3).

By default, plugin descriptors are expected to reside in `$ENGINE_USR/ui-plugins` directory, with a default mapping `ENGINE_USR=/usr/share/ovirt-engine` as defined by oVirt Engine local configuration. Plugin descriptors are expected to comply with [JSON](http://en.wikipedia.org/wiki/JSON) format specification, with the addition of allowing Java/C++ style comments (both `/`+`*` and `//` varieties).

By default, plugin user configuration files are expected to reside in `$ENGINE_ETC/ui-plugins` directory, with a default mapping `ENGINE_ETC=/etc/ovirt-engine` as defined by oVirt Engine local configuration. Plugin user configuration files are expected to comply with same content format rules as plugin descriptors. Note that plugin user configuration files generally follow `<descriptorFileName>-config.json` naming convention.

### Loading plugins

After a plugin has been [discovered](#Discovering_plugins) and its data embedded into WebAdmin HTML page, WebAdmin will attempt to load the given plugin as part of application startup (unless configured otherwise).

![Loading plugins](Loading-plugins.png "Loading plugins")

For each plugin, WebAdmin creates an HTML `iframe` element used to load [plugin host page](#Plugin_host_page) (1). Plugin host page is the entry point to [plugin bootstrap](#Plugin_bootstrap_sequence) process, used to evaluate plugin code (JavaScript) within the context of the corresponding `iframe` element. UI plugin infrastructure supports serving plugin resource files, such as plugin host page, from local file system (2). Plugin host page gets loaded into the `iframe` element and the plugin code is evaluated (3). From this point forward, plugin communicates with WebAdmin via plugin API (4).

By default, plugin resource files are expected to reside in `$ENGINE_USR/ui-plugins/<resourcePath>` directory, with `resourcePath` value defined by the corresponding attribute in [plugin descriptor](#Plugin_descriptor).

### Plugin descriptor

Plugin descriptor is the entry point to [plugin discovery](#Discovering_plugins) process, containing important plugin meta-data as well as (optional) default plugin-specific configuration.

Following code snippet shows a sample plugin descriptor: `/usr/share/ovirt-engine/ui-plugins/myPlugin.json`

    {

        // A name that uniquely identifies the plugin (required).
        // Not related to descriptor file name, must not be empty.
        "name": "MyPlugin",

        // URL of plugin host page used to evaluate plugin code (required).
        // Using UI plugin infrastructure support to serve plugin resource files.
        // This URL maps to $ENGINE_USR/ui-plugins/<resourcePathForMyPlugin>/start.html
        "url": "/webadmin/webadmin/plugin/MyPlugin/start.html",

        // Default configuration object associated with the plugin (optional).
        "config": { "band": "ZZ Top", "score": 10 },

        // Path to plugin resource files, relative to plugin descriptor location (optional).
        // Required when using UI plugin infrastructure support to serve plugin resource files.
        // This path maps to $ENGINE_USR/ui-plugins/my-files
        "resourcePath": "my-files"

    }

### Plugin user configuration (optional)

Plugin user configuration is used to override default plugin-specific configuration (if any) and tweak plugin runtime behavior.

Following code snippet shows a sample plugin user configuration: `/etc/ovirt-engine/ui-plugins/myPlugin-config.json`

    {

        // Custom configuration object associated with the plugin (optional).
        // This overrides the default (plugin descriptor) configuration, if any.
        "config": { "band": "AC/DC" },

        // Whether the plugin should be loaded on WebAdmin startup (optional).
        // Default value is 'true'.
        "enabled": true,

        // Relative order in which the plugin will be loaded (optional).
        // Default value is Integer.MAX_VALUE (lowest order).
        "order": 0

    }

As part of [discovering plugins](#Discovering_plugins), UI plugin infrastructure will merge custom configuration (if any) on top of default configuration (if any). For example:

*   Plugin descriptor defines `config` attribute as `{ "band": "ZZ Top", "score": 10 }`
*   Plugin user configuration defines `config` attribute as `{ "band": "AC/DC" }`
*   Resulting plugin configuration, accessible to the given plugin at runtime, will be `{ "band": "AC/DC", "score": 10 }`

### Plugin host page

Plugin host page is the entry point to [plugin bootstrap](#Plugin_bootstrap_sequence) process, used to evaluate plugin code (JavaScript) within the context of the corresponding `iframe` element.

Following code snippet shows a sample plugin host page: `/usr/share/ovirt-engine/ui-plugins/my-files/start.html`

    <!DOCTYPE html>
    <html>
    <head>
    <!--
        Can fetch dependent scripts or other resources as necessary (1).
        <script type="text/javascript" src="/webadmin/webadmin/plugin/MyPlugin/libs/example1.js"></script>
        <script type="text/javascript" src="libs/example2.js"></script>
    -->
    <script>

        // Plugin code goes here (2).

    </script>
    </head>
    <body>
    <!--
        HTML body is intentionally empty (3).
    -->
    </body>
    </html>

Prior to evaluating actual plugin code, [plugin host page](#Plugin_host_page) can fetch and evaluate dependent scripts or other resources as necessary (1). Actual [plugin code](#Plugin_bootstrap_sequence) is typically evaluated via HTML `head` section (2). Since the `iframe` element used to load the plugin host page is not visible in WebAdmin UI, any markup placed within HTML `body` section will have no effect in practice (3).

### Plugin bootstrap sequence

A typical plugin bootstrap sequence consists of following steps:

*   Obtain `pluginApi` instance for the given plugin
*   Obtain runtime plugin configuration object (optional)
*   Register relevant event handler functions
*   Notify UI plugin infrastructure to proceed with plugin initialization

Following code snippet illustrates the above mentioned steps in practice:

    // Access plugin API using 'parent' due to this code being evaluated within the context of an iframe element.
    // As 'parent.pluginApi' is subject to Same-Origin Policy, this will only work when WebAdmin HTML page and plugin
    // host page are served from same origin. WebAdmin HTML page and plugin host page will always be on same origin
    // when using UI plugin infrastructure support to serve plugin resource files.
    var api = parent.pluginApi('MyPlugin');

    // Runtime configuration object associated with the plugin (or an empty object).
    var config = api.configObject();

    // Register event handler function(s) for later invocation by UI plugin infrastructure.
    api.register({
        // UiInit event handler function.
        UiInit: function() {
            // Handle UiInit event.
            window.alert('Favorite music band is ' + config.band);
        }
    });

    // Notify UI plugin infrastructure to proceed with plugin initialization.
    api.ready();

### Plugin lifecycle

UI plugin infrastructure

### Supported application events

TODO

### Supported API functions

TODO don't forget screenshots

### UI plugin cheat sheet

Minimalistic plugin descriptor: `/usr/share/ovirt-engine/ui-plugins/helloWorld.json`

    {
        "name": "HelloWorld",
        "url": "/webadmin/webadmin/plugin/HelloWorld/start.html",
        "resourcePath": "hello-files"
    }

Minimalistic plugin host page: `/usr/share/ovirt-engine/ui-plugins/hello-files/start.html`

    <!DOCTYPE html><html><head>
    <script>
        var api = parent.pluginApi('HelloWorld');
        api.register({
            UiInit: function() { window.alert('Hello world'); }
        });
        api.ready();
    </script>
    </head><body></body></html>

### Sample UI plugins

TODO don't forget link to git repository

### Real-world UI plugins

TODO mention Oved's plugin, link to his blog post

### References

*   [Original design notes](Features/UIPluginsOriginalDesignNotes)

### Comments and discussion

*   Refer to [UI plugins discussion page](Talk:Features/UIPlugins).

<Category:Feature>
