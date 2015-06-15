---
title: OvirtEnginePort80
category: feature
authors: ekohl, imansano, mlipchuk
wiki_category: Feature
wiki_title: Features/OvirtEnginePort80
wiki_revision_count: 3
wiki_last_updated: 2014-06-16
feature_name: OvirtEnginePort80
feature_modules: packaging
feature_status: Released
---

# Ovirt Engine Port 80

## Running JBoss on ports 80/443 using apache_mod_ssl Module

This wiki describes how to enable oVirt to run on ports 80/443 instead of 8080/8443 using apache_mod_ssl module. This procedure is related to a server which runs ovirt-engine with JBoss 7.

### Steps To Do

**1.** Install httpd apache server and mod_ssl

      yum install httpd mod_ssl

**2.** Configure SELinux Boolean

      setsebool -P httpd_can_network_connect 1

**3.** You have to change the "standalone.xml" file (inside the "standalone/configuration" directory) and add 2 things:

      * The connector (it is disabled by default) 
      * The port binding:

Add the lines which shown below with "+" to the standalone.xml file:

               </subsystem>
               <subsystem xmlns="urn:jboss:domain:web:1.1"
      default-virtual-server="default-host">
                   <connector name="http" protocol="HTTP/1.1" scheme="http"
      socket-binding="http"/>
      +            <connector name="ajp" protocol="AJP/1.3" scheme="http"
      socket-binding="ajp"/>
                   <virtual-server name="default-host" enable-welcome-root="true">
                       <alias name="localhost"/>
                       <alias name="example.com"/> @@ -311,6 +312,7 @@
           <socket-binding-group name="standard-sockets"
      default-interface="public"
      port-offset="${jboss.socket.binding.port-offset:0}">
               <socket-binding name="http" port="8080"/>
               <socket-binding name="https" port="8443"/>
      +        <socket-binding name="ajp" port="8009"/>
               <socket-binding name="jacorb" port="3528"/>
               <socket-binding name="jacorb-ssl" port="3529"/>
               <socket-binding name="jmx-connector-registry"
      interface="management" port="1090"/>

**4.** Configure mod_ssl module to forward requests to JBoss. For this you need to create a new file under the "/etc/httpd/conf.d" directory: for example ***ovirt-engine.conf***

      touch ovirt-engine.conf

In that file you need the following directives in order to forward requests to JBoss:

      vim ovirt-engine.conf

      # Redirect oVirt specific URLs to the application server 
      # using the AJP protocol:
      ProxyPass / ajp://localhost:8009/

That will redirect all requests to the application server. You could be more specific and forward the requests to specific components:

      # Redirect oVirt specific URLs to the application server 
      # using the AJP protocol:
      ProxyPassMatch
      ^/(Components|webadmin|UserPortal|api)(/.*)?$
      ajp://localhost:8009/$1$2

**5.** Modify the "/etc/ovirt-engine/web-conf.js" file to use ports 80 and 443 instead of 8080 and 8443 Change any line which included "8080" to "80" and "8443" to "443"

**6.** Edit /etc/httpd/conf.d/ssl.conf Change the following lines to these values:

      SSLCertificateFile /etc/pki/ovirt-engine/certs/engine.cer
      SSLCertificateKeyFile /etc/pki/ovirt-engine/keys/engine_id_rsa.key 
      SSLCertificateChainFile /etc/pki/ovirt-eninge/ca.pem

**7.** Open ports 80 and 443 in the firewall Edit the "/etc/sysconfig/iptables" file

      vim /etc/sysconfig/iptables

Add the following lines under the RH-Firewall rules in /etc/sysconfig/iptables:

      -A RH-Firewall-1-INPUT -m state --state NEW -p tcp --dport 80 -j ACCEPT
      -A RH-Firewall-1-INPUT -m state --state NEW -p tcp --dport 443 -j ACCEPT

**8.** Restart iptables service

      service iptables restart

**9.** Start the httpd service

      service httpd start

**10.** Check that it works Surf ovirt-engine webadmin on port 80 and on port 443

      http://ovirt-enigne-fqdn/webadmin/
      https://ovirt-engine-fqdn/webadmin/

<Category:Feature>
