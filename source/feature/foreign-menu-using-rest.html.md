---
title: Foreign Menu Using REST
category: feature
authors: tjelinek
wiki_category: Feature
wiki_title: Features/Foreign Menu Using REST
wiki_revision_count: 4
wiki_last_updated: 2013-06-27
---

# Foreign Menu Using REST

### Summary

Provide a REST API on oVirt side which would be used by SPICE client to enrich the client by foreign menu and also to call the oVirt engine if some menu item is selected.

### Owner

*   Name: [Tomas Jelinek](User:TJelinek)
*   Email: <TJelinek@redhat.com>

### Current status

*   Status: under design and discussion.

### Background

The current way of enriching the SPICE menu from oVirt WebAdmin/UserPortal is to set the **dynamicMenu** parameter of the XPI/ActiveX client and than listening to the corresponding events on the portal side. The problem with this approach is that it does not work with the [Non Plugin Console Invocation](Features/Non plugin console invocation) feature as there is no way to listen to the changes from the JavaScript.

The proposed solution is to create a support to get the menu from the oVirt REST and on selection call the REST back.

### Design

The menu would be returned by calling the

      GET /api/foreignmenu/<vmId>

The result would be:

      <foreign_menu>
         
         <menu>
             <text>menu label</text>
             <item>  
                 <id>0656f432-923a-11e0-ad20-5254004ac988</id>
                 <text>Stop VM</text>
                 <item_code>someCode</item_code>
                 <marked>true</marked>
                 <url>/api/vms/5114bb3e-a4e6-44b2-b783-b3eea7d84720/stop</url>
                 <method>POST</method>
                 <body>
                      <![CDATA[
                           <action/>
                       ]]>
                 </body>
             </item>
             
             <item>
                 ...
             </item>

             <menu>
                 ...
             </menu>
         </menu> 

         <next_poll>10</next_poll>
      </foreign_menu>

       

Where:

*   **menu**: the menu item container - can contain submenus
*   **text**: the label of the menu item
*   **item**: one specific item the user can select
*   **item.id**: unique id of the item
*   **item.text**: the label of the item
*   **item.item_code**: the keyboard shortcut
*   **item.marked**: mark the item as this is the one selected (or active) - like the currently inserted CD
*   **url**: the REST API URL to call if selected
*   **method**: the HTTP method (e.g. POST/GET/DELETE etc.)
*   **body**: the body of the request (e.g. which CD to insert), if any
*   **next_poll**: when to call the menu again to poll for new data (in seconds). Can be -1 which means never

The specific workflow:

*   SPICE starts connecting to the guest
*   in parallel SPICE client calls the /api/foreignmenu/<vmId> to get the menu (does not block on this)
*   oVirt Engine generates the menu for the client. If there are any running tasks for that VM, the next_poll will be set to 5. If there will be no running tasks than -1 (don't poll again).
*   SPICE client visualizes the menu
*   user selects some item from the menu
*   SPICE client calls the oVirt's REST api on the given **url** with the specific HTTP **method** and with the given **BODY** (if any).
*   When the call returns, SPICE client calls the oVirt's REST to get the new menu (e.g. with changed marks or maybe new options)
*   oVirt Engine generates the new menu and checks if there are some running tasks (e.g. for turning off the VM etc.). If yes, sets the next poll to 5. If not, sets it to -1 (don't poll again)

### Authentication

The authentication will be done the same way as for the [UI Plugins](Features/UIPlugins). After the user logs in into oVirt's WebAdmin or UserPortal the frontend application logs into the oVirt's REST and keeps the session ID. When the console is opened from the frontend this session ID is passed to the SPICE client and it authenticates to the oVirt's REST using this session ID. It means, the SPICE client will have the same permissions as the user who opened it.

### Alternative Solutions

*   One possibility to avoid the two calls of the REST is to make a bridge which would receive the call from SPICE client, pass the call forward and than generate the menu and return it to the client
    -   Advantage: avoid one call from the SPICE client
    -   Disadvantage: additional complexity on the oVirt side while the call would have to be done anyway

<!-- -->

*   Keep the menu for the VM/User pair in a session
    -   Advantage: no need to send the REST URL, method etc to the client (only the menu ID)
    -   Disadvantage: memory intensive

### Additional Resources

[GObject bindings for oVirt REST API](http://cgit.freedesktop.org/~teuf/govirt/)

<Category:Feature> <Category:Template>
