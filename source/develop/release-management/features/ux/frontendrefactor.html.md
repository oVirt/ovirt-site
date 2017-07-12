---
title: FrontendRefactor
category: feature
authors: awels
feature_name: Frontend-Refactoring
feature_modules: webadmin,userportal
feature_status: Released
---

# Frontend class re-factoring effort

## Summary

This feature improves the modularity and maintainability of the Frontend class in the UI. This class is used for communication with the backend

## Owner

*   Name: Alexander Wels (awels)
*   Email: <awels@redhat.com>

## Current status

*   **Complete**: Solution implementation finished and merged into master

# Frontend public api methods

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
    -   Sequential invocation of RunAction. If one of the run actions fails then the sequence is stopped and the rest is not executed. This method is to provide a 'transaction' like method to execute multiple actions in a sequence.
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
    -   This method is a legacy call and no longer in use, we can remove this method.

##### Things to consider

*   Max number of concurrent connects from the browser to the server is limited.
*   Even though login and logout are very important operations, they really are not that special that they require separate code. In essence they are just a special case of an operation.
*   Operations can fail for whatever reason, and sometimes instead of returning an error we should attempt the operation again.
*   The underlying communication between the browser and server should be independent of the API exposed to the application. Right now we use GWT-RPC, but we should be able to swap it out to REST without having to change the API.
*   Sometimes the sequence of operations is important as demonstrated by the existence of RunMultipleAction**s**, so the new design needs to be able to handle a sequence as well as multiple concurrent requests. RunMultipleActions is there to give some kind of illusion of transactions, we should investigate if we can give actual transactions for certain sets of operations.
*   We need to minimize the disruption to the existing infrastructure and just mark the existing methods as deprecated if needed.
*   We need to make sure that the new design doesn't break any existing functionality, so we should write a unit test suite for the existing implementation (if possible) and use that to measure if the new implementation meets our needs.
*   We need to implement the new design in such a way that it can easily be unit tested, unlike the current implementation.

## Unit test testSuite

This is to document the things we need to test in the unit test suite.

##### RunQuery

*   Make sure the correct query is called based on the query type.
*   Make sure parameters are passed correctly.
*   Make sure that multiple same requests don't get called more than once.
*   Make sure that multiple different requests DO get called.
*   Make sure that the passed in callback is properly called when the request completes.
*   Make sure that the error handler is called with the correct error message if a problem occurs.
*   Make sure that the error handler is NOT called for failures that are supposed to be ignored. (Is this still a true statement?)
*   Make sure that the query started event is raised.
*   Make sure that the query complete event is raised once the query completes regardless of success/failure.
*   Make sure queries don't run if you are not logged in (currently a backend check only, maybe make it frontend as well?).

##### RunPublicQuery

*   Make sure that you can run the query even if you are not logged in

##### RunMultipleQueries

*   Make sure the correct queries are called based on the query type.
*   Make sure parameters are passed correctly.
*   Make sure that the passed in callback is properly called when the request completes.
    -   Make sure that the callback contains results for all the queries.
    -   If some of the queries resulted in failure, have those failures properly reported.
*   Make sure that the error handler is called with the correct error message if a problem occurs.
*   Make sure that the error handler is NOT called for failures that are supposed to be ignored. (Is this still a true statement?)
*   Make sure that the query started event is raised.
*   Make sure that the query complete event is raised once the query completes regardless of success/failure.
*   Make sure queries don't run if you are not logged in (currently a backend check only, maybe make it frontend as well?).

##### RunAction

*   Make sure the correct action is called based on the action type.
*   Make sure parameters are passed correctly.
*   Make sure that the passed in callback is properly called when the request completes.
*   Make sure that the error handler is called with the correct error message if a problem occurs.
*   Make sure that the error handler is NOT called for failures that are supposed to be ignored. (Is this still a true statement? After more investigation, it looks like it has something to do with pressing escape while the query is running, based on some of the comments)
*   Make sure queries don't run if you are not logged in (currently a backend check only, maybe make it frontend as well?).

##### RunMultipleAction

*   Make sure the correct action is called based on the action type.
*   Make sure parameters are passed correctly.
*   Make sure that the passed in callback is properly called when the request completes.
    -   Make sure that the callback contains results for all the actions.
    -   If some of the actions resulted in failure, have those failures properly reported.
*   Make sure that the error handler is called with the correct error message if a problem occurs.
*   Make sure that the error handler is NOT called for failures that are supposed to be ignored. (Is this still a true statement? After more investigation, it looks like it has something to do with pressing escape while the query is running, based on some of the comments)
*   Make sure queries don't run if you are not logged in (currently a backend check only, maybe make it frontend as well?).

##### RunMultipleActions

*   Not sure what to test here, pending discussion on transactional actions.

##### LoginAsync

*   Make sure that the passed in username/password/domain are passed properly.
*   On success make sure that the getLoginHandler is called.
*   Make sure that the error handler is called with the correct error message if a problem occurs.

##### LogoffAsync

*   Make sure the passed in username is passed properly.
*   On success make sure that the getLoginHandler is called.
*   Make sure that the error handler is called with the correct error message if a problem occurs.

# New Design

I propose a scheme fairly similar to a database connection pool manager combined with an operation queue. The operations are added to the end of the queue by an enQueueOperation method. The pool manager pulls operations from the front of the queue and sends it to one of the available connections. If there is a problem with the operation the manager is responsible for retrying the operation or returning the error to the callback (maybe have an error handler similar to the one we have now instead). If there are more operations than available connections the pool manager does nothing until a connection becomes available. This is your classic producer/consumer setup where the enQueue operation is the producer and the pool manager is the consumer.

##### Cross cutting concerns

There are several cross cutting concerns the new design needs to take into account.

1.  Error handling.
    -   For whatever reason the operation failed and we have no way of recovering. We need to inform the user that something horribly went wrong. We need to return two pieces of key information back to the user:
        1.  The status code of the error. The is the least important piece of information for the user, but highly important for trouble shooting the problem.
        2.  The human reabable error message. If possible we should translate these into the proper language associated with the users locale.

2.  Retry handling.
    -   Certain http error codes can be recovered from. The http error codes range from 300 to about 600. With anything in the 300 range getting automatically taken care of by the browser. Anything in the 400 range usually means missing files or operations failing due to authentication or authorization failures. Except for a 408, which means time-out expired. In the 500 range usually means some kind of server error, like 500 internal server error, or 503 server busy. Some of these we can try to remedy the situation by retrying an operation.
    -   On IE there are also status codes returned > 1000. These are wininet error codes that we can't really do anything about. We could treat these as internal server errors and retry the operation in hopes that the underlying case of the wininet errors get resolved by trying the operation again. Most of the known error codes we have seen are due to connections being dropped, so a retry should fix the situation.

3.  Start/Stop events for operations.
    -   Fire an event right before we execute the request containing the operation.
    -   Fire an event after the result is returned from the request, but before doing any callbacks or error handling.

##### GWT-RPC vs REST

Our current implementation uses GWT-RPC to do communication between the client and the server. In the future we are planning on moving to a REST based communication architecture. There are significant differences between REST and GWT-RPC and the new design needs to take those into account so we can easily swap out GWT-RPC for REST. I found a library that should make this easy for us [RestyGWT](http://restygwt.fusesource.org/) (Apache License version 2.0). This should allow us to keep almost the same programming model, but use REST instead.

Another possible approach is to create a javascript sdk for the REST api, and the use GWT JNI to call the methods of the javascript SDK.

##### Dataflow example

[1] Caller calls one of the existing operations like RunQuery. RunQuery calls enQueue operation with the appropriate parameters for the request.
[2] The enQueue operation optionally turns a multiple operation request into multiple operations in the queue.
[3] The operations are added to the queue.
[4] The connection manager takes the contents of the queue and creates a single request for the server. If the order of some of the operations is important they are handled specially by the manager so that the callback when the operation completes adds the next operation in the sequence to the queue.
[5] The order was important and the callback adds the next operation in the sequence to the queue.
[6] The operation completed, and the callback is called with the appropriate information. If multiple operations where merged into a single request, then multiple callbacks will be called.
![](/images/wiki/Overview.png)

##### Class Diagram of new Design

This is the class diagram of the new design. Frontend is now a singleton with deprecated static methods. All the operations (runQuery/runAction/etc) all create the appropriate VdcOperation object, which is then passed to the VdcOperationManager. The manager then puts the operation(s) into the queue and alerts the processor that new operations are available. The OperationProcessor then takes the available operations in the queue and processes them. After manipulating the operations appropriately the OperationProcessor calls transmitOperationList on the CommunicationsProvider. The communications provider calls the appropriate back-end services to do the operations.

![](/images/wiki/Frontend_class_diagram.png)

###### Frontend.java

This is the main class being refactored. All the existing static methods have been preserved, they are just marked deprecated. All the existing static methods now have an equivalent non-static method. For instance if we had public static void RunQuery, we now have a public void runQuery with the same parameters. We added a static getInstance method in cases where it was hard to inject the singleton using GIN. The resulting functionality should be identical to the current Frontend class.

###### VdcOperationManager

This is the class that manages all operations going into the queue. Operations are allowed to go into the queue if one of the following is true:

*   The user is logged in, and the operation is not public, and the operation is not already in the queue or being processed.
    -   actions are allowed to be duplicate in the queue, only queries are not allowed to be duplicate.
*   The user is not logged in and the operation is a public operation.

After the operation has been added to the queue alert the OperationProcessor that new operations are available in the queue.

###### VdcOperation

This is the container for a specific operation. Each operation defines the following properties:

*   The type of operations (query, action)
*   The parameters to the operations. For instance search string.
*   The callback to call once the operation completes. The callback defines both a success and a failure method which can be called depending on the outcome of the operation.
*   A flag that determines if this is a public operation, in other words if you don't have to logged in to execute the operation.

VdcOperations are immutable, aka all the member variables are final.

###### VdcOperationCallback

This interface defines the call back interface for operations. It contains an onSuccess and onFailure method.

###### VdcOperationCallbackList

The list version of the operation call back. This one is used when the operation expects a list of results.

###### VdcUserCallback

Call back for user operations. This is used when the user logs in and logs out.

###### OperationProcessor

This is more or less the heart of the refactoring. This class takes the operations in the queue and processes them before sending the operations to the communications provider. The processing consists mainly of replacing the existing callback objects with new ones that allow the processor to add special processing when the operation completes. Replacing the callbacks allows us to do things before calling the original call backs. For instance:

*   If there is a failure that might be resolved by a retry, we can automatically retry without having the caller worry about it.
*   Manipulate the return codes, or error messages without having the caller worry about it.
*   Anything else we want before making the call back to the caller.

Since VdcOperations are immutable objects (all the member variables are final), replacing the callback represents an interesting problem. We can't simply assign a new call back as it is final, as well as if it was possible we would lose the original call back which we will need. To solve this problem, I added a copy constructor which takes two parameters, the original operation, and a callback. In the constructor, we store the original operation, and copy all the values from the original operation, as well as assign the call back to the operation.

To ensure that we don't assign different new call backs to the same original call back (As would be the case when the original call to Fronted would be a runMultipleQueries) we store the original callback and the new callback in a map while processing all the operations. If a matching original call back is found, we replace it with the one from the map, otherwise we create a new one and put it in the map.

###### CommunicationProvider

This interface defines what a communications provider should provide. The interface is very simple. It should allow a list of operations to be passed into it. It also should allow the user to login and log out. The actual implementation of this interface will determine how the client communicates with the back end.

###### GWTRPCCommunicationProvider

The GWT RPC communication provider is the client interface with the GWT RPC backend. The provider uses the GenericApiGWTServiceAsync class to do the actual communication. When the provider receives a list of operations, it splits them out into actions and queries. If there are more than one actions, the provider calls runMultipleActions. If there is only one action it calls runAction. A similar procedure happens with queries, only it calls runMultipleQueries and runQuery. If an operation is public the provider calls runPublicQuery.

The result of RunQuery, RunAction, RunPublicQuery are not that interesting. We just call the call back based on success or failure of the operation. RunMultipleActions, and RunMultipleQueries is more interesting as we potentially muxed a lot of unrelated operations together, and we need to make sure that all the appropriate call backs are being called. The process of doing this is slightly different between actions and queries.

*   Actions. Because we can't mix different action types in a RunMultipleActions call, we have to make several calls, one for each action type. Since it is theoretically possible to have the same action type with different parameters **and** different call backs, we have to make sure that we look at the results of the action, and pass the result to the appropriate call back.
*   Queries. We can mix and match as many queries as we want into a single query, we will only have to make a single call to RunMultipleQueries. Obviously untangling the result from that query and making the proper call backs is a little more complicated, but not impossible.

##### Special considerations

1.  When the user logs out the queue is purged and any outstanding operations are completed but no callbacks are called.
2.  If the user is not logged in, then no operations are allowed into the queue, except for the logon operation.
3.  Multiple operations are broken into single operations in the queue. So if someone calls RunMultipleQueries with 3 queries to run, they get turned into 3 individual operations in the queue.
    -   Note-able issue with this is the current RunMultipleActions sequence, the order is important there but I am not sure if we should force the caller to make the order important in their callback (like it is now) or if we should have a different mechanism to enforce the order. For instance override the callback passed in during the enQueueOperation, and only have the last operation really call the callback. For all the other operations the callback is actually an enqueue on the next operation.
    -   If the order is not important then a set of multiple operations can be broken into single operations and added to the queue individually. Then each one can be executed as connections become available. The results of all the associated operations will have to be collected so we can return a coherent result to the called.

4.  Optimize performance by basically doing the opposite of above. We can take all the individual operations in the queue, and generate a single call to the server with all the operations in it. So if the queue contains 5 operations, then this gets turned into a single request to the server. The server will need to support this. Then when we get the result we can make the appropriate callbacks. This merging of the operations into a single call to the server will like only happen if there are a lot of calls coming into the queue at once and the connections are busy with other operations, which is precisely the time when we need to optimize things.
5.  Since we are introducing state into a static class, we should instead everything being static , create a singleton and have the static methods reference that singleton.

