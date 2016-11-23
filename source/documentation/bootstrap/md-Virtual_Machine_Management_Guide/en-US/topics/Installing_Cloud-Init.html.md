# Installing Cloud-Init

This procedure describes how to install Cloud-Init on a virtual machine. Once Cloud-Init is installed, you can create a template based on this virtual machine. Virtual machines created based on this template can leverage Cloud-Init functions, such as configuring the host name, time zone, root password, authorized keys, network interfaces, DNS service, etc on boot.

**Installing Cloud-Init**

1. Log on to the virtual machine.

2. Enable the required repositories:

    * Red Hat Enterprise Linux 6:

            # subscription-manager repos --enable=rhel-6-server-rpms
            # subscription-manager repos --enable=rhel-6-server-rh-common-rpms

    * Red Hat Enterprise Linux 7:

            # subscription-manager repos --enable=rhel-7-server-rpms
            # subscription-manager repos --enable=rhel-7-server-rh-common-rpms

3. Install the `cloud-init` package and dependencies:

        # yum install cloud-init
