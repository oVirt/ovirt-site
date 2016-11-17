## Installing the Red Hat Virtualization Manager Packages

Before you can configure and use the Red Hat Virtualization Manager, you must install the <package>rhevm</package> package and dependencies.

**Installing the Red Hat Virtualization Manager Packages**

1. To ensure all packages are up to date, run the following command on the machine where you are installing the Red Hat Virtualization Manager:

        # yum update

    **Note:** Reboot the machine if any kernel related packages have been updated. 

2. Run the following command to install the `rhevm` package and dependencies.

        # yum install rhevm

Proceed to the next step to configure your Red Hat Virtualization Manager.
