---
title: SPICE Remote-Viewer on OS X
authors: karli.sjoberg
wiki_title: SPICE Remote-Viewer on OS X
wiki_revision_count: 5
wiki_last_updated: 2014-02-11
---

# SPICE Remote-Viewer on OS X

## How to install and use RemoteViewer on OS X.

To be able to see your virtual machine´s console from OS X, you need to install a small application called RemoteViewer. Start by downloading:

[RemoteViewer-0.5.7 for OS X](http://people.freedesktop.org/~teuf/spice-gtk-osx/dmg/0.5.7/RemoteViewer-0.5.7-1.dmg)

Double-click to mount and open the ".dmg" file that´s been saved down to your Downloads folder (if you didn´t explicitly choose to save it to somewhere else) and click-and-drag the RemoteViewer application into your Applications folder.

Then, logged into oVirt Webadmin or Userportal, click on a VM, then click for console. The browser will probably at first block pop-ups, which you´ll need to allow. Then click for console again and download the generated ”console.vv” file (again, by default to your Downloads folder).

Now you need to start the "Terminal" application. Click on the Spotlight icon at the top right, type in "Terminal" and hit enter. Once the Terminal is started, you type in:

|-----------------------------------------------------------------------------------|
| $ /Applications/RemoteViewer.app/Contents/MacOS/RemoteViewer Downloads/console.vv |

Tested on Mac OS X 10.7.5 and 10.9.1 with oVirt-3.3.1
