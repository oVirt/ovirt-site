# Using the Visualization Editor

Use the visualization editor to create visualizations by:

* [#submitting-search-queries](Submitting search queries from the toolbar)
* [#selecting-metrics-and-aggregations](Selecting metrics and aggregations from the aggregation builder)

## Submitting Search Queries

Use the toolbar to perform search queries based on the Lucene query parser syntax. For a detailed explanation of this syntax, see [Apache Lucene - Query Parser Syntax](https://lucene.apache.org/core/2_9_4/queryparsersyntax.html).

## Selecting Metrics and Aggregations  

Use the aggregation builder to define which metrics to display, how to aggregate the data, and how to group the results.

The aggregation builder performs two types of aggregations, metric and bucket, which differ depending on the type of visualization you are creating:

* Bar, line, or area chart visualizations use **metrics** for the y-axis and **buckets** for the x-axis, segment bar colors, and row/column splits.

* Pie charts use **metrics** for the slice size and **buckets** to define the number of slices.

**To define a visualization from the aggregation bar:**

1. Select the metric aggregation for your visualization’s y-axis from the **Aggregation** drop-down list in the **metrics** section, for example, count, average, sum, min, max, or unique count. For more information about how these aggregations are calculated, see [Metrics Aggregation](https://www.elastic.co/guide/en/elasticsearch/reference/2.3//search-aggregations-metrics.html) in the Elasticsearch Reference documentation.

2. Use the **buckets** area to select the aggregations for the visualization’s x-axis, color slices, and row/column splits:

   1. Use the **Aggregation** drop-down list to define how to aggregate the bucket. Common bucket aggregations include date histogram, range, terms, filters, and significant terms.

      **Note:** The order in which you define the buckets determines the order in which they will be executed, so the first aggregation determines the data set for any subsequent aggregations. For more information, see [Aggregation Builder](https://www.elastic.co/guide/en/kibana/4.5/visualize.html#aggregation-builder) in the Kibana documentation.

   2. Select the metric you want to display from the **Field** drop-down list. For details about each of the available metrics, see [Metrics Schema](../Metrics_Schema).

   3. Select the required interval from the **Interval** field. 

3. Click **Apply Changes** ![](images/create.png).

