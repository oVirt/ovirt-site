# Using Dashboards

A dashboard displays a set of saved visualizations.
Dashboards have the advantage of enabling you to quickly access a wide range of metrics
while offering the flexibility of changing them to match your individual needs.

You can use the **Dashboard** tab to create your own dashboards.
Alternatively, Red Hat provides the following dashboard examples,
which you can import into Kibana and use as is or customize to suit your specific needs:

* System dashboard
* Hosts dashboard
* VMs dashboard

**Importing Dashboard Examples**

1. Copy the `/etc/ovirt-engine-metrics/dashboards-examples` directory from the Manager virtual machine to your local machine.
2. Open Kibana and click the **Settings** tab.
3. Click the **Indices** tab.
4. Select **project.ovirt-metrics-&lt;ovirt-env-name>.&lt;uuid>** in the **Index Patterns** pane and click the **Refresh field list** ![](images/refresh.png) button.
5. Select the **project.ovirt-logs-&lt;ovirt-env-name>.&lt;uuid>** index and click **Refresh field list**.
6. Click the **Objects** tab.
7. Click **Import** and import **Searches** from your local copy of `/etc/ovirt-engine-metrics/dashboards-examples`.
8. Click **Import** and import **Visualizations**.

   **Note:** If you see an error message while importing the visualizations, check your hosts to ensure that Collectd and Fluentd are running without errors.

9. Click **Import** and import **Dashboards**.

   The imported dashboards are now stored in the system.

**Loading Saved Dashboards**

Once you have created and saved a dashboard, or imported Red Hat's sample dashboards, you can display them in the *Dashboard* tab:

1. Click the **Dashboard** tab.
2. Click the **Load Saved Dashboard** ![](images/loadSavedDashboard.png) button to display a list of saved dashboards.
3. Click a saved dashboard to load it.

