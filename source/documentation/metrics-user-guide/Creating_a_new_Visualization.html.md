# Creating a New Visualization

Use the **Visualize** page to design data visualizations based on the metrics or log data collected by Metrics Store.
You can save these visualizations, use them individually, or combine visualizations into a dashboard.
A visualization can be based on one of the following data source types:

* A new interactive search
* A saved search
* An existing saved visualization 

Visualizations are based on Elasticsearch's [aggregation feature](https://www.elastic.co/guide/en/elasticsearch/reference/2.3/search-aggregations.html).

**Creating a New Visualization**

Kibana guides you through the creation process with the help of a visualization wizard.

1. To start the new visualization wizard, click the *Visualize* tab. 
2. In step 1, *Create a new visualization table*, select the type of visualization you want to create.
3. In step 2, *Select a search source*, select whether you want to create a new search or reuse a saved search:
   * To create a new search, select **From a new search** and enter the [indexes](../Index) to use as the source. Use *project.ovirt-logs* prefix for log data or *project.ovirt-metrics* prefix for metric data. 
   * To create a visualization from a saved search, select **From a saved search** and enter the name of the search.

     The [visualization editor](../Graphic_User_Interface_Elements) appears.



