---
title: FrontendRefactor
category: feature
authors: awels
wiki_category: Feature
wiki_title: Features/Design/FrontendRefactor
wiki_revision_count: 56
wiki_last_updated: 2014-04-30
---

# Frontend class re-factoring effort

#### Frontend public api method

The current implementation has the following methods exposed to the outside world:

*   RunQuery
    -   Execute a query and process the result. This method contains a mechanism for handling too many concurrent requests.
    -   The QueryWrapper class is used in the mechanism to handle too many concurrent requests.
    -   The most often used RunQuery, a quick search turns up 183 invocations of the method.
*   RunPublicQuery
    -   The same as RunQuery but without the mechanism for handling too many concurrent requests.
    -   Barely used at all, only 2 invocations, one from login, and one for looking up the rpm version to display in the about box.
*   RunMultipleQueries
    -   Take in a list of actions and parameters and run all all of them at once.
    -   Returns a list of return values, some of them may have failed. The callback is responsible for handling the list of results.
    -   This is no different from the above RunQuery with a list of one element.
    -   Rarely used, only 10 invocations.
*   RunAction
    -   Conceptually different from RunQuery in that an action modifies/creates/deletes something where a query does not make any changes. (CUD in CRUD)
*   RunMultipleAction(s)
*   LoginAsync
*   LogoffAsync
*   getLoggedInUser

##### Things to consider

*   Max number of concurrent connects from the browser to the server is limited, so we have to make sure to queue the requests. Also if the same of a request comes in while a previous one is still in the queue, we can discard that request. Since Frontend is a static class we need to introduce state into a stateless environment. We need a robust mechanism for detecting duplicate requests in the queue.
