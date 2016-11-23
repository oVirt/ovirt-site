# Installing and Configuring QXL Drivers

  You must manually install QXL drivers on virtual machines running Red Hat Enterprise Linux 5.4 or higher. This is unnecessary for virtual machines running Red Hat Enterprise Linux 6 or Red Hat Enterprise Linux 7 as the QXL drivers are installed by default.

**Installing QXL Drivers**

1. Log in to a Red Hat Enterprise Linux virtual machine.

2. Install the QXL drivers: 

        # yum install xorg-x11-drv-qxl

You can configure QXL drivers using either a graphical interface or the command line. Perform only one of the following procedures.

**Configuring QXL drivers in GNOME**

1. Click **System**.

2. Click **Administration**.

3. Click **Display**.

4. Click the **Hardware** tab.

5. Click **Video Cards Configure**.

6. Select **qxl** and click **OK**.

7. Restart X-Windows by logging out of the virtual machine and logging back in.

**Configuring QXL drivers on the command line:**

1. Back up `/etc/X11/xorg.conf`:

        # cp /etc/X11/xorg.conf /etc/X11/xorg.conf.$$.backup

2. Make the following change to the Device section of `/etc/X11/xorg.conf`:

        Section  "Device"
        Identifier "Videocard0"
        Driver  "qxl"
        Endsection
