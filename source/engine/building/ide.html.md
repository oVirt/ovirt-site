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

#### Some more work...

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

### NetBeans

*   If you use it, feel free to fill-in.

### Others

*   Same as Net Beans...
*   [Backend with jrebel](Backend with jrebel)
*   [OVirt - disable SSL in VDSM](OVirt - disable SSL in VDSM)
