---
title: Ovirt Reports
category: documentation
authors: aglitke, dougsland, sandrobonazzola, sradco, yaniv dary
wiki_category: Documentation
wiki_title: Ovirt Reports
wiki_revision_count: 27
wiki_last_updated: 2015-01-14
---

# Ovirt Reports

oVirt reports package provides a suite of pre-configured reports that enable you to monitor the system. The reports module is based on JasperReports and JasperServer.

## JasperReports and JasperReports Server Overview

*   JasperReports is an open source Java reporting tool that can produce reports and export them to PDF, HTML, Microsoft Excel, RTF, ODT, Comma-separated values and XML files.
*   It generates the reports from an XML or .jasper file.
*   JasperReports Server is a reporting server for JasperReports. Using it you can generate, organize, secure and deliver interactive reports.

## oVirt Reports Topics

*   Executive – High level reports that highly summarize data on resources and system entities.
*   Inventory – Reports that list entities or display data about there status.
*   Service Level – Report that are used to examine system health and service quality to users.
*   Trends – Graphs that indicate resource usage for planning of resources.

== oVirt Engine Report & DWH included in oVirt >= 3.2 == The below steps includes historical statistics database and a set of predefined reports for use and SSO to be able to run these reports vi the webadmin.

       # yum install ovirt-engine-reports
       # ovirt-engine-dwh-setup
       # ovirt-engine-reports-setup
