---
title: Branding
authors: awels, gshereme
wiki_title: Feature/Branding
wiki_revision_count: 20
wiki_last_updated: 2014-04-30
---

# Branding Support

### Overview

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
*   Header center image

As illustrated by the following image:
![](popup-window-border.png "fig:popup-window-border.png")

#### Login Screen

The user portal and web admin share the same login screen, they can be styled independently or they can share the same styling classes.

#### User portal main header

#### Web admin main header

#### Tabbing elements
