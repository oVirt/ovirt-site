---
title: How to Connect to SPICE Console With Portal
category: howto
authors: alonbl, deadhorseconsulting, digisign, gianluca
---

<!-- TODO: Content review -->

# How to Connect to SPICE Console With Portal

This article will explain how to connect to a SPICE console from either the User or Admin Portal using the SPICE Remote-Viewer Client/ActiveX Plugin.

## Under the Hood

So what happens when you hit the "Console" button?

1.  ovirt-engine sets a new password and it's expiry time (by default 120 s) which compose together a ticket
2.  ovirt-engine looks up other connection details (more on them later) in its database
3.  ovirt-engine passes all the connection info to the portal
4.  portal sets variables on application/x-spice object
5.  Internet Explorer passes variables info to the spice client (Remote-Viewer) via the ActiveX plugin (SpiceX.dll) and launches it
6.  spice client (Remote-Viewer) connects directly to a host using data given to it by the portal

## Assumptions and Prerequisities

*   An installed and running instance of ovirt-engine See: [Installing_ovirt-engine_from_rpm](Installing_ovirt-engine_from_rpm)
*   One or two nodes within an active cluster, EL6 or Fedora nodes are both fine.
*   You want to connect to you guest console using SPICE!
*   You are connecting from a Windows based Box/VM.
*   You are running one of the following Microsoft Windows versions:
    -   Microsoft Windows XP (x86)
    -   Windows Vista (x86/x64)
    -   Windows 7 (x86/x64)
    -   Server 2003/R2 (x86/x64)
    -   Server 2008/R2 (x86/x64)

## Getting/Prepping the Remote-Viewer Client/ActiveX Plugin

### Get the Cabinet File

*   Start by downloading: [spice.cab](http://elmarco.fedorapeople.org/spice.cab)

### Prepping the Files

*   Under windows extract the contents of the cabinet file
*   From the files extracted the one we are interested in is the executable installer file virt-viewer-<version>.exe (this will used in the case of the need for a manual client deployment)
*   Rename spice.cab to SpiceX.cab
*   Save these files somewhere where you can get to them from the system on which you are running your ovirt-engine instance

## Installing things Server Side

### Installing the Files

*   Login into the system on which you are running your ovirt-engine instance
*   Create a directory for the files to be hosted in, the ovirt-engine by default uses "/usr/share/spice"
*   Place the SpiceX.cab file and the virt-viewer-<version>.exe files in /usr/share/spice

### Make JBoss aware of the Files

#### ovirt-engine-3.3.1 and newer

1.  . Put spice artifacts (cabs) into a directory, example /usr/share/spice
2.  . Create symlink /usr/share/ovirt-engine/files/spice -> /usr/share/spice

#### ovirt-engine-3.3.0 and older

*   You will now need to let JBoss know how to host, where to host and what type of files these are
*   This will require the following modifications to /usr/share/ovirt-engine/engine.ear/root.war/WEB-INF/web.xml
*   Open /usr/share/ovirt-engine/engine.ear/root.war/WEB-INF/web.xml and make the following modifications:

Add a <servlet> definition for SpiceX.cab

      <!-- SpiceX.cab -->
      <servlet>
        <servlet-name>SpiceX.cab</servlet-name>
        <servlet-class>org.ovirt.engine.core.FileServlet</servlet-class>
      <init-param>
        <param-name>type</param-name>
        <param-value>application/octet-stream</param-value>
      </init-param>
      <init-param>
        <param-name>file</param-name>
        <param-value>/usr/share/spice/SpiceX.cab</param-value>
      </init-param>
      </servlet>
      <servlet-mapping>
        <servlet-name>SpiceX.cab</servlet-name>
        <url-pattern>/spice/SpiceX.cab</url-pattern>
      </servlet-mapping>

Add a <servlet> definition for virt-viewer-<version>.exe

      <!-- virt-viewer-<version>.exe -->
      <servlet>
        <servlet-name>virt-viewer-<version>.exe</servlet-name>
        <servlet-class>org.ovirt.engine.core.FileServlet</servlet-class>
      <init-param>
        <param-name>type</param-name>
        <param-value>application/octet-stream</param-value>
      </init-param>
      <init-param>
        <param-name>file</param-name>
        <param-value>/usr/share/spice/virt-viewer-<version>.exe</param-value>
      </init-param>
      </servlet>
      <servlet-mapping>
        <servlet-name>virt-viewer-<version>.exe</servlet-name>
        <url-pattern>/spice/virt-viewer-<version>.exe</url-pattern>
      </servlet-mapping>

*   Don't forget to replace <version> in virt-viewer-<version>.exe with the version for example: virt-viewer-0.5.3.exe
*   Close and save web.xml
*   NOTE the file web.xml is part of ovirt-engine-backend rpm; in oVirt 3.2 the <servlet> definition for SpiceX.cab is already in place
*   NOTE you will need to restart jboss-as to have the changes you just made picked up (EG: systemctl restart ovirt-engine.service)

## Add a deployment method Server Side

### Create a web page to deploy the cabinet/exe Files

*   As of oVirt 3.1 the code within the engine to automatically check/deploy the ActiveX Plugin was disabled. See ovirt-engine source file: frontend/webadmin/modules/gwt-common/src/main/java/org/ovirt/engine/ui/common/uicommon/SpiceInterfaceImpl.java
*   Given the prior the best way at the moment to do deploy to clients is to create a web page which will deploy/ allow download of the files to users
*   Thus we will need to whip up a page which can deploy or provide download of the files and which clients can access via the server on which JBoss/ovirt-engine is running
*   Fire up your favorite text editor and copy/paste the below:

Example simple html/java script page for Remote-Viewer Client/ActiveX Plugin download/deployment

      <!DOCTYPE html>
      <html>
      <head>
      <title>SPICE Remote Viewer Client/ActiveX Plugin</title>
      <script src="web-conf.js" type="text/javascript"></script>

      <script type="text/javascript">
      function installSpice()
      {
      try {
          document.getElementById('SpiceX').innerHTML = '<OBJECT id="SpiceX" codebase="/spice/SpiceX.cab" classid="clsid:ACD6D89C-938D-49B4-8E81-DDBD13F4B48A" width="0" height="0"></OBJECT>';
      } catch (ex) {
          alert("Epic Fail!: " + ex.Description);
      }
      }
      </script>

      <script type="text/javascript">
      function getHttpHref(addedUrl, description)
      {
          document.write("<a href=""+http_url+"/"+addedUrl+""/>"+description+"</a>");
      }
      </script>

      </head>
      <body>

        <h1><b><p>Web Install</p></b></h2>
        <h2><a href="#web">Spice Remote-Viewer Client/ActiveX Plugin Web Installer</a></h2>
        <h2><a href="#web-install1">Windows XP (x86)/Server 2003/R2 (x86/x64) Web Install Instructions</a></h2>
        <h2><a href="#web-install2">Windows Vista (x86/x64), Windows 7 (x86/x64), Server 2008/R2 (x86/x64) Web Install Instructions</a></h2>
        <h2><a href="#web-uninstall1">Windows XP (x86)/Server 2003/R2 (x86/x64) Uninstall Instructions</a></h2>
        <h2><a href="#web-uninstall2">Windows Vista (x86/x64), Windows 7 (x86/x64), Server 2008/R2 (x86/x64) Uninstall Instructions</a></h2>

         <h1><b><p>Manual Install</p></b></h2>
        <h2><a href="#manual">Spice Remote-Viewer Client/ActiveX Plugin Manual Install</a></h2>
        <h2><a href="#manual-install1">Windows XP (x86)/Server 2003/R2 (x86/x64) Manual Install Instructions</a></h2>
        <h2><a href="#manual-install2">Windows Vista (x86/x64), Windows 7 (x86/x64), Server 2008/R2 (x86/x64) Manual Install Instructions</a></h2>
        <h2><a href="#manual-uninstall1">Windows XP (x86)/Server 2003/R2 (x86/x64) Uninstall Instructions</a></h2>
        <h2><a href="#manual-uninstall2">Windows Vista (x86/x64), Windows 7 (x86/x64), Server 2008/R2 (x86/x64) Uninstall Instructions</a></h2>

        <a name="web"></a>
        <h1><b>Web Installer for Spice Remote-Viewer Client/ActiveX Plugin</b></h1>
        <p>This will attempt to install via your browser the Spice Remote-Viewer Client/ActiveX Plugin</p>
        <p>Supported Browsers: Microsoft Internet Explorer - 32-bit</p>
        <p>Supported Operating Systems: Microsoft Windows XP (x86),Windows Vista (x86/x64), Windows 7 (x86/x64), Server 2003/R2 (x86/x64), Server 2008/R2 (x86/x64)</p>

        <a name="web-install1"></a>
        <p><b>Windows XP (x86)/Server 2003/R2 (x86/x64) Web Install Instructions:</b></p>
        <p>1) Click the Install Spice button</p>
        <p>2) IE will prompt you with "This website wants to install the following add-on SpiceX.cab... proceed by clicking "Install this Add-on for All Users of this computer".</p>
        <p>3) Depending on the version of IE the next security warning may pop up asking you if you want to install SpiceX.cab" If it does not Click on the install spice button again and it will.</p>
        <p>4) In the security warning dialog click on the Install button.</p>
        <p>5) The install will now proceed in the background.<p/>
        <p>6) If the install was successful there will now be an entry called "VirtViewer" in your start menu under "All Programs".<p/>
        <p>7) The Spice Remote-Viewer Client/ActiveX Plugin is now installed and you will be able to view the consoles of your vm's in the User/Admin portals.</p>:

        <a name="web-install2"></a>
        <p><b>Windows Vista (x86/x64), Windows 7 (x86/x64), Server 2008/R2 (x86/x64) Web Install Instructions:</b></p>
        <p>1) Click the install spice button</p>
        <p>2) IE will prompt you with "This website wants to install the following add-on SpiceX.cab... proceed by clicking the arrow on the install button and choose "Install for All Users of this computer".</p>
        <p>3) Depending on the version of IE a UAC dialog may pop up asking you if you want to allow "SpiceX.cab" If it does not Click on the install spice button again and it will.</p>
        <p>4) In the UAC dialog click on the yes button.</p>
        <p>5) The install will now proceed in the background.</p>
        <p>6) If the install was successful there will now be an entry called "VirtViewer" in your start menu under "All Programs".</p>
        <p>7) The Spice Remote-Viewer Client/ActiveX Plugin is now installed and you will be able to view the consoles of your vm's in the User/Admin portals.</p>:

        <p><b id='SpiceX'>Spice ActiveX Plugin Object</b></p>
        <button onclick='installSpice()'>Install Spice</button>

        <a name="web-uninstall1"></a>
        <p><b>Windows XP (x86)/Server 2003/R2 (x86/x64) Uninstall Instructions:</b></p>
        <p>1) *Important* Close all open Internet Explorer windows/sessions!</p>
        <p>2) Click on the start menu</p>
        <p>3) Click "All Programs"</p>
        <p>4) Click "Accessories"></p>
        <p>5) Click "Command Prompt"</p>
        <p>6) In the command prompt window type "regsvr32 /u "C:\Documents and Settings\yourusernamehere\Local Settings\Application Data\virt-viewer\bin\SpiceX.dll"</p>
        <p>7) Next Click on the start menu</p>
        <p>8) Click "Control Panel"</p>
        <p>9) In the Control Panel run Add/Remove Programs</p>
        <p>10) Click on VirtViewer and click on Change/Remove</p>
        <p>11) The Spice Remote-Viewer Client/ActiveX Plugin is now uninstalled from the sytem</p>

        <a name="web-uninstall2"></a>
        <p><b>Windows Vista (x86/x64), Windows 7 (x86/x64), Server 2008/R2 (x86/x64) Uninstall Instructions:</b></p>
        <p>1) *Important* Close all open Internet Explorer windows/sessions!</p>
        <p>2) Click on the start menu</p>
        <p>3) Click "All Programs"</p>
        <p>4) Click "Accessories"></p>
        <p>5) Click "Command Prompt"</p>
        <p>6) In the command prompt window type "regsvr32 /u "C:\Users\yourusernamehere\AppData\Local\virt-viewer\bin\SpiceX.dll"</p>
        <p>7) Next Click on the start menu</p>
        <p>8) Click "Control Panel"</p>
        <p>9) In the Control Panel run "Programs and Features"</p>
        <p>10) Click on VirtViewer and click on Uninstall</p>
        <p>11) The Spice Remote-Viewer Client/ActiveX Plugin is now uninstalled from the sytem</p>

        <a name="manual"></a>
        <h1><b>Manual installer for Spice Remote-Viewer Client/ActiveX Plugin</b></h1>
        <p>This is for manually installing the Spice Remote-Viewer Client/ActiveX Plugin</p>
        <p>Supported Browsers: Microsoft Internet Explorer - 32-bit</p>
        <p>Supported Operating Systems: Microsoft Windows XP (x86),Windows Vista (x86/x64), Windows 7 (x86/x64), Server 2003/R2 (x86/x64), Server 2008/R2 (x86/x64)</p>

        <a name="manual-install1"></a>
        <p><b>Windows XP (x86)/Server 2003/R2 (x86/x64) Manual Install Instructions:</b></p>
        <p>1) Right-Click "Spice Remote-Viewer Client/ActiveX Plugin" and choose "save target as"</p>
        <p>2) Save the installer somewhere and note it's location</p>
        <p>3) *Important* Close all open Internet Explorer windows/sessions!</p>
        <p>4) Go to the location where you saved the installer and double-click it to launch it</p>
        <p>5) A security warning will pop up warning of an un-verified publisher this is fine click on the run button to proceed</p>
        <p>6) In the resulting installation dialog click on the install button to proceed with the install</p>
        <p>7) Click the close button once it is done to complete the install</p>
        <p>8) The Spice Remote-Viewer Client/ActiveX Plugin is now installed and you will be able to view the consoles of your vm's in the User/Admin portals.</p>

        <a name="manual-install2"></a>
        <p><b>Windows Vista (x86/x64), Windows 7 (x86/x64), Server 2008/R2 (x86/x64) Manual Install Instructions:</b></p>
        <p>1) Right-Click "Spice Remote-Viewer Client/ActiveX Plugin" and choose "save target as"</p>
        <p>2) Save the installer somewhere and note it's location</p>
        <p>3) *Important* Close all open Internet Explorer windows/sessions!</p>
        <p>4) Go to the location where you saved the installer and right-click it then choose "Run as Administrator"</p>
        <p>5) A UAC dialog will pop up asking you if you want to allow virt-viewer to install.</p>
        <p>6) In the UAC dialog click on the yes button.</p>
        <p>7) In the resulting installation dialog click on the install button to proceed with the install</p>
        <p>8) Click the close button once it is done to complete the install</p>
        <p>9) The Spice Remote-Viewer Client/ActiveX Plugin is now installed and you will be able to view the consoles of your vm's in the User/Admin portals.</p>

        <script type="text/JavaScript">getHttpHref("spice/virt-viewer-<version>.exe","Spice Remote-Viewer Client/ActiveX Plugin");</script>

        <a name="manual-uninstall1"></a>
        <p><b>Windows XP (x86)/Server 2003/R2 (x86/x64) Uninstall Instructions:</b></p>
        <p>1) *Important* Close all open Internet Explorer windows/sessions!</p>
        <p>2) Click on the start menu</p>
        <p>3) Click "All Programs"</p>
        <p>4) Click "Accessories"></p>
        <p>5) Click "Command Prompt"</p>
        <p>6) In the command prompt window type "regsvr32 /u "C:\Documents and Settings\yourusernamehere\Local Settings\Application Data\virt-viewer\bin\SpiceX.dll"</p>
        <p>7) Next Click on the start menu</p>
        <p>8) Click "Control Panel"</p>
        <p>9) In the Control Panel run Add/Remove Programs</p>
        <p>10) Click on VirtViewer and click on Change/Remove</p>
        <p>11) The Spice Remote-Viewer Client/ActiveX Plugin is now uninstalled from the sytem</p>

        <a name="manual-uninstall2"></a>
        <p><b>Windows Vista (x86/x64), Windows 7 (x86/x64), Server 2008/R2 (x86/x64) Uninstall Instructions:</b></p>
        <p>1) *Important* Close all open Internet Explorer windows/sessions!</p>
        <p>2) Click on the start menu</p>
        <p>3) Click "All Programs"</p>
        <p>4) Click "Accessories"></p>
        <p>5) Click "Command Prompt"</p>
        <p>6) In the command prompt window type "regsvr32 /u "C:\Users\yourusernamehere\AppData\Local\virt-viewer\bin\SpiceX.dll"</p>
        <p>7) Next Click on the start menu</p>
        <p>8) Click "Control Panel"</p>
        <p>9) In the Control Panel run "Programs and Features"</p>
        <p>10) Click on VirtViewer and click on Uninstall</p>
        <p>11) The Spice Remote-Viewer Client/ActiveX Plugin is now uninstalled from the sytem</p>

      </body>
      </html>

*   Don't forget to replace <version> in virt-viewer-<version>.exe with the version for example: virt-viewer-0.5.3.exe
*   Don't forget to replace "yourusernamehere" with your windows username for example "C:\\Users\\thrall\\AppData\\Local\\virt-viewer\\bin\\SpiceX.dll"
*   save the file as filename.html Example: "spice.html"

### Installing the web page

*   To install the web page copy it to /usr/share/ovirt-engine/engine.ear/root.war

### Accessing the web page

*   The page will now be accessible via the url to your ovirt-engine instance
*   Example URL
        http://ovirt.azeroth.net/spice.html

### Modify oVirt main page

*   Optionally you can modify the main oVirt page to contain a link to your deployment page
*   You will need to modify /usr/share/ovirt-engine/engine.ear/root.war/index.html

Add an entry to the below section of index.html containing the links to the various portals:

                    <div id='dynamicLinksSection' style="display: none;">
                            <div>
                            <h2>
                                    <span class="fakeH2">Portals</span>
                            </h2>
                                    <div><a href="UserPortal">User Portal</a></div>
                                    <div><a href="webadmin">Administrator Portal</a></div>
                                    <div><a href="OvirtEngineWeb/RedirectServlet?Page=Reports">Reports Portal</a></div>
                                    <div><a href="spice.html">Spice Install Portal</a></div>
                            </div>
                    </div>

## Installing via the web Client Side

### Windows XP (x86)/Server 2003/R2 (x86/x64) Clients

*   Launch Internet Explorer and browse to your oVirt instance and according spice.html
*   Example URL
        http://ovirt.azeroth.net/spice.html

*   Click the Install Spice button
*   IE will prompt you with "This website wants to install the following add-on SpiceX.cab... proceed by clicking "Install this Add-on for All Users of this computer".
*   Depending on the version of IE the next security warning may pop up asking you if you want to install SpiceX.cab" If it does not Click on the install spice button again and it will.
*   In the security warning dialog click on the Install button.
*   The install will now proceed in the background.
*   If the install was successful there will now be an entry called "VirtViewer" in your start menu under "All Programs".
*   The Spice Remote-Viewer Client/ActiveX Plugin is now installed and you will be able to view the consoles of your vm's in the User/Admin portals.

### Windows Vista (x86/x64), Windows 7 (x86/x64), Server 2008/R2 (x86/x64) Clients

*   Launch Internet Explorer and browse to your oVirt instance and according spice.html
*   Example URL
        http://ovirt.azeroth.net/spice.html

*   Click the install spice button
*   IE will prompt you with "This website wants to install the following add-on SpiceX.cab... proceed by clicking the arrow on the install button and choose "Install for All Users of this computer".
*   Depending on the version of IE a UAC dialog may pop up asking you if you want to allow "SpiceX.cab" If it does not Click on the install spice button again and it will.
*   In the UAC dialog click on the yes button.
*   The install will now proceed in the background.
*   If the install was successful there will now be an entry called "VirtViewer" in your start menu under "All Programs"
*   The Spice Remote-Viewer Client/ActiveX Plugin is now installed and you will be able to view the consoles of your vm's in the User/Admin portals.

## Manual Install Client Side

### Windows XP (x86)/Server 2003/R2 (x86/x64) Clients

*   Launch Internet Explorer and browse to your oVirt instance and according spice.html
*   Example URL
        http://ovirt.azeroth.net/spice.html

*   Right-Click "Spice Remote-Viewer Client/ActiveX Plugin" and choose "save target as"
*   Save the installer somewhere and note it's location
*   **Important** Close all open Internet Explorer windows/sessions!
*   Go to the location where you saved the installer and double-click it to launch it
*   A security warning will pop up warning of an un-verified publisher this is fine click on the run button to proceed
*   In the resulting installation dialog click on the install button to proceed with the install
*   Click the close button once it is done to complete the install
*   The Spice Remote-Viewer Client/ActiveX Plugin is now installed and you will be able to view the consoles of your vm's in the User/Admin portals.

### Windows Vista (x86/x64), Windows 7 (x86/x64), Server 2008/R2 (x86/x64) Clients

*   Launch Internet Explorer and browse to your oVirt instance and according spice.html
*   Example URL
        http://ovirt.azeroth.net/spice.html

*   Right-Click "Spice Remote-Viewer Client/ActiveX Plugin" and choose "save target as"
*   Save the installer somewhere and note it's location
*   **Important** Close all open Internet Explorer windows/sessions!
*   Go to the location where you saved the installer and right-click it then choose "Run as Administrator"
*   A UAC dialog will pop up asking you if you want to allow virt-viewer to install.
*   In the UAC dialog click on the yes button.
*   In the resulting installation dialog click on the install button to proceed with the install
*   Click the close button once it is done to complete the install
*   The Spice Remote-Viewer Client/ActiveX Plugin is now installed and you will be able to view the consoles of your vm's in the User/Admin portals.

## Un-Installing Client Side

### Windows XP (x86)/Server 2003/R2 (x86/x64) Clients

*   **Important** Close all open Internet Explorer windows/sessions!
*   Click on the start menu
*   Click "All Programs"
*   Click "Accessories"
*   Click "Command Prompt"
*   In the command prompt window type "regsvr32 /u "C:\\Documents and Settings\\yourusernamehere\\Local Settings\\Application Data\\virt-viewer\\bin\\SpiceX.dll"
*   Next Click on the start menu
*   Click "Control Panel"
*   In the Control Panel run Add/Remove Programs
*   Click on VirtViewer and click on Change/Remove
*   The Spice Remote-Viewer Client/ActiveX Plugin is now uninstalled from the system

### Windows Vista (x86/x64), Windows 7 (x86/x64), Server 2008/R2 (x86/x64) Clients

*   **Important** Close all open Internet Explorer windows/sessions!
*   Click on the start menu
*   Click "All Programs"
*   Click "Accessories"
*   Click "Command Prompt"
*   In the command prompt window type "regsvr32 /u "C:\\Users\\yourusernamehere\\AppData\\Local\\virt-viewer\\bin\\SpiceX.dll"
*   Next Click on the start menu
*   Click "Control Panel"
*   In the Control Panel run "Programs and Features"
*   Click on VirtViewer and click on Uninstall
*   The Spice Remote-Viewer Client/ActiveX Plugin is now uninstalled from the system

## Windows Mouse

When setting up new OS but before you install Windows client tools you might experience mouse problems. For example mouse keeps scrolling off the client window. This is confirmed to be now fixed by the Spice team and should show up in Windows client past version 0.5.3 Temporary work-arround is to:

*   Open Client Window
*   Select Window (do not click inside yet)
*   From the View menu select Full Screen or F-11
*   Click inside the window
