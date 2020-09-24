---
title: Additional Configuration
---

# Chapter 4: Additional Configuration

## Configuring Operating Systems with osinfo

oVirt stores operating system configurations for virtual machines in **/etc/ovirt-engine/osinfo.conf.d/00-defaults.properties**. This file contains default values such as `os.other.devices.display.protocols.value = spice/qxl,vnc/vga,vnc/qxl,vnc/cirrus`.

There are only a limited number of scenarios in which you would change these values:

* Adding an operating system that does not appear in the list of supported guest operating systems

* Adding a product key (for example, `os.windows_10x64.productKey.value =`)

* Configuring the sysprep path for a Windows virtual machine (for example, `os.windows_10x64.sysprepPath.value = ${ENGINE_USR}/conf/sysprep/sysprep.w10x64`)

  **Important:** Do not edit the actual **00-defaults.properties** file. Changes will be overwritten if you upgrade or restore the Engine.
  {: .alert .alert-info}

Do not change values that come directly from the operating system or the Engine, such as maximum memory size.

To change the operating system configurations, create an override file in **/etc/ovirt-engine/osinfo.conf.d/**. The file name must begin with a value greater than `00`, so that the file appears after **/etc/ovirt-engine/osinfo.conf.d/00-defaults.properties**, and ends with the extension, **.properties**.

For example, **10-productkeys.properties** overrides the default file, **00-defaults.properties**. The last file in the file list has precedence over earlier files.

## Configuring Single Sign-On for Virtual Machines

Configuring single sign-on, also known as password delegation, allows you to automatically log in to a virtual machine using the credentials you use to log in to the VM Portal. Single sign-on can be used on both Enterprise Linux and Windows virtual machines.

**Important:** If single sign-on to the VM Portal is enabled, single sign-on to virtual machines will not be possible. With single sign-on to the VM Portal enabled, the VM Portal does not need to accept a password, thus the password cannot be delegated to sign in to virtual machines.
{: .alert .alert-info}


### Configuring Single Sign-On for Enterprise Linux Virtual Machines Using IPA (IdM)

To configure single sign-on for Enterprise Linux virtual machines using GNOME and KDE graphical desktop environments and IPA (IdM) servers, you must install the `ovirt-engine-guest-agent` package on the virtual machine and install the packages associated with your window manager.

**Important:** The following procedure assumes that you have a working IPA configuration and that the IPA domain is already joined to the Engine. You must also ensure that the clocks on the Engine, the virtual machine and the system on which IPA (IdM) is hosted are synchronized using NTP.
{: .alert .alert-info}


**Configuring Single Sign-On for Enterprise Linux Virtual Machines**

1. Log in to the Enterprise Linux virtual machine.

2. Enable the required repositories.

3. Download and install the guest agent packages:

        # yum install ovirt-guest-agent-common

4. Install the single sign-on packages:

        # yum install ovirt-guest-agent-pam-module
        # yum install ovirt-guest-agent-gdm-plugin

5. Install the IPA packages:

        # yum install ipa-client

6. Run the following command and follow the prompts to configure *ipa-client* and join the virtual machine to the domain:

        # ipa-client-install --permit --mkhomedir

    **Note:** In environments that use DNS obfuscation, this command should be:
	{: .alert .alert-info}

        # ipa-client-install --domain=FQDN --server==FQDN

7. For Enterprise Linux 7.2 and later, run:

        # authconfig --enablenis --update

    **Note:** Enterprise Linux 7.2 has a new version of the System Security Services Daemon (SSSD), which introduces configuration that is incompatible with the oVirt Engine guest agent single sign-on implementation. The command will ensure that single sign-on works.
	{: .alert .alert-info}

8. Fetch the details of an IPA user:

        # getent passwd IPA_user_name

    This will return something like this:

        some-ipa-user:\*:936600010:936600001::/home/some-ipa-user:/bin/sh

    You will need this information in the next step to create a home directory for `some-ipa-user`.

9. Set up a home directory for the IPA user:

    i. Create the new user's home directory:

            # mkdir /home/some-ipa-user

    ii. Give the new user ownership of the new user's home directory:

            # chown 935500010:936600001 /home/some-ipa-user

Log in to the VM Portal using the user name and password of a user configured to use single sign-on and connect to the console of the virtual machine. You will be logged in automatically.

### Configuring Single Sign-On for Enterprise Linux Virtual Machines Using Active Directory

To configure single sign-on for Enterprise Linux virtual machines using GNOME and KDE graphical desktop environments and Active Directory, you must install the `ovirt-engine-guest-agent` package on the virtual machine, install the packages associated with your window manager and join the virtual machine to the domain.

**Important:** The following procedure assumes that you have a working Active Directory configuration and that the Active Directory domain is already joined to the Engine. You must also ensure that the clocks on the Engine, the virtual machine and the system on which Active Directory is hosted are synchronized using NTP.
{: .alert .alert-info}

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

    * For Enterprise Linux 7

            # systemctl start winbind.service
            # systemctl enable winbind.service

9. Verify that the system can communicate with Active Directory:

    i. Verify that a trust relationship has been created:

            # wbinfo -t

    ii. Verify that you can list users:

            # wbinfo -u

    iii. Verify that you can list groups:

            # wbinfo -g

10. Configure the NSS and PAM stack:

    i. Open the **Authentication Configuration** window:

            # authconfig-tui

    ii. Select the **Use Winbind** check box, select **Next** and press **Enter**.

    iii. Select the **OK** button and press **Enter**.

Log in to the VM Portal using the user name and password of a user configured to use single sign-on and connect to the console of the virtual machine. You will be logged in automatically.

### Configuring Single Sign-On for Windows Virtual Machines

To configure single sign-on for Windows virtual machines, the Windows guest agent must be installed on the guest virtual machine. The `oVirt Guest Tools` ISO file provides this agent. If the `oVirt-toolsSetup.iso` image is not available in your ISO domain, contact your system administrator.

**Configuring Single Sign-On for Windows Virtual Machines**

1. Select the Windows virtual machine. Ensure the machine is powered up.

2. Click **Change CD**.

3. Select `oVirt-toolsSetup.iso` from the list of images.

4. Click **OK**.

5. Click the **Console** icon and log in to the virtual machine.

6. On the virtual machine, locate the CD drive to access the contents of the guest tools ISO file and launch `oVirt-ToolsSetup.exe`. After the tools have been installed, you will be prompted to restart the machine to apply the changes.

Log in to the VM Portal using the user name and password of a user configured to use single sign-on and connect to the console of the virtual machine. You will be logged in automatically.

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

   **Important:** Note the distinction between the client machine and guest machine. The client is the hardware from which you access a guest. The guest is the virtual desktop or virtual server which is accessed through the VM Portal or Administration Portal.
   {: .alert .alert-info}

### Using USB Devices on Virtual Machines

USB redirection **Enabled** mode allows KVM/SPICE USB redirection for Linux and Windows virtual machines. Virtual (guest) machines require no guest-installed agents or drivers for native USB. On Enterprise Linux clients, all packages required for USB redirection are provided by the `virt-viewer` package. On Windows clients, you must also install the `usbdk` package. Native USB mode is supported on the following clients and guests:

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
	{: .alert .alert-info}

### Using USB Devices on a Windows Client

The `usbdk` driver must be installed on the Windows client for the USB device to be redirected to the guest. Ensure the version of `usbdk` matches the architecture of the client machine. For example, the 64-bit version of `usbdk` must be installed on 64-bit Windows machines.

**Using USB Devices on a Windows Client**

1. When the `usbdk` driver is installed, select a virtual machine that has been configured to use the SPICE protocol.

2. Ensure USB support is set to **Enabled**:

    i. Click **Edit**.

    ii. Click the **Console** tab.

    iii. Select **Enabled** from the **USB Support** drop-down list.

    iv. Click **OK**.

3. Click **Console** &rarr; **Console Options**.

4. Select the **Enable USB Auto-Share** check box.

5. Start the virtual machine from the VM Portal and click the **Console** button to connect to that virtual machine.

6. Plug your USB device into the client machine to make it appear automatically on the guest machine.

### Using USB Devices on an Enterprise Linux Client

The `usbredir` package enables USB redirection from Enterprise Linux clients to virtual machines. `usbredir` is a dependency of the `virt-viewer` package, and is automatically installed together with that package.

   **Note:** USB redirection is only supported when you open the virtual machine from the VM Portal.
   {: .alert .alert-info}

**Using USB devices on a Enterprise Linux client**

1. Click **Compute** &rarr; **Virtual Machines** and select a virtual machine that has been configured to use the SPICE protocol.

2. Ensure USB support is set to **Enabled**:

    i. Click **Edit**.

    ii. Click the **Console** tab.

    iii. Select **Enabled** from the **USB Support** drop-down list.

    iv. Click **OK**.

3. Click **Console** &rarr; **Console Options**.

4. Select the **Enable USB Auto-Share** check box and click **OK**.

5. Start the virtual machine from the VM Portal and click **Console** to connect to that virtual machine.

6. Plug your USB device into the client machine to make it appear automatically on the guest machine.

## Configuring Multiple Monitors

### Configuring Multiple Displays for Enterprise Linux Virtual Machines

A maximum of four displays can be configured for a single Enterprise Linux virtual machine when connecting to the virtual machine using the SPICE protocol.

1. Start a SPICE session with the virtual machine.

2. Open the **View** drop-down menu at the top of the SPICE client window.

3. Open the **Display** menu.

4. Click the name of a display to enable or disable that display.

    **Note:** By default, **Display 1** is the only display that is enabled on starting a SPICE session with a virtual machine. If no other displays are enabled, disabling this display will close the session.
	{: .alert .alert-info}

# Configuring Multiple Displays for Windows Virtual Machines

A maximum of four displays can be configured for a single Windows virtual machine when connecting to the virtual machine using the SPICE protocol.

1. Click **Compute** &rarr; **Virtual Machines** and select a virtual machine.

2. With the virtual machine in a powered-down state, click **Edit**.

3. Click the **Console** tab.

4. Select the number of displays from the **Monitors** drop-down list.

    **Note:** This setting controls the maximum number of displays that can be enabled for the virtual machine. While the virtual machine is running, additional displays can be enabled up to this number.
	{: .alert .alert-info}

5. Click **OK**.

6. Start a SPICE session with the virtual machine.

7. Open the **View** drop-down menu at the top of the SPICE client window.

8. Open the **Display** menu.

9. Click the name of a display to enable or disable that display.

    **Note:** By default, **Display 1** is the only display that is enabled on starting a SPICE session with a virtual machine. If no other displays are enabled, disabling this display will close the session.
	{: .alert .alert-info}

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
   {: .alert .alert-info}

#### Configuring SPICE Console Options

You can configure several options for opening graphical consoles for virtual machines, such as the method of invocation and whether to enable or disable USB redirection.

**Accessing Console Options**

1. Click **Compute** &rarr; **Virtual Machines** and select a running virtual machine.

2. Click **Console** &rarr; **Console Options.

    **Note:** You can configure the connection protocols and video type in the **Console** tab of the **Edit Virtual Machine** window in the Administration Portal. Additional options specific to each of the connection protocols, such as the keyboard layout when using the VNC connection protocol, can be configured.
	{: .alert .alert-info}

#### SPICE Console Options

When the SPICE connection protocol is selected, the following options are available in the **Console Options** window.

**SPICE Options**

* **Map control-alt-del shortcut to ctrl+alt+end**: Select this check box to map the **Ctrl** + **Alt** + **Del** key combination to **Ctrl** + **Alt** + **End** inside the virtual machine.

* **Enable USB Auto-Share**: Select this check box to automatically redirect USB devices to the virtual machine. If this option is not selected, USB devices will connect to the client machine instead of the guest virtual machine. To use the USB device on the guest machine, manually enable it in the SPICE client menu.

* **Open in Full Screen**: Select this check box for the virtual machine console to automatically open in full screen when you connect to the virtual machine. Press **SHIFT** + **F11** to toggle full screen mode on or off.

* **Enable SPICE Proxy**: Select this check box to enable the SPICE proxy.

#### VNC Console Options

When the VNC connection protocol is selected, the following options are available in the **Console Options** window.

**Console Invocation**

* **Native Client**: When you connect to the console of the virtual machine, a file download dialog provides you with a file that opens a console to the virtual machine via Remote Viewer.

*  **noVNC**: When you connect to the console of the virtual machine, a browser tab is opened that acts as the console.

**VNC Options**

* **Map control-alt-delete shortcut to ctrl+alt+end**: Select this check box to map the **Ctrl** + **Alt** + **Del** key combination to **Ctrl** + **Alt** + **End** inside the virtual machine.

#### RDP Console Options

When the RDP connection protocol is selected, the following options are available in the **Console Options** window.

**Console Invocation**

* **Auto**: The Engine automatically selects the method for invoking the console.

* **Native client**: When you connect to the console of the virtual machine, a file download dialog provides you with a file that opens a console to the virtual machine via Remote Desktop.

**RDP Options**

* **Use Local Drives**: Select this check box to make the drives on the client machine accessible on the guest virtual machine.

### Remote Viewer Options

#### Using SPICE Connection Options

When you specify the **Native client** console invocation option, you will connect to virtual machines using Remote Viewer. The Remote Viewer window provides a number of options for interacting with the virtual machine to which it is connected.

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

#### Remote Viewer Hotkeys

You can access the hotkeys for a virtual machine in both full screen mode and windowed mode. If you are using full screen mode, you can display the menu containing the button for hotkeys by moving the mouse pointer to the middle of the top of the screen. If you are using windowed mode, you can access the hotkeys via the **Send key** menu on the virtual machine window title bar.

**Note:** If `vdagent` is not running on the client machine, the mouse can become captured in a virtual machine window if it is used inside a virtual machine and the virtual machine is not in full screen. To unlock the mouse, press **Shift** + **F12**.
{: .alert .alert-info}

#### Manually Associating console.vv Files with Remote Viewer

If you are prompted to download a `console.vv` file when attempting to open a console to a virtual machine using the native client console option, and Remote Viewer is already installed, then you can manually associate `console.vv` files with Remote Viewer so that Remote Viewer can automatically use those files to open consoles.

**Manually Associating console.vv Files with Remote Viewer**

1. Start the virtual machine.

2. Open the **Console Options** window.

    * In the Administration Portal, click **Console** &rarr; **Console Options**.

    * In the VM Portal, click virtual machine name and click the pencil icon beside **Console**.

3. Change the console invocation method to **Native client** and click **OK**.

4. Attempt to open a console to the virtual machine, then click **Save** when prompted to open or save the **console.vv** file.

5. Click the location on your local machine where you saved the file.

6. Double-click the **console.vv** file and select **Select a program from a list of installed programs** when prompted.

7. In the **Open with** window, select **Always use the selected program to open this kind of file** and click the **Browse** button.

8. Click the **C:\Users\[user name]\AppData\Local\virt-viewer\bin** directory and select **remote-viewer.exe**.

9. Click **Open** and then click **OK**.

When you use the native client console invocation option to open a console to a virtual machine, Remote Viewer will automatically use the **console.vv** file that the oVirt Engine provides to open a console to that virtual machine without prompting you to select the application to use.

## Configuring a Watchdog

### Adding a Watchdog Card to a Virtual Machine

You can add a watchdog card to a virtual machine to monitor the operating system's responsiveness.

**Adding Watchdog Cards to Virtual Machines**

1. Click **Compute** &rarr; **Virtual Machines** tab and select a virtual machine.

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

3. Edit the **/etc/watchdog.conf** file and uncomment the following line:

        watchdog-device = /dev/watchdog

4. Save the changes.

5. Start the `watchdog` service and ensure this service starts on boot:

    * Enterprise Linux 6:

            # service watchdog start
            # chkconfig watchdog on

    * Enterprise Linux 7:

            # systemctl start watchdog.service
            # systemctl enable watchdog.service

### Confirming Watchdog Functionality

Confirm that a watchdog card has been attached to a virtual machine and that the `watchdog` service is active.

   **Warning:** This procedure is provided for testing the functionality of watchdogs only and must not be run on production machines.
   {: .alert .alert-warning}

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

The following is a list of options for configuring the `watchdog` service available in the **/etc/watchdog.conf** file. To configure an option, you must uncomment that option and restart the `watchdog` service after saving the changes.

**Note:** For a more detailed explanation of options for configuring the `watchdog` service and using the `watchdog` command, see the `watchdog` man page.
{: .alert .alert-info}

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

1. Click **Compute** &rarr; **Virtual Machines** and select a virtual machine.

2. Click **Edit**.

3. Click the **Host** tab.

4. Select the **Specific Host(s)** radio button and select a host from the list. The selected host must have at least two NUMA nodes.

5. Select **Do not allow migration** from the **Migration Options** drop-down list.

6. Enter a number into the **NUMA Node Count** field to assign virtual NUMA nodes to the virtual machine.

7. Select **Strict**, **Preferred**, or **Interleave** from the **Tune Mode** drop-down list. If the selected mode is **Preferred**, the **NUMA Node Count** must be set to `1`.

8. Click **NUMA Pinning**.

9. In the **NUMA Topology** window, click and drag virtual NUMA nodes from the box on the right to host NUMA nodes on the left as required, and click **OK**.

10. Click **OK**.

    **Note:** If you do not pin the virtual NUMA node to a host NUMA node, the system defaults to the NUMA node that contains the host device’s memory-mapped I/O (MMIO), provided that there are one or more host devices and all of those devices are from a single NUMA node.
	{: .alert .alert-info}

## Configuring Foreman Errata Management for a Virtual Machine

In the Administration Portal, you can configure a virtual machine to display the available errata. The virtual machine needs to be associated with a Foreman server to show available errata.

oVirt 4.2 supports errata management with Foreman 6.1.

The following prerequisites apply:

* The host that the virtual machine runs on also needs to be configured to receive errata information from Foreman. See "Configuring Foreman Errata Management for a Host" in the [Administration Guide](/documentation/administration_guide/) for more information.

* The virtual machine must have the rhevm-guest-agent package installed. This package allows the virtual machine to report its host name to the oVirt Engine. This allows the Foreman server to identify the virtual machine as a content host and report the applicable errata. For more information on installing the ovirt-guest-agent package see the Installing the Guest Agents and Drivers on Enterprise Linux section above for Enterprise Linux virtual machines and the Installing the Guest Agents and Drivers on Windows section for Windows virtual machines.

**Important:** Virtual machines are identified in the Foreman server by their FQDN. This ensures that an external content host ID does not need to be maintained in oVirt.
{: .alert .alert-info}

**Configuring Foreman Errata Management**

**Note:** The virtual machine must be registered to the Foreman server as a content host and have the katello-agent package installed.
{: .alert .alert-info}

1. Click **Compute** &rarr; **Virtual Machines** and select a virtual machine.

2. Click **Edit**.

3. Click the **Foreman/Satellite** tab.

4. Select the required Foreman server from the **Provider** drop-down list.

5. Click **OK**.

## Configuring Headless Virtual Machines

You can configure a headless virtual machine when it is not necessary to access the machine via a graphical console. This headless machine will run without graphical and video devices. This can be useful in situations where the host has limited resources, or to comply with virtual machine usage requirements such as real-time virtual machines.

Headless virtual machines can be administered via a Serial Console, SSH, or any other service for command line access. Headless mode is applied via the **Console** tab when creating or editing virtual machines and machine pools, and when editing templates. It is also available when creating or editing instance types.

If you are creating a new headless virtual machine, you can use the **Run Once** window to access the virtual machine via a graphical console for the first run only. See the “Explanation of Settings in the Run Once Window” in Appendix A for more details.

**Prerequisites**

* If you are editing an existing virtual machine, and the oVirt guest agent has not been installed, note the machine’s IP prior to selecting **Headless Mode**.

* Before running a virtual machine in headless mode, the GRUB configuration for this machine must be set to console mode otherwise the guest operating system’s boot process will hang. To set console mode, comment out the spashimage flag in the GRUB menu configuration file:

        # splashimage=(hd0,0)/grub/splash.xpm.gz serial --unit=0 --speed=9600 --parity=no --stop=1 terminal --timeout=2 serial

    **Note:** Restart the virtual machine if it is running when selecting the **Headless Mode** option.
	{: .alert .alert-info}

**Configuring a Headless Virtual Machine**

1. Click **Compute** &rarr; **Virtual Machines** and select a virtual machine.

2. Click **Edit**.

3. Click the **Console** tab.

4. Select **Headless Mode**. All other fields in the **Graphical Console** section are disabled.

5. Optionally, select **Enable VirtIO serial console** to enable communicating with the virtual machine via serial console. This is highly recommended.

6. Reboot the virtual machine if it is running.

## Configuring High Performance Virtual Machines, Templates, and Pools

You can configure a virtual machine for high performance, so that it runs with performance metrics as close to bare metal as possible. When you choose high performance optimization, the virtual machine is configured with a set of automatic, and recommended manual, settings for maximum efficiency.

The high performance option is only accessible in the Administration Portal, by selecting **High Performance** from the **Optimized for** drop-down list in the **Edit** or **New** virtual machine, template, or pool window. This option is not available in the VM Portal.

The high performance option is supported by oVirt 4.2 and later. Therefore, it is not available for earlier compatibility versions.

**Virtual Machines**

If you change the optimization mode of a running virtual machine to high performance, some configuration changes require restarting the virtual machine.

To change the optimization mode of a new or existing virtual machine to high performance, you may need to make manual changes to the cluster and to the pinned host configuration first.

A high performance virtual machine has certain limitations, because enhanced performance has a trade-off in decreased flexibility:

* A high performance virtual machine cannot be migrated.

* If pinning is set for CPU threads, IO threads, emulator threads, or NUMA nodes, according to the recommended settings, only a subset of cluster hosts can be assigned to the high performance virtual machine.
Many devices are automatically disabled, which limits the virtual machine’s usability.

**Templates and Pools**

High performance templates and pools are created and edited in the same way as virtual machines. If a high performance template or pool is used to create new virtual machines, those virtual machines will inherit this property and its configurations. Certain settings, however, are not inherited and have the following limitations:

* CPU pinning cannot be set for templates. CPU pinning must be manually set for virtual machines and for pools that are created from high performance virtual machines.

* Virtual NUMA and NUMA pinning topology cannot be set for templates or pools. Virtual NUMA must be manually set when creating a virtual machine based on a high performance template.
* IO and emulator threads pinning topology is not supported for pools.

### Creating a High Performance Virtual Machine, Template, or Pool

To create a high performance virtual machine, template, or pool:

1. In the **New** or **Edit** window, select **High Performance** from the **Optimized for** drop-down menu.

   Selecting this option automatically performs certain configuration changes to this virtual machine, which you can view by clicking different tabs. You can change them back to their original settings or override them. If you change a setting, its latest value is saved.

2. Click **OK**.

   If you have not set any manual configurations, the **High Performance Virtual Machine/Pool Settings** screen describing the recommended manual configurations appears.

   If you have set some of the manual configurations, the **High Performance Virtual Machine/Pool Settings** screen displays the settings you have not made.

   If you have set all the recommended manual configurations, the **High Performance Virtual Machine/Pool Settings** screen does not appear.

3. If the **High Performance Virtual Machine/Pool Settings** screen appears, click **Cancel** to return to the **New** or **Edit** window to perform the manual configurations.

   Alternatively, click **OK** to ignore the recommendations. The result may be a drop in the level of performance.

4. Click **OK**.

   You can view the optimization type in the General tab of the details view of the virtual machine, pool, or template.

    **Note:** Certain configurations can override the high performance settings. For example, if you select an instance type for a virtual machine before selecting **High Performance** from the **Optimized for** drop-down menu and performing the manual configuration, the instance type configuration will not affect the high performance configuration. If, however, you select the instance type after the high performance configurations, you should verify the final configuration in the different tabs to ensure that the high performance configurations have not been overridden by the instance type.
	{: .alert .alert-info}

    The last-saved configuration usually takes priority.

#### Automatic High Performance Configuration Settings

The following table summarizes the automatic settings. The **Enabled (Y/N)** column indicates configurations that are enabled or disabled. The **Applies to** column indicates the relevant resources:

VM - Virtual machine

T - Template

P - Pool

C - Cluster

<table>
  <colgroup>
    <col style="width: 60%; " class="col_1"/>
	<col style="width: 20%; " class="col_2"/>
	<col style="width: 20%; " class="col_3"/>
  </colgroup>
<thead>
<tr>
<th align="left" valign="top" id="idm140207901275968" scope="col">Setting</th><th align="center" valign="top" id="idm140207901274880" scope="col">Enabled (Y/N)</th><th align="center" valign="top" id="idm140207901273792" scope="col">Applies to</th></tr></thead><tbody><tr><td align="left" valign="top" headers="idm140207901275968"> <p>
										<span class="strong strong"><strong>Headless Mode</strong></span> (Console tab)
									</p>
									 </td><td align="center" valign="top" headers="idm140207901274880"> <p>
										<code class="literal">Y</code>
									</p>
									 </td><td align="center" valign="top" headers="idm140207901273792"> <p>
										<code class="literal">VM, T, P</code>
									</p>
									 </td></tr><tr><td align="left" valign="top" headers="idm140207901275968"> <p>
										<span class="strong strong"><strong>USB Support</strong></span> (Console tab)
									</p>
									 </td><td align="center" valign="top" headers="idm140207901274880"> <p>
										<code class="literal">N</code>
									</p>
									 </td><td align="center" valign="top" headers="idm140207901273792"> <p>
										<code class="literal">VM, T, P</code>
									</p>
									 </td></tr><tr><td align="left" valign="top" headers="idm140207901275968"> <p>
										<span class="strong strong"><strong>Smartcard Enabled</strong></span> (Console tab)
									</p>
									 </td><td align="center" valign="top" headers="idm140207901274880"> <p>
										<code class="literal">N</code>
									</p>
									 </td><td align="center" valign="top" headers="idm140207901273792"> <p>
										<code class="literal">VM, T, P</code>
									</p>
									 </td></tr><tr><td align="left" valign="top" headers="idm140207901275968"> <p>
										<span class="strong strong"><strong>Soundcard Enabled</strong></span> (Console tab)
									</p>
									 </td><td align="center" valign="top" headers="idm140207901274880"> <p>
										<code class="literal">N</code>
									</p>
									 </td><td align="center" valign="top" headers="idm140207901273792"> <p>
										<code class="literal">VM, T, P</code>
									</p>
									 </td></tr><tr><td align="left" valign="top" headers="idm140207901275968"> <p>
										<span class="strong strong"><strong>Enable VirtIO serial console</strong></span> (Console tab)
									</p>
									 </td><td align="center" valign="top" headers="idm140207901274880"> <p>
										<code class="literal">Y</code>
									</p>
									 </td><td align="center" valign="top" headers="idm140207901273792"> <p>
										<code class="literal">VM, T, P</code>
									</p>
									 </td></tr><tr><td align="left" valign="top" headers="idm140207901275968"> <p>
										<span class="strong strong"><strong>Do not allow migration</strong></span> (Host tab)
									</p>
									 </td><td align="center" valign="top" headers="idm140207901274880"> <p>
										<code class="literal">N</code>
									</p>
									 </td><td align="center" valign="top" headers="idm140207901273792"> <p>
										<code class="literal">VM</code>
									</p>
									 </td></tr><tr><td align="left" valign="top" headers="idm140207901275968"> <p>
										<span class="strong strong"><strong>Pass-Through Host CPU</strong></span> (Host tab)
									</p>
									 </td><td align="center" valign="top" headers="idm140207901274880"> <p>
										<code class="literal">Y</code>
									</p>
									 </td><td align="center" valign="top" headers="idm140207901273792"> <p>
										<code class="literal">VM, T, P</code>
									</p>
									 </td></tr><tr><td align="left" valign="top" headers="idm140207901275968"> <p>
										<span class="strong strong"><strong>Highly Available</strong></span> <a href="#ftn.idm140207901221120" class="footnote"><sup class="footnote" id="idm140207901221120">[a]</sup></a> (High Availability tab)
									</p>
									 </td><td align="center" valign="top" headers="idm140207901274880"> <p>
										<code class="literal">N</code>
									</p>
									 </td><td align="center" valign="top" headers="idm140207901273792"> <p>
										<code class="literal">VM, T, P</code>
									</p>
									 </td></tr><tr><td align="left" valign="top" headers="idm140207901275968"> <p>
										<span class="strong strong"><strong>No-Watchdog</strong></span> (High Availability tab)
									</p>
									 </td><td align="center" valign="top" headers="idm140207901274880"> <p>
										<code class="literal">N</code>
									</p>
									 </td><td align="center" valign="top" headers="idm140207901273792"> <p>
										<code class="literal">VM, T, P</code>
									</p>
									 </td></tr><tr><td align="left" valign="top" headers="idm140207901275968"> <p>
										<span class="strong strong"><strong>Memory Balloon Device</strong></span> (Resource Allocation tab)
									</p>
									 </td><td align="center" valign="top" headers="idm140207901274880"> <p>
										<code class="literal">N</code>
									</p>
									 </td><td align="center" valign="top" headers="idm140207901273792"> <p>
										<code class="literal">VM, T, P</code>
									</p>
									 </td></tr><tr><td align="left" valign="top" headers="idm140207901275968"> <p>
										<span class="strong strong"><strong>IO Threads Enabled</strong></span> <a href="#ftn.idm140207901198736" class="footnote"><sup class="footnote" id="idm140207901198736">[b]</sup></a> (Resource Allocation tab)
									</p>
									 </td><td align="center" valign="top" headers="idm140207901274880"> <p>
										<code class="literal">Y</code>
									</p>
									 </td><td align="center" valign="top" headers="idm140207901273792"> <p>
										<code class="literal">VM, T, P</code>
									</p>
									 </td></tr><tr><td align="left" valign="top" headers="idm140207901275968"> <p>
										Paravirtualized Random Number Generator PCI (virtio-rng) device (Random Generator tab)
									</p>
									 </td><td align="center" valign="top" headers="idm140207901274880"> <p>
										<code class="literal">Y</code>
									</p>
									 </td><td align="center" valign="top" headers="idm140207901273792"> <p>
										<code class="literal">VM, T, P</code>
									</p>
									 </td></tr><tr><td align="left" valign="top" headers="idm140207901275968"> <p>
										IO and emulator threads pinning topology
									</p>
									 </td><td align="center" valign="top" headers="idm140207901274880"> <p>
										<code class="literal">Y</code>
									</p>
									 </td><td align="center" valign="top" headers="idm140207901273792"> <p>
										<code class="literal">VM, T</code>
									</p>
									 </td></tr><tr><td align="left" valign="top" headers="idm140207901275968"> <p>
										CPU cache layer 3
									</p>
									 </td><td align="center" valign="top" headers="idm140207901274880"> <p>
										<code class="literal">Y</code>
									</p>
									 </td><td align="center" valign="top" headers="idm140207901273792"> <p>
										<code class="literal">VM, T, P</code>
									</p>
									 </td></tr></tbody><tbody class="footnotes"><tr><td colspan="3"><div id="ftn.idm140207901221120" class="footnote"><div class="para"><a href="#idm140207901221120" class="simpara"><sup class="simpara">[a] </sup></a>
											<code class="literal">Highly Available</code> is not automatically enabled. If you select it manually, high availability should be enabled for pinned hosts only.
										</div></div><div id="ftn.idm140207901198736" class="footnote"><div class="para"><a href="#idm140207901198736" class="simpara"><sup class="simpara">[b] </sup></a>
											Number of IO threads = 1
										</div></div></td></tr></tbody></table>

####  IO and Emulator Threads Pinning Topology (Automatic Settings)

The IO and emulator threads pinning topology is a new configuration setting for oVirt 4.2. It requires that IO threads, NUMA nodes, and NUMA pinning be enabled and set for the virtual machine. Otherwise, a warning will appear in the engine log.

Pinning topology:

* The first two CPUs of each NUMA node are pinned.

* If all vCPUs fit into one NUMA node of the host:

  * The first two vCPUs are automatically reserved/pinned

  * The remaining vCPUs are available for manual vCPU pinning

* If the virtual machine spans more than one NUMA node:

  * The first two CPUs of the NUMA node with the most pins are reserved/pinned

  * The remaining pinned NUMA node(s) are for vCPU pinning only

Pools do not support IO and emulator threads pinning.

**Warning:** If a host CPU is pinned to both a vCPU and IO/emulator threads, a warning will appear in the log and you will be asked to consider changing the CPU pinning topology to avoid this situation.
{: .alert .alert-warning}

####  High Performance Icons

The following icons indicate the states of a high performance virtual machine in the **Compute** &rarr; **Virtual Machines** screen.

**High Performance Icons**

<table class="lt-4-cols lt-7-rows">
  <colgroup>
    <col style="width: 17%; " class="col_1"/>
	<col style="width: 83%; " class="col_2"/>
  </colgroup>
  <thead><tr><th align="left" valign="top" id="idm140207901153328" scope="col">Icon</th><th align="left" valign="top" id="idm140207901152240" scope="col">Description</th></tr></thead><tbody><tr><td align="left" valign="top" headers="idm140207901153328"> <p>
										<span class="inlinemediaobject"><img src="/images/vmm-guide/hp_vm.png" alt="hp vm"/></span>

									</p>
									 </td><td align="left" valign="top" headers="idm140207901152240"> <p>
										High performance virtual machine
									</p>
									 </td></tr><tr><td align="left" valign="top" headers="idm140207901153328"> <p>
										<span class="inlinemediaobject"><img src="/images/vmm-guide/hp_vm_next_run.png" alt="hp vm next run"/></span>

									</p>
									 </td><td align="left" valign="top" headers="idm140207901152240"> <p>
										High performance virtual machine with Next Run configuration
									</p>
									 </td></tr><tr><td align="left" valign="top" headers="idm140207901153328"> <p>
										<span class="inlinemediaobject"><img src="/images/vmm-guide/stateless_hp_vm.png" alt="stateless hp vm"/></span>

									</p>
									 </td><td align="left" valign="top" headers="idm140207901152240"> <p>
										Stateless, high performance virtual machine
									</p>
									 </td></tr><tr><td align="left" valign="top" headers="idm140207901153328"> <p>
										<span class="inlinemediaobject"><img src="/images/vmm-guide/stateless_hp_vm_next_run.png" alt="stateless hp vm next run"/></span>

									</p>
									 </td><td align="left" valign="top" headers="idm140207901152240"> <p>
										Stateless, high performance virtual machine with Next Run configuration
									</p>
									 </td></tr><tr><td align="left" valign="top" headers="idm140207901153328"> <p>
										<span class="inlinemediaobject"><img src="/images/vmm-guide/vm_hp_pool.png" alt="vm hp pool"/></span>

									</p>
									 </td><td align="left" valign="top" headers="idm140207901152240"> <p>
										Virtual machine in a high performance pool
									</p>
									 </td></tr><tr><td align="left" valign="top" headers="idm140207901153328"> <p>
										<span class="inlinemediaobject"><img src="/images/vmm-guide/vm_hp_pool_next_run.png" alt="vm hp pool next run"/></span>

									</p>
									 </td><td align="left" valign="top" headers="idm140207901152240"> <p>
										Virtual machine in a high performance pool with Next Run configuration
									</p>
									 </td></tr></tbody></table>

### Configuring the Recommended Manual Settings

You can configure the recommended manual settings in either the **New** or the **Edit** windows.

If a recommended setting is not performed, the **High Performance Virtual Machine/Pool Settings** screen displays the recommended setting when you save the resource.

The recommended manual settings are:

* Pinning the CPU

* Setting the NUMA Nodes and Pinning Topology

* Configuring Huge Pages

* Disabling KSM

#### Manual High Performance Configuration Settings

The following table summarizes the recommended manual settings. The **Enabled (Y/N)** column indicates configurations that should be enabled or disabled. The **Applies to** column indicates the relevant resources:

* VM - Virtual machine

* T - Template

* P - Pool

* C - Cluster

**Manual High Performance Configuration Settings**

<table class="lt-4-cols lt-7-rows">
  <colgroup>
    <col style="width: 60%; " class="col_1"/>
    <col style="width: 20%; " class="col_2"/>
    <col style="width: 20%; " class="col_3"/>
  </colgroup>
  <thead>
    <tr>
	  <th align="left" valign="top" id="idm140207901082352" scope="col">Setting</th>
	  <th align="center" valign="top" id="idm140207901081264" scope="col">Enabled (Y/N)</th>
	  <th align="center" valign="top" id="idm140207901080176" scope="col">Applies to</th>
	</tr>
  </thead>
    <tbody>
	  <tr>
	   <td align="left" valign="top" headers="idm140207901082352"><p><span class="strong strong"><strong>NUMA Node Count</strong></span> (Host tab)</p></td>
	   <td align="center" valign="top" headers="idm140207901081264"><p><code class="literal">Y</code></p></td>
	   <td align="center" valign="top" headers="idm140207901080176"><p><code class="literal">VM</code></p></td>
	  </tr>
	  <tr>
	    <td align="left" valign="top" headers="idm140207901082352"><p>
										<span class="strong strong"><strong>Tune Mode</strong></span> (Host tab)
									</p>
									 </td><td align="center" valign="top" headers="idm140207901081264"> <p>
										<code class="literal">Y</code>
									</p>
									 </td><td align="center" valign="top" headers="idm140207901080176"> <p>
										<code class="literal">VM</code>
									</p>
									 </td></tr><tr><td align="left" valign="top" headers="idm140207901082352"> <p>
										<span class="strong strong"><strong>NUMA Pinning</strong></span> (Host tab)
									</p>
									 </td><td align="center" valign="top" headers="idm140207901081264"> <p>
										<code class="literal">Y</code>
									</p>
									 </td><td align="center" valign="top" headers="idm140207901080176"> <p>
										<code class="literal">VM</code>
									</p>
									 </td></tr><tr><td align="left" valign="top" headers="idm140207901082352"> <p>
										<span class="strong strong"><strong>CPU Pinning topology</strong></span> (Resource Allocation tab)
									</p>
									 </td><td align="center" valign="top" headers="idm140207901081264"> <p>
										<code class="literal">Y</code>
									</p>
									 </td><td align="center" valign="top" headers="idm140207901080176"> <p>
										<code class="literal">VM, P</code>
									</p>
									 </td></tr><tr><td align="left" valign="top" headers="idm140207901082352"> <p>
										<span class="strong strong"><strong>hugepages</strong></span> (Custom Properties tab)
									</p>
									 </td><td align="center" valign="top" headers="idm140207901081264"> <p>
										<code class="literal">Y</code>
									</p>
									 </td><td align="center" valign="top" headers="idm140207901080176"> <p>
										<code class="literal">VM, T, P</code>
									</p>
									 </td></tr><tr><td align="left" valign="top" headers="idm140207901082352"> <p>
										<span class="strong strong"><strong>KSM</strong></span> (Optimization tab)
									</p>
									 </td><td align="center" valign="top" headers="idm140207901081264"> <p>
										<code class="literal">N</code>
									</p>
									 </td><td align="center" valign="top" headers="idm140207901080176"> <p>
										<code class="literal">C</code>
									</p>
									 </td></tr></tbody></table>

#### Pinning CPUs

To pin vCPUs to a specific host’s physical CPU:

1. In the **Host** tab, select the **Specific Host(s)** radio button.

2. In the **Resource Allocation** tab, enter the **CPU Pinning Topology**, verifying that the configuration fits the pinned host’s configuration.

3. Verify that the virtual machine configuration is compatible with the host configuration:

  * A virtual machine’s number of sockets must not be greater than the host’s number of sockets.

  * A virtual machine’s number of cores per virtual socket must not be greater than the host’s number of cores.

  * A virtual machine’s number of threads per core must not be greater than the host’s number of threads per core.

    **Important:** CPU pinning has the following requirements:
    * If the host is NUMA-enabled, the host’s NUMA settings (memory and CPUs) must be considered because the virtual machine has to fit the host’s NUMA configuration.
    * The IO and emulator threads pinning topology must be considered.
    * CPU pinning can only be set for virtual machines and pools, but not for templates. Therefore, you must set CPU pinning manually whenever you create a high performance virtual machine or pool, even if they are based on a high performance template.
    {: .alert .alert-info}

#### Setting the NUMA Nodes and Pinning Topology

To set the NUMA nodes and pinning topology, you need a NUMA-enabled pinned host with at least two NUMA nodes.

1. In the **Host** tab, select the **NUMA Node Count** and the **Tune Mode** from the drop-down lists.

2. Click **NUMA Pinning**.

3. In the **NUMA Topology** window, click and drag virtual NUMA nodes from the box on the right to the host’s physical NUMA nodes on the left as required.

     **Important:** The number of declared virtual NUMA nodes and the NUMA pinning policy must take into account:
     * The host’s NUMA settings (memory and CPUs)
     * The NUMA node in which the host devices are declared
     * The CPU pinning topology
     * The IO and emulator threads pinning topology
     * Huge page sizes
     * NUMA pinning can only be set for virtual machines, but not for pools or templates. You must set NUMA pinning manually when you create a high performance virtual machine based on a template.
     {: .alert .alert-info}

#### Configuring Huge Pages

Support for huge pages is a new configuration setting for oVirt 4.2. Huge pages are pre-allocated when a virtual machine starts to run (dynamic allocation is disabled by default).

To configure huge pages:

1. In the **Custom Properties** tab, select **hugepages** from the custom properties list, which displays **Please select a key…**​ by default.

2. Enter the huge page size in KB.

   The oVirt Project recommends setting the huge page size to the largest size supported by the pinned host. The recommended size for x86_64 is 1 GB.

   The huge page size has the following requirements:

  * The virtual machine’s huge page size must be the same size as the pinned host’s huge page size.

  * The virtual machine’s memory size must fit into the selected size of the pinned host’s free huge pages.

  * The NUMA node size must be a multiple of the huge page’s selected size.
    
      **Important:** The following limitations apply:
      * Memory hotplug/unplug is disabled
      * Migration is disabled
      * The host’s memory resource is limited
      {: .alert .alert-info}

#### Disabling KSM

To disable Kernel Same-page Merging (KSM) for the cluster:

1. Click **Compute** &rarr; **Clusters** and select the cluster.

2. Click **Edit**.

3. In the **Optimization** tab, uncheck the **Enable KSM** check box.


## Installing a vGPU on a Virtual Machine

You can use a host with a compatible graphics processing unit (GPU) to run virtual machines with virtual GPUs (vGPUs). A virtual machine with a vGPU is better suited for graphics-intensive tasks than a virtual machine without a vGPU. A virtual machine with a vGPU can also run software that cannot run without a GPU, such as CAD.

**vGPU Requirements**

If you plan to configure a host to allow virtual machines on that host to install a vGPU, the following requirements must be met:

* vGPU-compatible GPU

* GPU-enabled host kernel

* Installed GPU with correct drivers

* Predefined **mdev_type** set to correspond with one of the mdev types supported by the device

* vGPU-capable drivers installed on each host in the cluster

* vGPU-supported virtual machine operating system with vGPU drivers installed

**Preparing a Host for vGPU Installation**

1. Install vGPU-capable drivers onto your host. Consult the documentation for your GPU card for more information.

2. Install **vdsm-hook-vfio-mdev**:

        # yum install vdsm-hook-vfio-mdev

You can now install vGPUs on the virtual machines running on this host.

**Installing a vGPU on a Virtual Machine**

1. Confirm the vGPU instance to use:

  * Click **Compute** &rarr; **Hosts**, click the required host’s name to go to the details view, and click the **Host Devices** tab. Available vGPU instances appear in the **Mdev Types** column.

  * Alternatively, run the following command on the host:

          # vdsm-client Host hostdevListByCaps

    Available vGPU instances appear in the **mdev** key **available_instances**.

2. Install the required virtual machine operating system.

3. Shut down the virtual machine.

4. Add the vGPU instance to the virtual machine:

  i. Select the virtual machine and click **Edit**.

  ii. Click **Show Advanced Options**, then click the **Custom Properties** tab.

  iii. Select **mdev_type** from the drop-down list and enter the vGPU instance in the text field.

  iv. Click **OK**.

5. Start the virtual machine and install the vGPU driver through the vendor’s installer. Consult the documentation for your GPU card for more information.

6. Restart the virtual machine.

7. Verify that the vGPU is recognized by checking the virtual machine operating system’s device manager.

    **Important:** You cannot migrate a virtual machine using a vGPU to a different host. When upgrading the virtual machine, verify the operating system and GPU vendor support in the vendor’s documentation.
	{: .alert .alert-info}

**Prev:** [Chapter 3: Installing Windows Virtual Machines](chap-Installing_Windows_Virtual_Machines.html) <br>
**Next:** [Chapter 5: Editing Virtual Machines](chap-Editing_Virtual_Machines.html)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/virtual_machine_management_guide/chap-additional_configuration)
