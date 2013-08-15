---
title: Branding
authors: awels, gshereme
wiki_title: Feature/Branding
wiki_revision_count: 20
wiki_last_updated: 2014-04-30
---

# Branding

<big>Branding Support</big>

## Overview

The oVirt user portal and web admin recently obtained new functionality to allow one to partially skin/override some of the existing styles. This document gives a description of what is change-able and where to look to make it happen. The purpose of the current implementation is to prove the framework and give some basic styling abilities as well as some ability to change some of the messages. As the user portal and web admin are both web applications developed in GWT, they use standard cascading style sheets (CSS) to style the application. GWT does some magic to in-line styles to make them available faster, so to allow external styles takes a little bit work.

The current implementation gives the ability to change some of the styles in the following elements of the user interface:

*   pop-up windows
*   the login screen
*   the main header part of the user interfaces
*   Some of the tabbing tabs.

If needed we can increase the number of style-able elements in the future.

Some of the user interface elements that can be styled is shared between the two applications. One can style them independently or one can share the styles between the application. This is usually done by importing a common style sheet file into the main style sheet file of the application.

It is also possible to change some of the messages displayed to the user. These messages include 'branding' type message. Basically everything you see that says 'oVirt' something can be changed to say something else. This allows one to brand oVirt for their own company or anything you want.

#### Pop-up windows

Popup windows include anything that allows you create/edit/update a particular entity such as hosts, VMs, etc. You can change the following attributes of pop-up windows:

*   Border
*   Header image on the left
*   Header center image (repeated)

As illustrated by the following image:
![](popup-window-border.png "fig:popup-window-border.png")
 As the oVirt default branding is itself a branding theme you can look at the oVirt branding in `packaging/branding/ovirt.branding` in the source tree to see which css classes are available. The classes for the popup window are in `ovirt_common.css` and `gwt_common.css`

#### Login Screen

The user portal and web admin share the same login screen, so in the default branding style they share the same classes. You can change the following attributes of the login screen:

*   Border
*   Header image on the left
*   Header center image (repeated)
*   Header right image
*   Text in the header center

As illustrated by the following image:
![](login-window.png "fig:login-window.png")
As the oVirt default branding is itself a branding theme you can look at the oVirt branding in `packaging/branding/ovirt.branding` in the source tree to see which css classes are available. The classes for the login window are in `ovirt_common.css` and `gwt_common.css`

#### User portal main header

The user portal main header has the following attributes that can be changed:

*   Logo
*   Center background image
*   Right background image
*   The border around the main grid
*   Text right above the 'logged in user' label.

As illustrated by the following image:
![](User_portal_header.png "fig:User_portal_header.png")
As the oVirt default branding is itself a branding theme you can look at the oVirt branding in `packaging/branding/ovirt.branding` in the source tree to see which css classes are available. The classes for the user portal header are in `ovirt_user_portal.css`

#### Web admin main header

The web admin main header has the following attributes that can be changed:

*   Logo
*   left and center background
*   right background
*   Text to the right of the logo

As illustrated by the following image:
![](Wed_admin_header.png "fig:Wed_admin_header.png")
As the oVirt default branding is itself a branding theme you can look at the oVirt branding in `packaging/branding/ovirt.branding` in the source tree to see which css classes are available. The classes for the user portal header are in `ovirt_webadmin.css`

#### Tabbing elements

There are two types of tabbing elements in the user portal. The main page tabbing elements (to switch between basic and extended) and the tabs on the left side of the screen when you have the extended tab selected. The following attributes can be changed:

*   Active tab
*   Inactive tab

As illustrated by the following image:
![](User_portal_tab.png "fig:User_portal_tab.png")
A lot of pop-up windows will have a tabbing element on it as well these elements are common between the user portal and web admin interfaces. The following attributes can be changed:

*   Active tab
*   Inactive tab

As illustrated by the following image:
![](User_portal_tab_popup.png "fig:User_portal_tab_popup.png")
As the oVirt default branding is itself a branding theme you can look at the oVirt branding in `packaging/branding/ovirt.branding` in the source tree to see which css classes are available. The classes for the tabbing elements are in `ovirt_common.css` and `ovirt_user_portal.css`

## Adding new brandable styles

### CSS

Because this is a GWT application most of the styles are compiled into the application when the application is built. As part of this process the style class names are obfuscated and they change each time the application is build. GWT provides some guidance on how to solve this problem [here](https://developers.google.com/web-toolkit/doc/latest/DevGuideClientBundle#External_and_legacy_scopes). In order to add new brand-able style classes the following will have to be considered:

*   Any class name you define needs to marked with @external
*   All the class names should start with obrand_ this is signify to theme authors that the class can be used to override styles.
*   Any images normally cannot be changed with a style sheet, so we cheated a little and used style sheets to set the background image on an image tag. In order to not display a broken image icon you need to set the src of the image to something transparent and small. Luckily GWT provides an image like that already in 'clear.cache.gif'
*   Other than this any normal style properties can be set in your external style sheet.

### Text messages

GWT provides a mechanism that allows you to define messages for your application and have them automatically translated during the compile process if you have provided a proper translation in a standard Java properties file. GWT provides a 'Messages' and 'Constants' interface for this purpose. Since the translations are compiled into the application during compile time this does not allow one to use an external file to override particular messages. In order to solve this we pass a messages Javascript object to the GWT application using the host page. This object is then processed and used to override some predefined messages.

The available messages are defined in ovirt_messages.properties which is a standard Java resource bundle. The resource bundle is consumed and translated into a Javascript object and placed in the host page. Since it is a standard resource bundle you can have multiple locales.

For step-by-step instructions, see the [README.branding](http://gerrit.ovirt.org/gitweb?p=ovirt-engine.git;a=blob;f=README.branding;hb=HEAD) in the root of the oVirt source code tree.

<Category:Feature>
