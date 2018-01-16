---
title: Build oVirt Report Using Grafana
author: sradco,
tags: oVirt, oVirt 4.2, open source virtualization, report, dwh
date: 2018-01-16 09:00:00 CET
---

[Grafana](https://grafana.com/), The open platform for beautiful analytics and monitoring,
adds support for [PostgreSQL](http://docs.grafana.org/features/datasources/postgres/).

It in now possible to connect Grafana to [oVirt DWH](https://www.ovirt.org/documentation/how-to/reports/dwh/),
in order to visualize and monitor the oVirt environment.

**Grafana dashboard example**
![](/images/grafana_dashboard_example.png)

READMORE

If you wish to create dashboards to monitor Ovirt environment, you will need to [install Grafana](http://docs.grafana.org/installation/rpm/).

Grafana automatically create and admin [user](http://docs.grafana.org/installation/configuration/#admin-user) and [password](http://docs.grafana.org/installation/configuration/#admin-password).

You will need to add a [PostgreSQL data source](http://docs.grafana.org/features/datasources/graphite/#adding-the-data-source) that connects to the DWH database.

For example:
![](/images/grafana_data_source_example.png)

Now you can start creating your dashboard widgets.

Go to `Dashboards` -> `+ New`.



**Graph panel example:**

To add a `Graph` type panel, on the left side you have the [Row controls menu](http://docs.grafana.org/guides/getting_started/#dashboards-panels-rows-the-building-blocks-of-grafana).
Go to the `+ Add Panel`, and pick `Graph`.

Query example for the - Five Most Utilized Hosts by Memory / CPU:

    SELECT DISTINCT
        min(time) AS time,
        MEM_Usage,
        host_name || 'MEM_Usage' as metric
    FROM (
        SELECT
            stats_hosts.host_id,
            CASE
                WHEN delete_date IS NULL
                    THEN host_name
                ELSE
                    host_name
                    ||
                    ' (Removed on '
                    ||
                    CAST ( CAST ( delete_date AS date ) AS varchar )
                    ||
                    ')'
            END AS host_name,
            stats_hosts.history_datetime AS time,
            SUM (
                COALESCE (
                    stats_hosts.max_cpu_usage,
                    0
                ) *
                COALESCE (
                    stats_hosts.minutes_in_status,
                    0
                )
            ) /
            SUM (
                COALESCE (
                    stats_hosts.minutes_in_status,
                    0
                )
            ) AS CPU_Usage,
            SUM (
                COALESCE (
                    stats_hosts.max_memory_usage,
                    0
                ) *
                COALESCE (
                    stats_hosts.minutes_in_status,
                    0
                )
            ) /
            SUM (
                COALESCE (
                    stats_hosts.minutes_in_status,
                    0
                )
            ) AS MEM_Usage
        -- If "Period" equals to "Daily" then "table_name"
        -- parameter equals to "hourly" else "daily"
        FROM v4_2_statistics_hosts_resources_usage_hourly AS stats_hosts
            INNER JOIN v4_2_configuration_history_hosts
                ON (
                    v4_2_configuration_history_hosts.host_id =
                    stats_hosts.host_id
                )
        WHERE  stats_hosts.history_datetime >= $__timeFrom()
        AND stats_hosts.history_datetime < $__timeTo()
            -- Here we get the latest hosts configuration
           AND  v4_2_configuration_history_hosts.history_id IN (
                SELECT MAX ( a.history_id )
                FROM v4_2_configuration_history_hosts AS a
                GROUP BY a.host_id
            )
            AND stats_hosts.host_id IN (
                SELECT a.host_id
                FROM v4_2_statistics_hosts_resources_usage_hourly a
                    INNER JOIN v4_2_configuration_history_hosts b
                        ON ( a.host_id = b.host_id )
                WHERE
                    -- Here we filter by active hosts only
                    a.host_status = 1
                    -- Here we filter by the datacenter chosen by the user
                     AND b.cluster_id IN (
                        SELECT v4_2_configuration_history_clusters.cluster_id
                        FROM v4_2_configuration_history_clusters
                        WHERE
                            v4_2_configuration_history_clusters.datacenter_id =
                            $datacenter_id
                    )
                    -- Here we filter by the clusters chosen by the user
                    AND b.cluster_id IN ($cluster_id)
                    AND a. history_datetime >= $__timeFrom()
                    AND a.history_datetime < $__timeTo()
                    -- Here we get the latest hosts configuration
                    AND b.history_id IN (
                        SELECT MAX (g.history_id)
                        FROM v4_2_configuration_history_hosts g
                        GROUP BY g.host_id
                    )
                    -- The "is_deleted" parameter chosen by the user determines
                    -- whether to include deleted entities or not
                    --$is_deleted
                GROUP BY a.host_id
                ORDER BY
                    -- Hosts will be ordered according to the summery of
                    -- memory and CPU usage percent.
                    --This determines the busiest hosts.
                    SUM (
                        COALESCE (
                            a.max_memory_usage * a.minutes_in_status,
                            0
                        )
                    ) /
                    SUM (
                        COALESCE (
                            a.minutes_in_status,
                            0
                        )
                    ) +
                    SUM (
                        COALESCE (
                            a.max_cpu_usage * a.minutes_in_status,
                            0
                        )
                    ) /
                    SUM (
                        COALESCE (
                            a.minutes_in_status,
                            0
                        )
                    ) DESC
                LIMIT 5
            )
    GROUP BY
        stats_hosts.host_id,
        host_name,
        delete_date,
        history_datetime
    ) AS a
    GROUP BY a.host_name, a.mem_usage
    ORDER BY time


The query uses the [Templateing](http://docs.grafana.org/reference/templating/) feature, to enable input controls.

You will need to add the following templates:

| Variable Name   | Label | Type | Data source | Query | Hide | Multi-value | Include All option |
|-----------------|-------|------|-------------|-------|------|-------------|--------------------|
| userlocale      | Language    | Query |`Choose your data source from the list` | SELECT DISTINCT language_code from enum_translator | | | |
| datacenter_name | Data Center | Query |`Choose your data source from the list` | SELECT DISTINCT datacenter_name FROM v4_2_configuration_history_datacenters | | | |
| datacenter_id   |             | Query |`Choose your data source from the list` | SELECT DISTINCT datacenter_id FROM v4_2_configuration_history_datacenters WHERE datacenter_name=$datacenter_name | Variable | | |
| cluster_name    | Cluster     | Query |`Choose your data source from the list` | SELECT cluster_name FROM v4_2_configuration_history_clusters WHERE datacenter_id = $datacenter_id | | Yes | Yes |
| cluster_id      |             | Query |`Choose your data source from the list` | SELECT cluster_id FROM v4_2_configuration_history_clusters WHERE datacenter_id = $datacenter_id | Variable | Yes | Yes |
| hostname        | Host        | Query |`Choose your data source from the list` | SELECT host_name FROM v4_2_configuration_history_hosts WHERE cluster_id IN ($cluster_id) | | | |
| host_id         |             | Query |`Choose your data source from the list` | SELECT host_id FROM v4_2_configuration_history_hosts WHERE host_name = $hostname | Variable | | |
| show_deleted    | Show deleted entities? | Query |`Choose your data source from the list` | SELECT DISTINCT coalesce( enum_translator_localized.value_localized, enum_translator_default.value ) as display FROM enum_translator as enum_translator_default LEFT OUTER JOIN ( SELECT enum_type, enum_key, value as value_localized FROM enum_translator WHERE language_code = $userlocale ) as enum_translator_localized ON ( enum_translator_localized.enum_type = enum_translator_default.enum_type AND enum_translator_localized.enum_key = enum_translator_default.enum_key ) WHERE language_code = 'en_US' AND enum_translator_default.enum_type = 'REPORTS_SHOW_DELETED'  | | | |
| is_deleted      |             | Query |`Choose your data source from the list` | SELECT DISTINCT  CASE WHEN enum_key = 0  THEN 'AND delete_date IS NULL'  ELSE ''  END FROM enum_translator WHERE value = $show_deleted AND enum_type = 'REPORTS_SHOW_DELETED' | | | |
