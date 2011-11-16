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

Wordpress is a drop-in PHP application that does not require very much tweaking beyond the basic installation.

Customization is more in the HTTP server configuration.

### Overview of Wordpress installation

1.  Installed RPMs from RHEL repository and EPEL.
2.  Tweaked HTTP configuration provided by the RPM to fit in to server needs.
3.  Configured MySQL as the database.
4.  Chose neutral theme we can drop the logo in to.

### Installation details

Installed packages:

    yum install wordpress

Since MySQL was already configured, added a database and grant privileges to the Wordpress database user:

    mysql -u root (REFER TO /root/passwords)

      mysql> create database ovirtwp;
      Query OK, 1 row affected (0.00 sec)

      mysql> grant all privileges on ovirtwp.* to ovirtwpuser identified by '(REFER TO /root/passwords)';
      Query OK, 0 rows affected (0.00 sec)

      mysql> flush privileges;
      Query OK, 0 rows affected (0.00 sec)

      mysql> exit

Edited '/etc/wordpress/wp-config.php' with these values.

Used <https://api.wordpress.org/secret-key/1.1/salt/> to generate new keys and salts, as explained in the comments.

    cat /etc/wordpress/wp-config.php
    <?php
    /**
     * The base configurations of the WordPress.
     *
     * This file has the following configurations: MySQL settings, Table Prefix,
     * Secret Keys, WordPress Language, and ABSPATH. You can find more information
     * by visiting {@link http://codex.wordpress.org/Editing_wp-config.php Editing
     * wp-config.php} Codex page. You can get the MySQL settings from your web host.
     *
     * This file is used by the wp-config.php creation script during the
     * installation. You don't have to use the web site, you can just copy this file
     * to "wp-config.php" and fill in the values.
     *
     * @package WordPress
     */

    // ** MySQL settings - You can get this info from your web host ** //
    /** The name of the database for WordPress */
    define('DB_NAME', 'ovirtwp');

    /** MySQL database username */
    define('DB_USER', 'ovirtwpuser');

    /** MySQL database password */
    define('DB_PASSWORD', '(REFER TO /root/passwords)');

    /** MySQL hostname */
    define('DB_HOST', 'localhost');

    /** Database Charset to use in creating database tables. */
    define('DB_CHARSET', 'utf8');

    /** The Database Collate type. Don't change this if in doubt. */
    define('DB_COLLATE', '');

    /**#@+
     * Authentication Unique Keys and Salts.
     *
     * Change these to different unique phrases!
     * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
     * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
     *
     * @since 2.6.0
     */
    define('AUTH_KEY',         '(SALT REDACTED)');
    define('SECURE_AUTH_KEY',  '(SALT REDACTED)');
    define('LOGGED_IN_KEY',    '(SALT REDACTED)');
    define('NONCE_KEY',        '(SALT REDACTED)');
    define('AUTH_SALT',        '(SALT REDACTED)');
    define('SECURE_AUTH_SALT', '(SALT REDACTED)');
    define('LOGGED_IN_SALT',   '(SALT REDACTED)');
    define('NONCE_SALT',       '(SALT REDACTED)');

    /**#@-*/

    /**
     * WordPress Database Table prefix.
     *
     * You can have multiple installations in one database if you give each a unique
     * prefix. Only numbers, letters, and underscores please!
     */
    $table_prefix  = 'wp_';

    /**
     * WordPress Localized Language, defaults to English.
     *
     * Change this to localize WordPress. A corresponding MO file for the chosen
     * language must be installed to wp-content/languages. For example, install
     * de_DE.mo to wp-content/languages and set WPLANG to 'de_DE' to enable German
     * language support.
     */
    define('WPLANG', '');

    /**
     * For developers: WordPress debugging mode.
     *
     * Change this to true to enable the display of notices during development.
     * It is strongly recommended that plugin and theme developers use WP_DEBUG
     * in their development environments.
     */
    define('WP_DEBUG', false);

    /* That's all, stop editing! Happy blogging. */

    /** Absolute path to the WordPress directory. */
    if ( !defined('ABSPATH') )
            define('ABSPATH', dirname(__FILE__) . '/');

    /** Sets up WordPress vars and included files. */
    require_once(ABSPATH . 'wp-settings.php');

Commented out the redirect for '/' in '/etc/httpd/conf.d/lists.ovirt.org', since the machine is also running Mailman.

    #       RedirectMatch ^/$ /mailman/listinfo

Changed the 'Alias' directive in '/etc/httpd/conf.d/wordpress.conf' - note the trailing '/' is important:

    Alias / /usr/share/wordpress/

For the password needed for <http://lists.ovirt.org/wp-admin/install.php> refer to '/root/passwords'.

Before releasing the website publicly, we added HTTPD ACLS for private review. This shows how that was accomplished. (Note that the group-use password is shown here since it is no longer in use.)

    cd /var/www
    touch .htpasswd
    htpasswd -b .htpasswd ovirtstaging 1zGn48XEZPHFe
    cat .htpasswd 
    ovirtstaging:CqmU6TAjCvtRo
    cd /usr/share/wordpress/
    vi /etc/httpd/conf.d/lists.ovirt.org.conf

The new directives for the Wordpress control of '/' are here; removed them when the site went live or moves to another host:

            <Directory /usr/share/wordpress>
              AllowOverride Options
              AuthUserFile /var/www/.htpasswd
              AuthGroupFile /dev/null
              AuthName EnterPassword
              AuthType Basic
              require valid-user
            </Directory>

To adjust Wordpress permalinks, the webapp attempts to write to $WEB/.htaccess. When it can't do that, Wordpress kicks back instructions to insert a block of rewrite rules in to the httpd access control file (.htaccess.) Since we are putting access control in httpd.conf for better performance, we included the block that Wordpress gives us in to '/etc/httpd/conf.d/lists.ovirt.org.conf':

            <Directory /usr/share/wordpress>
              AllowOverride Options
              AuthUserFile /var/www/.htpasswd
              AuthGroupFile /dev/null
              AuthName EnterPassword
              AuthType Basic
              require valid-user

              <IfModule mod_rewrite.c>
                RewriteEngine On
                RewriteBase /
                RewriteRule ^index\.php$ - [L]
                RewriteCond %{REQUEST_FILENAME} !-f
                RewriteCond %{REQUEST_FILENAME} !-d
                RewriteRule . /index.php [L]
              </IfModule>

            </Directory>

Configured Wordpress webapp screen by screen.

Since we hid the site during configuration, switched *Settings* > *Privacy* to make the site visible to search engines.

To make theme files editable, changed the file permission(s) to 644 and ownership to root:apache. Most problems with styling - images, CSS - was resolved by putting the entire 'wp-content' directory in to the 'apache' group.

    chmod 644 
    chown -R root:apache /usr/share/wordpress/wp-content/

Removed header using theme options for the Coraline theme: *Appearance* > *Header*

Installed the Jetpack add-on from Wordpress.com, using the 'ovirt' account on wordpress.com. Refer to the file '/root/passwords' for the password to this account.

Created a wordpress@ovirt.org alias.

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

Configured MySQL to start at boot:

    chkconfig mysqld on

Set MySQL root password:

    mysqladmin -u root password '(REFER TO /root/passwords)'
    mysqladmin -u root -h linode01.ovirt.org password '(REFER TO /root/passwords)'
    mysql_secure_installation

[Details of 'mysqladmin' output](#output_from_mysql_secure_installation).

database user: (REFER TO /root/passwords) password: (REFER TO /root/passwords)

Configured 'httpd' files:

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

    mysql> grant index, create, select, insert, update, delete, alter, lock tables on wikidb.* to 'wikiuser'@'localhost' identified by '(REFER TO /root/passwords)'
        -> 
        -> ;
    Query OK, 0 rows affected (0.00 sec)

    mysql> grant index, create, select, insert, update, delete, alter, lock tables on wikidb.* to 'wikiuser'@'localhost' identified by '(REFER TO /root/passwords)';
    Query OK, 0 rows affected (0.00 sec)

[Category:Infrastructure documentation](Category:Infrastructure documentation) <Category:MediaWiki> <Category:Wordpress>
