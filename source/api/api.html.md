---
title: Api
category: api
authors: michael pasternak, quaid
wiki_title: Category:Api
wiki_revision_count: 36
wiki_last_updated: 2013-09-23
---

# Api

oVirt api package provides Application programming interface for the oVirt engine.

## JasperReports and JasperReports Server Overview

*   JasperReports is an open source Java reporting tool that can produce reports and export them to PDF, HTML, Microsoft Excel, RTF, ODT, Comma-separated values and XML files.
*   It generates the reports from an XML or .jasper file.
*   JasperReports Server is a reporting server for JasperReports. Using it you can generate, organize, secure and deliver interactive reports.

## oVirt Reports Topics

*   Executive – High level reports that highly summarize data on resources and system entities.
*   Inventory – Reports that list entities or display data about there status.
*   Service Level – Report that are used to examine system health and service quality to users.
*   Trends – Graphs that indicate resource usage for planning of resources.

oVirt api package provides Application programming interface for the oVirt engine..

__TOC__

## REST Concept

*   Client–server
*   Stateless
*   Cacheable
*   Uniform interface

## REST Principals

*   Identification of resources
*   Manipulation of resources through representations
*   Self-descriptive
*   Hypermedia as the engine of application state

## oVirt-API URI structure

http(s)://server:port/api/vms/xxx-xxx/disks/yyy-yyy ------- ----------- --- --- ------- ----- -----

        1           2       3   4     5      6      7

1. protocol

2. server details

3. entry point (base resource)

4. collection

5. resource

6. sub-collection

7. sub-resource

<Category:Api>
