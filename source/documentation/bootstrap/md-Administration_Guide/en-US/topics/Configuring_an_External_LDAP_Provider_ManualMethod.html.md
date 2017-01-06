# Configuring an External LDAP Provider (Manual Method)

The `ovirt-engine-extension-aaa-ldap` extension uses the LDAP protocol to access directory servers and is fully customizable. Kerberos authentication is not required unless you want to enable the single sign-on to the User Portal or the Administration Portal feature.

If the interactive setup method in the previous section does not cover your use case, you can manually modify the configuration files to attach your LDAP server. The following procedure uses generic details. Specific values depend on your setup.

**Configuring an External LDAP Provider Manually**

1. On the Red Hat Virtualization Manager, install the LDAP extension package:

        # yum install ovirt-engine-extension-aaa-ldap

2. Copy the LDAP configuration template file into the `/etc/ovirt-engine` directory. Template files are available for active directories (`ad`) and other directory types (`simple`). This example uses the simple configuration template.

        # cp -r /usr/share/ovirt-engine-extension-aaa-ldap/examples/simple/. /etc/ovirt-engine

3. Rename the configuration files to match the profile name you want visible to users on the Administration Portal and the User Portal login pages:

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

5. Review the authentication configuration file. The profile name visible to users on the Administration Portal and the User Portal login pages is defined by `ovirt.engine.aaa.authn.profile.name`. The configuration profile location must match the LDAP configuration file location. All fields can be left as default.

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

9. The `example` profile you have created is now available on the Administration Portal and the User Portal login pages. To give the user accounts on the LDAP server appropriate permissions, for example to log in to the User Portal, see [Red Hat Enterprise Virtualization Manager User Tasks](sect-Red_Hat_Enterprise_Virtualization_Manager_User_Tasks).

**Note:** For more information, see the LDAP authentication and authorization extension README file at `/usr/share/doc/ovirt-engine-extension-aaa-ldap-version`.
