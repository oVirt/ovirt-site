# Opening a Serial Console to a Virtual Machine

Access a virtual machine's serial console from the command line, instead of opening a console from the Administration Portal or the User Portal. The serial console is emulated through VirtIO channels, using SSH and key pairs, and does not require direct access to the Manager; the Manager acts as a proxy for the connection, provides information about virtual machine placement, and stores the authentication keys. You can add public keys for each user from either the Administration Portal or the User Portal. You can access serial consoles for only those virtual machines for which you have appropriate permissions.

**Important:** To access the serial console of a virtual machine, the user must have the UserVmManager, SuperUser, or UserInstanceManager permission on that virtual machine. These permissions must be explicitly defined per user; it is not enough to assign these permissions for **Everyone**.

The serial console is accessed via TCP port 2222 on the Manager. This port is opened during `engine-setup` on new installations. The serial console relies on the `ovirt-vmconsole` package and the `ovirt-vmconsole-proxy` on the Manager, and the `ovirt-vmconsole` package and the `ovirt-vmconsole-host` package on virtualization hosts. These packages are installed by default on new installations. To install the packages on existing installations, reinstall the host. See [Reinstalling Hosts](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/administration-guide/#Reinstalling_Virtualization_Hosts) in the *Administration Guide*.

**Connecting to a Virtual Machine Serial Console**

1. On the client machine from which you will access the virtual machine serial console, generate an SSH key pair. The Manager supports standard SSH key types. For example, generate an RSA key:

        # ssh-keygen -t rsa -b 2048 -C "admin@internal" -f .ssh/serialconsolekey

    This command generates a public key and a private key.

2. In the Administration Portal or the User Portal, click the name of the signed-in user on the header bar, and then click **Options** to open the **Edit Options** window.

3. In the **User's Public Key** text field, paste the public key of the client machine that will be used to access the serial console.

4. Click the **Virtual Machines** tab and select a virtual machine.

5. Click **Edit**.

6. In the **Console** tab of the **Edit Virtual Machine** window, select the **Enable VirtIO serial console** check box.

7. On the client machine, connect to the virtual machine's serial console:

    1. If a single virtual machine is available, this command connects the user to that virtual machine:

            # ssh -t -p 2222 ovirt-vmconsole@MANAGER_IP
            Red Hat Enterprise Linux Server release 6.7 (Santiago)
            Kernel 2.6.32-573.3.1.el6.x86_64 on an x86_64
            USER login:

        If more than one virtual machine is available, this command lists the available virtual machines:

            # ssh -t -p 2222 ovirt-vmconsole@MANAGER_IP
            1. vm1 [vmid1]
            2. vm2 [vmid2]
            3. vm3 [vmid3]
            > 2
            Red Hat Enterprise Linux Server release 6.7 (Santiago)
            Kernel 2.6.32-573.3.1.el6.x86_64 on an x86_64
            USER login:

        Enter the number of the machine to which you want to connect, and press **Enter**.

    2. Alternatively, connect directly to a virtual machine using its unique identifier or its name:

            # ssh -t -p 2222 ovirt-vmconsole@MANAGER_IP --vm-id vmid1
            # ssh -t -p 2222 ovirt-vmconsole@MANAGER_IP --vm-name vm1

**Important:** If the serial console session is disconnected abnormally, a TCP timeout occurs. You will be unable to reconnect to the virtual machine's serial console until the timeout period expires.
