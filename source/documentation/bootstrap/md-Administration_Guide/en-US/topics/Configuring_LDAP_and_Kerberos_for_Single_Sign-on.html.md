# Configuring LDAP and Kerberos for Single Sign-on

Single sign-on allows users to log in to the User Portal or the Administration Portal without re-typing their passwords. Authentication credentials are obtained from the Kerberos server. To configure single sign-on to the Administration Portal and the User Portal, you need to configure two extensions: `ovirt-engine-extension-aaa-misc` and `ovirt-engine-extension-aaa-ldap`; and two Apache modules: `mod_auth_gssapi` and `mod_session`. You can configure single sign-on that does not involve Kerberos, however this is outside the scope of this documentation.

**Note:** If single sign-on to the User Portal is enabled, single sign-on to virtual machines will not be possible. With single sign-on to the User Portal enabled, the User Portal does not need to accept a password, thus the password cannot be delegated to sign in to virtual machines.

This example assumes the following:

* The existing Key Distribution Center (KDC) server uses the MIT version of Kerberos 5.

* You have administrative rights to the KDC server.

* The Kerberos client is installed on the Red Hat Virtualization Manager and user machines.

* The `kadmin` utility is used to create Kerberos service principals and `keytab` files.

This procedure involves the following components:

**On the KDC server**

* Create a service principal and a `keytab` file for the Apache service on the Red Hat Virtualization Manager.

**On the Red Hat Virtualization Manager**

* Install the authentication and authorization extension packages and the Apache Kerberos authentication module.

* Configure the extension files.

**Configuring Kerberos for the Apache Service**

1. On the KDC server, use the `kadmin` utility to create a service principal for the Apache service on the Red Hat Virtualization Manager. The service principal is a reference ID to the KDC for the Apache service.

        # kadmin
        kadmin> addprinc -randkey HTTP/fqdn-of-rhevm@REALM.COM

2. Generate a `keytab` file for the Apache service. The `keytab` file stores the shared secret key.

        kadmin> ktadd -k /tmp/http.keytab HTTP/fqdn-of-rhevm@REALM.COM
        kadmin> quit

3. Copy the `keytab` file from the KDC server to the Red Hat Virtualization Manager:

        # scp /tmp/http.keytab root@rhevm.example.com:/etc/httpd

**Configuring Single Sign-on to the User Portal or Administration Portal**

1. On the Red Hat Virtualization Manager, ensure that the ownership and permissions for the keytab are appropriate:

        # chown apache /etc/httpd/http.keytab
        # chmod 400 /etc/httpd/http.keytab

2. Install the authentication extension package, LDAP extension package, and the `mod_auth_gssapi` and  `mod_session` Apache modules:

        # yum install ovirt-engine-extension-aaa-misc ovirt-engine-extension-aaa-ldap mod_auth_gssapi mod_session

3. Copy the SSO configuration template file into the `/etc/ovirt-engine` directory. Template files are available for Active Directory (`ad-sso`) and other directory types (`simple-sso`). This example uses the simple SSO configuration template.

        # cp -r /usr/share/ovirt-engine-extension-aaa-ldap/examples/simple-sso/. /etc/ovirt-engine

4. Move `ovirt-sso.conf` into the Apache configuration directory:

        # mv /etc/ovirt-engine/aaa/ovirt-sso.conf /etc/httpd/conf.d

5. Review the authentication method file. You do not need to edit this file, as the realm is automatically fetched from the `keytab` file. 

        # vi /etc/httpd/conf.d/ovirt-sso.conf

    **Example authentication method file**

         <LocationMatch ^/ovirt-engine/sso/(interactive-login-negotiate|oauth/token-http-auth)|^/ovirt-engine/api>
          <If "req('Authorization') !~ /^(Bearer|Basic)/i">
            RewriteEngine on
            RewriteCond %{LA-U:REMOTE_USER} ^(.*)$
            RewriteRule ^(.*)$ - [L,NS,P,E=REMOTE_USER:%1]
            RequestHeader set X-Remote-User %{REMOTE_USER}s
        
            AuthType GSSAPI
            AuthName "Kerberos Login"
        
            # Modify to match installation
            GssapiCredStore keytab:/etc/httpd/http.keytab
            GssapiUseSessions On
            Session On
            SessionCookieName ovirt_gssapi_session path=/private;httponly;secure;
         
            Require valid-user
            ErrorDocument 401 "<html><meta http-equiv=\"refresh\" content=\"0; url=/ovirt-engine/sso/login-unauthorized\"/><body><a href=\"/ovirt-engine/sso/login-unauthorized\">Here</a></body></html>"
          </If>
        </LocationMatch>

6. Rename the configuration files to match the profile name you want visible to users on the Administration Portal and the User Portal login pages:

        # mv /etc/ovirt-engine/aaa/profile1.properties /etc/ovirt-engine/aaa/example.properties
        # mv /etc/ovirt-engine/extensions.d/profile1-http-authn.properties /etc/ovirt-engine/extensions.d/example-http-authn.properties
        # mv /etc/ovirt-engine/extensions.d/profile1-http-mapping.properties /etc/ovirt-engine/extensions.d/example-http-mapping.properties
        # mv /etc/ovirt-engine/extensions.d/profile1-authz.properties /etc/ovirt-engine/extensions.d/example-authz.properties

7. Edit the LDAP property configuration file by uncommenting an LDAP server type and updating the domain and passwords fields:

        #  vi /etc/ovirt-engine/aaa/example.properties

    **Example profile: LDAP server section**

        # Select one
        include = <openldap.properties>
        #include = <389ds.properties>
        #include = <rhds.properties>
        #include = <ipa.properties>
        #include = <iplanet.properties>
        #include = <rfc2307-389ds.properties>
        #include = <rfc2307-rhds.properties>
        #include = <rfc2307-openldap.properties>
        #include = <rfc2307-edir.properties>
        #include = <rfc2307-generic.properties>
        
        # Server
        #
        vars.server = ldap1.company.com
        
        # Search user and its password.
        #
        vars.user = uid=search,cn=users,cn=accounts,dc=company,dc=com
        vars.password = 123456
        
        pool.default.serverset.single.server = ${global:vars.server}
        pool.default.auth.simple.bindDN = ${global:vars.user}
        pool.default.auth.simple.password = ${global:vars.password}

    To use TLS or SSL protocol to interact with the LDAP server, obtain the root CA certificate for the LDAP server and use it to create a public keystore file. Uncomment the following lines and specify the full path to the public keystore file and the password to access the file.

    **Note:** For more information on creating a public keystore file, see [Setting Up SSL or TLS Connections between the Manager and an LDAP Server](Setting_Up_SSL_or_TLS_Connections_between_the_Manager_and_an_LDAP_Server).

    **Example profile: keystore section**

        # Create keystore, import certificate chain and uncomment
        # if using ssl/tls.
        pool.default.ssl.startTLS = true
        pool.default.ssl.truststore.file = /full/path/to/myrootca.jks
        pool.default.ssl.truststore.password = password

8. Review the authentication configuration file. The profile name visible to users on the Administration Portal and the User Portal login pages is defined by `ovirt.engine.aaa.authn.profile.name`. The configuration profile location must match the LDAP configuration file location. All fields can be left as default.

        # vi /etc/ovirt-engine/extensions.d/example-http-authn.properties

    **Example authentication configuration file**

        ovirt.engine.extension.name = example-http-authn
        ovirt.engine.extension.bindings.method = jbossmodule
        ovirt.engine.extension.binding.jbossmodule.module = org.ovirt.engine-extensions.aaa.misc
        ovirt.engine.extension.binding.jbossmodule.class = org.ovirt.engineextensions.aaa.misc.http.AuthnExtension
        ovirt.engine.extension.provides = org.ovirt.engine.api.extensions.aaa.Authn
        ovirt.engine.aaa.authn.profile.name = example-http
        ovirt.engine.aaa.authn.authz.plugin = example-authz
        ovirt.engine.aaa.authn.mapping.plugin = example-http-mapping
        config.artifact.name = HEADER
        config.artifact.arg = X-Remote-User

9. Review the authorization configuration file. The configuration profile location must match the LDAP configuration file location. All fields can be left as default.

        #  vi /etc/ovirt-engine/extensions.d/example-authz.properties

    **Example authorization configuration file**

        ovirt.engine.extension.name = example-authz
        ovirt.engine.extension.bindings.method = jbossmodule
        ovirt.engine.extension.binding.jbossmodule.module = org.ovirt.engine-extensions.aaa.ldap
        ovirt.engine.extension.binding.jbossmodule.class = org.ovirt.engineextensions.aaa.ldap.AuthzExtension
        ovirt.engine.extension.provides = org.ovirt.engine.api.extensions.aaa.Authz
        config.profile.file.1 = ../aaa/example.properties

10. Review the authentication mapping configuration file. The configuration profile location must match the LDAP configuration file location. The configuration profile extension name must match the `ovirt.engine.aaa.authn.mapping.plugin` value in the authentication configuration file. All fields can be left as default.

        # vi /etc/ovirt-engine/extensions.d/example-http-mapping.properties

    **Example authentication mapping configuration file**

        ovirt.engine.extension.name = example-http-mapping
        ovirt.engine.extension.bindings.method = jbossmodule
        ovirt.engine.extension.binding.jbossmodule.module = org.ovirt.engine-extensions.aaa.misc
        ovirt.engine.extension.binding.jbossmodule.class = org.ovirt.engineextensions.aaa.misc.mapping.MappingExtension
        ovirt.engine.extension.provides = org.ovirt.engine.api.extensions.aaa.Mapping
        config.mapAuthRecord.type = regex
        config.mapAuthRecord.regex.mustMatch = true
        config.mapAuthRecord.regex.pattern = ^(?<user>.*?)((\\\\(?<at>@)(?<suffix>.*?)@.*)|(?<realm>@.*))$
        config.mapAuthRecord.regex.replacement = ${user}${at}${suffix}

11. Ensure that the ownership and permissions of the configuration files are appropriate:

        # chown ovirt:ovirt /etc/ovirt-engine/aaa/example.properties
        # chown ovirt:ovirt /etc/ovirt-engine/extensions.d/example-http-authn.properties
        # chown ovirt:ovirt /etc/ovirt-engine/extensions.d/example-http-mapping.properties
        # chown ovirt:ovirt /etc/ovirt-engine/extensions.d/example-authz.properties
        # chmod 600 /etc/ovirt-engine/aaa/example.properties
        # chmod 640 /etc/ovirt-engine/extensions.d/example-http-authn.properties
        # chmod 640 /etc/ovirt-engine/extensions.d/example-http-mapping.properties
        # chmod 640 /etc/ovirt-engine/extensions.d/example-authz.properties

11. Restart the Apache service and the `ovirt-engine` service:

        # systemctl restart httpd.service
        # systemctl restart ovirt-engine.service
