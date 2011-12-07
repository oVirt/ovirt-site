---
title: Gerrit server backup
category: infra
authors: quaid
wiki_category: Infrastructure documentation
wiki_title: Gerrit server backup
wiki_revision_count: 7
wiki_last_updated: 2011-12-08
---

# Gerrit server backup

**Goal: create a cronjob that sends a tar backup of Gerrit.**

## On linode01.ovirt.org

*   Create Gerrit backup user; save password in */root/passwords*:

<!-- -->

    useradd gerrit-backup
    passwd gerrit-backup

*   Create SSH key structure:

<!-- -->

    touch /home/gerrit-backup/.ssh/authorized_keys
    vi /home/gerrit-backup/.ssh/authorized_keys # add id_rsa.pub contents
    chmod 644 /home/gerrit-backup/.ssh/authorized_keys 
    chmod 700 /home/gerrit-backup/.ssh/

*   Create backup directory and sub-dir tree:

<!-- -->

    mkdir -p /home/gerrit-backup/backup/src

## On gerrit.ovirt.org

*   Switch to the Gerrit user:

<!-- -->

    su - gerrit2

*   Create an SSH key without a passphrase, then copy the public key for the *authorized_keys* file on the remote host:

<!-- -->

    ssh-keygen # set no passphrase
    cat .ssh/id_rsa.pub

*   Prepare backup script:

<!-- -->

    mkdir /home/gerrit2/bin
    vi bin/gerrit-backup.sh

*   Bash script to remotely backup git repository directories using rsync over ssh:

<!-- -->

    #!/bin/bash
    #
    # Gerrit backup script: 0.1 Alpha
    #
    # 20111207 Karsten Wade <kwade@redhat.com> <quaid@iquaid.org>

    # Set variables
    RSYNC="/usr/bin/rsync"
    RSYNCOPTS="-az -e"
    SSH="/usr/bin/ssh"
    GITSRC="/usr/local/src/git/"
    REMOTEUSER="gerrit-backup"
    REMOTEURL="ovirt.org"
    REMOTEDIR="gerrit.ovirt.org-src-backup/src/"

    # Run backup - rsync local git source to remote backup directory
    # Note: gerrit user has sshkeys with no passphrase
    $RSYNC $RSYNCOPTS $SSH $GITSRC $REMOTEUSER@$REMOTEURL:$REMOTEDIR

*   Make script executable:

<!-- -->

    chmod 700 bin/gerrit-backup.sh

*   Make cronjob run every day at 2200 EST

<!-- -->

    crontab -e

*   Contents of user's *crontab*:

<!-- -->

    # mail all output to root
    MAILTO=root
    # Run at 2200 (10 pm) system time every day
    0 22 * * *     $HOME/bin/gerrit-backup.sh

[Category:Infrastructure documentation](Category:Infrastructure documentation)
