---
title: UIPlugins
category: feature
authors: sahina, vszocs
wiki_category: Feature
wiki_title: Features/UIPlugins
wiki_revision_count: 55
wiki_last_updated: 2015-05-13
wiki_conversion_fallback: true
wiki_warnings: conversion-fallback
---

# UI Plugins

### Summary

This feature provides an infrastructure and API for implementing and deploying custom user interface plugins for oVirt web administration application.

### Owner

*   Name: [Vojtech Szocs](user:Vszocs)
*   Email: <<vszocs@redhat.com>></<vszocs@redhat.com>>

### Overview

oVirt web administration application (WebAdmin) is the main graphical user interface for managing all components of a virtual system infrastructure. In addition to existing WebAdmin functionality, there can be times when administrators want to expose additional features or to integrate with other systems through WebAdmin UI. This is where UI plugins come into play: each plugin represents a set of user interface extensions that can be packaged and distributed for deployment on oVirt Engine via WebAdmin.

### Introduction

UI plugins integrate with WebAdmin directly on the client (web browser) using [JavaScript](http://en.wikipedia.org/wiki/JavaScript) programming language. Plugin invocation is driven by WebAdmin and happens right within the context of browser's JavaScript runtime, using JavaScript language as the lowest common denominator between WebAdmin ([GWT](http://en.wikipedia.org/wiki/Google_Web_Toolkit)) and individual plugins. UI plugins can take full advantage of JavaScript language and its rich ecosystem of libraries. There are no specific rules on how to implement UI plugins, plugin API is designed to be simple and not to get in developer's way, regardless of how a developer chooses to write the plugin.

At key events during runtime, WebAdmin invokes individual plugins via [event handler functions](#Application_event_reference) representing WebAdmin → plugin communication. Even though WebAdmin supports many different event handler functions, a plugin only declares functions which are of interest to its implementation. Each plugin must register relevant event handler functions as part of its [bootstrap sequence](#Plugin_bootstrap_sequence), before the plugin is put to use by WebAdmin.

To facilitate plugin → WebAdmin communication that drives UI extension, WebAdmin exposes [plugin API](#API_function_reference) as global (top-level) `pluginApi` JavaScript object for individual plugins to consume. Each plugin obtains specific `pluginApi` instance, allowing WebAdmin to control plugin API function invocation per each plugin with regard to [plugin lifecycle](#Plugin_lifecycle).

### Discovering plugins

Before a plugin can be [loaded](#Loading_plugins) and [bootstrapped](#Plugin_bootstrap_sequence) by WebAdmin, it has to be discovered by UI plugin infrastructure in the first place.

![](Discovering-plugins.png "Discovering plugins")

[Plugin descriptor](#Plugin_descriptor) is the entry point to discovery process, containing plugin meta-data as well as (optional) default plugin-specific configuration.

As part of handling WebAdmin HTML page request (1), UI plugin infrastructure attempts to discover and load plugin descriptors from local file system (2). For each descriptor, the infrastructure also attempts to load corresponding [plugin user configuration](#Plugin_user_configuration) used to override default plugin-specific configuration (if any) and tweak plugin runtime behavior. Note that providing plugin user configuration is completely optional. After loading descriptors and corresponding user configuration files (if any), oVirt Engine aggregates UI plugin data and embeds it into WebAdmin HTML page for runtime evaluation (3).

Descriptor files are expected to reside in `$ENGINE_USR/ui-plugins` directory, with default mapping `ENGINE_USR=/usr/share/ovirt-engine` as defined by oVirt Engine local configuration. Descriptor files should comply with [JSON](http://en.wikipedia.org/wiki/JSON) format specification with the addition of allowing Java/C++ style comments, i.e. both `/* comment */` and `// comment` varieties.

User configuration files are expected to reside in `$ENGINE_ETC/ui-plugins` directory, with default mapping `ENGINE_ETC=/etc/ovirt-engine` as defined by oVirt Engine local configuration. User configuration files should comply with same content format rules as descriptors. Note that user configuration files follow `-config.json` naming convention, i.e. using `-config` suffix.

### Loading plugins

After a plugin has been [discovered](#Discovering_plugins) and its data embedded into WebAdmin HTML page, WebAdmin will attempt to load the given plugin as part of application startup (unless configured otherwise).

![](Loading-plugins.png "Loading plugins")

For each plugin, WebAdmin creates hidden HTML `iframe` element used to load [plugin host page](#Plugin_host_page) (1). Plugin host page is the entry point to [bootstrap](#Plugin_bootstrap_sequence) process, used to evaluate plugin code (JavaScript) within the context of the corresponding `iframe` element. UI plugin infrastructure supports serving plugin resource files, such as host page, from local file system (2). Host page gets loaded into `iframe` element and plugin code is evaluated (3). From this point forward, plugin communicates with WebAdmin via plugin API (4). Since the purpose of host page is to bootstrap plugin code, any UI extensions should be done via [plugin API](#API_function_reference) rather than direct HTML DOM manipulation.

Plugin resource files are expected to reside in `$ENGINE_USR/ui-plugins/` directory, with `resourcePath` value defined by the corresponding attribute in [plugin descriptor](#Plugin_descriptor). For example:

*   Client requests URL `/ovirt-engine/webadmin/plugin//path/to/file`
*   Engine serves content of `$ENGINE_USR/ui-plugins//path/to/file`

### Plugin descriptor

Plugin descriptor contains plugin meta-data as well as default plugin-specific configuration.

Following code snippet shows a sample plugin descriptor:

      /usr/share/ovirt-engine/ui-plugins/example.json

    {

        // Unique name of the plugin (required)
        // Unrelated to descriptor file name, must not be empty
        "name": "ExamplePlugin",

        // URL of plugin host page that bootstraps plugin code (required)
        // This URL maps to $ENGINE_USR/ui-plugins/example-resources/start.html
        "url": "/ovirt-engine/webadmin/plugin/ExamplePlugin/start.html",

        // Default configuration associated with the plugin (optional)
        "config": { "band": "ZZ Top", "score": 10 },

        // Path to plugin resource files relative to descriptor (optional)
        // Required when using UI plugin infrastructure to serve plugin resource files
        // This path maps to $ENGINE_USR/ui-plugins/example-resources
        "resourcePath": "example-resources"

    }

### Plugin user configuration

Plugin user configuration contains custom plugin-specific configuration and attributes to tweak plugin runtime behavior.

Following code snippet shows a sample plugin user configuration:

      /etc/ovirt-engine/ui-plugins/example-config.json

    {

        // Custom configuration associated with the plugin (optional)
        // This overrides default configuration within descriptor, if any
        "config": { "band": "AC/DC" },

        // Whether the plugin should be loaded on WebAdmin startup (optional)
        // Default value is true
        "enabled": true,

        // Relative order in which the plugin will be loaded (optional)
        // Default value is Integer.MAX_VALUE (lowest order)
        "order": 0

    }

As part of [discovering plugins](#Discovering_plugins), UI plugin infrastructure will merge custom configuration (if any) on top of default configuration (if any). For example:

*   Plugin descriptor defines `config` attribute as `{ "band": "ZZ Top", "score": 10 }`
*   Plugin user configuration defines `config` attribute as `{ "band": "AC/DC" }`
*   Resulting plugin configuration, accessible to given plugin at runtime, will be `{ "band": "AC/DC", "score": 10 }`

### Plugin host page

Plugin host page [bootstraps](#Plugin_bootstrap_sequence) plugin code by evaluating JavaScript within the context of the corresponding `iframe` element.

Following code snippet shows a sample plugin host page:

      /usr/share/ovirt-engine/ui-plugins/example-resources/start.html

            // Plugin code, evaluated within HTML head section (2)

            // Plugin code, evaluated within HTML body section (3)

Prior to evaluating actual plugin code, host page can load dependent scripts or other resources as necessary (1). Plugin code can be evaluated either within `head` (2) or `body` (3) section of the HTML document. In addition to embedding plugin code inline into host page, code can be also loaded asynchronously as external script, i.e. ``

. There are no specific rules on how to load plugin code within the host page, the only requirement is that loading host page HTML document should evaluate plugin code eventually.

Note that WebAdmin [loads](#Loading_plugins) the given plugin via hidden HTML `iframe` element. This has following implications:

*   Plugin code runs within the context of the corresponding `iframe` element, i.e. not in WebAdmin (top-level) context
*   Plugin code should use [plugin API](#API_function_reference) to make UI extensions, i.e. avoid direct HTML DOM manipulation of WebAdmin UI
*   Any markup placed within HTML `body` section will have no effect since the `iframe` element is hidden from WebAdmin view

### Why load plugins via iframe element?

From UI plugin infrastructure perspective, each plugin represents a standalone web application that integrates with WebAdmin through [plugin API](#API_function_reference).

Each plugin can load dependent scripts or other resources scoped to its own context, i.e. `Window` object for the corresponding `iframe` element. The `iframe` element is essentially a sandbox for evaluating plugin code:

*   WebAdmin UI won't break when some plugin breaks - instead, WebAdmin puts the misbehaving plugin out of service
*   WebAdmin DOM won't be polluted with dependencies (external scripts or other resources) of individual plugins
*   WebAdmin vs. plugin integration happens through plugin API, discouraging direct HTML DOM manipulation of WebAdmin UI which would impose a fragile, HTML structure dependant bond between plugin and WebAdmin

Aside from [plugin host page](#Plugin_host_page), any custom UI contributed by a plugin follows the same principles as mentioned above.

### Plugin bootstrap sequence

Plugin code that runs due to host page being loaded typically follows a common pattern:

*   Get `pluginApi` instance for the given plugin
*   Get runtime plugin configuration (optional)
*   Customize API options that affect specific features of plugin API (optional)
*   Register relevant [event handler functions](#Application_event_reference)
*   When ready, notify UI plugin infrastructure to proceed with plugin initialization

Following code snippet illustrates the above mentioned pattern:

    // Get plugin API for "ExamplePlugin", using "parent" due to plugin code being evaluated within an iframe context
    // Note that "parent.pluginApi" is subject to Same-Origin Policy, this implies WebAdmin HTML page and plugin host
    // page must be on same origin, which holds true when using UI plugin infrastructure to serve plugin resource files
    var api = parent.pluginApi('ExamplePlugin');

    // Get runtime plugin configuration, i.e. custom configuration (if any) merged on top of default configuration (if any)
    var cfg = api.configObject();

    // Customize API options that affect specific features of plugin API, i.e. override default API options
    api.options({ ... });

    // Register relevant event handler functions for later invocation by UI plugin infrastructure
    api.register({ ... });

    // Notify UI plugin infrastructure to proceed with plugin initialization, i.e. expect UiInit event callback
    api.ready();

### Plugin lifecycle

UI plugin infrastructure maintains a common lifecycle to control execution of individual plugins. The lifecycle consists of possible states and transitions between these states at runtime.

![](Plugin-lifecycle.png "Plugin lifecycle")

DEFINED

The plugin has been defined through its meta-data. A corresponding `iframe` element has been created. This is the initial state for all plugins.

LOADING

The `iframe` element has been attached to DOM, causing plugin host page to be fetched asynchronously in the background. We are waiting for the plugin to report back as ready.

READY

The plugin has indicated that it is ready for use. We expect the event handler object (object containing [event handler functions](#Application_event_reference)) to be registered by now. While in plugin invocation context`*`, proceed with plugin initialization. Otherwise, initialize the plugin upon entering next invocation context.

INITIALIZING

The plugin is being initialized by calling `UiInit` event handler function. The `UiInit` function will be called just once during the lifetime of a plugin, before calling other event handler functions.

IN USE

The `UiInit` function completed successfully, WebAdmin will call other event handler functions as necessary. The plugin is in use.

FAILED

An uncaught exception escaped while calling plugin event handler function, indicating internal error within plugin code. The `iframe` element has been detached from DOM. The plugin is removed from service.

`*` Plugin invocation context starts when user logs into WebAdmin and ends when user logs out. Processing [event handler functions](#Application_event_reference) as well as [plugin API](#API_function_reference) calls is constrained by this context, i.e. plugins are in effect only while user stays authenticated in WebAdmin UI.

### Application event reference

<caption>Supported event handler functions</caption>

Function

Arguments`*`

Description

#### Core functions

      UiInit

-

Called by the infrastructure as part of plugin initialization. The `UiInit` function will be called just once during the lifetime of a plugin, before WebAdmin calls other event handler functions. This function is a good place for one-time UI extensions.

#### Authentication

      UserLogin

      string userNameWithDomain
 `string userId`

Called after a user logs into WebAdmin. The `userNameWithDomain` follows `user@domain` convention.

      UserLogout

-

Called after a user logs out of WebAdmin.

#### Main tab item selection

      {EntityType}SelectionChange

      arguments

Called when item selection changes in the given main tab. Replace `{EntityType}` with name of desired entity. Refer to [entity types](#Entity_type_reference) for details on supported entity names and their object representations.

#### REST API integration

      RestApiSessionAcquired

      string sessionId

Called upon acquiring oVirt Engine [REST API](REST-Api) [persistent session](Features/RESTSessionManagement) after successful login. The `sessionId` maps to REST API session bound to current WebAdmin user, which means this value is shared between all plugins. The REST API session is acquired with timeout equal to oVirt Engine user session timeout. WebAdmin will try to keep the REST API session (and corresponding Engine user session) alive by sending heartbeat requests while user stays authenticated in WebAdmin UI. WebAdmin won't close the session upon logout, as there might be other systems still working with it.

#### Cross-window messaging

      MessageReceived

      object data
 `object sourceWindow`

Called when another `Window` (i.e. custom UI contributed by a plugin) sends message to WebAdmin `Window` via HTML5 [postMessage](http://en.wikipedia.org/wiki/Web_Messaging) API. In a typical scenario, custom UI living in `iframe` context sends message to WebAdmin (parent) `Window` which in turn dispatches the message to individual plugins. Refer to `allowedMessageOrigins` in [API options](#API_option_reference) for details on customizing origins from which messages will be accepted. The `sourceWindow` can be used to establish two-way communication between plugin code and sender's `Window` object.

`*` If specified, `arguments` represent the implicit JavaScript [function argument object](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions_and_function_scope/arguments).

### API function reference

<caption>Supported API functions</caption>

Function

Arguments

Description

#### Core functions

      register

      object eventHandlerObject

Registers the event handler object, i.e. object containing [event handler functions](#Application_event_reference) which facilitate WebAdmin → plugin communication. The `register` function must be called with valid `eventHandlerObject` before calling `ready` function. The `eventHandlerObject` must be an object declaring event handler functions as its properties, or an empty object. After the `eventHandlerObject` has been set for given plugin, calling `register` function has no effect.

    api.register({
        UiInit: function() {
            api.addSubTab('Host', 'Special Host Tab', 'special-host-tab',
                '/ovirt-engine/webadmin/plugin/ExamplePlugin/special-host-tab.html');
            api.setTabAccessible('special-host-tab', false);
        },
        HostSelectionChange: function() {
            var specialHostSelected = arguments.length == 1
                && arguments[0].name.indexOf('special') != -1;
            api.setTabAccessible('special-host-tab', specialHostSelected);
        }
    });

      options

      object apiOptionsObject

Provides custom API options that affect specific features of plugin API, overriding default API options. The `options` function can be called anytime during the lifetime of a plugin. Refer to [API options](#API_option_reference) for details.

    api.options({
        allowedMessageOrigins: ['http://one.com', 'https://two.org']
    });

      ready

-

Notifies the infrastructure to proceed with plugin initialization, calling `UiInit` event handler function (if defined) as soon as the plugin invocation context is entered (refer to [plugin lifecycle](#Plugin_lifecycle) for details). The `register` function must be called with valid `eventHandlerObject` before calling `ready` function, otherwise the `ready` function has no effect.

    api.ready();

      configObject

-

Returns the runtime plugin configuration object containing custom configuration (if any) merged on top of default configuration (if any). Refer to [plugin user configuration](#Plugin_user_configuration) for details. In case neither the default nor custom configuration is available for given plugin, the `configObject` function returns an empty object.

    var conf = api.configObject();
    var favoriteBand = conf.band || ;

#### User information

      loginUserName

      loginUserId

#### Main and sub tabs

      addMainTab

      addSubTab

      setTabContentUrl

      setTabAccessible

      addMainTabActionButton

      addSubTabActionButton

#### Dialogs

      showDialog

      setDialogContentUrl

      closeDialog

### API option reference

<caption>Supported plugin API options</caption>

Option

Default value

Description

#### Cross-window messaging

`allowedMessageOrigins` (string or string array)

empty array

Defines allowed source [origins](http://en.wikipedia.org/wiki/Same_origin_policy#Origin_determination_rules) from which HTML5 `message` events will be accepted and passed to `MessageReceived` event handler function. The value can be either a string (single origin) or a string array (multiple origins). `*` translates to "any origin", as per HTML5 [postMessage](http://en.wikipedia.org/wiki/Web_Messaging) specification.

### Entity type reference

<caption>Supported entity types</caption>

Name

Object representation (exposed attributes)

      DataCenter

`id` (string)
 `name` (string)

      Cluster

`id` (string)
 `name` (string)

      Host

`id` (string)
 `name` (string)
 `hostname` (string)

      Network

`id` (string)
 `name` (string)

      Storage

`id` (string)
 `name` (string)

      Disk

`id` (string)

      VirtualMachine

`id` (string)
 `name` (string)
 `ipaddress` (string)

      Pool

`id` (string)
 `name` (string)

      Template

`id` (string)
 `name` (string)

      GlusterVolume

`id` (string)
 `name` (string)

      Provider

`id` (string)
 `name` (string)

      User

`id` (string)
 `username` (string)
 `domain` (string)

      Quota

`id` (string)
 `name` (string)

      Event

`id` (string)

### Tutorials

#### UI Plugins Crash Course

The [oVirt Space Shooter](Tutorial/UIPlugins/CrashCourse) tutorial walks you through the basics of creating your first UI plugin.

![](OVirt_Space_Shooter_3.png "oVirt Space Shooter")

### Resources

*   Presentation slides: ![](UI_Plugins_PoC_Overview_2012.pdf "UI Plugins PoC Overview") (October 2012)
*   Presentation slides: ![](UI_Plugins_at_oVirt_Workshop_Sunnyvale_2013.pdf "UI Plugins at oVirt Workshop Sunnyvale") (January 2013)
*   Miscellaneous: [Original Design Notes](Features/UIPluginsOriginalDesignNotes), ![](Ui-plugin-figures.tar.gz "UI Plugin Figures")

### UI plugin cheat sheet

Minimal plugin descriptor:

      /usr/share/ovirt-engine/ui-plugins/minimal.json

    {
        "name": "MinimalPlugin",
        "url": "/ovirt-engine/webadmin/plugin/MinimalPlugin/start.html",
        "resourcePath": "minimal-resources"
    }

Minimal plugin host page:

      /usr/share/ovirt-engine/ui-plugins/minimal-resources/start.html

            var api = parent.pluginApi('MinimalPlugin');
            api.register({
                UiInit: function() { window.alert('Hello world!'); }
            });
            api.ready();

### Sample UI plugins

Repository hosting sample UI plugins: git://gerrit.ovirt.org/samples-uiplugins ([Gerrit web](http://gerrit.ovirt.org/gitweb?p=samples-uiplugins.git))

### Real-world UI plugins

#### oVirt Monitoring UI Plugin

This plugin brings integration with [Nagios](http://www.nagios.org/) or [Icinga](https://www.icinga.org/) monitoring solution into oVirt.

*   Author: René Koch <<r.koch@ovido.at>></<r.koch@ovido.at>>
*   Project web site: <https://labs.ovido.at/monitoring/wiki/ovirt-monitoring-ui-plugin>
*   Installation documentation: <https://labs.ovido.at/monitoring/wiki/ovirt-monitoring-ui-plugin:install>
*   UI plugin source code: <https://labs.ovido.at/monitoring/wiki/ovirt-monitoring-ui-plugin:svn>

 ![](Ovirt-monitoring%20hosts%20graph.png "Monitoring Details sub tab")

#### Foreman UI Plugin

The purpose of this plugin is to allow administrators to see details on [Foreman](http://theforeman.org/) related entities (such as VMs).

*   Author: Oved Ourfali <<ovedo@redhat.com>></<ovedo@redhat.com>>
*   Documentation: <http://ovedou.blogspot.co.il/2012/12/ovirt-foreman-ui-plugin.html>
*   Foreman plugin source code: <https://github.com/oourfali/foreman_ovirt>
*   UI plugin source code: available from [sample UI plugin repository](#Sample_UI_plugins) as `foreman-plugin`

 ![](Foreman%20view%20details.png "Foreman Details sub tab")

#### UI-VDSM-Hooks Plugin

Using CGI scripts located on the host's web-server, VDSM commands (vdsClient) can be invoked directly from the WebAdmin UI.

*   Author: Daniel Erez <<derez@redhat.com>></<derez@redhat.com>>
*   Documentation: <http://derezvir.blogspot.co.il/2013/06/ovirt-ui-vdsm-hooks-plugin.html>
*   UI plugin source code: available from [sample UI plugin repository](#Sample_UI_plugins) as `ui-vdsm-hooks-plugin`

 ![](UI-VDSM-Hooks-Examples.png "UI-VDSM-Hooks context menu")

#### Shell In A Box UI Plugin

Using oVirt WebAdmin, make SSH connection to a host and emulate a terminal via [Shell In A Box](http://code.google.com/p/shellinabox/).

*   Author: Daniel Erez <<derez@redhat.com>></<derez@redhat.com>>
*   Documentation: <http://derezvir.blogspot.co.il/2013/01/ovirt-webadmin-shellinabox-ui-plugin.html>
*   UI plugin source code: available from [sample UI plugin repository](#Sample_UI_plugins) as `shellinabox-plugin`

 ![](ShellBox%20SubTab.png "Shell Box sub tab")

### Comments and discussion

*   Refer to [UI plugins discussion page](talk:Features/UIPlugins).
