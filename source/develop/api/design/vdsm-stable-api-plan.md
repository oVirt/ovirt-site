---
title: VDSM Stable API Plan
category: api
authors:
  - danken
  - iheim
  - smizrahi
---

<!-- TODO: Content review -->

# VDSM Stable API Plan

## API Schema

*   Decide on a formal format (are there any existing schema representation formats?)

Things to declare

*   Object names
*   Async vs Sync Call
*   Parameter hard types (incl. int types and string lengths)
*   Valid options for enums (maybe use introspection? Will be better for compatibility?)
*   Response
*   Object and struct details (Hard Types)
*   Events

## VDSM Supportability Guidelines

### Versioning

*   The API will be grouped by capabilities and each will be individually versioned. This has to be done to accommodate optional features.
*   The API is version as a whole, deprecation means a version bump where the deprecated methods are "forbidden" from use. For example if doSomething() became deprecated in version 2.1.X any application checking against version 2.1.X shouldn't use the verb.
*   The versioning scheme in the form of LATEST_API.OLDEST_API.BUGFIX. A client checking to see if the host is compatible needs to see if the API version it was made to work with is between and including MAJOR and MINOR. There will be a verb when you can put your version and it will say if it's supported for convenience.
*   Experimental verbs are unversioned and can appear or disappear at any time without notice.
*   VDSM Can export support for multiple supported API versions.

       {"Image Manipulator": "1.0.0",
        "Networking": "2.1.2",
        "Storage Connection Management": "3.0.4",
        "GlusterFS Support": "1.0.12"]}

*   Release with an API change is a new API version.
*   Versioning features separately means that clients that don't use certain parts of VDSM will not have to care if the bits they are not using change.

### Documentation

*   All API calls must be documented.
*   TBD. In code? In Schema?

### API Change

*   For API changes we will use the +1/-1 system.
*   For every API change there needs to be acks of at least 2 core developers. One of them has to be specialized at the subsystem in question.
*   Anyone can nack an API change.
*   Complex types should be easily extendable

### Experimental Verbs

*   All new APIs start their lives as experimental
*   Experimental verbs are mangled in a way where it's obvious to the user the call is experimental and WILL be changed.
*   When cementing an experimental call the same patch has to bump the version accordingly.
*   It's preferable to cement related calls as a group to prevent frequent API version changes.

### Deprecation

*   Deprecation should be done sparsely
*   Once marked deprecated, the API will remain available for at least 1 major release.

