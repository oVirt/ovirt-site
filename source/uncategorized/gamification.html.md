---
title: Gamification
authors: eedri, vszocs
wiki_title: Gamification
wiki_revision_count: 4
wiki_last_updated: 2014-06-08
---

# Gamification

## Summary

[Gamification](http://en.wikipedia.org/wiki/Gamification) is the use of concepts commonly found in games to engage users in solving problems.

In oVirt, Gamification refers to the initiative that aims to increase awareness of the project and its features by engaging users to accomplish various tasks, collect rewards and make their progress visible in an encouraging way.

[Projects](#Projects) listed below have one goal in common: *have fun and learn about oVirt at the same time*.

### Leader

*   [Eyal Edri](User:Eedri) <eedri@redhat.com>

## Projects

### ProgressBar UI plugin

Summary  
[UI plugin](Features/UIPlugins) that tracks the progress of using an oVirt system through achievements

Owner  
[Vojtech Szocs](User:Vszocs) <vszocs@redhat.com>

Current status  
in progress, code available as [patch](http://gerrit.ovirt.org/#/c/23013/) in gerrit

ProgressBar is meant to encourage users to explore oVirt features through WebAdmin UI.

![oVirt ProgressBar PoC](Progressbar-plugin-poc.png "oVirt ProgressBar PoC")

**Basic concepts**

*   achievement is the basic unit of tracking user's progress
*   each achievement maps to one or more feature(s)
*   achievements are organized into different categories (Networking, Storage, etc.)
*   achievement can be in following states:
    -   locked - achievement not completed yet, show mini-guide (hint) on how to unlock it
    -   unlocked - achievement completed, show mini-doc with summary on feature(s) behind it
    -   blocked - completion of this achivement depends on completion of another achievement

**Tracking progress**

*   each achievement has one or more completion condition(s) - tracking progress of given achievement
*   progress = % of achievements unlocked in given category (category progress) or in total (global progress)
*   rank = textual representation of progress (Novice, Master, etc.)

**Advanced concepts**

*   achievements can be organized into levels

### Space Shooter UI plugin

Summary  
[UI plugin](Features/UIPlugins) that serves as demo/tutorial on writing simple plugin

Owner  
[Vojtech Szocs](User:Vszocs) <vszocs@redhat.com>

Current status  
finished, code available from [sample UI plugin repository](Features/UIPlugins#Sample_UI_plugins) as `space-shooter-plugin`

Space Shooter ([tutorial](Tutorial/UIPlugins/CrashCourse)) is meant to walk you through the basics of creating your first UI plugin.

![oVirt Space Shooter](OVirt_Space_Shooter_3.png "oVirt Space Shooter")
