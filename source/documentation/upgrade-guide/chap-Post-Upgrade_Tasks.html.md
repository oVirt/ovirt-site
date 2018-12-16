---
title: Post-Upgrade Tasks
---

# Chapter 8: Post-Upgrade Tasks

## Changing the Cluster Compatibility Version

oVirt clusters have a compatibility version. The cluster compatibility version indicates the features of oVirt supported by all of the hosts in the cluster. The cluster compatibility is set according to the version of the least capable host operating system in the cluster.

    **Important:** To change the cluster compatibility version, you must have first updated all the hosts in your cluster to a level that supports your desired compatibility level.

**Procedure**

1. From the Administration Portal, click **Compute** &rarr; **Clusters**.

2. Select the cluster to change.

3. Click **Edit**.

4. Change the **Compatibility Version** to the desired value.

5. Click **OK** to open the **Change Cluster Compatibility Version** confirmation window.

6. Click **OK** to confirm.

    **Important:** An error message may warn that some virtual machines and templates are incorrectly configured. To fix this error, edit each virtual machine manually. The **Edit Virtual Machine** window provides additional validations and warnings that show what to correct. Sometimes the issue is automatically corrected and the virtual machine’s configuration just needs to be saved again. After editing each virtual machine, you will be able to change the cluster compatibility version.

After you update the cluster’s compatibility version, you must update the cluster compatibility version of all running or suspended virtual machines by restarting them from within the Manager, or using the REST, instead of within the guest operating system. Virtual machines will continue to run in the previous cluster compatibility level until they are restarted. Those virtual machines that require a restart are marked with the Next-Run icon (triangle with an exclamation mark). You cannot change the cluster compatibility version of a virtual machine snapshot that is in preview; you must first commit or undo the preview.

The self-hosted engine virtual machine does not need to be restarted.

You have updated the compatibility version of the cluster. Once you have updated the compatibility version of all clusters in a data center, you can then change the compatibility version of the data center itself.

## Changing the Data Center Compatibility Version

oVirt data centers have a compatibility version. The compatibility version indicates the version of oVirt that the data center is intended to be compatible with. All clusters in the data center must support the desired compatibility level.

    **Important:** To change the data center compatibility version, you must have first updated all the clusters in your data center to a level that supports your desired compatibility level.

**Procedure**

1. From the Administration Portal, **Compute** &rarr; **Data Centers**.

2. Select the data center to change from the list displayed.

3. Click **Edit**.

4. Change the **Compatibility Version** to the desired value.

5. Click **OK** to open the **Change Data Center Compatibility Version** confirmation window.

6. Click **OK** to confirm.

You have updated the compatibility version of the data center.

## Replacing SHA-1 Certificates with SHA-256 Certificates

oVirt 4.2 uses SHA-256 signatures, which provide a more secure way to sign SSL certificates than SHA-1.Newly installed 4.2 systems do not require any special steps to enable oVirt’s public key infrastructure (PKI) to use SHA-256 signatures. However, for upgraded systems one of the following is recommended:

* Option 1: Prevent warning messages from appearing in your browser when connecting to the Administration Portal. These warnings may either appear as pop-up windows or in the browser’s **Web Console** window. This option is not required if you already replaced the oVirt Engine’s Apache SSL certificate after the upgrade. However, if the certificate was signed with SHA-1, you should replace it with an SHA-256 certificate.

* Option 2: Replace the SHA-1 certificates throughout the system with SHA-256 certificates.

**Preventing Warning Messages from Appearing in the Browser**

1. Log in to the Engine machine as the root user.

2. Check whether **/etc/pki/ovirt-engine/openssl.conf** includes the line `default_md = sha256`:

        # cat /etc/pki/ovirt-engine/openssl.conf

   If it still includes default_md = sha1, back up the existing configuration and change the default to sha256:

        # cp -p /etc/pki/ovirt-engine/openssl.conf /etc/pki/ovirt-engine/openssl.conf."$(date +"%Y%m%d%H%M%S")"
        # sed -i 's/^default_md = sha1/default_md = sha256/' /etc/pki/ovirt-engine/openssl.conf

3. Define the certificate that should be re-signed:

        # names="apache"

4. For self-hosted engine environments, log in to one of the self-hosted engine nodes and enable global maintenance:

        # hosted-engine --set-maintenance --mode=global

5. On the Manager, re-sign the Apache certificate:

        for name in $names; do
            subject="$(
                openssl \
                    x509 \
                    -in /etc/pki/ovirt-engine/certs/"${name}".cer \
                    -noout \
                    -subject \
                | sed \
                    's;subject= \(.\*\);\1;' \
            )"
           /usr/share/ovirt-engine/bin/pki-enroll-pkcs12.sh \
                --name="${name}" \
                --password=mypass \
                --subject="${subject}" \
                --keep-key
        done

6. Restart the **httpd** service:

        # systemctl restart httpd

7. For self-hosted engine environments, log in to one of the self-hosted engine nodes and disable global maintenance:

        # hosted-engine --set-maintenance --mode=none

8. Connect to the Administration Portal to confirm that the warning no longer appears.

9. If you previously imported a CA or https certificate into the browser, find the certificate(s), remove them from the browser, and reimport the new CA certificate. Install the certificate authority according to the instructions provided by your browser. To get the certificate authority’s certificate, navigate to http://your-manager-fqdn/ovirt-engine/services/pki-resource?resource=ca-certificate&format=X509-PEM-CA, replacing your-manager-fqdn with the fully qualified domain name (FQDN).

**Replacing All Signed Certificates with SHA-256**

1. Log in to the Engine machine as the root user.

2. Check whether **/etc/pki/ovirt-engine/openssl.conf** includes the line `default_md = sha256`:

        # cat /etc/pki/ovirt-engine/openssl.conf

   If it still includes `default_md = sha1`, back up the existing configuration and change the default to `sha256`:

        # cp -p /etc/pki/ovirt-engine/openssl.conf /etc/pki/ovirt-engine/openssl.conf."$(date +"%Y%m%d%H%M%S")"
        # sed -i 's/^default_md = sha1/default_md = sha256/' /etc/pki/ovirt-engine/openssl.conf

3. Re-sign the CA certificate by backing it up and creating a new certificate in **ca.pem.new**:

        # cp -p /etc/pki/ovirt-engine/private/ca.pem /etc/pki/ovirt-engine/private/ca.pem."$(date +"%Y%m%d%H%M%S")"
        # openssl x509 -signkey /etc/pki/ovirt-engine/private/ca.pem -in /etc/pki/ovirt-engine/ca.pem -out /etc/pki/ovirt-engine/ca.pem.new -days 3650 -sha256

4. Replace the existing certificate with the new certificate:

        # mv /etc/pki/ovirt-engine/ca.pem.new /etc/pki/ovirt-engine/ca.pem

5. Define the certificates that should be re-signed:

        # names="engine apache websocket-proxy jboss imageio-proxy"

   If you replaced the oVirt Engine SSL Certificate after the upgrade, run the following instead:

        # names="engine websocket-proxy jboss imageio-proxy"

6. For self-hosted engine environments, log in to one of the self-hosted engine nodes and enable global maintenance:

        # hosted-engine --set-maintenance --mode=global

7. On the Engine, re-sign the certificates:

        for name in $names; do
           subject="$(
                openssl \
                    x509 \
                    -in /etc/pki/ovirt-engine/certs/"${name}".cer \
                    -noout \
                    -subject \
                | sed \
                    's;subject= \(.\*\);\1;' \
                )"
             /usr/share/ovirt-engine/bin/pki-enroll-pkcs12.sh \
                    --name="${name}" \
                    --password=mypass \
                    --subject="${subject}" \
                    --keep-key
        done

8. Restart the following services:

        # systemctl restart httpd
        # systemctl restart ovirt-engine
        # systemctl restart ovirt-websocket-proxy
        # systemctl restart ovirt-imageio-proxy

9. For self-hosted engine environments, log in to one of the self-hosted engine nodes and disable global maintenance:

        # hosted-engine --set-maintenance --mode=none

10. Connect to the Administration Portal to confirm that the warning no longer appears.

11. If you previously imported a CA or https certificate into the browser, find the certificate(s), remove them from the browser, and reimport the new CA certificate. Install the certificate authority according to the instructions provided by your browser. To get the certificate authority’s certificate, navigate to http://your-manager-fqdn/ovirt-engine/services/pki-resource?resource=ca-certificate&format=X509-PEM-CA, replacing your-manager-fqdn with the fully qualified domain name (FQDN).

12. Enroll the certificates on the hosts. Repeat the following procedure for each host.

  i. In the Administration Portal, click **Compute** &rarr; **Hosts**.

  ii. Select the host and click **Management** &rarr; **Maintenance**.

  iii. Once the host is in maintenance mode, click **Installation** &rarr; **Enroll Certificate**.

  iv. Click **Management** &rarr; **Activate**.

## Updating OVN Providers Installed in oVirt 4.1

If you installed an Open Virtual Network (OVN) provider in oVirt 4.1, you must manually edit its configuration for oVirt 4.2.

**Updating an OVN Provider’s Networking Plugin**

1. Click **Administration** → **Providers** and select the OVN provider.

2. Click **Edit**.

3. Click the **Networking Plugin** text field and select **oVirt Network Provider for OVN** from the drop-down list.

4. Click **OK**.

**Prev:** [Chapter 7: Upgrading a Remote Database Environment from 4.1 to oVirt 4.2](chap-Upgrading_a_Remote_Database_Environment_from_4.1_to_oVirt_4.2)<br>
**Next:** [Chapter 9: Updates Between Minor Releases](chap-Updates_between_Minor_Releases/)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/upgrade_guide/chap-post-upgrade_tasks)
