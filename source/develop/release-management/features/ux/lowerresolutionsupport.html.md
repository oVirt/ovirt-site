---
title: LowerResolutionSupport
category: feature
authors: awels, ecohen
feature_name: Low Resolution Support
feature_modules: webadmin,userportal
feature_status: Released
---

# Lower resolution support

## Summary

The web admin interface and to some degree also the user portal interface are not displayed properly in lower resolutions such as 1024x768. When resolutions are lower, the tab bar and action menu wrap overlapping other UI elements. This feature solves this issue by adding a scrollable tab bar for the tabs and a cascading menu bar for the action menu.

## Owner

*   Name: Alexander Wels (awels)
*   Email: <awels@redhat.com>

## Current status

*   **Complete**: Identify existing issues
*   **Complete**: Design solution based on the existing issues
*   **Complete**: Implement proposed solution: <http://gerrit.ovirt.org/#/c/21716/>

## Available in Version

*   ovirt-3.4

# Existing problems

## Tab bar wraps when the resolution is low

Currently in the web admin when the resolution is too low to hold all the tabs, the tabs wrap onto the next line and overlap the action bar. The same thing also happens when you drag the splitter bar to the right until there is not enough room for all the tabs. This is illustrated here: ![](/images/wiki/Overlap_tab_highlight.png)

The same thing happens to any sub tabs that have a tab bar. This is illustrated here:

![](/images/wiki/overlap_sub_tab.png)

## Grid action bar wraps when the resolution is low

In addition to this the action button bar does the same thing, as illustrated here: ![](/images/wiki/Overlap_action_highlight.png)

# Proposed solution

## Scrollable Tab bar

The standard solution for many applications that have tabs that if there is not enough space to hold all the tabs is to introduce the ability to scroll the tabs left or right. Aside from the scrolling buttons there is usually also a menu drop down that lists all the tabs for easy access to all the different tabs without the need to scroll. Our UIX designer created the following mockup as the base of the design.

![](/images/wiki/dropdown_design.png)

Once this is implemented the following will happen when there is not enough room to hold all the tabs (for instance at 1024x768 resolutions).

*   A left scroll button will appear
    -   The button will be enabled if there are tabs that can be visible on the left but are not visible.
*   A right scroll button will appear.
    -   The button will be enabled if there are tabs that can be visible on the right but are not visible.
*   A drop down button will appear.
    -   Clicking the dropdown will show you a menu with **all** the tab names, clicking an item in the menu will take you to the associated tab.

## Cascading tool bar

The standard way of handling too many items on a menu bar is to have them cascade off the right side of the toolbar and show up in a drop down menu. Only the items that cannot be shown in the tool bar show up in the menu. This is illustrated in the following screenshot: ![](/images/wiki/Cascade_action.png)

# Testing

## low resolutions (e.g. 1024x768)

Verify the following for low resolutions:

1.  when main tab panel doesn't have enough real-estate to be fully displayed:
    -   left/right navigation arrows appear in the main tab panel and behave correctly.
    -   tabs-navigation-drop-down-button appears in the main tab panel and behaves correctly [behavior should be similar to the behavior of Firefox browser when there are a lot of opened tabs in it]

2.  make sure to test interesting scenarios, which include a lot of main-tabs that are displayed:
    -   'System' left-pane-tree-node selected
    -   a specific Data-Center left-pane-tree-node is selected
    -   oVirt Reports are installed (i.e. Dashboard main tab is displayed)
    -   oVirt ui-plugin(s) that are adding main tab(s) are installed.

3.  when any sub-tab panel doesn't have enough real estate to be fully displayed: behavior should be similar to the one described in (1) above.
    -   Make sure to test a case of many sub-tabs using the ui-plugins mechanism.

4.  when any action button bar (either in main tab or in sub-tab) doesn't have enough real estate to be fully displayed:
    -   an action navigation drop down button appears and
        -   When clicked opens up a menu containing just the items that are no longer on the action bar.
    -   Make sure to test interesting scenarios: Tabs with many built-in buttons (e.g. VMs main tab), tab with a lot of actions added via the ui plugins infrastructure, etc.

(4) is relevant for the power user portal as well, make sure that the action button bar properly shows the drop down when not enough room is available.

## non-maximized window size

Verify the following for non-maximized window size:

1.  when main tab panel doesn't have enough real-estate to be fully displayed:
    -   left/right navigation arrows appear in the main tab panel and behave correctly.
    -   tabs-navigation-drop-down-button appears in the main tab panel and behaves correctly [behavior should be similar to the behavior of Firefox browser when there are a lot of opened tabs in it]

2.  make sure to test interesting scenarios, which include a lot of main-tabs that are displayed:
    -   'System' left-pane-tree-node selected
    -   a specific Data-Center left-pane-tree-node is selected
    -   oVirt Reports are installed (i.e. Dashboard main tab is displayed)
    -   oVirt ui-plugin(s) that are adding main tab(s) are installed.

3.  when any sub-tab panel doesn't have enough real estate to be fully displayed: behavior should be similar to the one described in (1) above.
    -   Make sure to test a case of many sub-tabs using the ui-plugins mechanism.

4.  when any action button bar (either in main tab or in sub-tab) doesn't have enough real estate to be fully displayed:
    -   an action navigation drop down button appears and
        -   When clicked opens up a menu containing just the items that are no longer on the action bar.
    -   Make sure to test interesting scenarios: Tabs with many built-in buttons (e.g. VMs main tab), tab with a lot of actions added via the ui plugins infrastructure, etc.

(4) is relevant for the power user portal as well, make sure that the action button bar properly shows the drop down when not enough room is available.

## left-pane width is significantly extended -> main-tabs view width is significantly narrowed down

Verify the following for wide left panes.

1.  when main tab panel doesn't have enough real-estate to be fully displayed:
    -   left/right navigation arrows appear in the main tab panel and behave correctly.
    -   tabs-navigation-drop-down-button appears in the main tab panel and behaves correctly [behavior should be similar to the behavior of Firefox browser when there are a lot of opened tabs in it]

2.  make sure to test interesting scenarios, which include a lot of main-tabs that are displayed:
    -   'System' left-pane-tree-node selected
    -   a specific Data-Center left-pane-tree-node is selected
    -   oVirt Reports are installed (i.e. Dashboard main tab is displayed)
    -   oVirt ui-plugin(s) that are adding main tab(s) are installed.

3.  when any sub-tab panel doesn't have enough real estate to be fully displayed: behavior should be similar to the one described in (1) above.
    -   Make sure to test a case of many sub-tabs using the ui-plugins mechanism.

4.  when any action button bar (either in main tab or in sub-tab) doesn't have enough real estate to be fully displayed:
    -   an action navigation drop down button appears and
        -   When clicked opens up a menu containing just the items that are no longer on the action bar.
    -   Make sure to test interesting scenarios: Tabs with many built-in buttons (e.g. VMs main tab), tab with a lot of actions added via the ui plugins infrastructure, etc.

(4) is relevant for the power user portal as well, make sure that the action button bar properly shows the drop down when not enough room is available.

