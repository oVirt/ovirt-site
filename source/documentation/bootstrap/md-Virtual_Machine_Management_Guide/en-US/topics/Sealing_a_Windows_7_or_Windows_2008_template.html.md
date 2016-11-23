# Sealing a Windows 7, Windows 2008, or Windows 2012 Template

Seal a Windows 7, Windows 2008, or Windows 2012 template before using the template to deploy virtual machines.

**Sealing a Windows 7, Windows 2008, or Windows 2012 Template**

1. Launch *Sysprep* from `C:\Windows\System32\sysprep\sysprep.exe`.

2. Enter the following information into the *Sysprep* tool:

    * Under **System Cleanup Action**, select **Enter System Out-of-Box-Experience (OOBE)**.

    * Select the **Generalize** check box if you need to change the computer's system identification number (SID).

    * Under **Shutdown Options**, select **Shutdown**.

3. Click **OK** to complete the sealing process; the virtual machine shuts down automatically upon completion.

The Windows 7, Windows 2008, or Windows 2012 template is sealed and ready for deploying virtual machines.
