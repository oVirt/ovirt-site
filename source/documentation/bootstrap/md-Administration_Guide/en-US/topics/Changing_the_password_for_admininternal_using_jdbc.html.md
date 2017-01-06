# Changing the Password for the Internal Administrative User

To reset the password of the internal administrative user (`admin@internal`), use the `ovirt-aaa-jdbc-tool` tool. You do not need to restart the `ovirt-engine` service for the password change to take effect.

By default, the password policy for user accounts on the internal domain has the following restrictions:

* A minimum of 6 characters.

* Three previous passwords used cannot be set again during the password change.

For more information on the password policy and other default settings, run `ovirt-aaa-jdbc-tool settings show`.

**Resetting the Password for the Internal Administrative User**

1. Log in to the machine on which the Red Hat Virtualization Manager is installed.

2. To change the password in interactive mode, run the following command. You must set a value for `--password-valid-to`, otherwise the password expiry time defaults to the current time. The date format is `yyyy-MM-dd HH:mm:ssX`. In this example, `Z` stands for UTC time. For more options, run `ovirt-aaa-jdbc-tool user password-reset --help`.

        # ovirt-aaa-jdbc-tool user password-reset admin --password-valid-to="2025-08-01 12:00:00Z"
