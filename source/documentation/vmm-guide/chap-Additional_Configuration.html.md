---
title: Additional Configuration
---

# Chapter 4: Additional Configuration

## Configuring Single Sign-On for Virtual Machines

Configuring single sign-on, also known as password delegation, allows you to automatically log in to a virtual machine using the credentials you use to log in to the User Portal. Single sign-on can be used on both Enterprise Linux and Windows virtual machines.

**Important:** If single sign-on to the User Portal is enabled, single sign-on to virtual machines will not be possible. With single sign-on to the User Portal enabled, the User Portal does not need to accept a password, thus the password cannot be delegated to sign in to virtual machines.

### Configuring Single Sign-On for Enterprise Linux Virtual Machines Using IPA (IdM)

To configure single sign-on for Enterprise Linux virtual machines using GNOME and KDE graphical desktop environments and IPA (IdM) servers, you must install the `ovirt-engine-guest-agent` package on the virtual machine and install the packages associated with your window manager.

**Important:** The following procedure assumes that you have a working IPA configuration and that the IPA domain is already joined to the Engine. You must also ensure that the clocks on the Engine, the virtual machine and the system on which IPA (IdM) is hosted are synchronized using NTP.

**Configuring Single Sign-On for Enterprise Linux Virtual Machines**

1. Log in to the Enterprise Linux virtual machine.

2. Enable the required repositories.

3. Download and install the guest agent packages:

        # yum install ovirt-engine-guest-agent-common

4. Install the single sign-on packages:

        # yum install ovirt-engine-guest-agent-pam-module
        # yum install ovirt-engine-guest-agent-gdm-plugin

5. Install the IPA packages:

        # yum install ipa-client

6. Run the following command and follow the prompts to configure *ipa-client* and join the virtual machine to the domain:

        # ipa-client-install --permit --mkhomedir

    **Note:** In environments that use DNS obfuscation, this command should be:

        # ipa-client-install --domain=FQDN --server==FQDN

7. For Enterprise Linux 7.2, run:

        # authconfig --enablenis --update

    **Note:** Enterprise Linux 7.2 has a new version of the System Security Services Daemon (SSSD), which introduces configuration that is incompatible with the oVirt Engine guest agent single sign-on implementation. The command will ensure that single sign-on works.

8. Fetch the details of an IPA user:

        # getent passwd IPA_user_name

    This will return something like this:

        some-ipa-user:*:936600010:936600001::/home/some-ipa-user:/bin/sh

    You will need this information in the next step to create a home directory for `some-ipa-user`.

9. Set up a home directory for the IPA user:

    a. Create the new user's home directory:

            # mkdir /home/some-ipa-user

    b. Give the new user ownership of the new user's home directory:

            # chown 935500010:936600001 /home/some-ipa-user

Log in to the User Portal using the user name and password of a user configured to use single sign-on and connect to the console of the virtual machine. You will be logged in automatically.

### Configuring Single Sign-On for Enterprise Linux Virtual Machines Using Active Directory

To configure single sign-on for Enterprise Linux virtual machines using GNOME and KDE graphical desktop environments and Active Directory, you must install the `ovirt-engine-guest-agent` package on the virtual machine, install the packages associated with your window manager and join the virtual machine to the domain.

**Important:** The following procedure assumes that you have a working Active Directory configuration and that the Active Directory domain is already joined to the Engine. You must also ensure that the clocks on the Engine, the virtual machine and the system on which Active Directory is hosted are synchronized using NTP.

**Configuring Single Sign-On for Enterprise Linux Virtual Machines**

1. Log in to the Enterprise Linux virtual machine.

2. Enable the oVirt Agent channel.

3. Download and install the guest agent packages:

        # yum install ovirt-engine-guest-agent-common

4. Install the single sign-on packages:

        # yum install ovirt-agent-gdm-plugin-ovirtcred

5. Install the Samba client packages:

        # yum install samba-client samba-winbind samba-winbind-clients

6. On the virtual machine, modify the `/etc/samba/smb.conf` file to contain the following, replacing `DOMAIN` with the short domain name and `REALM.LOCAL` with the Active Directory realm:

        [global]
           workgroup = DOMAIN
           realm = REALM.LOCAL
           log level = 2
           syslog = 0
           server string = Linux File Server
           security = ads
           log file = /var/log/samba/%m
           max log size = 50
           printcap name = cups
           printing = cups
           winbind enum users = Yes
           winbind enum groups = Yes
           winbind use default domain = true
           winbind separator = +
           idmap uid = 1000000-2000000
           idmap gid = 1000000-2000000
           template shell = /bin/bash

7. Join the virtual machine to the domain:

        net ads join -U user_name

8. Start the `winbind` service and ensure it starts on boot:

    * For Enterprise Linux 6

            # service winbind start
            # chkconfig winbind on

9. For Enterprise Linux 7

        # systemctl start winbind.service
        # systemctl enable winbind.service

10. Verify that the system can communicate with Active Directory:

    a. Verify that a trust relationship has been created:

            # wbinfo -t

    b. Verify that you can list users:

            # wbinfo -u

    c. Verify that you can list groups:

            # wbinfo -g

11. Configure the NSS and PAM stack:

    a. Open the **Authentication Configuration** window:

            # authconfig-tui

    b. Select the **Use Winbind** check box, select **Next** and press **Enter**.

    c. Select the **OK** button and press **Enter**.

Log in to the User Portal using the user name and password of a user configured to use single sign-on and connect to the console of the virtual machine. You will be logged in automatically.

### Configuring Single Sign-On for Windows Virtual Machines

To configure single sign-on for Windows virtual machines, the Windows guest agent must be installed on the guest virtual machine. The `oVirt Guest Tools` ISO file provides this agent. If the `oVirt-toolsSetup.iso` image is not available in your ISO domain, contact your system administrator.

**Configuring Single Sign-On for Windows Virtual Machines**

1. Select the Windows virtual machine. Ensure the machine is powered up.

2. Click **Change CD**.

3. Select `oVirt-toolsSetup.iso` from the list of images.

4. Click **OK**.

5. Click the **Console** icon and log in to the virtual machine.

6. On the virtual machine, locate the CD drive to access the contents of the guest tools ISO file and launch `oVirt-ToolsSetup.exe`. After the tools have been installed, you will be prompted to restart the machine to apply the changes.

Log in to the User Portal using the user name and password of a user configured to use single sign-on and connect to the console of the virtual machine. You will be logged in automatically.

### Disabling Single Sign-on for Virtual Machines

The following procedure explains how to disable single sign-on for a virtual machine.

**Disabling Single Sign-On for Virtual Machines**

1. Select a virtual machine and click **Edit**.

2. Click the **Console** tab.

3. Select the **Disable Single Sign On** check box.

4. Click **OK**.

## Configuring USB Devices

A virtual machine connected with the SPICE protocol can be configured to connect directly to USB devices.

The USB device will only be redirected if the virtual machine is active and in focus. USB redirection can be manually enabled each time a device is plugged in or set to automatically redirect to active virtual machines in the SPICE client menu.

**Important:** Note the distinction between the client machine and guest machine. The client is the hardware from which you access a guest. The guest is the virtual desktop or virtual server which is accessed through the User Portal or Administration Portal.

### Using USB Devices on Virtual Machines

USB redirection Native mode allows KVM/SPICE USB redirection for Linux and Windows virtual machines. Virtual (guest) machines require no guest-installed agents or drivers for native USB. On Enterprise Linux clients, all packages required for USB redirection are provided by the `virt-viewer` package. On Windows clients, you must also install the `usbdk` package. Native USB mode is supported on the following clients and guests:

* Client

    * Enterprise Linux 7.1 and higher

    * Enterprise Linux 6.0 and higher

    * Windows 10

    * Windows 8

    * Windows 7

    * Windows 2008

    * Windows 2008 Server R2

* Guest

    * Enterprise Linux 7.1 and higher

    * Enterprise Linux 6.0 and higher

    * Windows 7

    * Windows XP

    * Windows 2008

**Note:** If you have a 64-bit architecture PC, you must use the 64-bit version of Internet Explorer to install the 64-bit version of the USB driver. The USB redirection will not work if you install the 32-bit version on a 64-bit architecture. As long as you initially install the correct USB type, you then can access USB redirection from both 32 and 64-bit browsers.

### Using USB Devices on a Windows Client

The `usbdk` driver must be installed on the Windows client for the USB device to be redirected to the guest. Ensure the version of `usbdk` matches the architecture of the client machine. For example, the 64-bit version of `usbdk` must be installed on 64-bit Windows machines.

**Using USB Devices on a Windows Client**

1. When the `usbdk` driver is installed, select a virtual machine that has been configured to use the SPICE protocol.

2. Ensure USB support is set to **Native**:

    1. Click **Edit**.

    2. Click the **Console** tab.

    3. Select **Native** from the **USB Support** drop-down list.

    4. Click **OK**.

3. Click the **Console Options** button and select the **Enable USB Auto-Share** check box.

4. Start the virtual machine and click the **Console** button to connect to that virtual machine. When you plug your USB device into the client machine, it will automatically be redirected to appear on your guest machine.

### Using USB Devices on a Enterprise Linux Client

The `usbredir` package enables USB redirection from Enterprise Linux clients to virtual machines. `usbredir` is a dependency of the `virt-viewer` package, and is automatically installed together with that package.

**Using USB devices on a Enterprise Linux client**

1. Click the **Virtual Machines** tab and select a virtual machine that has been configured to use the SPICE protocol.

2. Ensure USB support is set to **Native**:

    1. Click **Edit**.

    2. Click the **Console** tab.

    3. Select **Native** from the **USB Support** drop-down list.

    4. Click **OK**.

3. Click the **Console Options** button and select the **Enable USB Auto-Share** check box.

4. Start the virtual machine and click the **Console** button to connect to that virtual machine. When you plug your USB device into the client machine, it will automatically be redirected to appear on your guest machine.

## Configuring Multiple Monitors

### Configuring Multiple Displays for Enterprise Linux Virtual Machines

A maximum of four displays can be configured for a single Enterprise Linux virtual machine when connecting to the virtual machine using the SPICE protocol.

1. Start a SPICE session with the virtual machine.

2. Open the **View** drop-down menu at the top of the SPICE client window.

3. Open the **Display** menu.

4. Click the name of a display to enable or disable that display.

    **Note:** By default, **Display 1** is the only display that is enabled on starting a SPICE session with a virtual machine. If no other displays are enabled, disabling this display will close the session.

# Configuring Multiple Displays for Windows Virtual Machines

A maximum of four displays can be configured for a single Windows virtual machine when connecting to the virtual machine using the SPICE protocol.

1. Click the **Virtual Machines** tab and select a virtual machine.

2. With the virtual machine in a powered-down state, click **Edit**.

3. Click the **Console** tab.

4. Select the number of displays from the **Monitors** drop-down list.

    **Note:** This setting controls the maximum number of displays that can be enabled for the virtual machine. While the virtual machine is running, additional displays can be enabled up to this number.

5. Click **Ok**.

6. Start a SPICE session with the virtual machine.

7. Open the **View** drop-down menu at the top of the SPICE client window.

8. Open the **Display** menu.

9. Click the name of a display to enable or disable that display.

    **Note:** By default, **Display 1** is the only display that is enabled on starting a SPICE session with a virtual machine. If no other displays are enabled, disabling this display will close the session.


## Configuring Console Options

### Console Options

Connection protocols are the underlying technology used to provide graphical consoles for virtual machines and allow users to work with virtual machines in a similar way as they would with physical machines. oVirt currently supports the following connection protocols:

**SPICE**

Simple Protocol for Independent Computing Environments (SPICE) is the recommended connection protocol for both Linux virtual machines and Windows virtual machines. To open a console to a virtual machine using SPICE, use Remote Viewer.

**VNC**

Virtual Network Computing (VNC) can be used to open consoles to both Linux virtual machines and Windows virtual machines. To open a console to a virtual machine using VNC, use Remote Viewer or a VNC client.

**RDP**

Remote Desktop Protocol (RDP) can only be used to open consoles to Windows virtual machines, and is only available when you access a virtual machines from a Windows machine on which Remote Desktop has been installed. Before you can connect to a Windows virtual machine using RDP, you must set up remote sharing on the virtual machine and configure the firewall to allow remote desktop connections.

**Note:** SPICE is not currently supported on virtual machines running Windows 8. If a Windows 8 virtual machine is configured to use the SPICE protocol, it will detect the absence of the required SPICE drivers and automatically fall back to using RDP.

#### Configuring SPICE Console Options

You can configure several options for opening graphical consoles for virtual machines, such as the method of invocation and whether to enable or disable USB redirection.

**Accessing Console Options**

1. Select a running virtual machine.

2. Open the **Console Options** window.

   * In the Administration Portal, right-click the virtual machine and click **Console Options**.

   * In the User Portal, click the **Edit Console Options** button.

   **The User Portal Edit Console Options Button**

   ![](/images/vmm-guide/6145.png)

**Note:** Further options specific to each of the connection protocols, such as the keyboard layout when using the VNC connection protocol, can be configured in the **Console** tab of the **Edit Virtual Machine** window.

#### SPICE Console Options

When the SPICE connection protocol is selected, the following options are available in the **Console Options** window.

**The Console Options window**

![](/images/vmm-guide/5679.png)

**Console Invocation**

* **Auto**: The Engine automatically selects the method for invoking the console.

* **Native client**: When you connect to the console of the virtual machine, a file download dialog provides you with a file that opens a console to the virtual machine via Remote Viewer.

* **SPICE HTML5 browser client (Tech preview)**: When you connect to the console of the virtual machine, a browser tab is opened that acts as the console.

**SPICE Options**

* **Map control-alt-del shortcut to ctrl+alt+end**: Select this check box to map the **Ctrl** + **Alt** + **Del** key combination to **Ctrl** + **Alt** + **End** inside the virtual machine.

* **Enable USB Auto-Share**: Select this check box to automatically redirect USB devices to the virtual machine. If this option is not selected, USB devices will connect to the client machine instead of the guest virtual machine. To use the USB device on the guest machine, manually enable it in the SPICE client menu.

* **Open in Full Screen**: Select this check box for the virtual machine console to automatically open in full screen when you connect to the virtual machine. Press **SHIFT** + **F11** to toggle full screen mode on or off.

* **Enable SPICE Proxy**: Select this check box to enable the SPICE proxy.

* **Enable WAN options**: Select this check box to set the parameters `WANDisableEffects` and `WANColorDepth` to `animation` and `16` bits respectively on Windows virtual machines. Bandwidth in WAN environments is limited and this option prevents certain Windows settings from consuming too much bandwidth.

#### VNC Console Options

When the VNC connection protocol is selected, the following options are available in the **Console Options** window.

**The Console Options window**

![](/images/vmm-guide/5680.png)

**Console Invocation**

* **Native Client**: When you connect to the console of the virtual machine, a file download dialog provides you with a file that opens a console to the virtual machine via Remote Viewer.

*  **noVNC**: When you connect to the console of the virtual machine, a browser tab is opened that acts as the console.

**VNC Options**

* **Map control-alt-delete shortcut to ctrl+alt+end**: Select this check box to map the **Ctrl** + **Alt** + **Del** key combination to **Ctrl** + **Alt** + **End** inside the virtual machine.

#### RDP Console Options

When the RDP connection protocol is selected, the following options are available in the **Console Options** window.

**The Console Options window**

![](/images/vmm-guide/4917.png)

**Console Invocation**

* **Auto**: The Engine automatically selects the method for invoking the console.

* **Native client**: When you connect to the console of the virtual machine, a file download dialog provides you with a file that opens a console to the virtual machine via Remote Desktop.

**RDP Options**

* **Use Local Drives**: Select this check box to make the drives on the client machine accessible on the guest virtual machine.

### Remote Viewer Options

#### Using SPICE Connection Options

When you specify the **Native client** console invocation option, you will connect to virtual machines using Remote Viewer. The Remote Viewer window provides a number of options for interacting with the virtual machine to which it is connected.

**The Remote Viewer connection menu**

![](/images/vmm-guide/1601.png)

**Remote Viewer Options**

<table>
 <thead>
  <tr>
   <td>Option</td>
   <td>Hotkey</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td>File</td>
   <td>
    <ul>
     <li><b>Screenshot</b>: Takes a screen capture of the active window and saves it in a location of your specification.</li>
     <li><b>USB device selection</b>: If USB redirection has been enabled on your virtual machine, the USB device plugged into your client machine can be accessed from this menu.</li>
     <li><b>Quit</b>: Closes the console. The hot key for this option is <b>Shift</b> + <b>Ctrl</b> + <b>Q</b>.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td>View</td>
   <td>
    <ul>
     <li><b>Full screen</b>: Toggles full screen mode on or off. When enabled, full screen mode expands the virtual machine to fill the entire screen. When disabled, the virtual machine is displayed as a window. The hot key for enabling or disabling full screen is <b>SHIFT</b> + <b>F11</b>.</li>
     <li><b>Zoom</b>: Zooms in and out of the console window. <b>Ctrl</b> + <b>+</b> zooms in, <b>Ctrl</b> + <b>-</b> zooms out, and <b>Ctrl</b> + <b>0</b> returns the screen to its original size.</li>
     <li><b>Automatically resize</b>: Tick to enable the guest resolution to automatically scale according to the size of the console window.</li>
     <li><b>Displays</b>: Allows users to enable and disable displays for the guest virtual machine.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td>Send key</td>
   <td>
    <ul>
     <li> <b>Ctrl</b> + <b>Alt</b> + <b>Del</b>: On a Enterprise Linux virtual machine, it displays a dialog with options to suspend, shut down or restart the virtual machine. On a Windows virtual machine, it displays the task manager or Windows Security dialog.</li>
     <li><b>Ctrl</b> + <b>Alt</b> + <b>Backspace</b>: On a Enterprise Linux virtual machine, it restarts the X sever. On a Windows virtual machine, it does nothing.</li>
     <li><b>Ctrl</b> + <b>Alt</b> + <b>F1</b></li>
     <li><b>Ctrl</b> + <b>Alt</b> + <b>F2</b></li>
     <li><b>Ctrl</b> + <b>Alt</b> + <b>F3</b></li>
     <li><b>Ctrl</b> + <b>Alt</b> + <b>F4</b></li>
     <li><b>Ctrl</b> + <b>Alt</b> + <b>F5</b></li>
     <li><b>Ctrl</b> + <b>Alt</b> + <b>F6</b></li>
     <li><b>Ctrl</b> + <b>Alt</b> + <b>F7</b></li>
     <li><b>Ctrl</b> + <b>Alt</b> + <b>F8</b></li>
     <li><b>Ctrl</b> + <b>Alt</b> + <b>F9</b></li>
     <li><b>Ctrl</b> + <b>Alt</b> + <b>F10</b></li>
     <li><b>Ctrl</b> + <b>Alt</b> + <b>F11</b></li>
     <li><b>Ctrl</b> + <b>Alt</b> + <b>F12</b></li>
     <li><b>Printscreen</b>: Passes the <b>Printscreen</b> keyboard option to the virtual machine.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td>Help</td>
   <td>The <b>About</b> entry displays the version details of Virtual Machine Viewer that you are using.</td>
  </tr>
  <tr>
   <td>Release Cursor from Virtual Machine</td>
   <td><b>SHIFT</b> + <b>F12</b></td>
  </tr>
 </tbody>
</table>

# SPICE Hotkeys

You can access the hotkeys for a virtual machine in both full screen mode and windowed mode. If you are using full screen mode, you can display the menu containing the button for hotkeys by moving the mouse pointer to the middle of the top of the screen. If you are using windowed mode, you can access the hotkeys via the **Send key** menu on the virtual machine window title bar.

**Note:** If `vdagent` is not running on the client machine, the mouse can become captured in a virtual machine window if it is used inside a virtual machine and the virtual machine is not in full screen. To unlock the mouse, press **Shift** + **F12**.

#### Manually Associating console.vv Files with Remote Viewer

If you are prompted to download a `console.vv` file when attempting to open a console to a virtual machine using the native client console option, and Remote Viewer is already installed, then you can manually associate `console.vv` files with Remote Viewer so that Remote Viewer can automatically use those files to open consoles.

**Manually Associating console.vv Files with Remote Viewer**

1. Start the virtual machine.

2. Open the **Console Options** window.

    * In the Administration Portal, right-click the virtual machine and click **Console Options**.

    * In the User Portal, click the **Edit Console Options** button.

    **The User Portal Edit Console Options Button**

    ![](/images/vmm-guide/6145.png)

3. Change the console invocation method to **Native client** and click **OK**.

4. Attempt to open a console to the virtual machine, then click **Save** when prompted to open or save the `console.vv` file.

5. Navigate to the location on your local machine where you saved the file.

6. Double-click the `console.vv` file and select **Select a program from a list of installed programs** when prompted.

7. In the **Open with** window, select **Always use the selected program to open this kind of file** and click the **Browse** button.

8. Navigate to the `C:\Users\[user name]\AppData\Local\virt-viewer\bin` directory and select `remote-viewer.exe`.

8. Click **Open** and then click **OK**.

When you use the native client console invocation option to open a console to a virtual machine, Remote Viewer will automatically use the `console.vv` file that the oVirt Engine provides to open a console to that virtual machine without prompting you to select the application to use.

## Configuring a Watchdog

### Adding a Watchdog Card to a Virtual Machine

You can add a watchdog card to a virtual machine to monitor the operating system's responsiveness.

**Adding Watchdog Cards to Virtual Machines**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click **Edit**.

3. Click the **High Availability** tab.

4. Select the watchdog model to use from the **Watchdog Model** drop-down list.

5. Select an action from the **Watchdog Action** drop-down list. This is the action that the virtual machine takes when the watchdog is triggered.

6. Click **OK**.

### Installing a Watchdog

To activate a watchdog card attached to a virtual machine, you must install the `watchdog` package on that virtual machine and start the `watchdog` service.

**Installing Watchdogs**

1. Log in to the virtual machine on which the watchdog card is attached.

2. Install the `watchdog` package and dependencies:

        # yum install watchdog

3. Edit the `/etc/watchdog.conf` file and uncomment the following line:

        watchdog-device = /dev/watchdog

4. Save the changes.

5.  Start the `watchdog` service and ensure this service starts on boot:

    * Enterprise Linux 6:

            # service watchdog start
            # chkconfig watchdog on

    * Enterprise Linux 7:

            # systemctl start watchdog.service
            # systemctl enable watchdog.service

### Confirming Watchdog Functionality

Confirm that a watchdog card has been attached to a virtual machine and that the `watchdog` service is active.

**Warning:** This procedure is provided for testing the functionality of watchdogs only and must not be run on production machines.

**Confirming Watchdog Functionality**

1. Log in to the virtual machine on which the watchdog card is attached.

2. Confirm that the watchdog card has been identified by the virtual machine:

        # lspci | grep watchdog -i

3. Run one of the following commands to confirm that the watchdog is active:

    * Trigger a kernel panic:

            # echo c > /proc/sysrq-trigger

    * Terminate the `watchdog` service:

            # kill -9 `pgrep watchdog`

The watchdog timer can no longer be reset, so the watchdog counter reaches zero after a short period of time. When the watchdog counter reaches zero, the action specified in the **Watchdog Action** drop-down menu for that virtual machine is performed.

### Parameters for Watchdogs in watchdog.conf

The following is a list of options for configuring the `watchdog` service available in the `/etc/watchdog.conf` file. To configure an option, you must uncomment that option and restart the `watchdog` service after saving the changes.

**Note:** For a more detailed explanation of options for configuring the `watchdog` service and using the `watchdog` command, see the `watchdog` man page.

**watchdog.conf variables**

| Variable name | Default Value | Remarks |
|-
| `ping` | N/A | An IP address that the watchdog attempts to ping to verify whether that address is reachable. You can specify multiple IP addresses by adding additional `ping` lines. |
| `interface` | N/A | A network interface that the watchdog will monitor to verify the presence of network traffic. You can specify multiple network interfaces by adding additional `interface` lines. |
| `file` | `/var/log/messages` | A file on the local system that the watchdog will monitor for changes. You can specify multiple files by adding additional `file` lines. |
| `change` | `1407` | The number of watchdog intervals after which the watchdog checks for changes to files. A `change` line must be specified on the line directly after each `file` line, and applies to the `file` line directly above that `change` line. |
| `max-load-1` | `24` | The maximum average load that the virtual machine can sustain over a one-minute period. If this average is exceeded, then the watchdog is triggered. A value of `0` disables this feature. |
| `max-load-5` | `18` | The maximum average load that the virtual machine can sustain over a five-minute period. If this average is exceeded, then the watchdog is triggered. A value of `0` disables this feature. By default, the value of this variable is set to a value approximately three quarters that of `max-load-1`. |
| `max-load-15` | `12` | The maximum average load that the virtual machine can sustain over a fifteen-minute period. If this average is exceeded, then the watchdog is triggered. A value of `0` disables this feature. By default, the value of this variable is set to a value approximately one half that of `max-load-1`. |
| `min-memory` | `1` | The minimum amount of virtual memory that must remain free on the virtual machine. This value is measured in pages. A value of `0` disables this feature. |
| `repair-binary` | `/usr/sbin/repair` | The path and file name of a binary file on the local system that will be run when the watchdog is triggered. If the specified file resolves the issues preventing the watchdog from resetting the watchdog counter, then the watchdog action is not triggered. |
| `test-binary` | N/A | The path and file name of a binary file on the local system that the watchdog will attempt to run during each interval. A test binary allows you to specify a file for running user-defined tests. |
| `test-timeout` | N/A | The time limit, in seconds, for which user-defined tests can run. A value of `0` allows user-defined tests to continue for an unlimited duration. |
| `temperature-device` | N/A | The path to and name of a device for checking the temperature of the machine on which the `watchdog` service is running. |
| `max-temperature` | `120` | The maximum allowed temperature for the machine on which the `watchdog` service is running. The machine will be halted if this temperature is reached. Unit conversion is not taken into account, so you must specify a value that matches the watchdog card being used. |
| `admin` | `root` | The email address to which email notifications are sent. |
| `interval` | `10` | The interval, in seconds, between updates to the watchdog device. The watchdog device expects an update at least once every minute, and if there are no updates over a one-minute period, then the watchdog is triggered. This one-minute period is hard-coded into the drivers for the watchdog device, and cannot be configured. |
| `logtick` | `1` | When verbose logging is enabled for the `watchdog` service, the `watchdog` service periodically writes log messages to the local system. The `logtick` value represents the number of watchdog intervals after which a message is written. |
| `realtime` | `yes` | Specifies whether the watchdog is locked in memory. A value of `yes` locks the watchdog in memory so that it is not swapped out of memory, while a value of `no` allows the watchdog to be swapped out of memory. If the watchdog is swapped out of memory and is not swapped back in before the watchdog counter reaches zero, then the watchdog is triggered. |
| `priority` | `1` | The schedule priority when the value of `realtime` is set to `yes`. |
| `pidfile` | `/var/run/syslogd.pid` | The path and file name of a PID file that the watchdog monitors to see if the corresponding process is still active. If the corresponding process is not active, then the watchdog is triggered. |

## Configuring Virtual NUMA

In the Administration Portal, you can configure virtual NUMA nodes on a virtual machine and pin them to physical NUMA nodes on a host. The host’s default policy is to schedule and run virtual machines on any available resources on the host. As a result, the resources backing a large virtual machine that cannot fit within a single host socket could be spread out across multiple NUMA nodes, and over time may be moved around, leading to poor and unpredictable performance. Configure and pin virtual NUMA nodes to avoid this outcome and improve performance.

Configuring virtual NUMA requires a NUMA-enabled host. To confirm whether NUMA is enabled on a host, log in to the host and run `numactl --hardware`. The output of this command should show at least two NUMA nodes. You can also view the host's NUMA topology in the Administration Portal by selecting the host from the **Hosts** tab and clicking **NUMA Support**. This button is only available when the selected host has at least two NUMA nodes.

**Configuring Virtual NUMA**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click **Edit**.

3. Click the **Host** tab.

4. Select the **Specific** radio button and select a host from the list. The selected host must have at least two NUMA nodes.

5. Select **Do not allow migration** from the **Migration Options** drop-down list.

6. Enter a number into the **NUMA Node Count** field to assign virtual NUMA nodes to the virtual machine.

7. Select **Strict**, **Preferred**, or **Interleave** from the **Tune Mode** drop-down list. If the selected mode is **Preferred**, the **NUMA Node Count** must be set to `1`.

8. Click **NUMA Pinning**.

    **The NUMA Topology Window**

    ![](/images/vmm-guide/numa.png)

9. In the **NUMA Topology** window, click and drag virtual NUMA nodes from the box on the right to host NUMA nodes on the left as required, and click **OK**.

10. Click **OK**.

**Note:** Automatic NUMA balancing is available in Enterprise Linux 7, but is not currently configurable through the oVirt Engine.

## Configuring Spacewalk Errata Management for a Virtual Machine

In the Administration Portal, you can configure a virtual machine to display the available errata. The virtual machine needs to be associated with a Spacewalk server to show available errata.

oVirt 4.0 supports errata management with Spacewalk 6.1.

The following prerequisites apply:

* The host that the virtual machine runs on also needs to be configured to receive errata information from Foreman. See "Configuring Foreman Errata Management for a Host" in the [Administration Guide](/documentation/admin-guide/administration-guide/) for more information.

* The virtual machine must have the rhevm-guest-agent package installed. This package allows the virtual machine to report its host name to the oVirt Manager. This allows the Spacewalk server to identify the virtual machine as a content host and report the applicable errata. For more information on installing the ovirt-guest-agent package see the Installing the Guest Agents and Drivers on Enterprise Linux section above for Enterprise Linux virtual machines and the Installing the Guest Agents and Drivers on Windows section for Windows virtual machines.

**Important:** Virtual machines are identified in the Foreman server by their FQDN. This ensures that an external content host ID does not need to be maintained in oVirt.

**Configuring Spacewalk Errata Management**

**Note:** The virtual machine must be registered to the Foreman server as a content host and have the katello-agent package installed.


1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click **Edit**.

3. Click the **Foreman** tab.

4. Select the required Foreman server from the **Provider** drop-down list.

5. Click **OK**.

**Prev:** [Chapter 3: Installing Windows Virtual Machines](../chap-Installing_Windows_Virtual_Machines) <br>
**Next:** [Chapter 5: Editing Virtual Machines](../chap-Editing_Virtual_Machines)
