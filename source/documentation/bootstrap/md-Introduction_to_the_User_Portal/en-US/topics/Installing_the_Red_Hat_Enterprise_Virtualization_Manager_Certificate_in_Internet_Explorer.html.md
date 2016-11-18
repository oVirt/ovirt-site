# Installing the Red Hat Virtualization Manager Certificate in Internet Explorer

The first time you access the User Portal, you must install the certificate used by the Red Hat Virtualization Manager to avoid security warnings.

**Installing the Red Hat Virtualization Manager Certificate in Internet Explorer**

1. Navigate to the following URL:

        https://[your manager's address]/ca.crt

2. Click the **Open** button in the **File Download - Security Warning** window to open the **Certificate** window.

3. Click the **Install Certificate** button to open the **Certificate Import Wizard** window.

4. Select the **Place all certificates in the following store** radio button and click **Browse** to open the **Select Certificate Store** window.

5. Select **Trusted Root Certification Authorities** from the list of certificate stores, then click **OK**.

6. Click **Next** to proceed to the **Certificate Store** screen.

7. Click **Next** to proceed to the **Completing the Certificate Import Wizard** screen.

8. Click **Finish** to install the certificate.

**Important:** If you are using Internet Explorer to access the User Portal, you must also add the URL for the Red Hat Virtualization welcome page to the list of trusted sites to ensure all security rules for trusted sites are applied to console resources such as `console.vv` mime files and Remote Desktop connection files.
