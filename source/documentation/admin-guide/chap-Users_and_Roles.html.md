---
title: Users and Roles
---

# Chapter 15: Users and Roles

## Introduction to Users

In oVirt, there are two types of user domains: local domain and external domain. A default local domain called the **internal** domain and a default user **admin** is created during the the Engine installation process.

You can create additional users on the **internal** domain using `ovirt-aaa-jdbc-tool`. User accounts created on local domains are known as local users. You can also attach external directory servers such as Red Hat Directory Server, Active Directory, OpenLDAP, and many other supported options to your oVirt environment and use them as external domains. User accounts created on external domains are known as directory users.

Both local users and directory users need to be assigned with appropriate roles and permissions through the Administration Portal before they can function in the environment. There are two main types of user roles: end user and administrator. An end user role uses and manages virtual resources from the VM Portal. An administrator role maintains the system infrastructure using the Administration Portal. The roles can be assigned to the users for individual resources like virtual machines and hosts, or on a hierarchy of objects like clusters and data centers.

## Introduction to Directory Servers

During installation, oVirt Engine creates an **admin** user on the **internal** domain. The user is also referred to as `admin@internal`. This account is intended for use when initially configuring the environment and for troubleshooting. After you have attached an external directory server, added the directory users, and assigned them with appropriate roles and permissions, the `admin@internal` user can be disabled if it is not required.

The directory servers supported are:

* 389ds

* 389ds RFC-2307 Schema

* Active Directory

* IBM Security Directory Server

* IBM Security Directory Server RFC-2307 Schema

* FreeIPA

* iDM

* Novell eDirectory RFC-2307 Schema

* OpenLDAP RFC-2307 Schema

* OpenLDAP Standard Schema

* Oracle Unified Directory RFC-2307 Schema

* RFC-2307 Schema (Generic)

* Red Hat Directory Server (RHDS)

* Red Hat Directory Server (RHDS) RFC-2307 Schema

* iPlanet

    **Important:** It is not possible to install oVirt Engine (`rhevm`) and IdM (`ipa-server`) on the same system. IdM is incompatible with the `mod_ssl` package, which is required by oVirt Engine.

    **Important:** If you are using Active Directory as your directory server, and you want to use `sysprep` in the creation of templates and virtual machines, then the oVirt administrative user must be delegated control over the Domain to:

    * **Join a computer to the domain**

    * **Modify the membership of a group**

    For information on creation of user accounts in Active Directory, see [http://technet.microsoft.com/en-us/library/cc732336.aspx](http://technet.microsoft.com/en-us/library/cc732336.aspx).

    For information on delegation of control in Active Directory, see [http://technet.microsoft.com/en-us/library/cc732524.aspx](http://technet.microsoft.com/en-us/library/cc732524.aspx).

## Configuring an External LDAP Provider

### Configuring an External LDAP Provider (Interactive Setup)

The `ovirt-engine-extension-aaa-ldap` extension allows users to customize their external directory setup easily. The `ovirt-engine-extension-aaa-ldap` extension supports many different LDAP server types, and an interactive setup script is provided to assist you with the setup for most LDAP types.

If the LDAP server type is not listed in the interactive setup script, or you want to do more customization, you can manually edit the configuration files. See [Configuring an External LDAP Provider ManualMethod](Configuring_an_External_LDAP_Provider_ManualMethod) for more information.

For an Active Directory example, see [Attaching an Active Directory](Attaching_an_Active_Directory).

**Prerequisites:**

* You need to know the domain name of the DNS or the LDAP server. Round-robin and failover policies are also supported.

* To set up secure connection between the LDAP server and the Engine, ensure a PEM-encoded CA certificate has been prepared. See [Setting Up SSL or TLS Connections between the Manager and an LDAP Server](Setting_Up_SSL_or_TLS_Connections_between_the_Manager_and_an_LDAP_Server) for more information.

* Have at least one set of account name and password ready to perform search and login queries to the LDAP server.

**Configuring an External LDAP Provider**

1. On the oVirt Engine, install the LDAP extension package:

        # yum install ovirt-engine-extension-aaa-ldap-setup

2. Run `ovirt-engine-extension-aaa-ldap-setup` to start the interactive setup:

        # ovirt-engine-extension-aaa-ldap-setup

3. Select an LDAP type by entering the corresponding number. If you are not sure which schema your LDAP server is, select the standard schema of your LDAP server type. For Active Directory, follow the procedure at [Attaching an Active Directory](Attaching_an_Active_Directory).

        Available LDAP implementations:
         1 - 389ds
         2 - 389ds RFC-2307 Schema
         3 - Active Directory
         4 - IBM Security Directory Server
         5 - IBM Security Directory Server RFC-2307 Schema
         6 - IPA
         7 - Novell eDirectory RFC-2307 Schema
         8 - OpenLDAP RFC-2307 Schema
         9 - OpenLDAP Standard Schema
        10 - Oracle Unified Directory RFC-2307 Schema
        11 - RFC-2307 Schema (Generic)
        12 - RHDS
        13 - RHDS RFC-2307 Schema
        14 - iPlanet
        Please select:

4. Press **Enter** to accept the default and configure domain name resolution for your LDAP server name:

        It is highly recommended to use DNS resolution for LDAP server.
        If for some reason you intend to use hosts or plain address disable DNS usage.
        Use DNS (Yes, No) [Yes]:

5. Select a DNS policy method by entering the corresponding number:

    * For option 1, the DNS servers listed in **/etc/resolv.conf** is used to resolve the IP address. Ensure the **/etc/resolv.conf** file is updated with the correct DNS servers.

    * For option 2, enter the fully qualified domain name (FQDN) or the IP address of the LDAP server. You can use the dig command with the SRV record to find out the domain name. An SRV record takes the following format:

      <i>_service._ protocol.domain_name</i>

      Example: `dig _ldap._tcp.redhat.com SRV`.

    * For option 3, enter a space-separated list of LDAP servers. Use either the FQDN or IP address of the servers. This policy provides load-balancing between the LDAP servers. Queries are distributed among all LDAP servers according to the round-robin algorithm.

    * For option 4, enter a space-separated list of LDAP servers. Use either the FQDN or IP address of the servers. This policy defines the first LDAP server to be the default LDAP server to respond to queries. If the first server is not available, the query will go to the next LDAP server on the list.

          1 - Single server
          2 - DNS domain LDAP SRV record
          3 - Round-robin between multiple hosts
          4 - Failover between multiple hosts
          Please select:

6. Select the secure connection method your LDAP server supports and specify the method to obtain a PEM-encoded CA certificate.

    * `File` allows you to provide the full path to the certificate.

    * `URL` allows you to specify a URL for the certificate.

    * `Inline` allows you to paste the content of the certificate in the terminal.

    * `System` allows you to specify the default location for all CA files.

    * `Insecure` skips certificate validation, but the connection is still encrypted using TLS.

          NOTE:
          It is highly recommended to use secure protocol to access the LDAP server.
          Protocol startTLS is the standard recommended method to do so.
          Only in cases in which the startTLS is not supported, fallback to non standard ldaps protocol.
          Use plain for test environments only.
          Please select protocol to use (startTLS, ldaps, plain) [startTLS]: startTLS
          Please select method to obtain PEM encoded CA certificate (File, URL, Inline, System, Insecure): File
          Please enter the password:

        **Note:** LDAPS stands for Lightweight Directory Access Protocol Over Secure Socket Links. For SSL connections, select the `ldaps` option.

7. Enter the search user distinguished name (DN). The user must have permissions to browse all users and groups on the directory server. The search user must be specified in LDAP annotation. If anonymous search is allowed, press **Enter** without any input.

    Enter search user DN (for example uid=username,dc=example,dc=com or leave empty for anonymous): uid=user1,ou=Users,ou=department-1,dc=example,dc=com
    Enter search user password:

8. Enter the base DN:

    Please enter base DN (dc=redhat,dc=com) [dc=redhat,dc=com]: ou=department-1,dc=redhat,dc=com

9. Select `Yes` if you intend to configure single sign-on for virtual machines. Note that the feature cannot be used with single sign-on to the Administration Portal feature. The script reminds you that the profile name must match the domain name.

    Are you going to use Single Sign-On for Virtual Machines (Yes, No) [Yes]:

10. Specify a profile name. The profile name is visible to users on the login page. This example uses `redhat.com`.

    **Note:** To rename the profile after the domain has been configured, edit the `ovirt.engine.aaa.authn.profile.name` attribute in the `/etc/ovirt-engine/extensions.d/redhat.com-authn.properties` file. Restart the engine service for the changes to take effect.

        Please specify profile name that will be visible to users:redhat.com

    **The Administration Portal Login Page**

    ![](/images/admin-guide/AAA_login_profile.png)

    **Note:** Users must select the desired profile from the drop-down list when logging in for the first time. The information is then stored in browser cookies and preselected the next time the user logs in.

11. Test the search and login function to ensure the your LDAP server is connected to your oVirt environment properly. For the login query, enter your `username` and `password`.

    NOTE:
    It is highly recommended to test drive the configuration before applying it into engine.
    Login sequence is executed automatically, but it is recommended to also execute Search sequence manually after successful Login sequence.

    Please provide credentials to test login flow:
    Enter user name:
    Enter user password:
    [ INFO  ] Executing login sequence...
    ...
    [ INFO  ] Login sequence executed successfully

12. Check that the user details are correct. If the user details are incorrect, select `Abort`:

    Please make sure that user details are correct and group membership meets expectations (search for PrincipalRecord and GroupRecord titles).
    Abort if output is incorrect.
    Select test sequence to execute (Done, Abort, Login, Search) [Abort]:

13. Manually testing the Search function is recommended. For the search query, select `Principal` for user accounts or `Group` for group accounts. Select `Yes` to `Resolve Groups` if you want the group account information for the user account to be returned. Three configuration files are created and displayed in the screen output.

    Select test sequence to execute (Done, Abort, Login, Search) [Search]: Search
    Select entity to search (Principal, Group) [Principal]:
    Term to search, trailing '\*' is allowed: testuser1
    Resolve Groups (Yes, No) [No]:

14. Select `Done` to complete the setup:

    Select test sequence to execute (Done, Abort, Login, Search) [Abort]: Done
    [ INFO  ] Stage: Transaction setup
    [ INFO  ] Stage: Misc configuration
    [ INFO  ] Stage: Package installation
    [ INFO  ] Stage: Misc configuration
    [ INFO  ] Stage: Transaction commit
    [ INFO  ] Stage: Closing up
    CONFIGURATION SUMMARY
    Profile name is: redhat.com
    The following files were created:
        /etc/ovirt-engine/aaa/redhat.com.properties
        /etc/ovirt-engine/extensions.d/redhat.com.properties
        /etc/ovirt-engine/extensions.d/redhat.com-authn.properties
    [ INFO  ] Stage: Clean up
    Log file is available at /tmp/ovirt-engine-extension-aaa-ldap-setup-20171004101225-mmneib.log:
    [ INFO  ] Stage: Pre-termination
    [ INFO  ] Stage: Termination

15. Restart the engine service. The profile you have created is now available on the Administration Portal and the VM Portal login pages. To assign the user accounts on the LDAP server appropriate roles and permissions, for example to log in to the VM Portal, see [Red Hat Enterprise Virtualization Manager User Tasks](sect-Red_Hat_Enterprise_Virtualization_Manager_User_Tasks).

    # systemctl restart ovirt-engine.service

**Note:** For more information, see the LDAP authentication and authorization extension README file at **/usr/share/doc/ovirt-engine-extension-aaa-ldap-version**.

### Attaching an Active Directory

**Prerequisites:**

* You need to know the Active Directory forest name. The forest name is also known as the root domain name.

    **Note:** Examples of the most common Active Directory configurations, which cannot be configured using the ovirt-engine-extension-aaa-ldap-setup tool, are provided in /usr/share/ovirt-engine-extension-aaa-ldap/examples/README.md.

* You need to either add the DNS server that can resolve the Active Directory forest name to the **/etc/resolv.conf** file on the Engine, or note down the Active Directory DNS servers and enter them when prompted by the interactive setup script.

* To set up secure connection between the LDAP server and the Engine, ensure a PEM-encoded CA certificate has been prepared. See [Setting Up SSL or TLS Connections between the Manager and an LDAP Server](Setting_Up_SSL_or_TLS_Connections_between_the_Manager_and_an_LDAP_Server) for more information.

* Unless anonymous search is supported, a user with permissions to browse all users and groups must be available on the Active Directory to be used as the search user. Note down the search user's distinguished name (DN). Do not use the administrative user for the Active Directory.

* You must have at least one set of account name and password ready to perform search and login queries to the Active Directory.

* If your Active Directory deployment spans multiple domains, be aware of the limitation described in the `/usr/share/ovirt-engine-extension-aaa-ldap/profiles/ad.properties` file.

**Configuring an External LDAP Provider**

1. On the oVirt Engine, install the LDAP extension package:

        # yum install ovirt-engine-extension-aaa-ldap-setup

2. Run `ovirt-engine-extension-aaa-ldap-setup` to start the interactive setup:

        # ovirt-engine-extension-aaa-ldap-setup

3. Select an LDAP type by entering the corresponding number. The LDAP related questions after this step is different for different LDAP types.

        Available LDAP implementations:
         1 - 389ds
         2 - 389ds RFC-2307 Schema
         3 - Active Directory
         4 - IBM Security Directory Server
         5 - IBM Security Directory Server RFC-2307 Schema
         6 - IPA
         7 - Novell eDirectory RFC-2307 Schema
         8 - OpenLDAP RFC-2307 Schema
         9 - OpenLDAP Standard Schema
        10 - Oracle Unified Directory RFC-2307 Schema
        11 - RFC-2307 Schema (Generic)
        12 - RHDS
        13 - RHDS RFC-2307 Schema
        14 - iPlanet
        Please select: 3

4. Enter the Active Directory forest name. If the forest name is not resolvable by your Engine's DNS, the script prompts you to enter a space-separated list of Active Directory DNS server names.

        Please enter Active Directory Forest name: ad-example.redhat.com
        [ INFO  ] Resolving Global Catalog SRV record for ad-example.redhat.com
        [ INFO  ] Resolving LDAP SRV record for ad-example.redhat.com

5. Select the secure connection method your LDAP server supports and specify the method to obtain a PEM-encoded CA certificate. The file option allows you to provide the full path to the certificate. The URL option allows you to specify a URL to the certificate. Use the inline option to paste the content of the certificate in the terminal. The system option allows you to specify the location for all CA files. The insecure option allows you to use startTLS in insecure mode.

        NOTE:
        It is highly recommended to use secure protocol to access the LDAP server.
        Protocol startTLS is the standard recommended method to do so.
        Only in cases in which the startTLS is not supported, fallback to non standard ldaps protocol.
        Use plain for test environments only.
        Please select protocol to use (startTLS, ldaps, plain) [startTLS]: startTLS
        Please select method to obtain PEM encoded CA certificate (File, URL, Inline, System, Insecure): File
        Please enter the password:

    **Note:** LDAPS stands for Lightweight Directory Access Protocol Over Secure Socket Links. For SSL connections, select the `ldaps` option.

    For more information on creating a PEM-encoded CA certificate, see [Setting Up SSL or TLS Connections between the Manager and an LDAP Server](Setting_Up_SSL_or_TLS_Connections_between_the_Manager_and_an_LDAP_Server).

6. Enter the search user distinguished name (DN). The user must have permissions to browse all users and groups on the directory server. The search user must be of LDAP annotation. If anonymous search is allowed, press **Enter** without any input.

        Enter search user DN (empty for anonymous): uid=user1,ou=Users,dc=test,dc=redhat,dc=com
        Enter search user password:

7. Specify whether to use single sign-on for virtual machines. This feature is enabled by default, but cannot be used if single sign-on to the Administration Portal is enabled. The script reminds you that the profile name must match the domain name.

        Are you going to use Single Sign-On for Virtual Machines (Yes, No) [Yes]:

8. Specify a profile name. The profile name is visible to users on the login page. This example uses `redhat.com`.

        Please specify profile name that will be visible to users:redhat.com

    **The Administration Portal Login Page**

    ![](/images/admin-guide/AAA_login_profile.png)

    **Note:** Users need to select the desired profile from the drop-down list when logging in for the first time. The information is then stored in browser cookies and preselected the next time the user logs in.

9. Test the search and login function to ensure your LDAP server is connected to your oVirt environment properly. For the login query, enter the account name and password. For the search query, select `Principal` for user accounts, and select `Group` for group accounts. Enter `Yes` to `Resolve Groups` if you want the group account information for the user account to be returned. Select `Done` to complete the setup. Three configuration files are created and displayed in the screen output.

        NOTE:
        It is highly recommended to test drive the configuration before applying it into engine.
        Perform at least one Login sequence and one Search sequence.
        Select test sequence to execute (Done, Abort, Login, Search) [Abort]: Login
        Enter search user name: testuser1
        Enter search user password:
        [ INFO  ] Executing login sequence...
        ...
        Select test sequence to execute (Done, Abort, Login, Search) [Abort]: Search
        Select entity to search (Principal, Group) [Principal]:
        Term to search, trailing '\*' is allowed: testuser1
        Resolve Groups (Yes, No) [No]:
        [ INFO  ] Executing login sequence...
        ...
        Select test sequence to execute (Done, Abort, Login, Search) [Abort]: Done
        [ INFO  ] Stage: Transaction setup
        [ INFO  ] Stage: Misc configuration
        [ INFO  ] Stage: Package installation
        [ INFO  ] Stage: Misc configuration
        [ INFO  ] Stage: Transaction commit
        [ INFO  ] Stage: Closing up
                  CONFIGURATION SUMMARY
                  Profile name is: redhat.com
                  The following files were created:
                      /etc/ovirt-engine/aaa/redhat.com.properties
                      /etc/ovirt-engine/extensions.d/redhat.com-authz.properties
                      /etc/ovirt-engine/extensions.d/redhat.com-authn.properties
        [ INFO  ] Stage: Clean up
                  Log file is available at /tmp/ovirt-engine-extension-aaa-ldap-setup-20160114064955-1yar9i.log:
        [ INFO  ] Stage: Pre-termination
        [ INFO  ] Stage: Termination

10. The profile you have created is now available on the Administration Portal and the VM Portal login pages.

    **Note:** For more information, see the LDAP authentication and authorization extension README file at `/usr/share/doc/ovirt-engine-extension-aaa-ldap-version`.

### Configuring an External LDAP Provider (Manual Method)

The `ovirt-engine-extension-aaa-ldap` extension uses the LDAP protocol to access directory servers and is fully customizable. Kerberos authentication is not required unless you want to enable the single sign-on to the VM Portal or the Administration Portal feature.

If the interactive setup method in the previous section does not cover your use case, you can manually modify the configuration files to attach your LDAP server. The following procedure uses generic details. Specific values depend on your setup.

**Configuring an External LDAP Provider Manually**

1. On the oVirt Engine, install the LDAP extension package:

        # yum install ovirt-engine-extension-aaa-ldap

2. Copy the LDAP configuration template file into the `/etc/ovirt-engine` directory. Template files are available for active directories (`ad`) and other directory types (`simple`). This example uses the simple configuration template.

        # cp -r /usr/share/ovirt-engine-extension-aaa-ldap/examples/simple/. /etc/ovirt-engine

3. Rename the configuration files to match the profile name you want visible to users on the Administration Portal and the VM Portal login pages:

        # mv /etc/ovirt-engine/aaa/profile1.properties /etc/ovirt-engine/aaa/example.properties
        # mv /etc/ovirt-engine/extensions.d/profile1-authn.properties /etc/ovirt-engine/extensions.d/example-authn.properties
        # mv /etc/ovirt-engine/extensions.d/profile1-authz.properties /etc/ovirt-engine/extensions.d/example-authz.properties

4. Edit the LDAP property configuration file by uncommenting an LDAP server type and updating the domain and passwords fields:

        #  vi /etc/ovirt-engine/aaa/example.properties

    **Example profile: LDAP server section**

        # Select one
        #
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

      **Note:**  For more information on creating a public keystore file, see [Setting Up SSL or TLS Connections between the Manager and an LDAP Server](Setting_Up_SSL_or_TLS_Connections_between_the_Manager_and_an_LDAP_Server).

    **Example profile: keystore section**

        # Create keystore, import certificate chain and uncomment
        # if using tls.
        pool.default.ssl.startTLS = true
        pool.default.ssl.truststore.file = /full/path/to/myrootca.jks
        pool.default.ssl.truststore.password = password

5. Review the authentication configuration file. The profile name visible to users on the Administration Portal and the VM Portal login pages is defined by `ovirt.engine.aaa.authn.profile.name`. The configuration profile location must match the LDAP configuration file location. All fields can be left as default.

        # vi /etc/ovirt-engine/extensions.d/example-authn.properties

    **Example authentication configuration file**

        ovirt.engine.extension.name = example-authn
        ovirt.engine.extension.bindings.method = jbossmodule
        ovirt.engine.extension.binding.jbossmodule.module = org.ovirt.engine-extensions.aaa.ldap
        ovirt.engine.extension.binding.jbossmodule.class = org.ovirt.engineextensions.aaa.ldap.AuthnExtension
        ovirt.engine.extension.provides = org.ovirt.engine.api.extensions.aaa.Authn
        ovirt.engine.aaa.authn.profile.name = example
        ovirt.engine.aaa.authn.authz.plugin = example-authz
        config.profile.file.1 = ../aaa/example.properties

6. Review the authorization configuration file. The configuration profile location must match the LDAP configuration file location. All fields can be left as default.

        # vi /etc/ovirt-engine/extensions.d/example-authz.properties

    **Example authorization configuration file**

        ovirt.engine.extension.name = example-authz
        ovirt.engine.extension.bindings.method = jbossmodule
        ovirt.engine.extension.binding.jbossmodule.module = org.ovirt.engine-extensions.aaa.ldap
        ovirt.engine.extension.binding.jbossmodule.class = org.ovirt.engineextensions.aaa.ldap.AuthzExtension
        ovirt.engine.extension.provides = org.ovirt.engine.api.extensions.aaa.Authz
        config.profile.file.1 = ../aaa/example.properties

7. Ensure that the ownership and permissions of the configuration profile are appropriate:

        # chown ovirt:ovirt /etc/ovirt-engine/aaa/example.properties
        # chmod 600 /etc/ovirt-engine/aaa/example.properties

8. Restart the engine service:

        # systemctl restart ovirt-engine.service

9. The `example` profile you have created is now available on the Administration Portal and the VM Portal login pages. To give the user accounts on the LDAP server appropriate permissions, for example to log in to the VM Portal, see [Red Hat Enterprise Virtualization Manager User Tasks](sect-Red_Hat_Enterprise_Virtualization_Manager_User_Tasks).

    **Note:** For more information, see the LDAP authentication and authorization extension README file at `/usr/share/doc/ovirt-engine-extension-aaa-ldap-version`.

### Removing an External LDAP Provider

This procedure shows you how to remove an external configured LDAP provider and its users.

**Removing an External LDAP Provider**

1. Remove the LDAP provider configuration files, replacing the default name *profile1*:

        # rm /etc/ovirt-engine/extensions.d/profile1-authn.properties
        # rm /etc/ovirt-engine/extensions.d/profile1-authz.properties
        # rm /etc/ovirt-engine/aaa/profile1.properties

2. Restart the `ovirt-engine` service:

        # systemctl restart ovirt-engine

3. In the Administration Portal, in the **Users** resource tab, select the users of this provider (those whose `Authorization provider` is `profile1-authz`) and click **Remove**.

## Configuring LDAP and Kerberos for Single Sign-on

Single sign-on allows users to log in to the VM Portal or the Administration Portal without re-typing their passwords. Authentication credentials are obtained from the Kerberos server. To configure single sign-on to the Administration Portal and the VM Portal, you need to configure two extensions: `ovirt-engine-extension-aaa-misc` and `ovirt-engine-extension-aaa-ldap`; and two Apache modules: `mod_auth_gssapi` and `mod_session`. You can configure single sign-on that does not involve Kerberos, however this is outside the scope of this documentation.

    **Note:** If single sign-on to the VM Portal is enabled, single sign-on to virtual machines will not be possible. With single sign-on to the VM Portal enabled, the VM Portal does not need to accept a password, thus the password cannot be delegated to sign in to virtual machines.

This example assumes the following:

* The existing Key Distribution Center (KDC) server uses the MIT version of Kerberos 5.

* You have administrative rights to the KDC server.

* The Kerberos client is installed on the oVirt Engine and user machines.

* The `kadmin` utility is used to create Kerberos service principals and **keytab** files.

This procedure involves the following components:

**On the KDC server**

* Create a service principal and a **keytab** file for the Apache service on the oVirt Engine.

**On the oVirt Engine**

* Install the authentication and authorization extension packages and the Apache Kerberos authentication module.

* Configure the extension files.

**Configuring Kerberos for the Apache Service**

1. On the KDC server, use the `kadmin` utility to create a service principal for the Apache service on the oVirt Engine. The service principal is a reference ID to the KDC for the Apache service.

        # kadmin
        kadmin> addprinc -randkey HTTP/fqdn-of-rhevm@REALM.COM

2. Generate a **keytab** file for the Apache service. The **keytab** file stores the shared secret key.

        kadmin> ktadd -k /tmp/http.keytab HTTP/fqdn-of-rhevm@REALM.COM
        kadmin> quit

3. Copy the **keytab** file from the KDC server to the oVirt Engine:

        # scp /tmp/http.keytab root@rhevm.example.com:/etc/httpd

**Configuring Single Sign-on to the VM Portal or Administration Portal**

1. On the oVirt Engine, ensure that the ownership and permissions for the keytab are appropriate:

        # chown apache /etc/httpd/http.keytab
        # chmod 400 /etc/httpd/http.keytab

2. Install the authentication extension package, LDAP extension package, and the `mod_auth_gssapi` and  `mod_session` Apache modules:

        # yum install ovirt-engine-extension-aaa-misc ovirt-engine-extension-aaa-ldap mod_auth_gssapi mod_session

3. Copy the SSO configuration template file into the `/etc/ovirt-engine` directory. Template files are available for Active Directory (`ad-sso`) and other directory types (`simple-sso`). This example uses the simple SSO configuration template.

        # cp -r /usr/share/ovirt-engine-extension-aaa-ldap/examples/simple-sso/. /etc/ovirt-engine

4. Move **ovirt-sso.conf** into the Apache configuration directory:

        # mv /etc/ovirt-engine/aaa/ovirt-sso.conf /etc/httpd/conf.d

5. Review the authentication method file. You do not need to edit this file, as the realm is automatically fetched from the **keytab** file.

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

6. Rename the configuration files to match the profile name you want visible to users on the Administration Portal and the VM Portal login pages:

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

8. Review the authentication configuration file. The profile name visible to users on the Administration Portal and the VM Portal login pages is defined by `ovirt.engine.aaa.authn.profile.name`. The configuration profile location must match the LDAP configuration file location. All fields can be left as default.

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

12. Restart the Apache service and the `ovirt-engine` service:

        # systemctl restart httpd.service
        # systemctl restart ovirt-engine.service

## User Authorization

### User Authorization Model

oVirt applies authorization controls based on the combination of the three components:

* The user performing the action

* The type of action being performed

* The object on which the action is being performed

### User Actions

For an action to be successfully performed, the **user** must have the appropriate **permission** for the **object** being acted upon. Each type of action corresponds to a **permission**. There are many different permissions in the system, so for simplicity:

Some actions are performed on more than one object. For example, copying a template to another storage domain will impact both the template and the destination storage domain. The user performing an action must have appropriate permissions for all objects the action impacts.

## Administering User Tasks From the Administration Portal

### Adding Users and Assigning VM Portal Permissions

Users must be created already before they can be added and assigned roles and permissions. The roles and permissions assigned in this procedure give the user the permission to log in to the VM Portal and to start creating virtual machines. The procedure also applies to group accounts.

**Adding Users and Assigning VM Portal Permissions**

1. Click **Administration** &rarr; **Configure**.

2. Click **System Permissions**.

3. Click **Add** to open the **Add System Permission to User** window.

4. Select a profile under **Search**. The profile is the domain you want to search. Enter a name or part of a name in the search text field, and click **GO**. Alternatively, click **GO** to view a list of all users and groups.

5. Select the check boxes for the appropriate users or groups.

6. Select an appropriate role to assign under **Role to Assign**. The **UserRole** role gives the user account the permission to log in to the VM Portal.

7. Click **OK**.

Log in to the VM Portal to verify that the user account has the permissions to log in.

### Viewing User Information

**Viewing User Information**

1. Click **Administration** &rarr; **Users**  to display the list of authorized users.

2. Click the user’s name to open the details view, usually with the **General** tab displaying general information, such as the domain name, email and status of the user.

3. The other tabs allow you to view groups, permissions, quotas, and events for the user.

   For example, to view the groups to which the user belongs, click the **Directory Groups** tab.

### Viewing User Permissions on Resources

Users can be assigned permissions on specific resources or a hierarchy of resources. You can view the assigned users and their permissions on each resource.

**Viewing User Permissions on Resources**

1. Find and click the resource’s name to open the details view.

2. Click the **Permissions** tab of the details pane to list the assigned users, the user's role, and the inherited permissions for the selected resource.

### Removing Users

When a user account is no longer required, remove it from oVirt.

**Removing Users**

1. Click **Administration** &rarr; **Users**  to display the list of authorized users.

2. Select the user to be removed. Ensure the user is not running any virtual machines.

3. Click **Remove**, then click **OK**.

The user is removed from oVirt, but not from the external directory.

### Viewing Logged-In Users

You can view the users who are currently logged in, along with session times and other details. Click **Administration** → **Active User Sessions** to view the **Session DB ID**, **User Name**, **Authorization provider**, **User id**, **Source IP**, **Session Start Time**, and **Session Last Active Time** for each logged-in user.

### Terminating a User Session

You can terminate the session of a user who is currently logged in.

**Terminating a User Session**

1. Click **Administration** → **Active User Sessions**.

2. Select the user session to be terminated.

3. Click **Terminate Session**.

4. Click **OK**.

## Administering User Tasks From the Command Line

You can use the `ovirt-aaa-jdbc-tool` tool to manage user accounts on the internal domain. Changes made using the tool take effect immediately and do not require you to restart the `ovirt-engine` service. For a full list of user options, run `ovirt-aaa-jdbc-tool user --help`. Common examples are provided in this section.

    **Important:** You must be logged into the Engine machine.

### Creating a New User

You can create a new user account. The optional `--attribute` command specifies account details. For a full list of options, run `ovirt-aaa-jdbc-tool user add --help`.

        # ovirt-aaa-jdbc-tool user add test1 --attribute=firstName=John --attribute=lastName=Doe
        adding user test1...
        user added successfully

### Setting a User Password.

You can create a password. You must set a value for `--password-valid-to`, otherwise the password expiry time defaults to the current time. The date format is `yyyy-MM-dd HH:mm:ssX`. In this example, `-0800` stands for GMT minus 8 hours. For more options, run `ovirt-aaa-jdbc-tool user password-reset --help`.

        # ovirt-aaa-jdbc-tool user password-reset test1 --password-valid-to="2025-08-01 12:00:00-0800"
        Password:
        updating user test1...
        user updated successfully

    **Note:** By default, the password policy for user accounts on the internal domain has the following restrictions:

    * A minimum of 6 characters.

    * Three previous passwords used cannot be set again during the password change.

    For more information on the password policy and other default settings, run `ovirt-aaa-jdbc-tool settings show`.

### Setting User Timeout
You can set the user timeout period:

        # engine-config --set UserSessionTimeOutInterval=integer

### Pre-encrypting a User Password

You can create a pre-encrypted user password using the `ovirt-engine-crypto-tool` script. This option is useful if you are adding users and passwords to the database with a script.

    **Note:** Passwords are stored in the Engine database in encrypted form. The `ovirt-engine-crypto-tool` script is used because all passwords must be encrypted with the same algorithm.

    If the password is pre-encrypted, password validity tests cannot be performed. The password will be accepted even if it does not comply with the password validation policy.

1. Run the following command:

        # /usr/share/ovirt-engine/bin/ovirt-engine-crypto-tool.sh pbe-encode

   The script will prompt you to enter the password.

   Alternatively, you can use the `--password=file:file` option to encrypt a single password that appears as the first line of a file. This option is useful for automation. In the following example, file is a text file containing a single password for encryption:

        # /usr/share/ovirt-engine/bin/ovirt-engine-crypto-tool.sh pbe-encode --password=file:file

2. Set the new password with the `ovirt-aaa-jdbc-tool` script, using the `--encrypted` option:

        # ovirt-aaa-jdbc-tool user password-reset test1 --password-valid-to="2025-08-01 12:00:00-0800" --encrypted

3. Enter and confirm the encrypted password:

        Password:
        Reenter password:
        updating user test1...
        user updated successfully

### Viewing User Information

You can view detailed user account information:

        # ovirt-aaa-jdbc-tool user show test1

This command displays more information than in the Administration Portal’s **Administration** &rarr; **Users** screen.

### Editing User Information

You can update user information, such as the email address:

        # ovirt-aaa-jdbc-tool user edit test1 --attribute=email=jdoe@example.com

### Removing a User

You can remove a user account:

        # ovirt-aaa-jdbc-tool user delete test1

Remove the user from the Administration Portal. See [Removing Users](Removing_Users1) for more information.

### Disabling the Internal Administrative User

You can disable users on the local domains including the admin@internal user created during `engine-setup`. Make sure you have at least one user in the environment with full administrative permissions before disabling the default admin user.

**Disabling the Internal Administrative User**

1. Log in to the machine on which the oVirt Engine is installed.

2. Make sure another user with the **SuperUser** role has been added to the environment. See [Adding users](Adding_users) for more information.

3. Disable the default **admin** user:

        # ovirt-aaa-jdbc-tool user edit admin --flag=+disabled

    **Note:** To enable a disabled user, run `ovirt-aaa-jdbc-tool user edit `username` --flag=-disabled`

### Managing Groups

You can use the `ovirt-aaa-jdbc-tool` tool to manage group accounts on your internal domain. Managing group accounts is similar to managing user accounts. For a full list of group options, run `ovirt-aaa-jdbc-tool group --help`. Common examples are provided in this section.

**Creating a Group**

This procedure shows you how to create a group account, add users to the group, and view the details of the group.

1. Log in to the machine on which the oVirt Engine is installed.

2. Create a new group:

        # ovirt-aaa-jdbc-tool group add group1

3. Add users to the group. The users must be created already.

        # ovirt-aaa-jdbc-tool group-manage useradd group1 --user=test1

    **Note:** For a full list of the group-manage options, run `ovirt-aaa-jdbc-tool group-manage --help`.

4. View group account details:

        # ovirt-aaa-jdbc-tool group show group1

5. Add the newly created group in the Administration Portal and assign the group appropriate roles and permissions. The users in the group inherit the roles and permissions of the group. See [Adding users](Adding_users) for more information.

**Creating Nested Groups**

This procedure shows you how to create groups within groups.

1. Log in to the machine on which the oVirt Engine is installed.

2. Create the first group:

        # ovirt-aaa-jdbc-tool group add group1

3. Create the second group:

        # ovirt-aaa-jdbc-tool group add group1-1

4. Add the second group to the first group:

        # ovirt-aaa-jdbc-tool group-manage groupadd group1 --group=group1-1

5. Add the first group in the Administration Portal and assign the group appropriate roles and permissions. See [Adding users](Adding_users) for more information.

### Querying Users and Groups

The `query` module allows you to query user and group information. For a full list of options, run `ovirt-aaa-jdbc-tool query --help`.

**Listing All User or Group Account Details**

This procedure shows you how to list all account information.

1. Log in to the machine on which the oVirt Engine is installed.

2. List the account details.

    * List all user account details:

            # ovirt-aaa-jdbc-tool query --what=user

    * List all group account details:

            # ovirt-aaa-jdbc-tool query --what=group

**Listing Filtered Account Details**

This procedure shows you how to apply filters when listing account information.

1. Log in to the machine on which the oVirt Engine is installed.

2. Filter account details using the `--pattern` parameter.

    * List user account details with names that start with the character j.

            # ovirt-aaa-jdbc-tool query --what=user --pattern="name=j*"

    * List groups that have the department attribute set to marketing:

            # ovirt-aaa-jdbc-tool query --what=group --pattern="department=marketing"

### Managing Account Settings

To change the default account settings, use the `ovirt-aaa-jdbc-tool` `settings` module.

**Updating Account Settings**

This procedure shows you how to update the default account settings.

1. Log in to the machine on which the oVirt Engine is installed.

2. Run the following command to show all the settings available:

        # ovirt-aaa-jdbc-tool setting show

3. Change the desired settings:

    * This example updates the default log in session time to 60 minutes for all user accounts. The default value is 10080 minutes.

            # ovirt-aaa-jdbc-tool setting set --name=MAX_LOGIN_MINUTES --value=60

    * This example updates the number of failed login attempts a user can perform before the user account is locked. The default value is 5.

            # ovirt-aaa-jdbc-tool setting set --name=MAX_FAILURES_SINCE_SUCCESS --value=3

        **Note:** To unlock a locked user account, run `ovirt-aaa-jdbc-tool user unlock test1`.

## Configuring Additional Local domains

Creating additional local domains other than the default **internal** domain is also supported. This can be done using the **ovirt-engine-extension-aaa-jdbc** extension and allows you to create multiple domains without attaching external directory servers, though the use case may not be common for enterprise environments.

Additionally created local domains will not get upgraded autonmatically during standard Red Hat Virtualization upgrades and need to be upgraded manually for each future release. For more information on creating additional local domains and how to upgrade the domains, see the README file at **/usr/share/doc/ovirt-engine-extension-aaa-jdbc-version/README.admin**.

**Prev:** [Chapter 14: Automating Configuration Tasks Using Ansible](../chap-Automating_Configuration_Tasks_Using_Ansible)<br>
**Next:** [Chapter 16: Quotas and Service Level Agreement Policy](../chap-Quotas_and_Service_Level_Agreement_Policy)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/administration_guide/chap-users_and_roles)
