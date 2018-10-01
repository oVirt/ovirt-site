# Analyzing Logs

Use the **Discover** page to interactively explore the data collected from Red Hat Virtualization. Each set of results that is collected is referred to as a *document*. Documents are collected from the following log files:

* **engine.log** contains all Red Hat Virtualization Manager UI crashes, Active Directory lookups, database issues, and other events.

* **vdsm.log** is the log file for VDSM, the Manager's agent on the virtualization host(s), and contains host-related events.


## Graphic User Interface Elements

The distribution of documents over time is displayed in a histogram at the top of the page. By default the information is grouped into 30 second intervals, but this can be changed by clicking the time drop-down list that appears above the histogram.

**Histogram**

![](images/histogram.png)

The bottom of the page displays the documents in a table, sorted according to time.

**Documents Table**

![](images/doctable.png)


## Using the Discover Page

From the **Discover** page you can:

* [Set the time filter](#setting-the-time-filter)
* [Submit search queries](#searching-your-data)
* [Filter the search results](#filtering-by-field)
* [View the results in the Visualization page](#visualizing-log-data)
* [Customize the Documents table](#customizing-the-documents-table)


## Setting the Time Filter


#FIXME below

By default, data from the last 15 minutes is displayed. There are several ways to change the time filter:

* Click the time filter ![](images/timefilter.png) and either select a predefined time filter or define a time range from the **Relative** or **Absolute** menus.
* Define a filter directly from the histogram by clicking a bar or click and drag over several bars.
For more information, see [Setting the Time Filter](https://www.elastic.co/guide/en/kibana/4.5/discover.html#set-time-filter) in the Kibana documentation. 


## Searching Your Data

Use the search field at the top of the page to filter the results according to a specific value. For example, to display results containing the word "login", type `&#42;login&#42;` in the search field. For more information about searches, see [Searching Your Data](https://www.elastic.co/guide/en/kibana/4.5/discover.html#search) in the Kibana documentation.


## Filtering By Field

Filtering log data by field enables you to focus on the specific error that interests you. 

**To filter the log data by field:**

1. Click the name of the field you want to filter on from the *Available Fields* pane. This displays the top five values for that field. To the right of each value, there are two magnifying glass buttons, one for adding a regular (positive) filter, and one for adding a negative filter.

   **Available Fields**

   |Available Field |Description |
   |-
   |_id |The unique ID of the document.|
   |_index |The ID of the index to which the document belongs. The index with the _project.ovirt-logs_ prefix is the only relevant index in the **Discover** page.|
   |hostname |For the engine.log this is the hostname of the Manager. For the vdsm.log this is hostname of the host.|
   |level |The log record's severity: TRACE, DEBUG, INFO, WARN, ERROR, FATAL.|
   |message |The body of the document's message.|
   |ovirt.class |The name of a Java class that produced this log.|
   |ovirt.correlationid |For the engine.log only. This ID is used to correlate the multiple parts of a single task performed by the Manager.|
   |ovirt.thread |The name of a Java thread inside which the log record was produced.|
   |tag |Predefined sets of metadata that can be used to filter the data.|
   |@timestamp |The [time](../Troubleshooting#information-is-missing-from-kibana) that the record was issued.|
   |_score |N/A|
   |_type |N/A|
   |ipaddr4 | The machine's IP address.|
   |ovirt.cluster_name |For the vdsm.log only. The name of the cluster to which the host belongs.|
   |ovirt.engine_fqdn |The Manager's FQDN.|
   |ovirt.module_lineno |The file and line number within the file that ran the command defined in _ovirt.class_.|
   |pipeline_metadata.collector.inputname |N/A|
   |pipeline_metadata.collector.ipaddr4 |N/A|
   |pipeline_metadata.collector.ipaddr6 |N/A|
   |pipeline_metadata.collector.name |N/A|
   |pipeline_metadata.collector.received_at |N/A|
   |pipeline_metadata.collector.version |N/A|
   |service |The log file from which the document was extracted. |

3. To add a positive filter, click the **Positive Filter** button ![](images/PositiveFilter.png). This filters out results that do not contain that value in the field.

4. To add a negative filter, click the **Negative Filter** button ![](images/NegativeFilter.png). This excludes results that contain that value in the field. 

   For more information about working with filters, see [Working with Filters](https://www.elastic.co/guide/en/kibana/4.5/discover.html#discover-filters) in the Kibana documentation.


## Visualizing Log Data

You can visualize and aggregate log data in the **Visualization** page by selecting a specific field from within the **Discover** page.

**To visualize log data:**

1. Click the name of the field you want to visualize from the **Available Fields** pane (see [Filtering By Field(#filtering-by-field)).

2. Click the **Visualize** button that appears beneath the top five values.

   You are transferred to the **Visualize** page where you can view the filtered value in a graphical format. 


## Customizing the Documents Table

You can customize the way that the data is displayed in the Documents table by adding fields to the table as columns and changing the display order. 

**To add fields to the table as columns:**

1. Hover over the name of the field you want to add to the documents table from the **Available Fields** pane (see [Filtering By Field(#filtering-by-field)).

2. Click **add**. The field is added to the table.

3. Optionally click the **Sort by** arrow ![](images/arrow.png) that appears next to the column title to sort the results by that column.

