---
title: PatternFly Tooltips
category: feature
authors: gshereme
feature_name: PatternFly tooltips
feature_modules: webadmin,userportal
feature_status: In Development
---

# PatternFly tooltips

## Summary

We are converting all tooltips in the oVirt web applications to use PatternFly (Bootstrap-based) tooltips.

### Owner

*   Name: Greg Sheremeta (Gshereme)
*   Email: gshereme@redhat.com

## Detailed Description

As part of our transition to a PatternFly-based UI, we are converting all tooltips in the oVirt web applications to use PatternFly (Bootstrap-based) tooltips.

Previously oVirt used a combination of blue panel-based homegrown tooltips, and html title-based tooltips. The look was disjointed. This effort will clean that up and make everything look uniform.

## Benefit to oVirt

Both oVirt users and administrators will benefits from a superior user experience. Developers will benefit from a simplified and easy to use tooltip infrastructure.

## Dependencies / Related Features

Depends on PatternFly. Nothing depends on this.

## Documentation / External references

Screenshots:

![](/images/wiki/patternfly_tooltips1.png)

![](/images/wiki/patternfly_tooltips2.png)

![](/images/wiki/patternfly_tooltips3.png)

![](/images/wiki/patternfly_tooltips4.png)

![](/images/wiki/patternfly_tooltips5.png)

![](/images/wiki/patternfly_tooltips6.png)

![](/images/wiki/patternfly_tooltips7.png)

![](/images/wiki/patternfly_tooltips8.png)

![](/images/wiki/patternfly_tooltips9.png)

![](/images/wiki/patternfly_tooltips10.png)

## Testing

Testing involves

*   Regression. Make sure screens haven't changed at all, in look or functionality. Pay special attention to grid columns, headers, and tooltips in both cells and headers.
*   Make sure all tooltips look the same. There should be no blue or yellow tooltips anywhere.



