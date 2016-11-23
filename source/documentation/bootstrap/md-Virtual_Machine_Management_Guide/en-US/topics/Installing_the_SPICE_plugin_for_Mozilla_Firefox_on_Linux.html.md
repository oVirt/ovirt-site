# Installing Remote Viewer on Red Hat Enterprise Linux

The Remote Viewer application provides users with a graphical console for connecting to virtual machines. Once installed, it is called automatically when attempting to open a SPICE session with a virtual machine. Alternatively, it can also be used as a standalone application. Remote Viewer is included in the `virt-viewer` package provided by the base Red Hat Enterprise Linux Workstation and Red Hat Enterprise Linux Server repositories.

**Installing Remote Viewer on Linux**

1. Install the `virt-viewer` package:

        # yum install virt-viewer

2. Restart your browser for the changes to take effect.

You can now connect to your virtual machines using either the SPICE protocol or the VNC protocol.
