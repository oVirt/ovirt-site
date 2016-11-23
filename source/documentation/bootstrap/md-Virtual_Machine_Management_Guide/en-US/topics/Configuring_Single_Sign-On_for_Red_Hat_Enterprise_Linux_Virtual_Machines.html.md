# Configuring Single Sign-On for Red Hat Enterprise Linux Virtual Machines Using IPA (IdM)

To configure single sign-on for Red Hat Enterprise Linux virtual machines using GNOME and KDE graphical desktop environments and IPA (IdM) servers, you must install the `rhevm-guest-agent` package on the virtual machine and install the packages associated with your window manager.

**Important:** The following procedure assumes that you have a working IPA configuration and that the IPA domain is already joined to the Manager. You must also ensure that the clocks on the Manager, the virtual machine and the system on which IPA (IdM) is hosted are synchronized using NTP.

**Configuring Single Sign-On for Red Hat Enterprise Linux Virtual Machines**

1. Log in to the Red Hat Enterprise Linux virtual machine.

2. Enable the required channel:

    * For Red Hat Enterprise Linux 6 

            # subscription-manager repos --enable=rhel-6-server-rhv-4-agent-rpms

    * For Red Hat Enterprise Linux 7 

            # subscription-manager repos --enable=rhel-7-server-rh-common-rpms

3. Download and install the guest agent packages:

        # yum install rhevm-guest-agent-common

4. Install the single sign-on packages: 

        # yum install rhevm-guest-agent-pam-module
        # yum install rhevm-guest-agent-gdm-plugin

5. Install the IPA packages: 

        # yum install ipa-client

6. Run the following command and follow the prompts to configure *ipa-client* and join the virtual machine to the domain:

        # ipa-client-install --permit --mkhomedir

    **Note:** In environments that use DNS obfuscation, this command should be:

        # ipa-client-install --domain=FQDN --server==FQDN

7. For Red Hat Enterprise Linux 7.2, run:

        # authconfig --enablenis --update

    **Note:** Red Hat Enterprise Linux 7.2 has a new version of the System Security Services Daemon (SSSD) which introduces configuration that is incompatible with the Red Hat Virtualization Manager guest agent single sign-on implementation. The command will ensure that single sign-on works.

8. Fetch the details of an IPA user:

        # getent passwd IPA_user_name

    This will return something like this:

        some-ipa-user:*:936600010:936600001::/home/some-ipa-user:/bin/sh

    You will need this information in the next step to create a home directory for `some-ipa-user`.

8. Set up a home directory for the IPA user:

    1. Create the new user's home directory:

            # mkdir /home/some-ipa-user

    2. Give the new user ownership of the new user's home directory:

            # chown 935500010:936600001 /home/some-ipa-user

Log in to the User Portal using the user name and password of a user configured to use single sign-on and connect to the console of the virtual machine. You will be logged in automatically.

