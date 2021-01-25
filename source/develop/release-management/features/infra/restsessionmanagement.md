---
title: RESTSessionManagement
category: feature
authors: ovedo
---

# REST API session management

## Summary

The purpose of the feature is to add session management to the oVirt REST API.

## Owner

*   Name: Oved Ourfali (Ovedo)
*   Email: <ovedo@redhat.com>

## Current status

*   Finished implementation in oVirt 3.1

## Background

This feature is essential for certain types of ISV integration. Many ISVs need to mirror the oVirt inventory (i.e. all VMs, clusters, basically any object managed by oVirt) in real-time to their own database. The way they do this currently is by polling /api/events and look for changes. In order to be able to react to changes fast, they typically poll every 5 seconds. The query itself is very efficient, so it doesn't cause a whole lot of load on oVirt. But it floods the log with login/logout events. This persistent session feature is a solution for that.

## Requirements

1.  Provide a session management mechanism that would allow clients to use the oVirt API without requiring them to pass credentials on each call
2.  Reduce the overhead and also without the extra overhead of logging in and out in each request.
3.  Continue supporting the old mechanism, in which credentials are passed in every request (no login/logout optimization, just the same as today).

## Detailed Description

Today, when working with the API (via the CLI, SDK, curl, browser or any other web client), the credentials must be passed in each and every request made to the API. Also, in each such request the REST API initiates a login and logout to the engine core. The purpose of this feature is to allow clients to perform some initial login phase, work with the same session for multiple requests, and then close it (or leave it open until it is closed for inactivity).

## Implementation

The proposed implementation for that is to rely on cookies in the following way:

1.  First, the client does a request providing credentials, with a special Header field: "Prefer: persistent-auth".
2.  The server logs in to the engine-core, with a new generated session-id that is saved on the HTTP Session, and performs the required action. The JSESSIONID cookie is returned automatically to the client.
3.  The client gets the cookie, and (if he wants to) in the second request he passes it to the server, with the "Prefer" header to enable keeping the session. No need to pass credentials.
4.  Passing the credentials will re-authenticate, returning a new cookie.
5.  The server gets the cookie, validates the session using (getting the session-ID from the HTTP session attributes), performs the request, and returns. The session remains valid as the "Prefer" header was passed.
6.  Once the client passes the cookie but doesn't pass the "Prefer" header, the session is closed.

Notes:

*   Existing clients can continue working as they are working today. They just ignore the JSESSIONID cookie, and pass credentials on each call. No need to provide the "Prefer" header. The API will then do login and logout to the engine on each call.
*   If the session is expired, the client will be required to pass credentials again, resulting in a new session being created.
    1.  The client passes the "Prefer" header field on every request, besides the last one. When the server gets a request with a JSESSIONID, and without the "Prefer" header, it logs out the session.
*   Other options are:
*   Rely on session timeout for invalidation of sessions.
    1.  The client passes the "Prefer" header field only once (on start), and passes another header field when he finishes the work with the session.
*   The engine session ID is not the JSESSIONID. The

We decided to go with the first approach, passing the header on every request, and releasing the session once the header isn't passed.

Flow of using the Prefer header on each call:

      Client                                           Server
        |                                                |
        | ---------initial request with Prefer header--> |
        |                                          [login]
        | <----Set-Cookie:JSESSIONID=.....---------------|
        |                                                |
        | -----Cookie:JSESSIONID=.....+ Prefer header--->|
        |                               [validate session]
        | <----------------------------------------------|
        |                                                |
        | -----Cookie:JSESSIONID=.....+ Prefer header--->|
        |                               [validate session]
        | <----------------------------------------------|
        |                                                |
        |              ... time pases...                 |
        |                                                |
        | -----Cookie:JSESSIONID=.....------------------>|
        | [validate session. no Prefer header --> logout ]
        | <----------------------------------------------|
        |                                                |
       

Flow when relying on session timeout:

      Client                                           Server
        |                                                |
        | ---------initial request with Prefer header--> |
        |                                          [login]
        | <----Set-Cookie:JSESSIONID=.....---------------|
        |                                                |
        | -----Cookie:JSESSIONID=....................--->|
        |                               [validate session]
        | <----------------------------------------------|
        |                                                |
        | -----Cookie:JSESSIONID=....................--->|
        |                               [validate session]
        | <----------------------------------------------|
        |                                                |
        |              ... time pases...                 |
        |                                                |
        | -----Cookie:JSESSIONID=.....------------------>|
        |                               [validate session]
        | <----------------------------------------------|
        |                                                |
        |              ... time pases...                 |
        |                                                |
        |             [session timeout --> remove session]
        |                                                |
       

Flow when passing another header for ending sessions:

      Client                                           Server
        |                                                |
        | ---------initial request with Prefer header--> |
        |                                          [login]
        | <----Set-Cookie:JSESSIONID=.....---------------|
        |                                                |
        | -----Cookie:JSESSIONID=....................--->|
        |                               [validate session]
        | <----------------------------------------------|
        |                                                |
        | -----Cookie:JSESSIONID=....................--->|
        |                               [validate session]
        | <----------------------------------------------|
        |                                                |
        |              ... time pases...                 |
        |                                                |
        | -----Cookie:JSESSIONID=....., "Logout" header->|
        |                      [validate session. logout ]
        | <----------------------------------------------|
        |                                                |
       

## Scope

The scope of the feature is as follows:

*   Adding the mechanism to the REST API
*   Using this mechanism in the CLI/SDK

## Documentation / External references

1. On the HTTP Prefer header field: <http://tools.ietf.org/html/draft-snell-http-prefer-12>


