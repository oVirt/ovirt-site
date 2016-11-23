# SPICE Console Options

When the SPICE connection protocol is selected, the following options are available in the **Console Options** window.

**The Console Options window**

![](images/5679.png)

**Console Invocation**

* **Auto**: The Manager automatically selects the method for invoking the console.

* **Native client**: When you connect to the console of the virtual machine, a file download dialog provides you with a file that opens a console to the virtual machine via Remote Viewer.

* **SPICE HTML5 browser client (Tech preview)**: When you connect to the console of the virtual machine, a browser tab is opened that acts as the console.

**SPICE Options**

* **Map control-alt-del shortcut to ctrl+alt+end**: Select this check box to map the **Ctrl** + **Alt** + **Del** key combination to **Ctrl** + **Alt** + **End** inside the virtual machine.

* **Enable USB Auto-Share**: Select this check box to automatically redirect USB devices to the virtual machine. If this option is not selected, USB devices will connect to the client machine instead of the guest virtual machine. To use the USB device on the guest machine, manually enable it in the SPICE client menu.

* **Open in Full Screen**: Select this check box for the virtual machine console to automatically open in full screen when you connect to the virtual machine. Press **SHIFT** + **F11** to toggle full screen mode on or off.

* **Enable SPICE Proxy**: Select this check box to enable the SPICE proxy.

* **Enable WAN options**: Select this check box to set the parameters `WANDisableEffects` and `WANColorDepth` to `animation` and `16` bits respectively on Windows virtual machines. Bandwidth in WAN environments is limited and this option prevents certain Windows settings from consuming too much bandwidth.


