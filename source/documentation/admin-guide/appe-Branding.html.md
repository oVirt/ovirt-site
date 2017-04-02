---
title: Branding
---

# Appendix F: Branding

## Re-Branding the Engine

Various aspects of the oVirt Engine can be customized, such as the icons used by and text displayed in pop-up windows and the links shown on the Welcome Page. This allows you to re-brand the Engine and gives you fine-grained control over the end look and feel presented to administrators and users.

The files required to customize the Engine are located in the `/etc/ovirt-engine/branding/` directory on the system on which the Engine is installed. The files comprise a set of cascading style sheet files that are used to style various aspects of the graphical user interface and a set of properties files that contain messages and links that are incorporated into various components of the Engine.

To customize a component, edit the file for that component and save the changes. The next time you open or refresh that component, the changes will be applied.

## Login Screen

The login screen is the login screen used by both the Administration Portal and User Portal. The elements of the login screen that can be customized are as follows:

* The border

* The header image on the left

* The header image on the right

* The header text

The classes for the login screen are located in `common.css`.

## Administration Portal Screen

The administration portal screen is the main screen that is shown when you log into the Administration Portal. The elements of the administration portal screen that can be customized are as follows:

* The logo

* The left background image

* The center background image

* The right background image

* The text to the right of the logo

The classes for the administration portal screen are located in `web_admin.css`.

## User Portal Screen

The user portal screen is the screen that is shown when you log into the User Portal. The elements of the user portal screen that can be customized are as follows:

* The logo

* The center background image

* The right background image

* The border around the main grid

* The text above the **Logged in user** label

The classes for the user portal screen are located in `user_portal.css`.

## Pop-Up Windows

Pop-up windows are all windows in the Engine that allow you to create, edit or update an entity such as a host or virtual machine. The elements of pop-up windows that can be customized are as follows:

* The border

* The header image on the left

* The header center image (repeated)

The classes for pop-up windows are located in `common.css`.

## Tabs

There are two types of tab elements in the User Portal - the main tabs for switching between the Basic view and the Extended view, and the tabs on the left side of the screen when the Extended view is selected. Many pop-up windows in the Administration Portal also include tabs. The elements of these tabs that can be customized are as follows:

* Active

* Inactive

The classes for tabs are located in `common.css` and `user_portal.css`.

## The Welcome Page

The Welcome Page is the page that is initially displayed when you visit the homepage of the Engine. In addition to customizing the overall look and feel, you can also make other changes such as adding links to the page for additional documentation or internal websites by editing a template file. The elements of the Welcome Page that can be customized are as follows:

* The page title

* The header (left, center and right)

* The error message

* The link to forward and the associated message for that link

The classes for the Welcome Page are located in `welcome_style.css`.

**The Template File**

The template file for the Welcome Page is a regular HTML file of the name `welcome_page.template` that does not contain `HTML`, `HEAD` or `BODY` tags. This file is inserted directly into the Welcome Page itself, and acts as a container for the content that is displayed in the Welcome Page. As such, you must edit this file to add new links or change the content itself. Another feature of the template file is that it contains placeholder text such as `{user_portal}` that is replaced by corresponding text in the `messages.properties` file when the Welcome Page is processed.

## The Page Not Found Page

The Page Not Found page is a page that is displayed when you open a link to a page that cannot be found in the oVirt Engine. The elements of the Page Not Found page that can be customized are as follows:

* The page title

* The header (left, center and right)

* The error message

* The link to forward and the associated message for that link

The classes for the Page Not Found page are located in `welcome_style.css`.

**Prev:** [Appendix E: Using Search Bookmarks and Tags](../appe-Using_Search_Bookmarks_and_Tags)<br>
**Next:** [Appendix G: System Accounts](../appe-System_Accounts)
