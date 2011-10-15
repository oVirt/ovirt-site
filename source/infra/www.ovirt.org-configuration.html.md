---
title: Www.ovirt.org-Configuration
category: infra
authors: dneary, quaid
wiki_category: Infrastructure documentation
wiki_title: Www.ovirt.org-Configuration
wiki_revision_count: 10
wiki_last_updated: 2014-04-23
---

# Www.ovirt.org-Configuration

## Setting up Wordpress as ovirt.org front page

*   working
*   on
*   this

## Setting up MediaWiki as ovirt.org wiki

### Overview

1.  Install RPMs from RHEL/EPEL.
    -   mediawiki116

2.  Tweak locations & details as per theopensourceway.org.
    1.  Configuration so users can add other users.
    2.  .htaccess for /wiki

3.  Write-up (borrow) the how-to-add users content.
4.  Write-up the wiki how-to.
    1.  List of categories to use.
    2.  How to name pages. (Borrow from fedoraproject.org?)

## Configuration details

Installed packages:

    yum install mysql mysql-server wordpress mediawiki116

Configure mysql to start at boot:

    chkconfig mysqld on

Set mysql root password:

    mysqladmin -u root password '(REFER TO /root/passwords-root)'
    mysqladmin -u root -h linode01.ovirt.org password '(REFER TO /root/passwords-root)'
    mysql_secure_installation

[Details of 'mysqladmin' output](#output_from_mysql_secure_installation).

database user: (REFER TO /root/passwords-root) password: (REFER TO /root/passwords-root)

Configure httpd files:

    vi /etc/httpd/conf.d/mediawiki116.conf 

From '/etc/httpd/conf.d/mediawiki116.conf':

    # This is a sample configuration for a wiki instance located under
    # /var/www/mediawiki116 and exposed as http://thishost/wiki116. Please
    # read /usr/share/doc/mediawiki116-*/README.RPM on whether to use this
    # instance or create copies of it.

    # Alias /wiki116                     /var/www/mediawiki116/index.php
    # Alias /wiki116/index.php           /var/www/mediawiki116/index.php
    # Alias /wiki116/api.php             /var/www/mediawiki116/api.php
    # Alias /wiki116/opensearch_desc.php /var/www/mediawiki116/opensearch_desc.php
    # Alias /wiki116/skins               /var/www/mediawiki116/skins
    # Alias /wiki116/images              /var/www/mediawiki116/images

    # Remove this after installing.
    #Alias /wiki116/config               /var/www/mediawiki116/config

    ## Using /wiki instead of /wiki116

    Alias /wiki                     /var/www/mediawiki116/index.php
    #Alias /wiki/index.php           /var/www/mediawiki116/index.php
    #Alias /wiki/api.php             /var/www/mediawiki116/api.php
    #Alias /wiki/opensearch_desc.php /var/www/mediawiki116/opensearch_desc.php
    #Alias /wiki/skins               /var/www/mediawiki116/skins
    #Alias /wiki/images              /var/www/mediawiki116/images

    # Remove this after installing.
    Alias /wiki/config               /var/www/mediawiki116/config

    ## Following is a standard configuration, now uncommented

    <Directory /var/www/mediawiki116>
      Options FollowSymLinks
    </Directory>

    Alias /wiki /var/www/html/w

Installed 'memcached', set to run from localhost:11251. (Using default package configuration, fed that to MediaWiki installer, it worked.)

User accounts on the wiki are created by other users, and is **not** a self-service operation. This is how that is configured.

MediaWiki custom user account creation configuration section in '/var/www/mediawiki116/LocalSettings.php':

    # Permission controls to limit access.
    # added 2011-09-18 Karsten Wade <kwade@redhat.com>

    // Implicit group for all visitors
    $wgGroupPermissions['*'    ]['createaccount']   = false;
    $wgGroupPermissions['*'    ]['read']            = true;
    $wgGroupPermissions['*'    ]['edit']            = false;
    $wgGroupPermissions['*'    ]['createpage']      = false;
    $wgGroupPermissions['*'    ]['createtalk']      = false;

    // Implicit group for all logged-in accounts
    $wgGroupPermissions['user' ]['move']            = true;
    $wgGroupPermissions['user' ]['read']            = true;
    $wgGroupPermissions['user' ]['edit']            = true;
    $wgGroupPermissions['user' ]['createpage']      = true;
    $wgGroupPermissions['user' ]['createtalk']      = true;
    $wgGroupPermissions['user' ]['upload']          = true;
    $wgGroupPermissions['user' ]['reupload']        = true;
    $wgGroupPermissions['user' ]['reupload-shared'] = true;
    $wgGroupPermissions['user' ]['minoredit']       = false;
    $wgGroupPermissions['user' ]['purge']           = true; // can use ?action=purge without clicking "ok"
    // Adding that all logged-in accounts can create new user acounts; we are relying upon humans vetting humans
    $wgGroupPermissions['user' ]['createaccount']   = true;

    // Implicit group for accounts that pass $wgAutoConfirmAge
    $wgGroupPermissions['autoconfirmed']['autoconfirmed'] = true;

    // Implicit group for accounts with confirmed email addresses
    // This has little use when email address confirmation is off
    $wgGroupPermissions['emailconfirmed']['emailconfirmed'] = true;

    $wgGroupPermissions['bot'  ]['autopatrol']      = true;

    // Leaving in some useful configuration bits borrowed from
    // the opensourceway.org/wiki configuration; we might need them
    // when customizing the MediaWiki skin, especially if we use the
    // same background-image trick that theopensourceway.org uses.
    // 2011-09-18 kwade@redhat.com

    // Custom image - temporary
    // $wgLogo = "{$wgScriptPath}/skins/localskinname/someimage.png";

    // Setting to blank to show background with logo on it. It remains clickable,
    // but it's a hack. -- kwade@redhat.com 2010-02-26
    // $wgLogo = "";

    // Adding Cite extension -
    // http://www.mediawiki.org/wiki/Extension:Cite/Cite.php#Installation (using mediawiki-Cite pkg)
    // 2010-03-06 kwade@redhat.com
    // require_once("$IP/extensions/Cite/Cite.php");

The background image is set in the skin, which for the default monobook is 'skins/monobook/headbg.jpg'. Replace that with another JPG and the background Just Works(TM). Use this configuration in '/var/www/mediawiki116/LocalSettings.php' to make the default logo disappear:

    // Setting to blank to show background with logo on it. It remains clickable,
    // but it's a hack. -- kwade@redhat.com 2011-09-21
    $wgLogo = "";

## output from mysql_secure_installation

    [root@linode01 quaid]# mysql_secure_installation 

    NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MySQL
          SERVERS IN PRODUCTION USE!  PLEASE READ EACH STEP CAREFULLY!

    In order to log into MySQL to secure it, we'll need the current
    password for the root user.  If you've just installed MySQL, and
    you haven't set the root password yet, the password will be blank,
    so you should just press enter here.

    Enter current password for root (enter for none): 
    OK, successfully used password, moving on...

    Setting the root password ensures that nobody can log into the MySQL
    root user without the proper authorisation.

    You already have a root password set, so you can safely answer 'n'.

    Change the root password? [Y/n] n
     ... skipping.

    By default, a MySQL installation has an anonymous user, allowing anyone
    to log into MySQL without having to have a user account created for
    them.  This is intended only for testing, and to make the installation
    go a bit smoother.  You should remove them before moving into a
    production environment.

    Remove anonymous users? [Y/n] y
     ... Success!

    Normally, root should only be allowed to connect from 'localhost'.  This
    ensures that someone cannot guess at the root password from the network.

    Disallow root login remotely? [Y/n] y
     ... Success!

    By default, MySQL comes with a database named 'test' that anyone can
    access.  This is also intended only for testing, and should be removed
    before moving into a production environment.

    Remove test database and access to it? [Y/n] y
     - Dropping test database...
     ... Success!
     - Removing privileges on test database...
     ... Success!

    Reloading the privilege tables will ensure that all changes made so far
    will take effect immediately.

    Reload privilege tables now? [Y/n] y
     ... Success!

    Cleaning up...

    All done!  If you've completed all of the above steps, your MySQL
    installation should now be secure.

    Thanks for using MySQL!

## Output from mysql -u root -p mysql

    Enter password: 
    Reading table information for completion of table and column names
    You can turn off this feature to get a quicker startup with -A

    Welcome to the MySQL monitor.  Commands end with ; or \g.
    Your MySQL connection id is 21
    Server version: 5.1.52 Source distribution

    Copyright (c) 2000, 2010, Oracle and/or its affiliates. All rights reserved.
    This software comes with ABSOLUTELY NO WARRANTY. This is free software,
    and you are welcome to modify and redistribute it under the GPL v2 license

    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

    mysql> create database wikidb;
    Query OK, 1 row affected (0.00 sec)

    mysql> grant index, create, select, insert, update, delete, alter, lock tables on wikidb.* to 'wikiuser'@'localhost' identified by '(REFER TO /root/passwords-root)'
        -> 
        -> ;
    Query OK, 0 rows affected (0.00 sec)

    mysql> grant index, create, select, insert, update, delete, alter, lock tables on wikidb.* to 'wikiuser'@'localhost' identified by '(REFER TO /root/passwords-root)';
    Query OK, 0 rows affected (0.00 sec)

<Category:Infrastructure> <Category:MediaWiki> [Category:Infrastructure docs](Category:Infrastructure docs) <Category:Wordpress>
