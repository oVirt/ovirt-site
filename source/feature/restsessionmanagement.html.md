---
title: RESTSessionManagement
category: feature
authors: ovedo
wiki_category: Feature
wiki_title: Features/RESTSessionManagement
wiki_revision_count: 17
wiki_last_updated: 2012-12-11
---

# REST API session management

### Summary

The purpose of the feature is to add session management to the oVirt REST API.

### Owner

*   Name: [ Oved Ourfali](User:Ovedo)
*   Email: <ovedo@redhat.com>

### Current status

*   Design phase

### Requirements

1.  Provide a session management mechanism that would allow clients to use the oVirt API without requiring them to pass credentials on each call
2.  Reduce the overhead and also without the extra overhead of logging in and out in each request.
3.  Continue supporting the old mechanism, in which credentials are passed in every request (no login/logout optimization, just the same as today).

### Detailed Description

Today, when working with the API (via the CLI, SDK, curl, browser or any other web client), the credentials must be passed in each and every request made to the API. Also, in each such request the REST API initiates a login and logout to the engine core. The purpose of this feature is to allow clients to perform some initial login phase, work with the same session for multiple requests, and then close it (or leave it open until it is closed for inactivity).

### Implementation

The proposed implementation for that is to rely on cookies in the following way:

1.  First, the client does a request the same as today, providing credentials.
2.  The server logs in to the engine, and performs the required action. In addition, it returns a new cookie called "saveSession" with the value "true".
3.  The client get the cookie, and (if he wants to) in the second request he passes it to the server.
4.  The server gets the "saveSession" cookie was passed with the value "true", and it logs in, performs the request, and returns a new cookie called "sessionId", with the engine session ID as the value.
5.  The client gets the "sessionId" cookie, and passes it (with the "saveSession" cookie) in all the subsequent requests, without the need to pass credentials.
6.  The server gets the "sessionId" cookie, it checks the session and who is the logged-in user in this session.
7.  After few such requests the client can choose to close the session, using the "saveSession" cookie, with a value of "false" (note that if it isn't used then the session will be closed after some timeout).
8.  The server sees this cookie, and it closes the session.

Diagram of all phases:

      Client                                           Server
        |                                                |
        | ------------initial request------------------> |
        |                                         [login/logout]
        | <----Set-Cookie:saveSession=true---------------|
        |                                                |
        | -----Cookie:saveSession=true------------------>|
        |                                           [login only]
        | <----Set-Cookie:sessionId=X--------------------|
        |                                                |
        | -----Cookie:sessionId=X----------------------->|
        |                             [uses the sessionID]
        | <----------------------------------------------|
        |                                                |
        | -----Cookie:sessionId=X----------------------->|
        |                             [uses the sessionID]
        | <----------------------------------------------|
        |                                                |
        |              ... time pases...                 |
        |                                                |
        | -----Cookie:sessionId=X;saveSession=false----->|
        |                [uses the sessionID and logs out]
        | <----------------------------------------------|
        |                                                |
       

### Documentation / External references

### Comments/Discussion/Issues

Several improvements that can be done in the protocol:

1.  Cookie expiration - use some expiration on the sessionId cookie. Upon expiration the API might renew it and return a new sessionId, or return an error and let the client do the procedure again.

Questions:

1.  Do we need encryption/decryption in these cookies?

<Category:Feature> <Category:Template>
