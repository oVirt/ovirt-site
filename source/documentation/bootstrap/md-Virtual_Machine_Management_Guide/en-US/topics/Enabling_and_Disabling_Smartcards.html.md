# Smart Card Authentication

Smart cards are an external hardware security feature, most commonly seen in credit cards, but also used by many businesses as authentication tokens. Smart cards can be used to protect Red Hat Virtualization virtual machines.

**Enabling Smart Cards**

1. Ensure that the smart card hardware is plugged into the client machine and is installed according to manufacturer's directions.

2. Click the **Virtual Machines** tab and select a virtual machine.

3. Click **Edit**.

4. Click the **Console** tab and select the **Smartcard enabled** check box.

5. Click **OK**.

6. Run the virtual machine by clicking the **Console** icon. Smart card authentication is now passed from the client hardware to the virtual machine.

**Important:** If the Smart card hardware is not correctly installed, enabling the Smart card feature will result in the virtual machine failing to load properly.

**Disabling Smart Cards**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click **Edit**.

3. Click the **Console** tab, and clear the **Smartcard enabled** check box.

4. Click **OK**.

**Configuring Client Systems for Smart Card Sharing**

1. Smart cards may require certain libraries in order to access their certificates. These libraries must be visible to NSS library, which `spice-gtk` uses to provide the smart card to the guest. NSS expects the libraries to provide the PKCS #11 interface.

2. Make sure that the module architecture matches spice-gtk/remote-viewer's architecture. For instance, if you have only the 32b PKCS #11 library available, you must install the 32b build of virt-viewer in order for smart cards to work.

**Configuring RHEL clients with CoolKey Smart Card Middleware**

1. CoolKey Smart Card middleware is a part of Red Hat Enterprise Linux. Install the `Smart card support` group. If the Smart Card Support group is installed on a Red Hat Enterprise Linux system, smart cards are redirected to the guest when Smart Cards are enabled. The following command installs the `Smart card support` group:

        # yum groupinstall "Smart card support"

**Configuring RHEL clients with Other Smart Card Middleware**

1. Register the library in the system's NSS database. Run the following command as root:

        # modutil -dbdir /etc/pki/nssdb -add "module name" -libfile /path/to/library.so

**Configuring Windows Clients**

1. Red Hat does not provide PKCS #11 support to Windows clients. Libraries that provide PKCS #11 support must be obtained from third-parties. When such libraries are obtained, register them by running the following command as a user with elevated privileges:

        modutil -dbdir %PROGRAMDATA%\pki\nssdb -add "module name" -libfile C:\Path\to\module.dll
