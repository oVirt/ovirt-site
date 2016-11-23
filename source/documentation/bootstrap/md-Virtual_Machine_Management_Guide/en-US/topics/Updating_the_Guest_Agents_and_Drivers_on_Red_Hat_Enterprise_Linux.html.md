# Updating the Guest Agents and Drivers on Red Hat Enterprise Linux

Update the guest agents and drivers on your Red Hat Enterprise Linux virtual machines to use the latest version.

**Updating the Guest Agents and Drivers on Red Hat Enterprise Linux**

1. Log in to the Red Hat Enterprise Linux virtual machine.

2. Update the `rhevm-guest-agent-common` package:

        # yum update rhevm-guest-agent-common

3. Restart the service:

    * For Red Hat Enterprise Linux 6 

            # service ovirt-guest-agent restart

    * For Red Hat Enterprise Linux 7 

            # systemctl restart ovirt-guest-agent.service
