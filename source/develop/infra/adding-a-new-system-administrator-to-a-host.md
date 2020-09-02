---
title: Adding a new system administrator to a host
category: infra
authors: quaid
---

# Adding a new system administrator to a host

Here are the general steps for adding a new system administrator with 'sudo' access to a host.

Modify these steps for giving specific 'sudo' access, such as to backups, restarting web services, etc. when the team is ready to sub-divide admin tasks.

*   Switch to the root user or use 'sudo' (preferable):

<!-- -->

    su -                    ## Or do all this with sudo, preferably

*   Add the new user to the system:

<!-- -->

    useradd foo

*   If the system uses e.g. the `wheel` group for sudo permissions, add the user to the appropriate group for sudo permission:

<!-- -->

    usermod -a -G wheel foo

*   Create the user's password to activate the account; the user will not use this password to login, but they need it for 'sudo':

<!-- -->

    passwd foo

*   Create the user's SSH config directory:

<!-- -->

    mkdir /home/foo/.ssh

*   Change ownership of the user's SSH config directory:

<!-- -->

    chown foo:foo /home/foo/.ssh

*   Change directory permissions to read/write/execute for the user only:

<!-- -->

    chmod 700 /home/foo/.ssh

*   Either paste the 'id_rsa.pub' contents in to 'authorized_keys' or ...

<!-- -->

    vi /home/foo/.ssh/authorized_keys       ## Then paste the id_rsa.pub
                        ## contents in to the
                        ## 'authorized_keys' file
                        ##
                        ## Or if no file exists ...

*   ... move the 'id_rsa.pub' file in to the directory with the new name of 'authorized_keys':

<!-- -->

    cp /tmp/foo-id_rsa.pub /home/foo/.ssh/authorized_keys

*   Change the file's ownership to the new user:

<!-- -->

    chown foo:foo /home/foo/.ssh/authorized_keys

*   Confirm the file's permissions are read/write for the user, read for everyone else, by changing them:

<!-- -->

    chmod 644 /home/foo/.ssh/authorized_keys

*   Add the user to the 'sudoers' file:

<!-- -->

    visudo                  ## Add the following stanza
                        ## for 'foo' below the one for
                        ## 'root':

    #* Allow root to run any commands anywhere
    root    ALL=(ALL)       ALL
    foo   ALL=(ALL)       ALL

*   The final permissions:

<!-- -->

    ls /home/foo/.ssh/ -hal
    total 12K
    drwx------ 2 foo foo 4.0K Dec  3 19:38 .                 
    drwx------ 3 foo foo 4.0K Dec  3 19:34 ..                ## ~/.ssh is correct
    -rw-r--r-- 1 foo foo  604 Dec  3 19:33 authorized_keys   ## authorized_keys file is correct

Here are the final commands as run:

    useradd foo
    passwd foo
    ## If using the wheel group use the following command:
    usermod -a -G wheel foo
    mkdir /home/foo/.ssh
    chown foo:foo /home/foo/.ssh
    chmod 700 /home/foo/.ssh
    ## One of the following two methods for creating the authorized_keys file
    vi /home/foo/.ssh/authorized_keys
    cp /tmp/foo-id_rsa.pub /home/foo/.ssh/authorized_keys
    chown foo:foo /home/foo/.ssh/authorized_keys
    chmod 644 /home/foo/.ssh/authorized_keys
    ## If not using the wheel group, add directly to sudoers file with the following command:
    visudo
    ls -hal /home/foo/.ssh

[Category:Infrastructure documentation](/develop/infra/infrastructure-documentation.html) [Category:Infrastructure SOP](/develop/infra/infrastructure-sop.html)
