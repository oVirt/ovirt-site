---
title: Accessing the VM Portal
---

# Chapter 1: Accessing the VM Portal

## What is the VM Portal?

Desktop virtualization provides users with a desktop environment that is similar to a personal computer’s desktop environment. The VM Portal delivers Virtual Desktop Infrastructure to users. Users access the VM Portal through a web browser to display and access their assigned virtual desktops. The actions available to a user in the VM Portal are set by a system administrator. Standard users can start, stop, and use desktops that are assigned to them by the system administrator. Power users can perform some administrative actions. Both types of users access the VM Portal from the same URL, and are presented with options appropriate to their permission level on login.

**Standard User Access**

Standard users can power their virtual desktops on and off and connect to them through the VM Portal. Direct connection to virtual machines is facilitated with SPICE or VNC clients. Both protocols provide the user with an environment similar to a locally installed desktop. The administrator specifies the protocol used to connect to a virtual machine at the time of the virtual machine’s creation.

**Power User Access**

System administrators can delegate some administration tasks by granting users power user access. In addition to the tasks that can be performed by standard users, power users can:

* Create, edit, and remove virtual machines

* Manage virtual disks and network interfaces

* Assign user permissions to virtual machines

* Create and use templates to rapidly deploy virtual machines

* Monitor resource usage and high-severity events

* Create and use snapshots to restore virtual machines to previous states

## Browser Requirements

The following browser versions and operating systems can be used to access the Administration Portal and the VM Portal.

Browser support is divided into tiers:

* Tier 1: Browser and operating system combinations that are fully tested and fully supported.

* Tier 2: Browser and operating system combinations that are partially tested, and are likely to work.

* Tier 3: Browser and operating system combinations that are not tested, but may work.

**Browser Requirements**

|Support Tier |Operating System Family |Browser|
|-
|Tier 1 |Enterprise Linux |Mozilla Firefox Extended Support Release (ESR) version |
|Tier 2 |Windows |Internet Explorer 11 or later |
| |Any |Most recent version of Google Chrome or Mozilla Firefox|
|Tier 3 |Any |Earlier versions of Google Chrome or Mozilla Firefox|
| |Any |Other browsers|

## Client Requirements

Virtual machine consoles can only be accessed using supported Remote Viewer (`virt-viewer`) clients on Red Hat Enterprise Linux and Windows. To install `virt-viewer`, see [Installing Supporting Components on Client Machines](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/virtual_machine_management_guide/sect-installing_supporting_components) in the *Virtual Machine Management Guide*. Installing `virt-viewer` requires Administrator privileges.

Virtual machine consoles are accessed through the SPICE protocol. The QXL graphical driver can be installed in the guest operating system for improved/enhanced SPICE functionalities. SPICE currently supports a maximum resolution of 2560x1600 pixels.

Supported QXL drivers are available on Enterprise Linux, Windows XP, and Windows 7.

SPICE support is divided into tiers:

* Tier 1: Operating systems on which Remote Viewer has been fully tested and is supported.

* Tier 2: Operating systems on which Remote Viewer is partially tested and is likely to work. Limited support is provided for this tier.

**Client Operating System SPICE Support**

|Support Tier |Operating System |
|-
|Tier 1 |Enterprise Linux 7.2 and later|
| |Microsoft Windows 7 |
|Tier 2 |Microsoft Windows 8 |
| |Microsoft Windows 10 |

## Installing the CA certificate

The first time you access the VM Portal, you must install the certificate used by the oVirt Engine to avoid security warnings.

**Installing the CA certificate in Firefox**

1. Go to the VM Portal URL.

2. Click **Add Exception** to open the **Add Security Exception** window.

3. Select **Permanently store this exception**.

4. Click **Confirm Security Exception**.

**Installing the CA certificate in Internet Explorer**

1. Go to the VM Portal certificate URL: **https://_\[VM Portal URL]_/ca.crt**.

2. Click **Open** in the **File Download - Security Warning** window to open the **Certificate** window.

3. Click the **Install Certificate** button to open the **Certificate Import Wizard** window.

4. Select the **Place all certificates in the following store** radio button and click **Browse** to open the **Select Certificate Store** window.

5. Select **Trusted Root Certification Authorities** from the list of certificate stores and click **OK**.

6. Click **Next** to proceed to the **Certificate Store** screen.

7. Click **Next** to proceed to the **Completing the Certificate Import Wizard** screen.

8. Click **Finish** to install the certificate.

    **Important:** If you are using Internet Explorer to access the VM Portal, you must also add the URL for the oVirt welcome page to the list of trusted sites to ensure that all security rules for trusted sites are applied to console resources such as *console.vv* mime files and Remote Desktop connection files.

**Downloading the CA certificate**

To download the CA certificate manually, click the **CA Certificate** link on the Engine's welcome screen and save the **ca.crt** file.

## Logging in to the VM Portal

**Logging in to the VM Portal**

1. Enter the provided server address into the web browser to access the Engine welcome screen.

2. Select the required language from the drop-down list.

3. Click **VM Portal**. An SSO login page displays. SSO login enables you to log in to the VM Portal and the Administration Portal (if you have permission) at the same time.

4. Enter your **User Name** and **Password**. Use the **Profile** drop-down list to select the correct domain.

5. Click **Log In**. The list of virtual machines and pools assigned to you displays.

To log out of the Portal, click your user name in the header bar and select **Log out**. You are logged out of all portals and the Engine welcome screen displays.

## Graphical user interface elements

You can perform common virtual machine tasks, change log-in options, and view messages in the VM Portal screen.

![](/images/intro-vm-portal/VM_screen.png)

**Key graphical user interface elements**

* ![](/images/intro-vm-portal/1.png) `Header bar`

  The header bar contains the **Refresh** button, the **User** drop-down button, and the **Messages** drop-down button.

  * The **Refresh** button refreshes the display.
  * The **User** drop-down button displays the following list:

    * **Options**: SSH key, for connecting via serial console to the VM Portal
    * **About**: VM Portal release information
    * **Log out**: To log out of the VM Portal

  * The **Messages** drop-down button displays messages from the system.

* ![](/images/intro-vm-portal/2.png) `Toolbar`

  The toolbar contains buttons that allow you to perform additional actions.

* ![](/images/intro-vm-portal/3.png)`Virtual machines pane`

   The virtual machines pane displays the icon, operating system, name, state, and management icons of each virtual machine and pooled virtual machine.

**Next:** [Chapter 2: Managing Virtual Machines](../Viewing_virtual_machines)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/introduction_to_the_vm_portal/chap-accessing_the_vm_portal)
