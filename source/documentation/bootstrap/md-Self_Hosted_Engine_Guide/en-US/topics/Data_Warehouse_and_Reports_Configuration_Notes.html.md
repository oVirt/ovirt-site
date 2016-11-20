# Data Warehouse Configuration Notes

**Behavior**

The following behavior is expected in `engine-setup`:

Install the Data Warehouse package, run `engine-setup`, and answer `No` to configuring Data Warehouse:

    Configure Data Warehouse on this host (Yes, No) [Yes]: No

Run `engine-setup` again; setup no longer presents the option to configure those services.

**Workaround**

To force `engine-setup` to present both options again, run `engine-setup --reconfigure-optional-components`.

**Note:** To configure only the currently installed Data Warehouse packages, and prevent setup from applying package updates found in enabled repositories, add the `--offline` option .
