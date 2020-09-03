---
title: Lists.ovirt.org-Configuration
category: infra
authors: quaid
---

# Lists.ovirt.org-Configuration

## Configuration for lists.ovirt.org

These configuration details are derived from notes taken during the installation and configuration of lists.ovirt.org.

### Overall configuration details

Trimmed all unneeded packages from system to get base install, or use a base image that is already minimal.

Configured firewall to allow ports 22, 25, 80, and 443:

    cat /tmp/firewall.sh
    #!/bin/bash
    iptables -F
    iptables -X
    iptables -I INPUT -p icmp -j ACCEPT
    iptables -A INPUT -d 127.0.0.1 -j ACCEPT
    iptables -A INPUT -p tcp --dport 22 -j ACCEPT
    iptables -A INPUT -p tcp --dport 25 -j ACCEPT
    iptables -A INPUT -p tcp --dport 80 -j ACCEPT
    iptables -A INPUT -p tcp --dport 443 -j ACCEPT
    iptables -A INPUT -m state --state new -j REJECT 
    service iptables save

Set IP address to static in: '/etc/sysconfig/network-scripts/ifcfg-eth0'

Installed mailman and postfix:

    yum install mailman postfix

Configured Postfix to listen to the external interface and for all the domains you want. These are the parameters set differently from default for ovirt.org:

    myhostname = lists.ovirt.org
    inet_interfaces = $myhostname, localhost, 173.255.252.138
    mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain, linode01.ovirt.org
    relay_domains = $mydestination, linode01.ovirt.org, lists.ovirt.org

### Mailman configuration

In '/etc/httpd/conf.d/mailman.conf' set '/mailman' to redirect to listinfo page:

    # Uncomment the following line, to redirect queries to /mailman to the
    # listinfo page (recommended).

    RedirectMatch ^/mailman[/]*$ /mailman/listinfo

NOTE: Normally a Mailman-only host would have '/' redirected. This may be disabled because lists.ovirt.org is serving www.ovirt.org at '/'.

    # RedirectMatch ^/[/]*$ /mailman/listinfo

Edited '/etc/mailman/mm_cfg.py' and configured:

    DEFAULT_URL_HOST   = "lists.ovirt.org"
    DEFAULT_EMAIL_HOST = "ovirt.org"

Restarted Apache.

Added new virtual host to '/etc/httpd/conf.d/lists.ovirt.org.conf':

    <VirtualHost *:80>
        ServerAdmin webmaster@lists.ovirt.org
        DocumentRoot /var/www/html/
        ServerName lists.ovirt.org
        ErrorLog logs/lists.ovirt.org-error_log
        CustomLog logs/lists.ovirt.org-access_log common
    </VirtualHost>

Ran 'chkconfig {httpd,postfix,mailman,iptables} on'.

Ran '/usr/lib/mailman/bin/mmsitepass' to set mailman password.

Ran '/usr/lib/mailman/bin/newlist' to create a new list. Add the password to the file '/root/passwords'.

Don't forget to add sections to '/etc/aliases' for each mailing list, then run 'newaliases'.

    To finish creating your mailing list, you must edit your /etc/aliases (or
    equivalent) file by adding the following lines, and possibly running the
    `newaliases' program:

    ## mailman mailing list
    mailman:              "|/usr/lib/mailman/mail/mailman post mailman"
    mailman-admin:        "|/usr/lib/mailman/mail/mailman admin mailman"
    mailman-bounces:      "|/usr/lib/mailman/mail/mailman bounces mailman"
    mailman-confirm:      "|/usr/lib/mailman/mail/mailman confirm mailman"
    mailman-join:         "|/usr/lib/mailman/mail/mailman join mailman"
    mailman-leave:        "|/usr/lib/mailman/mail/mailman leave mailman"
    mailman-owner:        "|/usr/lib/mailman/mail/mailman owner mailman"
    mailman-request:      "|/usr/lib/mailman/mail/mailman request mailman"
    mailman-subscribe:    "|/usr/lib/mailman/mail/mailman subscribe mailman"
    mailman-unsubscribe:  "|/usr/lib/mailman/mail/mailman unsubscribe mailman"

### Resources used

<http://www.iredmail.org/forum/topic1582-howto-configure-mailman-on-centosrhel-5.html>


/usr/share/doc/mailman/INSTALL.REDHAT

[Category:Infrastructure documentation](/develop/infra/infrastructure-documentation.html)
