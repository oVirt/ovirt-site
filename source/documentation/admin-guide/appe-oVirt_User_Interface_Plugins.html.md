---
title: oVirt User Interface Plugins
---

# Appendix C: oVirt User Interface Plugins

oVirt supports plug-ins that expose non-standard features. This makes it easier to use the oVirt Administration Portal to integrate with other systems. Each interface plug-in represents a set of user interface extensions that can be packaged and distributed for use with oVirt.

oVirt's User Interface plug-ins integrate with the Administration Portal directly on the client using the JavaScript programming language. Plug-ins are invoked by the Administration Portal and executed in the web browser's JavaScript runtime. User Interface plug-ins can use the JavaScript language and its libraries.

At key events during runtime, the Administration Portal invokes individual plug-ins via event handler functions representing Administration-Portal-to-plug-in communication. Although the Administration Portal supports multiple event-handler functions, a plug-in declares functions which are of interest only to its implementation. Each plug-in must register relevant event handler functions as part of the plug-in bootstrap sequence before the plug-in is put to use by the administration portal.

To facilitate the plug-in-to-Administration-Portal communication that drives the User Interface extension, the Administration Portal exposes the plug-in API as a global (top-level) pluginApi JavaScript object that individual plug-ins can consume. Each plug-in obtains a separate pluginApi instance, allowing the Administration Portal to control plug-in API-function invocation for each plug-in with respect to the plug-in's life cycle.

## oVirt User Interface Plugin Lifecycle

The basic life cycle of a User Interface Plug-in divides into three stages:

1. Plug-in discovery.

2. Plug-in loading.

3. Plug-in bootstrapping.

### oVirt User Interface Plug-in Discovery

Creating plug-in descriptors is the first step in the plug-in discovery process. Plug-in descriptors contain important plug-in metadata and optional default plug-in-specific configurations.

As part of handling administration portal HTML page requests (`HTTP GET`), User Interface plug-in infrastructure attempts to discover and load plug-in descriptors from your local file system. For each plug-in descriptor, the infrastructure also attempts to load corresponding plug-in user configurations used to override default plug-in-specific configurations (if any exist) and tweak plug-in runtime behavior. Plug-in user configuration is optional. After loading descriptors and corresponding user configuration files, oVirt Engine aggregates User Interface plug-in data and embeds it into the administration portal HTML page for runtime evaluation.

By default, plug-in descriptors reside in `$ENGINE_USR/ui-plug-ins`, with a default mapping of `ENGINE_USR=/usr/share/ovirt-engine` as defined by oVirt Engine local configuration. Plug-in descriptors are expected to comply with JSON format specifications, but plug-in descriptors allow Java/C++ style comments (of both `/*` and `//` varieties) in addition to the JSON format specifications.

By default, plug-in user configuration files reside in `$ENGINE_ETC/ui-plug-ins`, with a default mapping of `ENGINE_ETC=/etc/ovirt-engine` as defined by oVirt Engine local configuration. Plug-in user configuration files are expected to comply with same content format rules as plug-in descriptors.

**Note:** Plug-in user configuration files generally follow the `<descriptorFileName>-config.json` naming convention.

### oVirt User Interface Plug-in Loading

After a plug-in has been discovered and its data is embedded into the administration portal HTML page, administration portal tries to load the plug-in as part of application startup (unless you have configured it not to load as part of application startup).

For each plug-in that has been discovered, the administration portal creates an HTML iframe element that is used to load its host page. The plug-in host page is necessary to begin the plug-in bootstrap process, which (the bootstrap process) is used to evaluate the plug-in code in the context of the plug-in's iframe element. User interface plug-in infrastructure supports serving plug-in resource files (such as the plug-in host page) from the local file system. The plug-in host page is loaded into the iframe element and the plug-in code is evaluated. After the plug-in code is evaluated, the plug-in communicates with the administration portal by means of the plug-in API.

### oVirt User Interface Plug-in Bootstrapping

A typical plug-in bootstrap sequence consists of following steps:

**Plug-in Bootstrap Sequence**

1. Obtain pluginApi instance for the given plug-in

2. Obtain runtime plug-in configuration object (optional)

3. Register relevant event handler functions

4. Notify UI plug-in infrastructure to proceed with plug-in initialization

The following code snippet illustrates the above mentioned steps in practice:

    // Access plug-in API using 'parent' due to this code being evaluated within the context of an iframe element.
    // As 'parent.pluginApi' is subject to Same-Origin Policy, this will only work when WebAdmin HTML page and plug-in
    // host page are served from same origin. WebAdmin HTML page and plug-in host page will always be on same origin
    // when using UI plug-in infrastructure support to serve plug-in resource files.
    var api = parent.pluginApi('MyPlugin');

    // Runtime configuration object associated with the plug-in (or an empty object).
    var config = api.configObject();

    // Register event handler function(s) for later invocation by UI plug-in infrastructure.
    api.register({
         // UiInit event handler function.
      UiInit: function() {
        // Handle UiInit event.
         window.alert('Favorite music band is ' + config.band);
             }
    });

    // Notify UI plug-in infrastructure to proceed with plug-in initialization.
    api.ready();

<!-- end ## section -->

## User Interface Plugin-related Files and Their Locations

**UI Plugin-related Files and their Locations**

| File | Location | Remarks |
|-
| Plug-in descriptor files (meta-data) | `/usr/share/ovirt-engine/ui-plugins/my-plugin.json` | |
| Plug-in user configuration files | `/etc/ovirt-engine/ui-plugins/my-plugin-config.json` | |
| Plug-in resource files | `/usr/share/ovirt-enging/ui-plugins/<resourcePath>/PluginHostPage.html` | `<resourcePath>` is defined by the corresponding attribute in the plug-in descriptor. |

## Example User Interface Plug-in Deployment

Follow these instructions to create a user interface plug-in that runs a `Hello World!` program when you sign in to the oVirt Engine administration portal.

**Deploying a `Hello World!` Plug-in**

1. Create a plug-in descriptor by creating the following file in the Engine at `/usr/share/ovirt-engine/ui-plugins/helloWorld.json`:

        {
            "name": "HelloWorld",
            "url": "/ovirt-engine/webadmin/plugin/HelloWorld/start.html",
            "resourcePath": "hello-files"
        }

2. Create the plug-in host page by creating the following file in the Engine at `/usr/share/ovirt-engine/ui-plugins/hello-files/start.html`:

        <!DOCTYPE html><html><head>
        <script>
            var api = parent.pluginApi('HelloWorld');
            api.register({
         UiInit: function() { window.alert('Hello world'); }
            });
            api.ready();
        </script>
        </head><body></body></html>

If you have successfully implemented the `Hello World!` plug-in, you will see this screen when you sign in to the administration portal:

**A Successful Implementation of the `Hello World!` Plug-in**

![](/images/admin-guide/1475.png)

**Prev:** [Appendix B: Custom Network Properties](../appe-Custom_Network_Properties)<br>
**Next:** [Appendix D: oVirt and SSL](../appe-oVirt_and_SSL)
