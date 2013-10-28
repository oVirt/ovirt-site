---
title: DevProcess
authors: amureini, gina, granha, ovedo, roy, snmishra, ybronhei
wiki_title: DevProcess
wiki_revision_count: 13
wiki_last_updated: 2015-05-20
---

# Dev Process

## Development Process

The code you write, and the way you present it, are crucial for understanding and maintaining the source code. Please read the following sections for guidelines on Git, Gerrit, patch management and more.

### Patch Review Process Goals

The patch review process goals are:

1.  Improving code quality
2.  Design improvements
3.  Openness, transparency, community
4.  Usable revision history
5.  Archived discussions
6.  Patches which can be cherry-picked

The oVirt project uses gerrit in order to review patches. For more on Gerrit and how to use it see [Working with oVirt Gerrit](Working with oVirt Gerrit)

### Basic Principles

#### Review Process

1.  Patches sent to Gerrit for review
2.  A peer thoughtfully reviews the patch
3.  Feedback gratefully received
4.  All discussions on the patch must be done on Gerrit
5.  Consensus formed, ACK or NAK agreed

#### Patch Format

       component: short summary under 75 chars (#xxxxxx)
       https://bugzilla.redhat.com/XXXXXX
       
       Longer description.
       
       With multiple paragraphs if necessary.
       
       Wrapped at ~80 chars.
       

#### Patch Format For Work In Progress

       component: WIP: short summary under 75 chars (#xxxxxx)
       https://bugzilla.redhat.com/XXXXXX
       
       Longer description.
       
       With multiple paragraphs if necessary.
       
       Wrapped at ~80 chars.
       

#### Describe your changes properly

1.  Not just “what”, but “why”
2.  Makes patches easier to review
3.  Incredibly useful to future developers, and for you as well (don't trust your own memory)

#### Separate your changes

1.  Each commits contain a single logical change
2.  Keep refactoring separate from bug fixes

#### Focus on details

1.  Adhere to coding style
2.  Adhere to commit message format
3.  Make your code beautiful
4.  Refactor if necessary
5.  Use whitespaces and not tabs
6.  Prefer understandable code over comments

#### Patch queues

1.  Each topic branch is a patch queue
2.  Send each branch as a series of patches
3.  Gives reviewers an easy story to follow

#### Git guidelines

##### Merge commits

1.  Don't use 'git merge' or 'git pull'
2.  Use 'git rebase' and 'git fetch' instead
3.  A merge commit is rarely what you want

##### Topic branches

Create a branch for everything you work on. It can be done by either postfixing the topic to the push link

      push origin HEAD:refs/publish/master/name_of_topic

or using gerrit's review page directly by clicking on the topic

##### Interactive Rebase

You can also interactive rebase. It is very useful when you would like to re-write your own commit objects before pushing them somewhere. It is an easy way to split, merge or re-order commits before sharing them with others. You can also use it to clean up commits you've pulled from someone when applying them locally.

For more information on using interactive rebase see <http://book.git-scm.com/4_interactive_rebasing.html>
