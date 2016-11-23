# Manually Associating console.vv Files with Remote Viewer

If you are prompted to download a `console.vv` file when attempting to open a console to a virtual machine using the native client console option, and Remote Viewer is already installed, then you can manually associate `console.vv` files with Remote Viewer so that Remote Viewer can automatically use those files to open consoles.

**Manually Associating console.vv Files with Remote Viewer**

1. Start the virtual machine.

2. Open the **Console Options** window.

    * In the Administration Portal, right-click the virtual machine and click **Console Options**.

    * In the User Portal, click the **Edit Console Options** button.

    **The User Portal Edit Console Options Button**

    ![](images/6145.png)

3. Change the console invocation method to **Native client** and click **OK**.

4. Attempt to open a console to the virtual machine, then click **Save** when prompted to open or save the `console.vv` file.

5. Navigate to the location on your local machine where you saved the file.

6. Double-click the `console.vv` file and select **Select a program from a list of installed programs** when prompted.

7. In the **Open with** window, select **Always use the selected program to open this kind of file** and click the **Browse** button.

8. Navigate to the `C:\Users\[user name]\AppData\Local\virt-viewer\bin` directory and select `remote-viewer.exe`.

8. Click **Open** and then click **OK**.

When you use the native client console invocation option to open a console to a virtual machine, Remote Viewer will automatically use the `console.vv` file that the Red Hat Virtualization Manager provides to open a console to that virtual machine without prompting you to select the application to use.
