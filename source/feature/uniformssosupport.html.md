---
title: UniformSSOSupport
category: feature
authors: ovedo, rnori
wiki_category: Feature
wiki_title: Features/UniformSSOSupport
wiki_revision_count: 30
wiki_last_updated: 2014-10-16
---

# Uniform SSO Support

## Picketlink Integration

### Summary

This document describes the new web application SSO infrastructure in the engine core. This infrastructure will enable moving between oVirt web applications, without having to authenticating each one of them separately.

### Owner

*   Feature owner: [ Oved Ourfali](User:Ovedo)
*   Email: ovedo@redhat.com

### Motivation

There were several key points in the motivation for this project:

*   With the upcoming integration between Webadmin and the Reports server, the need to be able to view reports without re-authenticating is crucial.
*   3rd party applications can authenticate using this infrastructure as well, allowing them to perform operations on the different oVirt web applications, without the need to re-authenticate.

### Introduction

Currently, the engine uses LDAP domains, and internal admin domain in order to authenticate (when using the API, Webadmin, UP). When using jasperserver, a whole different infrastructure is used in order to authenticate, as it contains its own set of users. Nowadays, integration of the Webadmin and the reports server is under-way, thus introducing the need to be able to authenticate to Webadmin, and automatically be able to view reports, without the need to re-authenticate.

#### Basic annotations

*   SAML - Stands for Security Assertion Markup Language is an XML-based open standard for exchanging authentication and authorization data between security domains, that is, between an identity provider (a producer of assertions) and a service provider (a consumer of assertions). A service provider relies on an identity provider to identify a principal. At the principal's request, the identity provider passes a SAML assertion to the service provider. On the basis of this assertion, the service provider makes an access control decision.
*   Picketlink - Picketlink is a Jboss project, providing SAML v2.0 based SSO solution for web applications.
*   IDP - Identity provider. The entity which is responsible for identifying a principal trying to connect to the application.
*   SP - Service provider. The service itself, which needs to get information on who is the principal already connected to the system.

![](Picketlink1.png "Picketlink1.png")

### Solution Architecture

In our solution we have the following players:

*   IDP - web application, part of the engine EAR, which is responsible for authenticating and providing information on the logged-in principal, using SAML.
*   The engine login module - used to perform the authentication process using the existing engine infrastructure. The IDP uses this login module.
*   The SPs - for start, the service providers which will use this infrastructure is the Webadmin, and the reports server.

![](Picketlink_img2.png "Picketlink_img2.png")

#### Login flow

1.  The user will try to contact the Webadmin application
2.  If it is not logged in yet
    1.  Post the request to the IDP, showing a login screen to the user (asking for username, password and domain)
    2.  The user logs in
    3.  The credentials go to the login module, passed to the engine core, and authentication is performed
    4.  If the authentication is succeeded, a session is created in the engine core (as today)

3.  If it is already logged in
    1.  Get the session ID
    2.  Continue working in the session

Same flow goes for the Reports server.

Now, the user would like to view a report:

1.  The browser accesses the Reports server through webadmin (or directly)
2.  It is already logged in (when accessing through webadmin we are already logged in), so no need to authenticate, and the reports server identifies him as the user logged in (e.g, admin@internal, user1@domain1, etc.)

#### Logout flow

Picketlink supports "Global logout", i.e. logging out through the IDP, which basically means the user is no longer logged in, and access to any web application will result in requesting the user to login.

For example, if the SP link is <http://host.domain/sp> then the global logout link is at <http://host.domain/sp?GLO=true>. This will go the the IDP, and call the logout method of the login module, clearing the session at the engine core side.

### Current status

*   Target Release:
*   Status: Design Stage
*   Last updated date: Wed November 10 2011

### Dependencies / Related Features and Projects

Affected oVirt projects:

### Documentation / External references

1.  Picketlink homepage - <http://www.jboss.org/picketlink>
2.  PicketLink Federation - <http://www.jboss.org/picketlink/Fed.html>
3.  User Guide (PDF) - <http://community.jboss.org/servlet/JiveServlet/download/14645-5-7349/UserGuide.pdf>

### Comments and Discussion

### Future Work

### Gaps / Open Issues

*   The SAML standard doesn't support session time-outs. Not sure it is such an issue, as we can keep the session valid at the engine side
*   Locale for the reports server - the locale in the reports server is set in its login screen. In our case we need to find some other way to do so. There is a way to do this for single reports, but if someone will want to browse to the reports server, and not just view reports through webadmin, then the locale won't be set.

[Category: Feature](Category: Feature)
