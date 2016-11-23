# Automating Guest Additions on Windows Guests with Red Hat Virtualization Application Provisioning Tool(APT)

Red Hat Virtualization Application Provisioning Tool (APT) is a Windows service that can be installed on Windows virtual machines and templates. When the APT service is installed and running on a virtual machine, attached ISO files are automatically scanned. When the service recognizes a valid Red Hat Virtualization guest tools ISO, and no other guest tools are installed, the APT service installs the guest tools. If guest tools are already installed, and the ISO image contains newer versions of the tools, the service performs an automatic upgrade. This procedure assumes you have attached the `rhev-tools-setup.iso` ISO file to the virtual machine.

**Installing the APT Service on Windows**

1. Log in to the virtual machine.

2. Select the CD Drive containing the `rhev-tools-setup.iso` file.

3. Double-click *RHEV-Application Provisioning Tool*.

4. Click **Yes** in the **User Account Control** window.

5. Once installation is complete, ensure the `Start RHEV-apt Service` check box is selected in the **RHEV-Application Provisioning Tool InstallShield Wizard** window, and click **Finish** to apply the changes.

Once the APT service has successfully installed or upgraded the guest tools on a virtual machine, the virtual machine is automatically rebooted; this happens without confirmation from the user logged in to the machine. The APT Service will also perform these operations when a virtual machine created from a template that has the APT Service already installed is booted for the first time.

**Note:** The *RHEV-apt* service can be stopped immediately after install by clearing the `Start RHEV-apt Service` check box. You can stop, start, or restart the service at any time using the **Services** window.
