---
title: Build oVirt Reports Using Grafana
author: sradco,
tags: oVirt, oVirt 4.2, open source virtualization, report, dwh
date: 2018-06-24 09:00:00 CET
---

[Grafana](https://grafana.com/), The open platform for beautiful analytics and monitoring,
recently added support for [PostgreSQL](http://docs.grafana.org/features/datasources/postgres/).

It in now possible to connect Grafana to [oVirt DWH](https://www.ovirt.org/documentation/how-to/reports/dwh/),
in order to visualize and monitor the oVirt environment.

**Grafana dashboard example**
![](/images/grafana_dashboard_example.png)

READMORE

If you wish to create dashboards to monitor oVirt environment, you will need to [install Grafana](http://docs.grafana.org/installation/rpm/). Please follow the rest of the installation instructions to [start the Grafana server](http://docs.grafana.org/installation/rpm/#start-the-server-via-systemd) and [enable it](http://docs.grafana.org/installation/rpm/#enable-the-systemd-service-to-start-at-boot).

**Note:** Please do not install Grafana on the engine machine.

Grafana automatically creates an admin [user](http://docs.grafana.org/installation/configuration/#admin-user) and [password](http://docs.grafana.org/installation/configuration/#admin-password).

You will need to add a [PostgreSQL data source](http://docs.grafana.org/features/datasources/graphite/#adding-the-data-source) that connects to the DWH database.

For example:
![](/images/grafana_data_source_example.png)

You may want to add a read only user to connect the history database :

**Note:** In oVirt 4.2 we ship postgres 9.5 through the Software Collection. 
1. In order to run psql you will need to run:
     
       # su - postgres 
       # scl enable rh-postgresql95 -- psql ovirt_engine_history
**Allowing Read-Only Access to the History Database**
2. Create the user to be granted read-only access to the history database:

       # CREATE ROLE [user name] WITH LOGIN ENCRYPTED PASSWORD '[password]';
3. Grant the newly created user permission to connect to the history database:

       # GRANT CONNECT ON DATABASE ovirt_engine_history TO [user name];
4. Grant the newly created user usage of the public schema:

       # GRANT USAGE ON SCHEMA public TO [user name];
5. Exit the database
   
       # \q
6. Generate the rest of the permissions that will be granted to the newly created user and save them to a file:

       # scl enable rh-postgresql95 -- psql -U postgres -c "SELECT 'GRANT SELECT ON ' || relname || ' TO [user name];' FROM pg_class JOIN pg_namespace ON pg_namespace.oid = pg_class.relnamespace WHERE nspname = 'public' AND relkind IN ('r', 'v');" --pset=tuples_only=on  ovirt_engine_history > grant.sql
7. Use the file you created in the previous step to grant permissions to the newly created user:

       # scl enable rh-postgresql95 -- psql -U postgres -f grant.sql ovirt_engine_history
8. Remove the file you used to grant permissions to the newly created user:

       # rm grant.sql

9. Ensure the database can be accessed remotely by enabling md5 client authentication. Edit the /var/opt/rh/rh-postgresql95/lib/pgsql/data/pg_hba.conf file, and add the following line immediately underneath the line starting with local at the bottom of the file, replacing user_name with the new user you created:

       host    database_name    user_name    0.0.0.0/0   md5
10. Allow TCP/IP connections to the database. Edit the /var/opt/rh/rh-postgresql95/lib/pgsql/data/postgresql.conf file and add the following line:

        listen_addresses='*'
11. Restart the postgresql service:

        # systemctl restart rh-postgresql95-postgresql


Now you can start creating your dashboard widgets.

**Creating a Dashboard**

Go to `Dashboards` -> `+ New`.


First create the variables required for building the different widgets:

The graph example below uses the [Variables](http://docs.grafana.org/reference/templating/) feature, to enable drop down input controls that allows taggling between differen datacenters / cluster / hosts etc.


You will need to [add the following variables](https://www.ovirt.org/blog/2018/06/ovirt-report-using-grafana/):

| Variable Name   | Label | Type | Data source | Query | Hide | Multi-value | Include All option |
|-----------------|-------|------|-------------|-------|------|-------------|--------------------|
| userlocale      | Language    | Query |`Choose your data source from the list` | SELECT DISTINCT language_code from enum_translator | | | |
| datacenter_name | Data Center | Query |`Choose your data source from the list` | SELECT DISTINCT datacenter_name FROM v4_2_configuration_history_datacenters | | | |
| datacenter_id   |             | Query |`Choose your data source from the list` | SELECT DISTINCT datacenter_id FROM v4_2_configuration_history_datacenters WHERE datacenter_name='$datacenter_name' | Variable | | |
| cluster_name    | Cluster     | Query |`Choose your data source from the list` | SELECT cluster_name FROM v4_2_configuration_history_clusters WHERE datacenter_id = '$datacenter_id' | | Yes | Yes |
| cluster_id      |             | Query |`Choose your data source from the list` | SELECT cluster_id FROM v4_2_configuration_history_clusters WHERE datacenter_id = '$datacenter_id' | Variable | Yes | Yes |
| hostname        | Host        | Query |`Choose your data source from the list` | SELECT host_name FROM v4_2_configuration_history_hosts WHERE cluster_id IN ('$cluster_id') | | | |
| host_id         |             | Query |`Choose your data source from the list` | SELECT host_id FROM v4_2_configuration_history_hosts WHERE host_name = '$hostname' | Variable | | |


**Note:** All the queries are based on the DWH views that are supported also when upgrading to the next oVirt release.
In order to use the latest views you please update the DWH v4_2 prefixes to the prefix of your setup version.

**Graph panel example:**

To add a `Graph` type panel, on the left side you have the [Row controls menu](http://docs.grafana.org/guides/getting_started/#dashboards-panels-rows-the-building-blocks-of-grafana).
Go to the `+ Add Panel`, and pick `Graph`.

Query example for the - Five Most Utilized Hosts by Memory / CPU:

```
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
                        '$datacenter_id'
                )
                -- Here we filter by the clusters chosen by the user
                AND b.cluster_id IN ('$cluster_id')
                AND a. history_datetime >= $__timeFrom()
                AND a.history_datetime < $__timeTo()
                -- Here we get the latest hosts configuration
                AND b.history_id IN (
                    SELECT MAX (g.history_id)
                    FROM v4_2_configuration_history_hosts g
                    GROUP BY g.host_id
                )
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
```

**Note:** In this example we dont use the `Host` variable, so you can not filter the results by it.
