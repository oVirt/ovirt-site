---
title: PatternFly Tooltips
category: feature
authors: gshereme
wiki_category: Feature
wiki_title: Features/PatternFly Tooltips
wiki_revision_count: 3
wiki_last_updated: 2015-03-10
feature_name: PatternFly tooltips
feature_modules: webadmin,userportal
feature_status: In Development
---

# PatternFly tooltips

## Summary

We are converting all tooltips in the oVirt web applications to use PatternFly (Bootstrap-based) tooltips.

### Owner

*   Name: [ Greg Sheremeta](User:Gshereme)
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

![](patternfly_tooltips1.png "patternfly_tooltips1.png")

![](patternfly_tooltips2.png "patternfly_tooltips2.png")

![](patternfly_tooltips3.png "patternfly_tooltips3.png")

![](patternfly_tooltips4.png "patternfly_tooltips4.png")

![](patternfly_tooltips5.png "patternfly_tooltips5.png")

![](patternfly_tooltips6.png "patternfly_tooltips6.png")

![](patternfly_tooltips7.png "patternfly_tooltips7.png")

![](patternfly_tooltips8.png "patternfly_tooltips8.png")

![](patternfly_tooltips9.png "patternfly_tooltips9.png")

![](patternfly_tooltips10.png "patternfly_tooltips10.png")

## Testing

Testing involves

*   Regression. Make sure screens haven't changed at all, in look or functionality. Pay special attention to grid columns, headers, and tooltips in both cells and headers.
*   Make sure all tooltips look the same. There should be no blue or yellow tooltips anywhere.

## Comments and Discussion

*   Refer to [Talk:Your feature name](Talk:Your feature name)

