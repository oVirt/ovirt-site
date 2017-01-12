# Syntax for the oVirt Engine Rename Command

The basic syntax for the `ovirt-engine-rename` command is:

    # /usr/share/ovirt-engine/setup/bin/ovirt-engine-rename

The command also accepts the following options:


`--newname=[new name]`
: Allows you to specify the new fully qualified domain name for the Manager without user interaction.

`--log=[file]`
: Allows you to specify the path and name of a file into which logs of the rename operation are to be written.

`--config=[file]`
: Allows you to specify the path and file name of a configuration file to load into the rename operation.

`--config-append=[file]`
: Allows you to specify the path and file name of a configuration file to append to the rename operation. This option can be used to specify the path and file name of an answer file.

`--generate-answer=[file]`
: Allows you to specify the path and file name of a file into which your answers to and the values changed by the `ovirt-engine-rename` command are recorded.
