# Defining Custom Properties

The custom properties that are accepted by the Red Hat Virtualization Manager - and in turn passed to custom hooks - are defined using the `engine-config` command. Run this command as the `root` user on the host where Red Hat Virtualization Manager is installed.

The `UserDefinedVMProperties` and `CustomDeviceProperties` configuration keys are used to store the names of the custom properties supported. Regular expressions defining the valid values for each named custom property are also contained in these configuration keys.

Multiple custom properties are separated by a semi-colon. Note that when setting the configuration key, any existing value it contained is overwritten. When combining new and existing custom properties, all of the custom properties in the command used to set the key's value must be included.

Once the configuration key has been updated, the `ovirt-engine` service must be restarted for the new values to take effect.

**Virtual Machine Properties - Defining the `smartcard` Custom Property**

1. Check the existing custom properties defined by the `UserDefinedVMProperties` configuration key using the following command:

        # engine-config -g UserDefinedVMProperties

    As shown by the output below, the custom property `memory` is already defined. The regular expression `^[0-9]+$` ensures that the custom property will only ever contain numeric characters.

        # engine-config -g UserDefinedVMProperties
        UserDefinedVMProperties:  version: 3.6
        UserDefinedVMProperties:  version: 4.0
        UserDefinedVMProperties : memory=^[0-9]+$ version: 4.0

2. Because the `memory` custom property is already defined in the `UserDefinedVMProperties` configuration key, the new custom property must be appended to it. The additional custom property, `smartcard`, is added to the configuration key's value. The new custom property is able to hold a value of `true` or `false`.

        # engine-config -s UserDefinedVMProperties='memory=^[0-9]+$;smartcard=^(true|false)$' --cver=4.0

3. Verify that the custom properties defined by the `UserDefinedVMProperties` configuration key have been updated correctly.

        # engine-config -g UserDefinedVMProperties
        UserDefinedVMProperties:  version: 3.6
        UserDefinedVMProperties:  version: 4.0
        UserDefinedVMProperties : memory=^[0-9]+$;smartcard=^(true|false)$ version: 4.0

4. Finally, the `ovirt-engine` service must be restarted for the configuration change to take effect.

        # systemctl restart ovirt-engine.service

**Device Properties - Defining the `interface` Custom Property**

1. Check the existing custom properties defined by the `CustomDeviceProperties` configuration key using the following command:

        # engine-config -g CustomDeviceProperties

    As shown by the output below, no custom properties have yet been defined.

        # engine-config -g CustomDeviceProperties
        CustomDeviceProperties:  version: 3.6
        CustomDeviceProperties:  version: 4.0

2. The `interface` custom property does not already exist, so it can be appended as is. In this example, the value of the `speed` sub-property is set to a range of 0 to 99999, and the value of the `duplex` sub-property is set to a selection of either `full` or `half`.

        # engine-config -s CustomDeviceProperties="{type=interface;prop={speed=^([0-9]{1,5})$;duplex=^(full|half)$}}" --cver=4.0

3. Verify that the custom properties defined by the `CustomDeviceProperties` configuration key have been updated correctly.

        # engine-config -g CustomDeviceProperties
        UserDefinedVMProperties:  version: 3.6
        UserDefinedVMProperties:  version: 4.0
        UserDefinedVMProperties : {type=interface;prop={speed=^([0-9]{1,5})$;duplex=^(full|half)$}} version: 4.0

4. Finally, the `ovirt-engine` service must be restarted for the configuration change to take effect.

        # systemctl restart ovirt-engine.service
