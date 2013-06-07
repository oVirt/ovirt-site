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

This feature provides an infrastructure and API for implementing and deploying custom user interface plugins for oVirt web administration application.

### Owner

*   Name: [Vojtech Szocs](User:Vszocs)
*   Email: <vszocs@redhat.com>

### Current status

*   Plugin infrastructure implementation complete and working
*   In progress: improve and extend plugin API to cover more use-cases
*   In progress: resolve issues with JavaScript vs. REST API communication

### Overview

oVirt web administration application (WebAdmin) is the main graphical user interface for managing all components of a virtual system infrastructure. In addition to existing WebAdmin functionality, there can be times when administrators want to expose additional features or to integrate with other systems through WebAdmin UI. This is where UI plugins come into play: each plugin represents a set of user interface extensions that can be packaged and distributed for deployment on oVirt Engine via WebAdmin.

### Introduction

UI plugins integrate with WebAdmin directly on the client (web browser) using [JavaScript](http://en.wikipedia.org/wiki/JavaScript) programming language. Plugin invocation is driven by WebAdmin and happens right within the context of web browser's JavaScript runtime, using JavaScript language as the lowest common denominator between WebAdmin ([GWT](http://en.wikipedia.org/wiki/Google_Web_Toolkit)) and individual plugins. UI plugins can take full advantage of JavaScript language and its rich ecosystem of libraries. There are no specific rules on how to implement UI plugins, plugin API is designed to be simple and not to get in developer's way, regardless of how a developer chooses to write the plugin.

At key events during runtime, WebAdmin invokes individual plugins via [event handler functions](#Application_event_reference) representing WebAdmin → plugin communication. Even though WebAdmin supports many different event handler functions, a plugin only declares functions which are of interest to its implementation. Each plugin must register relevant event handler functions as part of its [bootstrap sequence](#Plugin_bootstrap_sequence), before the plugin is put to use by WebAdmin.

To facilitate plugin → WebAdmin communication that drives UI extension, WebAdmin exposes [plugin API](#API_function_reference) as global (top-level) `pluginApi` JavaScript object for individual plugins to consume. Each plugin obtains specific `pluginApi` instance, allowing WebAdmin to control plugin API function invocation per each plugin with regard to [plugin lifecycle](#Plugin_lifecycle).

### Discovering plugins

Before a plugin can be [loaded](#Loading_plugins) and [bootstrapped](#Plugin_bootstrap_sequence) by WebAdmin, it has to be discovered by UI plugin infrastructure in the first place.

![Discovering plugins](Discovering-plugins.png "Discovering plugins")

[Plugin descriptor](#Plugin_descriptor) is the entry point to discovery process, containing plugin meta-data as well as (optional) default plugin-specific configuration.

As part of handling WebAdmin HTML page request (1), UI plugin infrastructure attempts to discover and load plugin descriptors from local file system (2). For each descriptor, the infrastructure also attempts to load corresponding [plugin user configuration](#Plugin_user_configuration) used to override default plugin-specific configuration (if any) and tweak plugin runtime behavior. Note that providing plugin user configuration is completely optional. After loading descriptors and corresponding user configuration files (if any), oVirt Engine aggregates UI plugin data and embeds it into WebAdmin HTML page for runtime evaluation (3).

Descriptor files are expected to reside in `$ENGINE_USR/ui-plugins` directory, with default mapping `ENGINE_USR=/usr/share/ovirt-engine` as defined by oVirt Engine local configuration. Descriptor files should comply with [JSON](http://en.wikipedia.org/wiki/JSON) format specification with the addition of allowing Java/C++ style comments, i.e. both `/* comment */` and `// comment` varieties.

User configuration files are expected to reside in `$ENGINE_ETC/ui-plugins` directory, with default mapping `ENGINE_ETC=/etc/ovirt-engine` as defined by oVirt Engine local configuration. User configuration files should comply with same content format rules as descriptors. Note that user configuration files generally follow `<descriptorFileName>-config.json` naming convention, i.e. using `-config` suffix.

### Loading plugins

After a plugin has been [discovered](#Discovering_plugins) and its data embedded into WebAdmin HTML page, WebAdmin will attempt to load the given plugin as part of application startup (unless configured otherwise).

![Loading plugins](Loading-plugins.png "Loading plugins")

For each plugin, WebAdmin creates hidden HTML `iframe` element used to load [plugin host page](#Plugin_host_page) (1). Plugin host page is the entry point to [bootstrap](#Plugin_bootstrap_sequence) process, used to evaluate plugin code (JavaScript) within the context of the corresponding `iframe` element. UI plugin infrastructure supports serving plugin resource files, such as host page, from local file system (2). Host page gets loaded into `iframe` element and plugin code is evaluated (3). From this point forward, plugin communicates with WebAdmin via plugin API (4). Since the purpose of host page is to bootstrap plugin code, any UI extensions should be done via [plugin API](#API_function_reference) rather than direct HTML DOM manipulation.

Plugin resource files are expected to reside in `$ENGINE_USR/ui-plugins/<resourcePath>` directory, with `resourcePath` value defined by the corresponding attribute in [plugin descriptor](#Plugin_descriptor). For example:

*   Client requests URL `/webadmin/webadmin/plugin/<pluginName>/path/to/file`
*   Engine serves content of `$ENGINE_USR/ui-plugins/<resourcePath>/path/to/file`

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
        "url": "/webadmin/webadmin/plugin/ExamplePlugin/start.html",

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
        // Default value is "true"
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

    <!DOCTYPE html>
    <html>

    <head>
        <!--
            Load additional scripts or other resources as necessary (1)
            <script type="text/javascript" src="/webadmin/webadmin/plugin/ExamplePlugin/js/useful-library.js"></script>
        -->
        <script type="text/javascript">
            // Plugin code, evaluated within HTML head section (2)
        </script>
    </head>

    <body>
        <script type="text/javascript">
            // Plugin code, evaluated within HTML body section (3)
        </script>
    </body>

    </html>

Prior to evaluating actual plugin code, host page can load dependent scripts or other resources as necessary (1). Plugin code can be evaluated either within `head` (2) or `body` (3) section of the HTML document. In addition to embedding plugin code inline into host page, code can be also loaded asynchronously as external script, i.e. `<script type="text/javascript" src="..."></script>`. There are no specific rules on how to load plugin code within the host page, the only requirement is that loading host page HTML document should evaluate plugin code eventually.

Note that WebAdmin [loads](#Loading_plugins) the given plugin via hidden HTML `iframe` element. This has following implications:

*   Plugin code runs within the context of the corresponding `iframe` element, i.e. not WebAdmin (top-level) context
*   Plugin code should use [plugin API](#API_function_reference) to make UI extensions, i.e. avoid direct HTML DOM manipulation
*   Any markup placed within HTML `body` section will have no effect since the `iframe` element is hidden from WebAdmin view

### Plugin bootstrap sequence

Plugin code that runs due to host page being loaded typically follows a common pattern:

*   Get `pluginApi` instance for the given plugin
*   Get runtime plugin configuration (optional)
*   Customize API options that affect specific features of plugin API (optional)
*   Register relevant [event handler functions](#Application_event_reference)
*   Notify UI plugin infrastructure to proceed with plugin initialization

Following code snippet illustrates the above mentioned pattern:

    // Get plugin API for "ExamplePlugin" using "parent" due to plugin code being evaluated within an iframe context
    // Note that "parent.pluginApi" is subject to Same-Origin Policy, this implies WebAdmin HTML page and plugin host
    // page must be on same origin, i.e. this holds true when using UI plugin infrastructure to serve plugin resource files
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

TODO

### Application event reference

TODO

### API function reference

TODO

### UI plugin cheat sheet

Minimal plugin descriptor:

      /usr/share/ovirt-engine/ui-plugins/minimal.json

    {
        "name": "MinimalPlugin",
        "url": "/webadmin/webadmin/plugin/MinimalPlugin/start.html",
        "resourcePath": "minimal-resources"
    }

Minimal plugin host page:

      /usr/share/ovirt-engine/ui-plugins/minimal-resources/start.html

    <!DOCTYPE html><html><head>

    <script type="text/javascript">
        var api = parent.pluginApi('MinimalPlugin');
        api.register({
            UiInit: function() { window.alert('Hello world!'); }
        });
        api.ready();
    </script>

    </head><body></body></html>

### Sample UI plugins

Repository hosting sample UI plugins: `git://gerrit.ovirt.org/samples-uiplugins` ([Gerrit web](http://gerrit.ovirt.org/gitweb?p=samples-uiplugins.git))

### Real-world UI plugins

#### oVirt Monitoring UI Plugin

This plugin brings integration with [Nagios](http://www.nagios.org/) or [Icinga](https://www.icinga.org/) monitoring solution into oVirt.

*   Author: René Koch <r.koch@ovido.at>
*   Project web site: <https://labs.ovido.at/monitoring/wiki/ovirt-monitoring-ui-plugin>
*   Installation documentation: <https://labs.ovido.at/monitoring/wiki/ovirt-monitoring-ui-plugin:install>
*   UI plugin source code: <https://labs.ovido.at/monitoring/wiki/ovirt-monitoring-ui-plugin:svn>

![Monitoring Details sub tab](Ovirt-monitoring hosts graph.png "fig:Monitoring Details sub tab")

#### Foreman UI Plugin

The purpose of this plugin is to allow administrators to see details on [Foreman](http://theforeman.org/) related entities (such as VMs).

*   Author: Oved Ourfali <ovedo@redhat.com>
*   Documentation: <http://ovedou.blogspot.co.il/2012/12/ovirt-foreman-ui-plugin.html>
*   Foreman plugin source code: <https://github.com/oourfali/foreman_ovirt>
*   UI plugin source code: available from [sample UI plugin repository](#Sample_UI_plugins) as `foreman-plugin`

![Foreman Details sub tab](Foreman view details.png "fig:Foreman Details sub tab")

#### Shell In A Box UI Plugin

Using oVirt WebAdmin, make SSH connection to a host and emulate a terminal via [Shell In A Box](http://code.google.com/p/shellinabox/).

*   Author: Daniel Erez <derez@redhat.com>
*   Documentation: <http://derezvir.blogspot.co.il/2013/01/ovirt-webadmin-shellinabox-ui-plugin.html>
*   UI plugin source code: available from [sample UI plugin repository](#Sample_UI_plugins) as `shellinabox-plugin`

![Shell Box sub tab](ShellBox SubTab.png "fig:Shell Box sub tab")

### References

*   [Original design notes](Features/UIPluginsOriginalDesignNotes)

### Comments and discussion

*   Refer to [UI plugins discussion page](Talk:Features/UIPlugins).

<Category:Feature>
