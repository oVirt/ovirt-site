---
title: Performance And Scalability
authors: liran.zelkha
wiki_title: Features/Performance And Scalability
wiki_revision_count: 5
wiki_last_updated: 2013-06-11
---

# Performance And Scalability

## Goals

The goal of this page is to detail the performance optimizing and scalability improvement work done by the oVirt team, and to direct development resources to the most urgent tasks.

## Tasks

### Database Access

*   Caching

Implement ResultSet caching based on SimpleJdbcTemplate. See [http://gerrit.ovirt.org/#/c/14188/ Change](http://gerrit.ovirt.org/#/c/14188/_Change) for information on implementation.

*   Batch updates

Enable the option of sending multiple insert/update stored procedure calls as a single batch. See [http://gerrit.ovirt.org/#/c/15039/ Change](http://gerrit.ovirt.org/#/c/15039/_Change) for information on implementation.

*   Multi dimensional arrays

Using multiple dimensional arrays as stored procedure parameters to replace the use of fnspliter

### UI/Admin

*   Improve serialization performance

### UI/User

### Engine/VDSM Communication

*   Use HTTP 1.1 compression and keep-alive with VDSM XML-RPC

### General Code Improvement

*   Cache GUID creation
*   Merge NGUID/GUID/UUID
