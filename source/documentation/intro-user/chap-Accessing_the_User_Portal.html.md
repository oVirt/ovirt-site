---
title: Accessing the User Portal
---

# Chapter 1: Accessing the User Portal

## oVirt Engine Client Requirements

The following browser versions and operating systems can be used to access the Administration Portal and the User Portal.

Browser support is divided into tiers:

* Tier 1: Browser and operating system combinations that are fully tested.

* Tier 2: Browser and operating system combinations that are partially tested, and are likely to work.

* Tier 3: Browser and operating system combinations that are not tested, but may work.

**Browser Requirements**

| Support Tier | Operating System Family | Browser | Portal Access |
|-
| Tier 1 | Enterprise Linux | Mozilla Firefox Extended Support Release (ESR) version | Administration Portal and User Portal |
| Tier 2 | Windows | Internet Explorer 10 or later | Administration Portal and User Portal |
|        | Any | Most recent version of Google Chrome or Mozilla Firefox | Administration Portal and User Portal |
| Tier 3 | Any | Earlier versions of Google Chrome or Mozilla Firefox | Administration Portal and User Portal |
|        | Any | Other browsers | Administration Portal and User Portal |

Virtual machine consoles can only be accessed using supported Remote Viewer (`virt-viewer`) clients on Enterprise Linux and Windows. To install `virt-viewer`, see [Installing Supported Components](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/virtual-machine-management-guide#sect-Installing_Supporting_Components) in the *Virtual Machine Management Guide*. Installing `virt-viewer` requires Administrator privileges.

SPICE console access is only available on other operating systems, such as OS X, through the unsupported SPICE HTML5 browser client.

Supported QXL drivers are available on Enterprise Linux machines, Windows XP and Windows 7 machines.

SPICE support is divided into tiers:

* Tier 1: Operating systems on which remote-viewer has been fully tested.

* Tier 2: Operating systems on which remote-viewer is partially tested and is likely to work.

**Client Operating System SPICE Support**

| Support Tier | Operating System | SPICE Support |
|-
| Tier 1 | Enterprise Linux 7 | Fully supported on Enterprise Linux 7.2 and above |
|        | Microsoft Windows 7        | Fully supported on Microsoft Windows 7 |
| Tier 2 | Microsoft Windows 8        | Supported when spice-vdagent is running on these guest operating systems |
|        | Microsoft Windows 10       | Supported when spice-vdagent is running on these guest operating systems |

## Logging in to and out of the User Portal

Log in to and out of the oVirt User Portal directly from your web browser.

* Logging in to the User Portal

1. Access the User Portal:

    * Enter the provided **User Portal URL** in the address bar of your web browser. The address must be in the format of `https://server.example.com/UserPortal`.

    * Enter the provided *server address* into the web browser to access the welcome screen. Click **User Portal** to be directed to the User Portal.

2. Enter your **User Name** and **Password**. Use the **Profile** drop-down menu to select the correct domain.

3. If you have only one running virtual machine in use, optionally select the **Connect Automatically** check box to connect

4. Select the required language from the drop-down list.

5. Click **Login**. The list of virtual machines assigned to you displays.

To log out of the oVirt User Portal click your user name in the title bar, then click **Sign out**. You are logged out and the User Portal login screen displays.

## Logging in for the First Time: Installing the Engine Certificate

### Installing the oVirt Engine Certificate in Firefox

The first time you access the User Portal, you must install the certificate used by the oVirt Engine to avoid security warnings.

**Installing the oVirt Engine Certificate in Firefox**

1. Navigate to the URL for the User Portal in Firefox.

2. Click **Add Exception** to open the *Add Security Exception* window.

3. Ensure the **Permanently store this exception** check box is selected.

4. Click the **Confirm Security Exception** button.

### Installing the oVirt Engine Certificate in Internet Explorer

The first time you access the User Portal, you must install the certificate used by the oVirt Engine to avoid security warnings.

**Installing the oVirt Engine Certificate in Internet Explorer**

1. Navigate to the following URL:

        https://[your manager's address]/ca.crt

2. Click the **Open** button in the **File Download - Security Warning** window to open the **Certificate** window.

3. Click the **Install Certificate** button to open the **Certificate Import Wizard** window.

4. Select the **Place all certificates in the following store** radio button and click **Browse** to open the **Select Certificate Store** window.

5. Select **Trusted Root Certification Authorities** from the list of certificate stores, then click **OK**.

6. Click **Next** to proceed to the **Certificate Store** screen.

7. Click **Next** to proceed to the **Completing the Certificate Import Wizard** screen.

8. Click **Finish** to install the certificate.

**Important:** If you are using Internet Explorer to access the User Portal, you must also add the URL for the Red Hat Virtualization welcome page to the list of trusted sites to ensure all security rules for trusted sites are applied to console resources such as `console.vv` mime files and Remote Desktop connection files.

**Next:** [Chapter 2: The Basic Tab](../chap-The_Basic_Tab)
