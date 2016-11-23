# Installing the Guest Agents and Drivers on Red Hat Enterprise Linux

The Red Hat Virtualization guest agents and drivers are installed on Red Hat Enterprise Linux virtual machines using the `rhevm-guest-agent` package provided by the Red Hat Virtualization Agent repository.

# Installing the Guest Agents and Drivers on Red Hat Enterprise Linux

1. Log in to the Red Hat Enterprise Linux virtual machine.

2. Enable the Red Hat Virtualization Agent repository:

    * For Red Hat Enterprise Linux 6 

            # subscription-manager repos --enable=rhel-6-server-rhv-4-agent-rpms

    * For Red Hat Enterprise Linux 7 

            # subscription-manager repos --enable=rhel-7-server-rh-common-rpms

3. Install the `rhevm-guest-agent-common` package and dependencies:

        # yum install rhevm-guest-agent-common

4. Start and enable the service:

    * For Red Hat Enterprise Linux 6 

            # service ovirt-guest-agent start
            # chkconfig ovirt-guest-agent on

    * For Red Hat Enterprise Linux 7 

            # systemctl start ovirt-guest-agent.service
            # systemctl enable ovirt-guest-agent.service

5. Start and enable the `qemu-ga` service:

    * For Red Hat Enterprise Linux 6 

            # service qemu-ga start
            # chkconfig qemu-ga on

    * For Red Hat Enterprise Linux 7 

            # systemctl start qemu-guest-agent.service
            # systemctl enable qemu-guest-agent.service

The guest agent now passes usage information to the Red Hat Virtualization Manager. The Red Hat Virtualization agent runs as a service called `ovirt-guest-agent` that you can configure via the `ovirt-guest-agent.conf` configuration file in the `/etc/` directory.
