# Setting Up SSL or TLS Connections between the Manager and an LDAP Server

To set up a secure connection between the Red Hat Enterpriser Virtualization Manager and an LDAP server, obtain the root CA certificate of the LDAP server, copy the root CA certificate to the Manager, and create a PEM-encoded CA certificate. The keystore type can be any Java-supported type. The following procedure uses the Java KeyStore (JKS) format.

**Note:** For more information on creating a PEM-encoded CA certificate and importing certificates, see the `X.509 CERTIFICATE TRUST STORE` section of the README file at `/usr/share/doc/ovirt-engine-extension-aaa-ldap-version`.

**Creating a PEM-encoded CA certificate**

1. On the Red Hat Virtualization Manager, copy the root CA certificate of the LDAP server to the `/tmp` directory and import the root CA certificate using `keytool` to create a PEM-encoded CA certificate. The following command imports the root CA certificate at `/tmp/myrootca.pem` and creates a PEM-encoded CA certificate `myrootca.jks` under `/etc/ovirt-engine/aaa/`. Note down the certificate's location and password. If you are using the interactive setup tool, this is all the information you need. If you are configuring the LDAP server manually, follow the rest of the procedure to update the configuration files.

        $ keytool -importcert -noprompt -trustcacerts -alias myrootca -file /tmp/myrootca.pem -keystore /etc/ovirt-engine/aaa/myrootca.jks -storepass password

2. Update the `/etc/ovirt-engine/aaa/profile1.properties` file with the certificate information:

    **Note:** `${local:_basedir}` is the directory where the LDAP property configuration file resides and points to the `/etc/ovirt-engine/aaa` directory. If you created the PEM-encoded CA certificate in a different directory, replace `${local:_basedir}` with the full path to the certificate.

    * To use startTLS (recommended):

            # Create keystore, import certificate chain and uncomment
            pool.default.ssl.startTLS = true
            pool.default.ssl.truststore.file = ${local:_basedir}/myrootca.jks
            pool.default.ssl.truststore.password = password
    * To use SSL:

            # Create keystore, import certificate chain and uncomment
            pool.default.serverset.single.port = 636
            pool.default.ssl.enable = true
            pool.default.ssl.truststore.file = ${local:_basedir}/myrootca.jks
            pool.default.ssl.truststore.password = password

To continue configuring an external LDAP provider, see [Configuring an External LDAP Provider](Configuring_an_External_LDAP_Provider). To continue configuring LDAP and Kerberos for Single Sign-on, see [Configuring LDAP and Kerberos for Single Sign-on](Configuring_LDAP_and_Kerberos_for_Single_Sign-on).
