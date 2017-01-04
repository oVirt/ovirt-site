# SPICE Logs for SPICE Clients Launched Using console.vv Files

**For Linux client machines:**

1. Enable SPICE debugging by running the `remote-viewer` command with the `--spice-debug` option. When prompted, enter the connection URL, for example, spice://[virtual_machine_IP]:[port].

        #  remote-viewer --spice-debug 

2. To view logs, download the `console.vv` file and run the `remote-viewer` command with the `--spice-debug` option and specify the full path to the `console.vv` file.

        # remote-viewer --spice-debug /path/to/console.vv

**For Windows client machines:**

1. Download the `debug-helper.exe` file and move it to the same directory as the `remote-viewer.exe` file. For example, the `C:\Users\[user name]\AppData\Local\virt-viewer\bin` directory.

2. Execute the `debug-helper.exe` file to install the GNU Debugger (GDB).

3. Enable SPICE debugging by executing the `debug-helper.exe` file.

        debug-helper.exe remote-viewer.exe --spice-controller

4. To view logs, connect to the virtual machine, and you will see a command prompt running GDB that prints standard output and standard error of `remote-viewer`.
