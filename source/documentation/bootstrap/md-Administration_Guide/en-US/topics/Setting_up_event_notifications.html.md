# Configuring Event Notifications in the Administration Portal


**Summary**

The Red Hat Virtualization Manager can notify designated users via email when specific events occur in the environment that the Red Hat Virtualization Manager manages. To use this functionality, you must set up a mail transfer agent to deliver messages. Only email notifications can be configured through the Administration Portal. SNMP traps must be configured on the Manager machine.

**Configuring Event Notifications**

1. Ensure you have set up the mail transfer agent with the appropriate variables.

2. Use the **Users** resource tab, tree mode, or the search function to find and select the user to which event notifications will be sent.

3. Click the **Event Notifier** tab in the details pane to list the events for which the user will be notified. This list is blank if you have not configured any event notifications for that user.

4. Click **Manage Events** to open the **Add Event Notification** window.

    **The Add Events Notification Window**

    ![](images/5607.png)

5. Use the **Expand All** button or the subject-specific expansion buttons to view the events.

6. Select the appropriate check boxes.

7. Enter an email address in the **Mail Recipient** field.

8. Click **OK** to save changes and close the window.

9. Add and start the `ovirt-engine-notifier` service on the Red Hat Virtualization Manager. This activates the changes you have made:

        # systemctl daemon-reload
        # systemctl enable ovirt-engine-notifier.service
        # systemctl restart ovirt-engine-notifier.service

**Result**

The specified user now receives emails based on events in the Red Hat Virtualization environment. The selected events display on the **Event Notifier** tab for that user.
