# Viewing the Health Status of a Storage Domain

Storage domains have an external health status in addition to their regular **Status**. The external health status is reported by plug-ins or external systems, or set by an administrator, and appears to the left of the storage domain's **Name** as one of the following icons:

* **OK**: No icon

* **Info**: ![](images/Info.png)

* **Warning**: ![](images/Warning.png)

* **Error**: ![](images/Error.png)

* **Failure**: ![](images/Failure.png)

To view further details about the storage domain's health status, select the storage domain and click the **Events** sub-tab.

The storage domain's health status can also be viewed using the REST API. A `GET` request on a storage domain will include the `external_status` element, which contains the health status.

You can set a storage domain's health status in the REST API via the `events` collection. For more information, see [Adding Events](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/rest-api-guide/#Adding_Events) in the *REST API Guide*.




