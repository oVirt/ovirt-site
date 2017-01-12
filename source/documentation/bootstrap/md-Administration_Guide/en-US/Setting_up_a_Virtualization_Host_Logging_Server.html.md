# Setting Up a Virtualization Host Logging Server

Hosts generate and update log files, recording their actions and problems. Collecting these log files centrally simplifies debugging.

This procedure should be used on your centralized log server. You could use a separate logging server, or use this procedure to enable host logging on the Red Hat Virtualization Manager.

**Setting up a Virtualization Host Logging Server**

1. Configure SELinux to allow `rsyslog` traffic.

        # semanage port -a -t syslogd_port_t -p udp 514

2. Edit `/etc/rsyslog.conf` and add the following lines:

        $template TmplAuth, "/var/log/%fromhost%/secure" 
        $template TmplMsg, "/var/log/%fromhost%/messages" 
        
        $RuleSet remote
        authpriv.*   ?TmplAuth
        *.info,mail.none;authpriv.none,cron.none   ?TmplMsg
        $RuleSet RSYSLOG_DefaultRuleset
        $InputUDPServerBindRuleset remote

    Uncomment the following:

        #$ModLoad imudp
        #$UDPServerRun 514

3. Restart the rsyslog service:

        # systemctl restart rsyslog.service

Your centralized log server is now configured to receive and store the `messages` and `secure` logs from your virtualization hosts.
