---
title: UIRefreshSynchronization
category: feature
authors: awels
---

# UI Refresh Synchronization

## Summary

Solve UI consistency issues related to the UI not being updated when certain actions/events happen.

## Owner

*   Name: Alexander Wels (awels)
*   Email: <awels@redhat.com>

## Current status

*   **Complete**: Solution implementation merged into master
*   **Complete**: Identify existing issues
*   **Complete**: Design solution based on the existing issues and proposed solutions.

# Existing problems

## Actions are not immediately shown in updated UI elements

Quite frequently it happens that one performs an action on lets say a VM, and after the action completes it takes the UI a few seconds to show the updated status. For instance if I delete an existing VM from my grid after I click the ok button, the dialog disappears, as illustrated by the following image. ![](/images/wiki/Remove_dialog.png) but it takes a few seconds for VM to be removed from the VM grid, as illustrated by the following image (The VM is still there after clicking the ok button). ![](/images/wiki/Remove_dialog_finished.png) This is especially noticeable if you have the refresh of the grid set to 30 or 60 seconds.

### Actions cause an immediate refresh, however the result of the action takes a while to materialize

This is a somewhat related issue to actions not immediately showing updated UI elements. In fact the client makes an attempt to update the appropriate elements, however since the action doesn't have an immediate result, the refresh retrieves the same data that was there, and there is no notification once a result is available. So the UI elements are never updated until the next normal refresh cycle after the result is available. The user experience is identical to the client not attempting to refresh at all, it takes a while for the user to see changes they made appear in their UI.

## The event log is updated, but the rest of the UI elements are not

This is related but slightly different problem from the one described above. In this case something in the system caused an event to be generated and this event shows up in the event log in the UI but there is no corresponding change in the rest of the UI. For instance someone removed a VM and the event shows up in the event log, however the VM is still visible in the VM grid. This is illustrated in the following image. ![](/images/wiki/Event_out_of_sync.png) This is caused by the fact that the event log is refresh at a different interval than the rest of the UI, in fact you cannot change the refresh of the event log, but you can change the refresh of the rest of the UI (like the VM grid).

# Proposed solutions

## Action solution

The problem is the fact that an action changes the state of a particular model or sets of models on the back-end and the front-end doesn't know about those changes immediately. However the front-end does know about the fact that a particular action has completed (namely in the form of a callback from the GWT-RPC code). In a perfect world the action would know which models would potentially be affected and would notify them to refresh their state. However this would create tightly coupled actions and model which is something we want to avoid. As well as it becoming a maintenance nightmare to keep track of which models are associated with which actions.

We can reverse the situation and make the models aware of which actions would require them to refresh themselves. This way we can fire an event when an action completes and all interested models in that event can check if they are interested in the action associated with that event. Based on that information the model can decide if it wants to refresh or not. This of course has the potential for many models to be notified at once, so we can maybe utilize action groups or something to lower the number of models that get notified. We can also remove/add the listeners based on if the standard refresh timer is active on that model.

As demonstrated in this figure:

![](/images/wiki/UI_Sync_action.png)

Unfortunately this does not solve the problem of an action taking a little longer to complete. The refresh happens immediately and afterwards there is no notification that the action completed one way or the other. To remedy this situation the ideal solution would be some sort of notification from the back-end that the action completed and that we can refresh the model. Unfortunately we not yet ready to fully support push technology so we have to use some creative solutions.

As with the solution above we can immediately refresh like before, but at the same time if we just completed an action we can set the refresh timer to be really fast so we will be guaranteed to get the update when it completes. In order not to spam the back-end completely we should stop after a period of time. A good period of time is the current refresh timer. If the action takes that long to complete we can return to a normal refresh period after one period has expired. We should also slow down the refresh the further we get into the refresh time period. The longer the action takes to complete the longer we can have the refresh interval without giving a bad experience to the end user.

This is illustrated here. dots are refreshes while pipes are the refresh timeout.

    |.... . . . .  .  .  .  .    .    .    .    .     .     .     |.                                                   |.

## Event solution

The problem is something besides the interactions of the user with the UI has made changes to a model or a set of models on the back-end and the front-end doesn't know about these changes. Interactions by the user are captured by the 'action solution' above. Some/all of those changes generate an event which is retrieved using a periodic event query. This event query is not in sync with the rest of the normal model queries. So we can get a situation where an event is reported in the event log but the associated UI elements have not been updated yet.

The solution to this problem is very similar to the solution of the actions. Instead of looking for action results, we look for query results for the event query. If we find such a results we can fire a similar event to the action completed event and have models listen for that event. Then the models can decide if they need to be refreshed or not.

As demonstrated by the following figure:

![](/images/wiki/UI_Sync_event.png)

