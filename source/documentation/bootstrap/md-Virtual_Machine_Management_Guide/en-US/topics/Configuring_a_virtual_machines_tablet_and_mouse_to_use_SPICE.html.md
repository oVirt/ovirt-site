# Configuring a Virtual Machine's Tablet and Mouse to use SPICE

Edit the `/etc/X11/xorg.conf` file to enable SPICE for your virtual machine's tablet devices.

**Configuring a Virtual Machine's Tablet and Mouse to use SPICE**

1. Verify that the tablet device is available on your guest:

        # /sbin/lsusb -v | grep 'QEMU USB Tablet'

    If there is no output from the command, do not continue configuring the tablet.

2. Back up `/etc/X11/xorg.conf`:

        # cp /etc/X11/xorg.conf /etc/X11/xorg.conf.$$.backup

3. Make the following changes to `/etc/X11/xorg.conf`: 

        Section "ServerLayout"
        Identifier     "single head configuration"
        Screen      0  "Screen0" 0 0
        InputDevice    "Keyboard0" "CoreKeyboard"
        InputDevice    "Tablet" "SendCoreEvents"
        InputDevice    "Mouse" "CorePointer"
        EndSection
        
        Section "InputDevice"
        Identifier  "Mouse"
        Driver      "void"
        #Option      "Device" "/dev/input/mice"
        #Option      "Emulate3Buttons" "yes"
        EndSection
        
        Section "InputDevice"
        Identifier  "Tablet"
        Driver      "evdev"
        Option      "Device" "/dev/input/event2"
        Option "CorePointer" "true"
        EndSection

4. Log out and log back into the virtual machine to restart X-Windows.
