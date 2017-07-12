---
title: CSSGrids
category: feature
authors: gshereme
feature_name: CSS Grids
feature_modules: webadmin,userportal
feature_status: Proposal
---

# CSS Grids

## Summary

I propose we switch to using Bootstrap CSS grids for all layout in our web applications, specifically the user and admin portals. (Definition: "grid" here means "CSS grid", a way to layout an application -- not to be confused with the existing data grids in oVirt, which display details of model objects.)

## Owner

*   Name: Greg Sheremeta (Gshereme)
*   Email: gshereme@redhat.com

## Current status

Proposal only. Not approved. Just an idea.

## Background

Currently, we rely on a mishmash of outdated web technologies to achieve desired layouts in our web UI. These techniques should be updated to modern standards to promote flexibility and accessibility going forward.

Outdated technique 1: using tables for layout. Layout should not be achieved via tables. Some of this is the fault of GWT, which uses tables for some of its layout features. These would need to be avoided.

Outdated technique 2: hardcoding widths, sizes, etc. There are many occurrences of UI widgets being set to specific sizes or specific positions, often with hardcoded magic numbers.

## Detailed description

I proposed we replace both of these outdated techniques with the use of responsive design via the Bootstrap CSS framework and its grid layout. For more information on the grid, see <http://getbootstrap.com/css/#grid> The details need to be studied and worked out, but essentially we would avoid code such as:

       set elementX to 240px wide, position 30px top, 20px left.

This code is brittle and does not respond well to overarching UI changes. It also does not respond well to browser window changes, small sizes, mobile browsers, etc. We would replace with code such as:

       for screen size greater than 1024px wide...
         set up 6 columns of equal width
         place elementX in column2 and span it over through column 5
       for screen size greater than 1500px wide ...
         set up ...
       for mobile screen size...
         set up ...

This grid-based approach is becoming a de facto standard in responsive web design.

Further, PatternFly uses this approach throughout, and since oVirt is adopting PatternFly, it makes very much sense for oVirt to adopt Bootstrap grids.

Example:

![](/images/wiki/Bootstrap_grid_example.png)

## Benefit to oVirt

At first glance, there is little benefit to end users. However, for users that use a smaller screen resolution or perhaps a mobile device, this paves the way for us to achieve full mobile compatibility. For code maintainers, this will save a lot of pain w/r/t layout nightmares that currently exist. We will worry much less about positioning things correctly by the pixel -- the grid takes care of it. (I know well about this pain while doing phase 1 of the PatternFly implementation. A few overall changes and everything is off by a few pixels. It is very time-consuming to find and adjust all these hardcoded values.)

The grid also makes it easier to achieve a unified, columnar look. For example, visit <http://960.gs/> -- Fedora is an example on that page. Click "show grid" on the Fedora page. If we can define a reusable structure for all dialog boxes, for example, it will be easier to crank out new dialog boxes and make sure they have the same look.

## Dependencies / Related Features

We already depend on PatternFly and Bootstrap.

## Challenges / Risks

*   movable panes / resizable grid columns. Does using a CSS grid eliminate movable panes or resizable columns? Or do CSS grids exist within the panes? Perhaps we just use CSS grids in limited places, like dialog boxes, login screen, etc?
*   potentially a ton of code to update

## Documentation / External references

<http://getbootstrap.com/css/#grid>

## Testing

Testing would be look and feel regression testing. Make sure screens that weren't touched haven't changed at all, in look or functionality. Make sure screens that were touched look good and are still functional. Check font sizes, button sizes, field sizes, borders, alignment, etc.



