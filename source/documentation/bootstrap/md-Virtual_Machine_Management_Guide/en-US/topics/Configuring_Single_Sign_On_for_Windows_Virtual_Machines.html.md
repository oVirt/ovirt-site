# Configuring Single Sign-On for Windows Virtual Machines

To configure single sign-on for Windows virtual machines, the Windows guest agent must be installed on the guest virtual machine. The `RHEV Guest Tools` ISO file provides this agent. If the `RHEV-toolsSetup.iso` image is not available in your ISO domain, contact your system administrator.

**Configuring Single Sign-On for Windows Virtual Machines**

1. Select the Windows virtual machine. Ensure the machine is powered up.

2. Click **Change CD**.

3. Select `RHEV-toolsSetup.iso` from the list of images.

4. Click **OK**.

5. Click the **Console** icon and log in to the virtual machine.

6. On the virtual machine, locate the CD drive to access the contents of the guest tools ISO file and launch `RHEV-ToolsSetup.exe`. After the tools have been installed, you will be prompted to restart the machine to apply the changes.

Log in to the User Portal using the user name and password of a user configured to use single sign-on and connect to the console of the virtual machine. You will be logged in automatically.
