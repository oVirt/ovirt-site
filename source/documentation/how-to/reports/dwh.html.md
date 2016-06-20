---
title: oVirt DWH
category: documentation
authors: quaid, sradco, yaniv dary
wiki_category: Documentation
wiki_title: Ovirt DWH
wiki_revision_count: 5
wiki_last_updated: 2015-01-14
---

<!-- TODO: Content review -->

# Ovirt DWH

A historic database that allows users to create reports over a static API using business intelligence suites that enable you to monitor the system. This package contains the ETL (Extract Transform Load) process created using Talend Open Studio and DB scripts to create a working history DB.

## oVirt Engine DWH Views

The engine API for the ETL that Creates a more user friendly interface of the engine tables and gaps the differences between the engine to the history database tables. It is the first stage in data transformation

## DB Tables and API Views Information

*   Sample data is collected at the end of every minute and is kept for up to 48 hours.
*   Hourly level is aggregated every hour for the hour before last and is kept for 2 months.
*   Daily level is aggregated every day for the day before last and is kept for 5 years.
*   Upgrade is done via reentrent PL/pgSQL files.

## Prerequisites

<b>Please notice:</b> For a local oVirt DWH installation we assume you have already installed ovirt-engine on this machine before trying to install ovirt-engine-dwh.

In oVirt Engine 3.5 it is now possible to setup oVirt DWH on a separate machine. please refer to [Separate-DWH-Host](Features/Separate-DWH-Host) for details.

== oVirt Engine DWH included in oVirt >= 3.4 ==

The below steps includes historical statistics database and a set of predefined reports for use and SSO to be able to run these reports vi the webadmin.

       # yum install ovirt-engine-dwh
       # engine-setup

From 3.4.0 both ovirt-engine-dwh is configurable by just running engine-setup. They're now available also on CentOS but you may need to add the jpackage repository[1] in order to satisfy package dependencies.

[1] <http://mirrors.dotsrc.org/jpackage/6.0/generic/free/repoview/>

== oVirt Engine DWH included in oVirt >= 3.2 < 3.4 == The below steps includes historical statistics database.

       # yum install ovirt-engine-dwh
       # ovirt-engine-dwh-setup

## oVirt Engine Reports

oVirt reports package provides a suite of pre-configured reports that enable you to monitor the system. The reports module is based on JasperReports and JasperServer. Please refer to [Ovirt_Reports](Ovirt_Reports) for details.

<Category:Documentation> <Category:DWH>
