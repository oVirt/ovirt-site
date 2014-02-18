---
title: NewLookAndFeelPatternFlyPhase1
category: feature
authors: gshereme
wiki_category: Feature
wiki_title: Features/NewLookAndFeelPatternFlyPhase1
wiki_revision_count: 11
wiki_last_updated: 2014-09-23
feature_name: New Look and Feel based on PatternFly -- Phase 1
feature_modules: webadmin,userportal
feature_status: In Development
---

--[Gshereme](User:Gshereme) ([talk](User talk:Gshereme)) 20:28, 18 February 2014 (GMT)

# New Look and Feel based on PatternFly -- Phase 1

### Summary

We are updating the look and feel of oVirt using [PatternFly](http://www.patternfly.org), the open interface project. The new look and feel aims to maintain the colors and spirit associated with oVirt, while updating it with a new, modern, sleek, and minimal look. The minimal design allows complex screens to look cleaner and airier, and lets the user focus on the data and the tasks by removing all extraneous visual elements. The use of color is very judicious and limited to where it truly adds value. Besides that, the style is cool, flat, and graphic. The interactions and behaviors remain unchanged, and the scope of this feature is limited to visual updates.

For Phase I of this project, we will apply the new look and feel to the following parts of oVirt:

*   Welcome Page
*   404 Page
*   Login Page (web admin/user portal)
*   Top Banner (web admin/user portal)

### Owner

*   Name: [ Greg Sheremeta](User:Gshereme)
*   Email: gshereme@redhat.com

### Current status

*   Currently in code review. <http://gerrit.ovirt.org/#/c/24594/>
*   Last updated: -- by [ WIKI}}](User:{{urlencode:{{REVISIONUSER}})

### Detailed Description

The best way to describe will be to show example screens. TODO: add screens

### Benefit to oVirt

This is a major change. Both oVirt users and administrators will benefits from a superior user experience.

### Dependencies / Related Features

none

### Documentation / External references

<https://bugzilla.redhat.com/show_bug.cgi?id=1064543>

<http://lists.ovirt.org/pipermail/users/2013-October/017088.html>

### Testing

Testing involves

*   Regression. Make sure screens that weren't touched haven't changed at all, in look or functionality. Check font sizes, button sizes, field sizes, borders, alignment, etc.
*   Make sure changes pages and sections match the designs and are fully functional. For example, make sure the login pages look right and function correctly.

### Comments and Discussion

The new design was proposed on the oVirt mailing list in October, 2013. <http://lists.ovirt.org/pipermail/users/2013-October/017088.html>

*   Refer to [Talk:Your feature name](Talk:Your feature name)

<Category:Feature>
