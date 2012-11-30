---
title: DebugFrontend
authors: abonas, fkobzik, gshereme, lhornyak, tjelinek, vszocs, ybronhei
wiki_title: DebugFrontend
wiki_revision_count: 23
wiki_last_updated: 2014-09-16
---

# Debug Frontend

## Setup Frontend in Development Mode (WebAdmin and UserPortal)

This document describes how to setup the frontend applications in development mode. It describes only how to do it using Eclipse and ignores other IDEs. Please feel free to contribute.

### Reasons

*   The client side logs are not sent to server - to see them, you need to run the frontend in dev mode
*   The frontend itself is quite complex. To track bugs in it you often need a debugger
*   Without development mode, you would need to recompile the whole application to see the result - in development mode you just refresh the browser window

### Prerequisites

This document expects that you have successfully cloned and build the sources and you have a running version of the oVirt deployed (http://wiki.ovirt.org/wiki/Building_oVirt_engine) and set up the Eclipse (http://wiki.ovirt.org/wiki/Building_Ovirt_Engine/IDE).

### Steps

The following steps describes how to set up both the WebAdmin and UserPortal.

*   For WebAdmin:
    -   Go to <ovirt-root>/frontend/webadmin/modules/webadmin/
    -   Run mvn gwt:debug -Pgwt-admin,gwtdev
*   For UserPortal:
    -   Go to <ovirt-root>/frontend/webadmin/modules/userportal-gwtp/
    -   Run mvn gwt:debug -Pgwt-user,gwtdev
*   If it was successful, you should see a line like this: [INFO] Listening for transport dt_socket at address: 8000
*   Now, go to Eclipse and go to Debug Configurations -> Remote Java Application -> New launch configuration
*   In the given dialog, fill the following values:
    -   Give it some name
    -   Connect -> Project -> Browse -> Select (webadmin or userportal)
    -   Host: localhost
    -   Port: 8000
*   In the Source tab:
    -   Add -> Java Project -> check uicommonweb, gwt-common
*   Press Apply, than Debug
*   If successful, a new GWT Development Mode window should be opened for you
*   Now you need to navigate the browser to:
*   For WebAdmin:
    -   <http://127.0.0.1:8080/webadmin/webadmin/WebAdmin.html?gwt.codesvr=127.0.0.1:9997>
*   For UserPortal
    -   <http://127.0.0.1:8080/UserPortal/org.ovirt.engine.ui.userportal.UserPortal/UserPortal.html?gwt.codesvr=127.0.0.1:9997>
*   If this is the first time you have tried to reach a development mode server, it will prompt you to install the Google Web Toolkit Developer Plugin. Go ahead and install it. This may require to restart your browser. When you will have the plugin installed, navigate to the above mentioned URL again
*   Now the WebAdmin (UserPortal) code should be executed. It will take a while, because the Java code is interpreted and not the compiled JavaScript code is executed.

If everything is successful, you should see a new tab in the GWT Development Mode window with some logs in it. If yes, everything is prepared and you can put some breakpoints to the code and debug as any other application.

### Troubleshooting

The most common issue is that the Google Web Toolkit Developer Plugin is not installed or is not correctly installed. Please make sure, your browser is officially supported by the Google Web Toolkit Developer Plugin.

Another reason could be the maven compiler parameters. Please make sure you did not build you backend with *-Dgwt.draftCompile=true* and *-Dgwt.user.agent=gecko* , recompile without these parameters if you did. - [Lhornyak](User:Lhornyak) ([talk](User talk:Lhornyak)) 14:50, 30 November 2012 (GMT)
