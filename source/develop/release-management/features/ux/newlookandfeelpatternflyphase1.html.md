---
title: NewLookAndFeelPatternFlyPhase1
category: feature
authors: gshereme
feature_name: New Look and Feel based on PatternFly -- Phase 1
feature_modules: webadmin,userportal
feature_status: In Development
---

--Gshereme (Gshereme) ([talk](User talk:Gshereme)) 20:28, 18 February 2014 (GMT)

# New Look and Feel based on PatternFly -- Phase 1

## Summary

We are updating the look and feel of oVirt using [PatternFly](http://www.patternfly.org), the open interface project. The new look and feel aims to maintain the colors and spirit associated with oVirt, while updating it with a new, modern, sleek, and minimal look. The minimal design allows complex screens to look cleaner and airier, and lets the user focus on the data and the tasks by removing all extraneous visual elements. The use of color is very judicious and limited to where it truly adds value. Besides that, the style is cool, flat, and graphic. The interactions and behaviors remain unchanged, and the scope of this feature is limited to visual updates.

For Phase I of this project, we will apply the new look and feel to the following parts of oVirt:

*   Welcome Page
*   404 Page
*   Login Page (web admin/user portal)
*   Top Banner (web admin/user portal)

## Owner

*   Name: Gshereme (Gshereme)
*   Email: gshereme@redhat.com

## Current status

*   Merged. <http://gerrit.ovirt.org/#/c/24594/> Several follow-up patches. Officially included in oVirt 3.5.
*   Last updated: -- by (WIKI)

## Detailed Description

The best way to describe will be to show example screens.

**Welcome Page**

![](/images/wiki/OVirt-LAF-Welcome-Page.png)

**\1** ![](/images/wiki/OVirt-LAF-404.png)

**\1** ![](/images/wiki/OVirt-LAF-LoginPage.png)

**\1** ![](/images/wiki/OVirt-LAF-Admin-Banner-Only.png)

**\1** ![](/images/wiki/OVirt-LAF-Basic-Banner-Only.png) ![](/images/wiki/OVirt-LAF-Extended-Banner-Only.png)

## Benefit to oVirt

This is a major change. Both oVirt users and administrators will benefits from a superior user experience.

## Dependencies / Related Features

none

## Documentation / External references

<https://bugzilla.redhat.com/show_bug.cgi?id=1064543>

<http://lists.ovirt.org/pipermail/users/2013-October/017088.html>

## Implementation notes

*   This feature effectively brings Bootstrap3 CSS library into ovirt-engine for full use. Bootstrap itself is not included, but PatternFly is a skinned version of Bootstrap. All Bootstrap widgets are present and usable.

<!-- -->

*   Adds gwtbootstrap3 library. This library adds a bootstrap-aware rendering to GWT widgets. These widgets render with minimal GWT decoration (no wrapping divs, etc.) for easier hits to bootstrap selectors. We expect to use more gwtbootstrap3 as we transition the entire application over. The net result will be cleaner HTML and more reliance on CSS to achieve desired looks.

<!-- -->

*   Adds PatternFly (https://www.patternfly.org/) to the project. Since we are transitioning to PatternFly in phases, this first phase requires some hacks to be stacked on top of PatternFly. ovirt-patternfly-compat.css includes these. It is possible that oVirt-specific widgets (or variations of widgets) will be contributed upstream to PatternFly. **Try to keep PatternFly in mind when doing new UI work.**

## Testing

Testing involves

*   Regression. Make sure screens that weren't touched haven't changed at all, in look or functionality. Check font sizes, button sizes, field sizes, borders, alignment, etc.
*   Make sure changed pages and sections match the designs and are fully functional. For example, make sure the login pages look right and function correctly.

## Comments and Discussion

The new design was proposed on the oVirt mailing list in October, 2013.

<http://lists.ovirt.org/pipermail/users/2013-October/017088.html>


