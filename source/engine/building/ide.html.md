---
title: IDE
authors: abonas, amureini, dneary, doron, gina, lhornyak, nslomian, nsoffer, roy,
  shireesh, snmishra, tjelinek, vered
wiki_title: Building oVirt Engine/IDE
wiki_revision_count: 50
wiki_last_updated: 2015-05-20
---

# IDE

## Using IDE for Ovirt Engine

### Reason

Java IDE Is very much like Vegemite[1](http://en.wikipedia.org/wiki/Vegemite);
Some really really like it, some like it as Marmite[2](http://en.wikipedia.org/wiki/Marmite) and some like it as Cenovis[3](http://en.wikipedia.org/wiki/Cenovis).
Others, simply can't stand the thought of it...

As for Java IDE, some like Eclipse, some like Net Beans,
and others can't stand the thought of anything which is not **VI**.

This page is intended for those who would like to use some sort of
a graphical development environmet, which does not requier the use
of 'esc'+':' combination ;)

### Eclipse

#### Use case

*   Recommended due to JBoss integration.
*   May be used with Pythone as well: <http://wiki.python.org/moin/EclipsePythonIntegration>
*   Current Eclipse release is Indigo Service Release 1.
    -   Available from <http://www.eclipse.org/downloads/>
    -   Use the J2EE for developers.

#### Setting up oVirt engine development environment in Eclipse

*   Before you start, perform a maven build from command line (refer [Building oVirt engine](Building oVirt engine)). This makes sure that the generated code is available, and you won't see too many compilation errors in eclipse after importing the projects.

<!-- -->

*   Fix maven version

<!-- -->

    >> open Windows --> 
       Preferences --> 
       Maven --> 
       Installations
    >> Choose 2.2 installation. If it's not there, use the 'add' button and add the path to your maven 2.2 installation.

*   Install maven plugin to eclipse
    -   Note: Make sure you use m2e version 0.12.XXX as later versions do not work well with maven 2.2.

<!-- -->

    >> open help --> 
       install new software --> 
       click 'add' and place the following url http://m2eclipse.sonatype.org/sites/m2e 
    >> check all components, install and restart eclipse at the end

*   Import sources:

<!-- -->

    >> file --> 
       import --> 
       Maven --> 
       Existing Maven Projects --> 
       browse into your engine sources direcotry and click OK

*   Change project settings to Resolve compilation errors

<!-- -->

    restapi-definition ->  project ->  properties -> java build path ->  source ->  add source folder ->  target/generated sources/xjc
    webadmin ->  project ->  properties ->  java build path -> source ->  add source folder->  target/generated sources/{annotations,gwt,test-annotations}

*   If you see the error "**The method setCharacterEncoding(String) is undefined for the type HttpServletResponse**" in source *frontend/webadmin/modules/frontend/src/main/java/org/ovirt/engine/ui/frontend/server/gwt/WebadminDynamicHostingServlet.java*, modify *pom.xml* at root level to change servlet API version from 2.3 to 2.4 as the concerned API is introduced in 2.4. The code change should look like:

<!-- -->

    <javax.ejb.api.version>3.0</javax.ejb.api.version>
    -<javax.servlet.api.version>2.3</javax.servlet.api.version>
    +<javax.servlet.api.version>2.4</javax.servlet.api.version>
    <jcraft.jsch.version>0.1.42</jcraft.jsch.version>

*   Make sure that you import the engine code formatter into eclipse **before** starting development. The engine maven build uses [checkstyle](http://checkstyle.sourceforge.net) to check coding standards. One of the standards checked is that the code should not contain tabs or trailing whitespaces. Since eclipse inserts tabs by default for code formatting, you can end up with a lot of compilation errors in command line maven build if you don't follow this (and the next) step.

<!-- -->

    Window ->  Preferences ->  Java ->  Code Style ->  Formatter -> Import -> <ovirt-src-root>/config/engine-code-format.xml

*   The above formatter however, doesn't work with trailing whitespaces inside comments. To make sure that this is also taken care, add the following **Save Action** to the Java editor:

<!-- -->

    Window ->  Preferences ->  Java ->  Editor ->  Save Actions -> Additional Actions ->  Configure ->  Code Organizing ->  Remove trailing whitespace -> All lines 

*   By now, hopefully, you should have resolved all compilation errors shown by eclipse, and ready to start development of oVirt engine.

<!-- -->

*   On some machines, editing a properties file in eclipse results in a lot of "diff" in git, making it difficult to review the code change. It may be a good idea to verify this in the beginning, and if the problem exists, edit the properties files using an external text editor.

### NetBeans

*   If you use it, feel free to fill-in.

### Others

*   Same as Net Beans...
*   [Backend with jrebel](Backend with jrebel)
*   [OVirt - disable SSL in VDSM](OVirt - disable SSL in VDSM)
