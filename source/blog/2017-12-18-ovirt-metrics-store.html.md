---
title: Monitor Your oVirt Environment with oVirt Metrics Store
author: sradco
tags: oVirt Metrics Store
date: 2017-12-04 09:00:00 CET
---

The oVirt project now includes a unified metrics and logs real-time monitoring solution for the oVirt environment.

Using Elasticsearch - a search and analytics engine - and its native visualization layer, Kibana, we now provide oVirt project users with a fully functional monitoring solution.

READMORE

The solution includes self-service dashboards for creating your own dashboard, reports, and log analysis for both the engine and VDSM logs.

**The Kibana dashboard**
![](/images/Kibana_dashboard.png)

Combining Elasticsearch and kibana - both built on top of the OpenShift Container Platform (OCP) - with the collectd and fluentd client-side daemons, results in a powerful end-to-end solution.

For additional details, including how to set up the oVirt Metrics Store, please see:

- [oVirt Metrics Store Feature page](/develop/release-management/features/metrics/metrics-store/)
- [Deep Dive to oVirt Metrics Store - Google slides](https://docs.google.com/presentation/d/1bP7HJLyBTyRfCmVnz03imM4PYYFWYrEhKT4NTLH8fOI/edit#slide=id.g2b2b8fd6eb_1_245)
- [Deep Dive to oVirt Metrics Store - recording](https://saml.redhat.com/idp/?SAMLRequest=fZLNbsIwEITvfQrL9%2Fw4QAgWCYIi1FQtjSD00EtlHFPSJnbqdWj79k0CSHDhas3O7Hzr8eS3LNBBaMiVDDGxXYyE5CrL5UeIN%2BnCCvAkuhsDKwuvotPa7OVKfNcCDJoCCG2auXsloS6FXgt9yLnYrJ5CvDemAuo426IWn4JJsLkqHQDldFYORvE8xO%2F%2BkPdcttv2PbIbsWznjoa%2Bx8jA9TLCBem5fTfbEt5sFQPUIpZgmDQh9lwytIhnkSAlPdrzKRnYQeC%2FYZRoZRRXxSyXxxK1llQxyIFKVgqghtP19PmJerZLt0cR0Ic0TazkZZ12Boc8E3rZqEM8a%2FZHj20BtBTmR%2BkvjF7PuLwWVwNQAj0Cup1WnVbD0ZEn7TrpS4fbBuxMHEct3wZvOwSVfUV57Fy6R%2BfbtX3ieaKKnP%2BhhdIlM7fT2pc8s3adlFZtaTBCGuxEp4jrDxH9Aw%3D%3D&RelayState=eyJncm91cCI6MTM1NCwibW9kZSI6ImF1dGgiLCJyZWRpcmVjdFVyaSI6Imh0dHBzOi8vYmx1ZWpl%0AYW5zLmNvbS9wbGF5YmFjay9zL1NETTF1U0NXTEFIWnJTTjdaTU1hNHFwMW51eE5Kam9UR2ZmZWpv%0AUFRZc1BFUnpsWTRrS1RyUHlaVDYxVXR3c2EiLCJnZW5lcmF0ZVJlZnJlc2hUb2tlbiI6ZmFsc2V9%0A)
