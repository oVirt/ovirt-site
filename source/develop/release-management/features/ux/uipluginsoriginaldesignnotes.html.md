---
title: UIPluginsOriginalDesignNotes
authors: vszocs
---

# UI Plugins Original Design Notes

## WebAdmin UI plugin infrastructure

*My notes on implementing 3rd party UI plugin infrastructure for WebAdmin GWT application.*

### Create PluginManager class as GIN-managed eager singleton

*   PluginManager will create and expose global "plugins" JavaScript object through JSNI.
*   Initially, "plugins" object will be empty. 3rd party plugins will register themselves into this object when they're invoked by plugin infrastructure. This is very similar to how jQuery plugins work.

Example plugin code (each plugin is represented by a piece of JavaScript):

    plugins.myPlugin = {
        // plugin life-cycle functions will go here
    };

*   PluginManager will invoke (evaluate) all 3rd party plugins. The global "plugins" object will now contain all registered plugins.
*   For exposing WebAdmin classes (plugin API) to plugins (JavaScript code), gwt-exporter project will be used. See <http://code.google.com/p/gwt-exporter/wiki/GettingStarted>.

### Define plugin life-cycle controlled by PluginManager

*   PluginManager will invoke plugin life-cycle functions on registered plugins.
*   Some ideas on life-cycle functions:
    -   init - called right after invoking the plugin, allows the plugin to initialize itself before it's put to use (init function must return something to indicate that the plugin is ready)
    -   handle - handles a specific application event, for example: VM in VM main tab has been selected, we're about to present context-sensitive menu, plugin might want to add its own context-sensitive menu item(s)
    -   events - defines which application events (extension points) is the plugin interested in

### Define automatic plugin discovery and loader architecture

*   WebAdmin host page servlet can detect 3rd party plugins placed in some directory and include them into the final page. Alternatively, plugins can be detected and requested async after WebAdmin startup.
*   Allow plugins to define their dependencies (other JavaScript libraries). For this purpose, plugin configuration (JSON or XML) file can be defined.
