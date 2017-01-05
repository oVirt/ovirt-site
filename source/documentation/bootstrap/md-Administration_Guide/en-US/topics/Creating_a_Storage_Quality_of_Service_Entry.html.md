# Creating a Storage Quality of Service Entry

Create a storage quality of service entry.

**Creating a Storage Quality of Service Entry**

1. Click the **Data Centers** resource tab and select a data center.

2. Click **QoS** in the details pane.

3. Click **Storage**.

4. Click **New**.

5. Enter a name for the quality of service entry in the **QoS Name** field.

6. Enter a description for the quality of service entry in the **Description** field.

7. Specify the throughput quality of service:

    1. Select the **Throughput** check box.

    2. Enter the maximum permitted total throughput in the **Total** field.

    3. Enter the maximum permitted throughput for read operations in the **Read** field.

    4. Enter the maximum permitted throughput for write operations in the **Write** field.

8. Specify the input and output quality of service:

    1. Select the **IOps** check box.

    2. Enter the maximum permitted number of input and output operations per second in the **Total** field.

    3. Enter the maximum permitted number of input operations per second in the **Read** field.

    4. Enter the maximum permitted number of output operations per second in the **Write** field.

9. Click **OK**.

You have created a storage quality of service entry, and can create disk profiles based on that entry in data storage domains that belong to the data center.
