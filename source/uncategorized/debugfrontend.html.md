---
title: DebugFrontend
authors: abonas, fkobzik, gshereme, lhornyak, tjelinek, vszocs, ybronhei
wiki_title: DebugFrontend
wiki_revision_count: 23
wiki_last_updated: 2014-09-16
---

# Debug Frontend

## How to debug Frontend applications

This document contains instructions and tips for debugging oVirt Frontend web applications. Although it focuses on debugging applications in Eclipse IDE, it should be easy to adapt within your own development environment.

oVirt Frontend comprises following web applications:

*   WebAdmin: `$OVIRT_HOME/frontend/webadmin/modules/webadmin/`
*   UserPortal: `$OVIRT_HOME/frontend/webadmin/modules/userportal-gwtp/`

oVirt Frontend applications use [Google Web Toolkit](https://developers.google.com/web-toolkit/), an open source set of tools for building JavaScript web applications using Java programming language. One GWT tool we'll use in particular is [Development Mode](https://developers.google.com/web-toolkit/doc/latest/DevGuideCompilingAndDebugging#DevGuideDevMode), which allows debugging an application without having to translate (compile) it to JavaScript.

### Prerequisites

This document assumes that you've successfully [cloned and built oVirt from source](http://wiki.ovirt.org/wiki/Building_oVirt_engine) and [configured Eclipse for development](http://wiki.ovirt.org/wiki/Building_Ovirt_Engine/IDE).

### Development Mode

Launching Development Mode spawns a separate JVM instance (Java application) that executes GWT application code as bytecode, providing a bridge between web browser and Java IDE:

*   Java IDE connects to Development Mode to debug GWT application code, allowing to set breakpoints and debug code as Java
*   web browser connects to Development Mode via GWT Developer Plugin, passing instructions to Development Mode which executes them and sends the result back to web browser

### Step 0 - Things to check

Make sure to have appropriate oVirt-related environment variables exported, for example:

    $ export OVIRT_HOME=$HOME/workspace/ovirt-engine
    $ export JBOSS_HOME=/usr/local/dev/ovirt-jboss-as
    $ export ENGINE_DEFAULTS=$OVIRT_HOME/backend/manager/conf/engine.conf.defaults

You should also do full oVirt build prior to debugging, with WebAdmin and/or UserPortal GWT compilation enabled:

    $ cd $OVIRT_HOME
    $ mvn clean install -Pdep,gwt-admin,gwt-user -Dgwt.compiler.localWorkers=8

Notes:

*   `dep` profile deploys oVirt Engine to JBoss AS, e.g. `$JBOSS_HOME/standalone/deployments/engine.ear`
*   `gwt-admin` profile enables WebAdmin GWT compilation (optional)
*   `gwt-user` profile enables UserPortal GWT compilation (optional)
*   `gwt.compiler.localWorkers` should match the number of CPU cores for parallelizing GWT compilation (optional)

### Step 1 - Launching Development Mode

Make sure JBoss AS is running and launch Development Mode for WebAdmin or UserPortal:

    $ cd $GWT_APP_DIR
    $ mvn gwt:debug -Pgwtdev,gwt-admin,gwt-user -Dgwt.noserver=true

Notes:

*   `gwt:debug` launches Development Mode via gwt-maven-plugin
*   `gwtdev` profile adds extra Java sources and resources necessary for debugging, so that changes in related Frontend projects (`uicommonweb`, `gwt-common` etc.) are reflected in Development Mode for new debugging sessions
*   `gwt.noserver` tells Development Mode that the application is already deployed on JBoss AS (don't use embedded Jetty instance to serve application content)

You should see following output in console: `Listening for transport dt_socket at address: 8000`

### Step 2 - Connecting to Development Mode from Java IDE

In Eclipse, create new debug configuration for WebAdmin or UserPortal via "Run | Debug Configurations | Remote Java Application | New launch configuration":

*   In Connect tab:
    -   Project: choose WebAdmin or UserPortal project that you previously imported into Eclipse
    -   Host: `localhost`
    -   Port: `8000`
*   In Source tab:
    -   Click "Add | Java Project" and choose related Frontend projects: `uicommonweb`, `gwt-common`

Click "Apply" and "Debug", so that Eclipse now connects to Development Mode, which spawns Development Mode GUI.

### Step 3 - Launching the application in web browser

Open your favorite web browser and navigate to one of debug URLs below:

*   WebAdmin: <http://127.0.0.1:8700/webadmin/webadmin/WebAdmin.html?gwt.codesvr=127.0.0.1:9997>
*   UserPortal: <http://127.0.0.1:8700/UserPortal/org.ovirt.engine.ui.userportal.UserPortal/UserPortal.html?gwt.codesvr=127.0.0.1:9997>

Notes:

*   `gwt.codesvr` points to Development Mode, port 9997 is used internally by GWT Developer Plugin to communicate with Development Mode
*   This means you're debugging the application in your favorite web browser!

Navigating to debug URLs mentioned above for the first time, you will be prompted to install GWT Developer Plugin for the given web browser. Just proceed with plugin installation and restart the browser.

The next time you navigate to debug URLs mentioned below, GWT Developer Plugin will connect to Development Mode and new debugging session will be started for the given browser. This can take some time, please be patient and wait while the application gets loaded.

You can switch to Development Mode GUI and see a new tab representing the debugging session. Note that each session has its own client-side logs displayed within the given tab.

## Typical development cycle

Development Mode allows you to "code-test-debug" running GWT application, without having to compile it to JavaScript or even restart Development Mode.

Whenever you make code changes while debugging:

*   Eclipse might complain that changes cannot be hot-swapped, in this case just click "Terminate" and reconnect again
*   Reload (refresh) the application in web browser, this will start new Development Mode session

## Compiling Frontend applications in detailed mode

Sometimes it's necessary to profile or analyze GWT applications, e.g. fixing memory leaks or identifying performance bottlenecks in different web browsers. GWT compiler produces optimized and obfuscated JavaScript by default, which is hard to work with.

To compile WebAdmin or UserPortal in detailed mode, reducing the level of code optimization and preventing obfuscation, you can do full oVirt build with `gwtdev` profile:

    $ cd $OVIRT_HOME
    $ mvn clean install -Pdep,gwt-admin,gwt-user,gwtdev

*Use detailed mode only when profiling or analyzing GWT application code, don't use it for regular oVirt builds.*

## Frequently asked questions

*Q: My web browser doesn't prompt me to install GWT Developer Plugin.*

A: Make sure your browser is officially supported by GWT Developer Plugin. Alternatively, get it from [here](http://gwt.googleusercontent.com/samples/MissingPlugin/MissingPlugin.html) and install the plugin manually into your browser.

*Q: The web page is blank after navigating to debug URL.*

A: Make sure to do full oVirt build prior to debugging for all web browsers, e.g. without specifying `gwt.userAgent` property.

*Q: Client-side logs are not persisted on Engine, e.g. `$JBOSS_HOME/standalone/log/engine/engine-ui.log`.*

A: Currently, client-side logs are enabled only when debugging the application via Development Mode.

*Q: I'm getting `-bindAddress host "0.0.0.0" unknown` error message when launching Development Mode.*

A: Using 0.0.0.0 means that Development Mode will listen for incoming connections on all network interfaces, as opposed to 127.0.0.1 which listens for incoming connections only on loopback interface available from local machine only. Make sure that host name is properly set in `/etc/hosts`. For Windows machines, check `%windir%\system32\drivers\etc\hosts`.

*Q: I'm getting `Exception: java.lang.OutOfMemoryError` or similar error during GWT compilation.*

A: You can tweak GWT compiler JVM arguments via `gwt-plugin.extraJvmArgs` property, for example:

    $ mvn clean install -Pdep,gwt-admin,gwt-user -Dgwt-plugin.extraJvmArgs="-Xms1024M -Xmx2048M -XX:PermSize=256M -XX:MaxPermSize=512M"
