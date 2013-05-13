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

#### Frontend public api methods

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
    -   Conceptually different from RunQuery in that an action creates/updates/deletes something where a query does not make any changes. (CUD in CRUD)
    -   From an implementation stand point RunAction and RunQuery are identical, they are just different types of operations.
    -   Heavily used, 110 invocations at least.
*   RunMultipleAction
    -   Takes in a list of actions and parameters for those actions and runs them all at once.
    -   The callback is responsible for handling the resulting result list.
    -   Heavily used 105 invocations.
*   RunMultipleActions
    -   Sequential invocation of RunAction. If one of the run actions fails then the sequence is stopped and the rest is not executed.
    -   Rarely used, only 8 invocations
*   LoginAsync
    -   Log the user into the application based on pass in
        -   Username
        -   Password
        -   Domain
    -   1 invocation
*   LogoffAsync
    -   Log the passed in user name out of the system.
    -   2 invocations
*   getLoggedInUser
    -   Determine the currently logged in user.
    -   No invocations at all (can we remove this method?). There are two getLoggedInUser, one that makes an rpc call to the server, another that just returns a value in memory. The one I am talking about here is the one that makes the call to the server.

##### Things to consider

*   Max number of concurrent connects from the browser to the server is limited.
*   Even though login and logout are very important operations, they really are not that special that they require separate code. In essence they are just a special case of an action.
*   Operations can fail for whatever reason, and sometimes instead of returning an error we should attempt the operation again.
*   The underlying communication between the browser and server should be independent of the api exposed to the application. Right now we use GWT-RPC, but we should be able to swap it out to REST without having to change the API.
*   Sometimes the sequence of operations is important as demonstrated by the existence of RunMultipleAction**s**, so the new design needs to be able to handle a sequence as well as multiple concurrent requests.
*   We need to minimize the disruption to the existing infrastructure and just mark the existing methods as deprecated if needed.

#### New Design

I propose a scheme fairly similar to a database connection pool manager combined with an operation queue. The operations are added to the end of the queue by an enQueueOperation method. The pool manager pulls operations from the front of the queue and sends it to one of the available connections. If there is a problem with the operation the manager is responsible for retrying the operation or returning the error to the callback (maybe have an error handler similar to the one we have now instead). If there are more operations than available connections the pool manager does nothing until a connection becomes available. This is your classic producer/consumer setup where the enQueue operation is the producer and the pool manager is the consumer.

#### Special considerations

1.  When the user logs out the queue is purged and any outstanding operations are completed but no callbacks are called.
2.  If the user is not logged in, then no operations are allowed into the queue, except for the logon operation.
3.  Multiple operations are broken into single operations in the queue.
    1.  Note-able issue with this is the current RunMultipleActions sequence, the order is important there but I am not sure if we should force the caller to make the order important in their callback or if we should have a mechanism to enforce the order. For instance override the callback passed in during the enQueueOperation, and only have the last operation really call the callback. For all the other operations the callback is actually an enqueue on the next operation.
