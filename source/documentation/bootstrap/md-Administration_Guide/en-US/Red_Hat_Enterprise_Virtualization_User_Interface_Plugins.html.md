# Red Hat Virtualization User Interface Plug-ins

Red Hat Virtualization supports plug-ins that expose non-standard features. This makes it easier to use the Red Hat Virtualization Administration Portal to integrate with other systems. Each interface plug-in represents a set of user interface extensions that can be packaged and distributed for use with Red Hat Virtualization.

Red Hat Virtualization's User Interface plug-ins integrate with the Administration Portal directly on the client using the JavaScript programming language. Plug-ins are invoked by the Administration Portal and executed in the web browser's JavaScript runtime. User Interface plug-ins can use the JavaScript language and its libraries.

At key events during runtime, the Administration Portal invokes individual plug-ins via event handler functions representing Administration-Portal-to-plug-in communication. Although the Administration Portal supports multiple event-handler functions, a plug-in declares functions which are of interest only to its implementation. Each plug-in must register relevant event handler functions as part of the plug-in bootstrap sequence before the plug-in is put to use by the administration portal.

To facilitate the plug-in-to-Administration-Portal communication that drives the User Interface extension, the Administration Portal exposes the plug-in API as a global (top-level) pluginApi JavaScript object that individual plug-ins can consume. Each plug-in obtains a separate pluginApi instance, allowing the Administration Portal to control plug-in API-function invocation for each plug-in with respect to the plug-in's life cycle.
