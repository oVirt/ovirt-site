# Installing the Guest Agents and Drivers on Windows

The Red Hat Virtualization guest agents and drivers are installed on Windows virtual machines using the `rhev-tools-setup.iso` ISO file, which is provided by the `rhev-guest-tools-iso` package installed as a dependency to the Red Hat Virtualization Manager. This ISO file is located in `/usr/share/rhev-guest-tools-iso/rhev-tools-setup.iso` on the system on which the Red Hat Virtualization Manager is installed.

**Note:** The `rhev-tools-setup.iso` ISO file is automatically copied to the default ISO storage domain, if any, when you run `engine-setup`, or must be manually uploaded to an ISO storage domain.

**Note:** Updated versions of the `rhev-tools-setup.iso` ISO file must be manually attached to running Windows virtual machines to install updated versions of the tools and drivers. If the APT service is enabled on virtual machines, the updated ISO files will be automatically attached.

**Note:** If you install the guest agents and drivers from the command line or as part of a deployment tool such as Windows Deployment Services, you can append the options `ISSILENTMODE` and `ISNOREBOOT` to `RHEV-toolsSetup.exe` to silently install the guest agents and drivers and prevent the machine on which they have been installed from rebooting immediately after installation. The machine can then be rebooted later once the deployment process is complete. 

    D:\RHEV-toolsSetup.exe ISSILENTMODE ISNOREBOOT

**Installing the Guest Agents and Drivers on Windows**

1. Log in to the virtual machine.

2. Select the CD Drive containing the `rhev-tools-setup.iso` file.

3. Double-click *RHEV-toolsSetup*.

4. Click **Next** at the welcome screen.

5. Follow the prompts on the **RHEV-Tools InstallShield Wizard** window. Ensure all check boxes in the list of components are selected.

    **Selecting All Components of Red Hat Virtualization Tools for Installation**

    ![](images/5604.png)

6. Once installation is complete, select `Yes, I want to restart my computer now` and click **Finish** to apply the changes.

The guest agents and drivers now pass usage information to the Red Hat Virtualization Manager and allow you to access USB devices, single sign-on into virtual machines and other functionality. The Red Hat Virtualization guest agent runs as a service called RHEV Agent that you can configure using the `rhev-agent` configuration file located in `C:\Program Files\Redhat\RHEV\Drivers\Agent`.
