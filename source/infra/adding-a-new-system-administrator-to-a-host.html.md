---
title: Adding a new system administrator to a host
category: infra
authors: quaid
wiki_category: Infrastructure documentation
wiki_title: Adding a new system administrator to a host
wiki_revision_count: 11
wiki_last_updated: 2013-02-19
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

*   Create the user's password to activate the account; the user will not use this password to login, but they need it for 'sudo':

<!-- -->

    passwd foo

*   Create the user's SSH config directory:

<!-- -->

    mkdir /home/foo/.ssh

*   Either paste the 'id_rsa.pub' contents in to 'authorized_keys' ...

<!-- -->

    vi /home/foo/.ssh/authorized_keys       ## Then paste the id_rsa.pub
                        ## contents in to the
                        ## 'authorized_keys' file
                        ##
                        ## Or if no file exists ...

*   ... or move the 'id_rsa.pub' file in to the directory with the new name of 'authorized_keys':

<!-- -->

    cp /tmp/foo-id_rsa.pub /home/foo/.ssh/authorized_keys

*   Add the user to the 'sudoers' file:

<!-- -->

    visudo                  ## Add the following stanza
                        ## for 'foo' below the one for
                        ## 'root':

    #* Allow root to run any commands anywhere
    root    ALL=(ALL)       ALL
    quaid   ALL=(ALL)       ALL

*   Change ownership of the user's SSH config directory:

<!-- -->

    chown -R foo:foo /home/foo/.ssh

*   Change file permissions to read/write for the user only:

<!-- -->

    chmod 600 /home/quaid/.ssh

[Category:Infrastructure documentation](Category:Infrastructure documentation)
