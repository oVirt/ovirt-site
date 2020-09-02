---
title: Gerrit server backup
category: infra
authors: quaid
---

# Gerrit server backup

**Goal: create a cronjob that sends a tar backup of Gerrit.**

## On linode01.ovirt.org

*   Create Gerrit backup user, saving the password in */root/passwords*:

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

### Backup git source directories

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
    # Gerrit backup script - git source backup
    #
    # 0.1 Alpha - 20111207 Karsten Wade <kwade@redhat.com> <quaid@iquaid.org>
    #
    # Copyright 2011 Karsten Wade <kwade@redhat.com> <quaid@iquaid.org>
    #
    #   Licensed under the Apache License, Version 2.0 (the "License");
    #   you may not use this file except in compliance with the License.
    #   You may obtain a copy of the License at
    #
    # http://www.apache.org/licenses/LICENSE-2.0
    #
    #   Unless required by applicable law or agreed to in writing, software
    #   distributed under the License is distributed on an "AS IS" BASIS,
    #   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    #   See the License for the specific language governing permissions and
    #   limitations under the License.
    #

    # Set variables
    RSYNC="/usr/bin/rsync"
    RSYNCOPTS="-az -e"
    SSH="/usr/bin/ssh"
    GITSRC="/usr/local/src/git/"
    REMOTEUSER="gerrit-backup"
    REMOTEHOST="ovirt.org"
    REMOTEDIR="gerrit.ovirt.org-src-backup/src/"

    # Run backup - rsync local git source to remote backup directory
    # Note: gerrit user has sshkeys with no passphrase
    $RSYNC $RSYNCOPTS $SSH $GITSRC $REMOTEUSER@$REMOTEHOST:$REMOTEDIR

*   Make script executable:

<!-- -->

    chmod 700 bin/gerrit-backup.sh

*   Make cronjob run every day at 2200 EST

<!-- -->

    crontab -e

*   -   Contents of user's *crontab*:

<!-- -->

    # mail all output to root
    MAILTO=root
    # Run at 2200 (10 pm) system time every day
    0 22 * * *     $HOME/bin/gerrit-backup.sh
    # Run database backup at 2220 (10:20 pm) system time every day
    20 22 * * *    $HOME/bin/gerrit-database-backup.sh
    # Run backup of /home/gerrit2 at 2240 (10:30 pm) system time every day
    40 22 * * *    $HOME/bin/gerrit-gerrit2-home-backup.sh

### Backup Gerrit database

*   Add this backup script to the *gerrit2* user's crontab:

<!-- -->

    #!/bin/bash
    #
    # Gerrit backup script - database backup
    #
    # 0.1 Alpha - 20111207 Karsten Wade <kwade@redhat.com> <quaid@iquaid.org>
    # 
    #
    # Copyright 2011 Karsten Wade <kwade@redhat.com> <quaid@iquaid.org>
    #
    #   Licensed under the Apache License, Version 2.0 (the "License");
    #   you may not use this file except in compliance with the License.
    #   You may obtain a copy of the License at
    #
    # http://www.apache.org/licenses/LICENSE-2.0
    #
    #   Unless required by applicable law or agreed to in writing, software
    #   distributed under the License is distributed on an "AS IS" BASIS,
    #   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    #   See the License for the specific language governing permissions and
    #   limitations under the License.
    #

    # set variables
    SU="/bin/su"
    SCP="/usr/bin/scp"
    TAR="/bin/tar"
    TAROPTS="-czf"
    HOME="/home/gerrit2/"
    PGDUMP="/usr/bin/pg_dump"
    PGUSER="gerrit2"
    PGHOST="localhost"
    # PGPORT=""
    # The -w directive stops a password request, the ~/.pgpass file provides the password
    PGOPTS="-w"
    DATE=`/bin/date +%Y%m%d`
    DBNAME="reviewdb"
    BACKUPDIR="/home/gerrit2/backups/database"
    BACKUPFILE="gerrit-pg-dump"
    REMOTEHOST="ovirt.org"
    REMOTEUSER="gerrit-backup"
    REMOTEDIR="gerrit.ovirt.org-database-backup"

    ## Run backup
    # Switch to the Gerrit user - useful if root runs the script
    #$SU - $PGUSER
    # The gerrit2 user should change to the home directory
    cd $HOME
    # Dump the database to a SQL script file with a dated filename
    $PGDUMP $PGOPTS $DBNAME > $BACKUPDIR/$BACKUPFILE-$DATE.sql
    # Compress the SQL script
    $TAR $TAROPTS $BACKUPDIR/$BACKUPFILE-$DATE.tgz $BACKUPDIR/$BACKUPFILE-$DATE.sql
    # Securely copy the SQL script to a remote backup host
    $SCP $BACKUPDIR/$BACKUPFILE-$DATE.tgz $REMOTEUSER@$REMOTEHOST:$REMOTEDIR/

### Backup gerrit2 user home directory

*   Add this backup script to the *gerrit2* user's crontab:

<!-- -->

    #!/bin/bash
    #
    # Gerrit backup script - gerrit2 user home backup
    #
    # 0.1 Alpha - 20111208 Karsten Wade <kwade@redhat.com> <quaid@iquaid.org>
    # 
    #
    # Copyright 2011 Karsten Wade <kwade@redhat.com> <quaid@iquaid.org>
    #
    #   Licensed under the Apache License, Version 2.0 (the "License");
    #   you may not use this file except in compliance with the License.
    #   You may obtain a copy of the License at
    #
    # http://www.apache.org/licenses/LICENSE-2.0
    #
    #   Unless required by applicable law or agreed to in writing, software
    #   distributed under the License is distributed on an "AS IS" BASIS,
    #   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    #   See the License for the specific language governing permissions and
    #   limitations under the License.
    #

    # set variables
    SCP="/usr/bin/scp"
    TAR="/bin/tar"
    TAROPTS="-czf"
    # Follwing variable doesn't work, probably due to a bash expansion order
    TAREXCLUDE="--exclude='/home/gerrit2/backups*'"
    HOME="/home/gerrit2/"
    DATE=`/bin/date +%Y%m%d`
    BACKUPDIR="/home/gerrit2/backups/gerrit2-home/"
    BACKUPFILE="gerrit-gerrit2-home-backup"
    BACKUPTARGET="/home/gerrit2"
    REMOTEHOST="ovirt.org"
    REMOTEUSER="gerrit-backup"
    REMOTEDIR="gerrit.ovirt.org-gerrit2-home-backup/"

    ## Run backup
    # Switch to the Gerrit user - useful if root runs the script
    #$SU - $PGUSER
    # The gerrit2 user should change to the home directory
    cd $HOME
    # Compress the home directory
    $TAR $TAROPTS $BACKUPDIR/$BACKUPFILE-$DATE.tgz $BACKUPTARGET --exclude='/home/gerrit2/backups*'
    # Securely copy the compressed archive to a remote backup host
    $SCP $BACKUPDIR/$BACKUPFILE-$DATE.tgz $REMOTEUSER@$REMOTEHOST:$REMOTEDIR

### Resources

*   <http://www.postgresql.org/docs/8.4/static/backup-dump.html>
*   <http://www.postgresql.org/docs/8.4/static/libpq-pgpass.html>

[Category:Infrastructure documentation](/develop/infra/infrastructure-documentation.html)
