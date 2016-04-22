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
        // This URL maps to $ENGINE_USR/ui-plugins/example-resources/plugin.html
        "url": "plugin/ExamplePlugin/plugin.html",

        // Default configuration associated with the plugin (optional)
        "config": { "band": "ZZ Top", "score": 10 },

        // Path to plugin resource files relative to descriptor (optional)
        // Required when using UI plugin infrastructure to serve plugin resource files
        // This path maps to $ENGINE_USR/ui-plugins/example-resources
        "resourcePath": "example-resources"

    }

Notice the use of relative URL in `url` attribute. Since WebAdmin resides in `/ovirt-engine/webadmin` URL context, it's usually best to use relative URLs when referring to plugin resource files. This way, the plugin is more resilient to potential changes in WebAdmin base URL.

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

      /usr/share/ovirt-engine/ui-plugins/example-resources/plugin.html

            // Plugin code, evaluated within HTML head section (2)

            // Plugin code, evaluated within HTML body section (3)

Prior to evaluating actual plugin code, host page can load dependent scripts or other resources as necessary (1). Plugin code can be evaluated either within `head` (2) or `body` (3) section of the HTML document. In addition to embedding plugin code inline into host page, code can be also loaded asynchronously as external script, i.e. ``

. There are no specific rules on how to load plugin code within the host page, the only requirement is that loading host page HTML document should evaluate plugin code eventually.

Note that WebAdmin [loads](#Loading_plugins) the given plugin via hidden HTML `iframe` element. This has following implications:

*   Plugin code runs within the context of the corresponding `iframe` element, i.e. not in WebAdmin (top-level) context
*   Plugin code should use [plugin API](#API_function_reference) to make UI extensions, i.e. avoid direct HTML DOM manipulation of WebAdmin UI
*   Any markup placed within HTML `body` section will have no effect since the `iframe` element is hidden from WebAdmin view

Notice the use of relative URL to load additional script in above snippet. According to [plugin descriptor](#Plugin_descriptor), the host page resides in `/ovirt-engine/webadmin/plugin/ExamplePlugin` URL context. From this context, we can refer to plugin resource files directly using relative paths.

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

### Plugin development tips

#### Avoid mixed content issues

If WebAdmin HTML page is served over HTTPS, WebAdmin and UI plugins should retrieve all content from remote servers through HTTPS in order not to compromise security of the whole application. When HTML page served over HTTPS includes content retrieved through cleartext HTTP, it's called mixed content page.

There are generally two types of [mixed content](https://developer.mozilla.org/en-US/docs/Security/MixedContent):

*   mixed active content - content through which an attacker could gain access to all or parts of web page: `script` element, `iframe` element, `XMLHttpRequest` object, etc.
*   mixed passive content - content that cannot access or alter web page: `img` element, etc.

Modern browsers typically block mixed active content and allow mixed passive content by default.

When requesting content from remote servers, UI plugins should ensure that requests are made through HTTPS in case WebAdmin HTML page is served over HTTPS. In other words, UI plugins shouldn't compromise security of the whole application.

For example, to load remote script using protocol of enclosing web page: ``

#### Working with REST API session

***In oVirt 4.0 the `RestApiSessionAcquired` event will be replaced with API to create authenticated requests for Engine services like the REST API.***

Upon successful login, WebAdmin acquires oVirt Engine REST API session for use by all UI plugins. Refer to [REST API integration](#REST_API_integration) for details.

To prevent closing the REST API session after processing given request, UI plugins should always include `Prefer: persistent-auth` header in all requests to REST API service.

The REST API session acquired by WebAdmin is marked as [CSRF](http://en.wikipedia.org/wiki/Cross-site_request_forgery) protected, which means all requests associated with this session must include a CSRF token (in addition to `JSESSIONID` cookie that is automatically sent by the browser). Otherwise, REST API will reject the request, which may trigger unexpected follow-up behavior such as "Authentication Required" browser popup.

The CSRF token is represented as `JSESSIONID` header with value obtained from `RestApiSessionAcquired` event handler function.

Following code snippet illustrates above mentioned practices using `XMLHttpRequest` object:

    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() { /* process response when done */ };
    xhr.open('GET', 'http://example-host/ovirt-engine/api', true);
    xhr.withCredentials = true; // for cross-site requests, ensure that auth information and cookies are included
    xhr.setRequestHeader('Accept', 'application/json'); // control response format
    xhr.setRequestHeader('Filter', 'false'); // control whether to filter results based on (WebAdmin) user's permissions
    xhr.setRequestHeader('Prefer', 'persistent-auth'); // prevent closing REST API session after processing request
    xhr.setRequestHeader('JSESSIONID', sessionId); // include CSRF token
    xhr.send(null);

### Terms used in API reference

#### JavaScript interface object

Object implementing a contract (interface) by declaring corresponding functions. Unlike the traditional concept of interface abstract type in object-oriented languages, an interface object doesn't necessarily have to declare all functions of the given interface in order to "implement" such interface. In fact, an empty object can be used as a valid interface object. Missing functions will be treated as empty (no-op) functions with default return values, as defined by the contract of such functions. An interface object can "implement" multiple interfaces simply by declaring functions of those interfaces.

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

Called when item selection changes in the given main tab. Replace `{EntityType}` with name of desired entity. Refer to [entity types](#Entity_type_reference) for details on supported entities and their object representations.

    api.register({
        DataCenterSelectionChange: function() {
            var firstSelectedItem = (arguments.length > 0) ? arguments[0] : null;
            var firstSelectedItemId = firstSelectedItem && firstSelectedItem.id;
        }
    });

#### System tree node selection

      SystemTreeSelectionChange

      object selectedNode

Called when node selection changes in the system tree. The `selectedNode` object contains two attributes: `string type` and `object entity` (optional, only if selected node has an entity associated). Refer to [entity types](#Entity_type_reference) for details on supported entities and their object representations.

    api.register({
        SystemTreeSelectionChange: function(selectedNode) {
            // See SystemTreeItemType Java enum for all supported values
            var nodeType = selectedNode.type;
            // Defined only if selected node has an entity associated
            var associatedEntity = selectedNode.entity;
            var associatedEntityId = associatedEntity && associatedEntity.id;
        }
    });

#### REST API integration

      RestApiSessionAcquired

      string sessionId

Called upon acquiring oVirt Engine [REST API](REST-Api) [persistent session](Features/RESTSessionManagement) after successful login. The `sessionId` maps to REST API session bound to current WebAdmin user, which means this value is shared between all plugins. The REST API session is acquired with timeout equal to oVirt Engine user session timeout. WebAdmin will try to keep the REST API session (and corresponding Engine user session) alive by sending heartbeat requests while user stays authenticated in WebAdmin UI. WebAdmin won't close the session upon logout, as there might be other systems still working with it.

------------------------------------------------------------------------

**Note:** the `sessionId` applies to oVirt Engine REST API service deployed at `/ovirt-engine/api`, not the legacy URL `/api`. UI plugins should always use `/ovirt-engine/api` to access the REST API service.

#### Cross-window messaging

      MessageReceived

      string` or `object data
 `object sourceWindow`

Called when another `Window` (i.e. custom UI contributed by a plugin) sends message to WebAdmin `Window` via HTML5 [postMessage](http://en.wikipedia.org/wiki/Web_Messaging) API. In a typical scenario, custom UI living in `iframe` context sends message to WebAdmin (parent) `Window` which in turn dispatches the message to individual plugins. Refer to `allowedMessageOrigins` in [API options](#API_option_reference) for details on customizing origins from which messages will be accepted. The `sourceWindow` can be used to establish two-way communication between plugin code and sender's `Window` object. Note that some browsers might support only `string` values when passing data through HTML5 postMessage API.

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
                'plugin/ExamplePlugin/special-tab.html');
            api.setTabAccessible('special-host-tab', false);
        },
        HostSelectionChange: function() {
            var isSpecial = arguments.length == 1 && arguments[0].name.indexOf('special') != -1;
            api.setTabAccessible('special-host-tab', isSpecial);
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

#### Authentication

      loginUserName

-

Returns user name and domain of currently logged in user, following `user@domain` convention.

    var userNameWithDomain = api.loginUserName();
    var domain = userNameWithDomain.substring(userNameWithDomain.indexOf('@') + 1);

      loginUserId

-

Returns [UUID](http://en.wikipedia.org/wiki/Universally_unique_identifier) of currently logged in user.

    var userId = api.loginUserId();

#### Main and sub tabs

      addMainTab

      string label
 `string historyToken`
 `string contentUrl`
 `object options`

Adds new main tab with content provided from given URL. All arguments are required except for `options`. The `label` is the text displayed on tab header. The `historyToken` serves as unique identifier of the tab, with its value reflected in tab header URL. Recommended `historyToken` format is `letters-with-dashes`. The `contentUrl` is passed to `src` attribute of the `iframe` element which renders tab content. The `options` can be undefined, null or object containing additional tab options:

*   `alignRight` - controls horizontal tab header alignment, default value is `false`
*   `priority` - controls tab's relative priority within the tab panel, default value is `Number.MAX_VALUE`

<!-- -->

    api.addMainTab('Custom Tab One', 'custom-tab-one',
        'plugin/ExamplePlugin/one.html'
    );
    api.addMainTab('Custom Tab Two', 'custom-tab-two',
        'plugin/ExamplePlugin/two.html',
        {
            alignRight: true,
            priority: -1
        }
    );

      addSubTab

      string entityTypeName
 `string label`
 `string historyToken`
 `string contentUrl`
 `object options`

Adds new sub tab with content provided from given URL. All arguments are required except for `options`. Semantics of `label`, `historyToken`, `contentUrl` and `options` are identical to ones declared by `addMainTab` function. The `entityTypeName` identifies existing main tab to which the newly added sub tab should be associated (only standard main tabs are supported). Refer to [entity types](#Entity_type_reference) for details on supported entity names.

    api.addSubTab('Host', 'Custom Host Tab One', 'custom-host-tab-one',
        'plugin/ExamplePlugin/host-one.html'
    );
    api.addSubTab('Host', 'Custom Host Tab Two, 'custom-host-tab-two',
        'plugin/ExamplePlugin/host-two.html',
        {
            alignRight: true,
            priority: -1
        }
    );

      setTabContentUrl

      string historyToken
 `string contentUrl`

Updates the content URL of given (main or sub) tab. Semantics of `historyToken` and `contentUrl` are identical to ones declared by `addMainTab` function. The `setTabContentUrl` function works only for tabs added via plugin API.

    api.setTabContentUrl('custom-tab',
        'plugin/ExamplePlugin/tab-content.html');

      setTabAccessible

      string historyToken
 `boolean tabAccessible`

Controls the accessibility of given (main or sub) tab. Semantics of `historyToken` is identical to one declared by `addMainTab` function. If `tabAccessible` is `false`, corresponding tab header will be hidden in WebAdmin UI and attempts to reveal the given tab manually by manipulating URL will be denied. The `setTabAccessible` function works only for tabs added via plugin API.

    api.setTabAccessible('custom-tab', false);

      addMainTabActionButton

      string entityTypeName
 `string label`
 `object actionButtonInterface`

Adds new button to the action panel and/or context menu for the given main tab. Semantics of `entityTypeName` is identical to one declared by `addSubTab` function. The `label` is the text displayed on button. The `actionButtonInterface` is an [interface object](#JavaScript_interface_object) that overrides button behavior via following properties:

*   `onClick` - function called when user clicks the button, arguments are items currently selected in given main tab, no-op by default
*   `isEnabled` - function called to determine whether the button should be enabled (clickable), arguments are items currently selected in given main tab, returns `true` by default
*   `isAccessible` - function called to determine whether the button should be accessible (visible), arguments are items currently selected in given main tab, returns `true` by default
*   `location` - controls button location in action panel and main tab's context menu, supported values:
    -   `OnlyFromContext` - button available only from context menu
    -   `OnlyFromToolBar` - button available only from action panel
    -   `ContextAndToolBar` - button available from both action panel and context menu (default value)

<!-- -->

    api.addMainTabActionButton('Host', 'Custom Button', {
        onClick: function() {
            var selectedHost = arguments[0];
            var isSpecial = selectedHost.name.indexOf('special') != -1;
            api.setTabAccessible('custom-tab', isSpecial);
        },
        isEnabled: function() {
            return arguments.length == 1;
        }
    });

      addSubTabActionButton

      string mainTabEntityTypeName
 `string subTabEntityTypeName`
 `string label`
 `object actionButtonInterface`

Adds new button to the action panel and/or context menu for the given sub tab. Semantics of `label` and `actionButtonInterface` are identical to ones declared by `addMainTabActionButton` function. The `mainTabEntityTypeName` and `subTabEntityTypeName` together identify existing sub tab to which the newly added button should be associated (only standard sub tabs are supported). Refer to [entity types](#Entity_type_reference) for details on supported entity names.

    api.addSubTabActionButton('Host', 'Event', 'Custom Button', {
        onClick: function() {
            var selectedHostEvent = arguments[0];
            var isSpecial = selectedHostEvent.message.indexOf('special') != -1;
            api.setTabAccessible('custom-tab', isSpecial);
        },
        isEnabled: function() {
            return arguments.length == 1;
        }
    });

------------------------------------------------------------------------

**Limitation:** `subTabEntityTypeName` currently supports only `Event` value, see [RFE ticket](https://bugzilla.redhat.com/1028124).

#### Dialogs

      showDialog

      string title
 `string dialogToken`
 `string contentUrl`
 `string width`
 `string height`
 `object options`

Shows new dialog with content provided from given URL. All arguments are required except for `options`. The `title` is the text displayed on dialog header. The `dialogToken` serves as unique identifier of the dialog. The `dialogToken` can be null in case the plugin doesn't need to reference the dialog after showing it, i.e. in case the dialog is meant to be closed via close icon or by pressing Escape key. Recommended `dialogToken` format is `letters-with-dashes`. The `contentUrl` is passed to `src` attribute of the iframe element which renders dialog content. The `width` and `height` are used to define dialog dimensions in CSS units. The `options` can be undefined, null or object containing additional dialog options:

*   `buttons` - array defining buttons to display in dialog's footer area, empty by default, each element is an [interface object](#JavaScript_interface_object) that overrides button behavior via following properties:
    -   `label` - controls text displayed on button, default value is empty string
    -   `onClick` - function called when user clicks the button, no arguments, no-op by default
*   `resizeEnabled` - controls whether the dialog can be resized with mouse, default value is `false`
*   `closeIconVisible` - controls whether the close icon (located in right-hand part of dialog header) is visible, default value is `true`
*   `closeOnEscKey` - controls whether the dialog can be closed by pressing Escape key, default value is `true`

<!-- -->

    api.showDialog('Custom Dialog One', 'custom-dialog-one',
        'plugin/ExamplePlugin/dialog-one.html',
        '640px', '480px'
    );
    api.showDialog('Custom Dialog Two', 'custom-dialog-two',
        'plugin/ExamplePlugin/dialog-two.html',
        '640px', '480px',
        {
            buttons: [
                {
                    label: 'Close',
                    onClick: function() {
                        api.closeDialog('custom-dialog-two');
                    }
                }
            ],
            resizeEnabled: true,
            closeIconVisible: false,
            closeOnEscKey: false
        }
    );

      setDialogContentUrl

      string dialogToken
 `string contentUrl`

Updates the content URL of given dialog. Semantics of `dialogToken` and `contentUrl` are identical to ones declared by `showDialog` function. The `setDialogContentUrl` function has no effect if the given dialog is already closed. The `setDialogContentUrl` function works only for dialogs shown via plugin API.

    api.setDialogContentUrl('custom-dialog',
        'plugin/ExamplePlugin/dialog-content.html');

      closeDialog

      string dialogToken

Closes the given dialog. Semantics of `dialogToken` is identical to one declared by `showDialog` function. Once closed, the dialog is destroyed.

    api.closeDialog('custom-dialog');

#### Navigation

      revealPlace

      string historyToken

Reveals the given application place, e.g. standard or plugin-contributed main tab. The `historyToken` denotes a logical place of the web application, represented as `#historyToken` in application's URL.

    api.revealPlace('hosts');

#### Search

      setSearchString

      string searchString

Applies the given search string. The `searchString` is the text to apply into WebAdmin's search panel.

    api.setSearchString('Hosts: name = abc');

### API option reference

<caption>Supported plugin API options</caption>

Option

Default value

Description

#### Cross-window messaging

      string` or `string[] allowedMessageOrigins

empty array

Defines [origins](http://en.wikipedia.org/wiki/Same_origin_policy#Origin_determination_rules) from which `message` events will be accepted and dispatched to plugin via `MessageReceived` event handler function. The value can be a string (single origin) or a string array (multiple origins). `*` translates to "any origin", as per HTML5 [postMessage](http://en.wikipedia.org/wiki/Web_Messaging) specification. Refer to `MessageReceived` function for details on cross-window messaging workflow.

------------------------------------------------------------------------

**Limitation:** plugins currently have to customize `allowedMessageOrigins` value to accept messages that originate from content served through UI plugin infrastructure, i.e. plugin resource files requested as `/ovirt-engine/webadmin/plugin//path/to/file`. Since Engine origin is generally considered safe, `allowedMessageOrigins` default value should be changed to Engine origin, see [RFE ticket](https://bugzilla.redhat.com/972226).

### Entity type reference

<caption>Supported entity types</caption>

Name

Attributes exposed by object representation`*`

      DataCenter

      string name

      Cluster

      string name

      Host

      string name
 `string hostname`

      Network

      string name

      Storage

      string name

      Disk

-

      VirtualMachine

      string name
 `string ipaddress`

      Pool

      string name

      Template

      string name

      GlusterVolume

      string name

      Provider

      string name

      User

      string username
 `string domain`

      Quota

      string name

      Event

      string correlationId
 `string message`
 `string callStack`
 `string customEventId`
 `string toString`

`*` all representations expose `string id` attribute which maps to [UUID](http://en.wikipedia.org/wiki/Universally_unique_identifier) of the given entity.

### Tutorials

#### UI Plugins Crash Course

The [oVirt Space Shooter](Tutorial/UIPlugins/CrashCourse) tutorial walks you through the basics of creating your first UI plugin.

![](OVirt_Space_Shooter_3.png "oVirt Space Shooter")

#### AngularJS Demo Plugin

This sample UI plugin uses [AngularJS](http://angularjs.org/), Model-View-Controller framework for JavaScript.

Plugin source code is available from [sample UI plugin repository](#Sample_UI_plugins) as `angular-demo-plugin`.

### Resources

*   ![](Writing-ui-plugin-with-angularjs.pdf "Writing UI plugin with AngularJS") + ![](Writing-ui-plugin-with-angularjs-demo-files.tar.gz "Sample Code") (April 2014)
*   ![](UI_Plugins_at_oVirt_Workshop_Sunnyvale_2013.pdf "UI Plugins at oVirt Workshop Sunnyvale") (January 2013)
*   ![](UI_Plugins_PoC_Overview_2012.pdf "UI Plugins PoC Overview") (October 2012)
*   [Original Design Notes](Features/UIPluginsOriginalDesignNotes)
*   ![](Ui-plugin-figures.tar.gz "UI Plugin Figures")

### UI plugin cheat sheet

Minimal plugin descriptor:

      /usr/share/ovirt-engine/ui-plugins/minimal.json

    {
        "name": "MinimalPlugin",
        "url": "plugin/MinimalPlugin/plugin.html",
        "resourcePath": "minimal-resources"
    }

Minimal plugin host page:

      /usr/share/ovirt-engine/ui-plugins/minimal-resources/plugin.html

            var api = parent.pluginApi('MinimalPlugin');
            api.register({
                UiInit: function() { window.alert('Hello world!'); }
            });
            api.ready();

### <a name="Sample_UI_plugins"></a>Sample UI plugins

Following repository hosts sample UI plugins contributed by community:

    $ git clone git://gerrit.ovirt.org/samples-uiplugins

Feel free to submit patches that introduce new plugins (or update existing ones) in this repository.

### Showcase

#### oVirt Monitoring UI Plugin

This plugin brings integration with [Nagios](http://www.nagios.org/) or [Icinga](https://www.icinga.org/) monitoring solution into oVirt.

*   Author: René Koch <<r.koch@ovido.at>></<r.koch@ovido.at>>
*   Project web site: <https://labs.ovido.at/monitoring/wiki/ovirt-monitoring-ui-plugin>
*   Installation documentation: <https://labs.ovido.at/monitoring/wiki/ovirt-monitoring-ui-plugin:install>
*   UI plugin source code: <https://github.com/monitoring-ui-plugin/monitoring-ui-plugin>

 ![](Ovirt-monitoring%20hosts%20graph.png "Monitoring Details sub tab")

#### Docker UI Plugin

This plugin allows you to create VM that runs a Docker image.

*   Author: Oved Ourfali <<ovedo@redhat.com>></<ovedo@redhat.com>>
*   Documentation: <http://ovedou.blogspot.co.il/2014/03/running-docker-container-in-ovirt.html>
*   UI plugin source code: available from [sample UI plugin repository](#Sample_UI_plugins) as `docker-plugin`

 ![](Create%20docker%20vm%20dialog.jpg "Create Docker VM dialog")

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

#### Cockpit UI Plugin

With this plugin, the host main-tab shows new subtab embedding Cockpit which is running on the selected host.
The host's right-click menu is enriched for new 'Cockpit' action leading to opening new browser window/tab with the host's Cockpit.

When Cockpit is not running on the selected host, the menu action is disabled and the embedding subtab shows basic troubleshooting info.

*   Author: Marek Libra <<mlibra@redhat.com>>
*   UI plugin source code: available from [sample UI plugin repository](#Sample_UI_plugins) as `cockpit-plugin`

 ![](Cockpit_UIPlugin.png "Cockpit UI Plugin")

### Comments and discussion

*   Refer to [discussion page](talk:Features/UIPlugins).
