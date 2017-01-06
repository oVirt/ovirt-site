# Syntax for the engine-config Command

You can run the engine configuration tool from the machine on which the Red Hat Virtualization Manager is installed. For detailed information on usage, print the help output for the command:

    # engine-config --help

**Common tasks**

List available configuration keys
: 
        # engine-config --list

List available configuration values
: 
        # engine-config --all

Retrieve value of configuration key
: 
        # engine-config --get [KEY_NAME]

    Replace `[KEY_NAME]` with the name of the preferred key to retrieve the value for the given version of the key. Use the `--cver` parameter to specify the configuration version of the value to be retrieved. If no version is provided, values for all existing versions are returned.

Set value of configuration key
: 
        # engine-config --set [KEY_NAME]=[KEY_VALUE] --cver=[VERSION]

    Replace `[KEY_NAME]` with the name of the specific key to set, and replace `[KEY_VALUE]` with the value to be set. You must specify the `[VERSION]` in environments with more than one configuration version.

Restart the ovirt-engine service to load changes
: The `ovirt-engine` service needs to be restarted for your changes to take effect.

        # service ovirt-engine restart
