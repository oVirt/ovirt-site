# Installing the CA certificate

The first time you access the VM Portal, you must install the certificate used by the Red Hat Virtualization Manager to avoid security warnings.

**Installing the CA certificate in Firefox**

1. Go to the VM Portal URL.
2. Click **Add Exception** to open the **Add Security Exception** window.
3. Select **Permanently store this exception**.
4. Click **Confirm Security Exception**.

**Installing the CA certificate in Internet Explorer**

1. Go to the VM Portal certificate URL: **https://_\[VM Portal URL]_/ca.crt**.
2. Click **Open** in the **File Download - Security Warning** window to open the **Certificate** window.
3. Click the **Install Certificate** button to open the **Certificate Import Wizard** window.
4. Select the **Place all certificates in the following store** radio button and click **Browse** to open the **Select Certificate Store** window.
5. Select **Trusted Root Certification Authorities** from the list of certificate stores and click **OK**.
6. Click **Next** to proceed to the **Certificate Store** screen.
7. Click **Next** to proceed to the **Completing the Certificate Import Wizard** screen.
8. Click **Finish** to install the certificate.

**Important:** If you are using Internet Explorer to access the VM Portal, you must also add the URL for the Red Hat Virtualization welcome page to the list of trusted sites to ensure that all security rules for trusted sites are applied to console resources such as *console.vv* mime files and Remote Desktop connection files. 

**Downloading the CA certificate**

To download the CA certificate manually, click the **CA Certificate** link on the Manager's welcome screen and save the **ca.crt** file.
