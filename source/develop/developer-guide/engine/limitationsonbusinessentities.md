---
title: LimitationsOnBusinessEntities
authors: yair zaslavsky
---

# LimitationsOnBusinessEntities

## Coding limitations on Business Entities

### Summary

Currently oVirt engine-core and web UI components of oVirt share the same business entities (i.e `org.ovirt.engine.core.common.DiskImageBase`).
As long as there is no separation of business entities between engine-core and web UI, there are some coding limitations (as a result of GWT compilation)
which should be addressed by developers defining a new entity.

### List of limitations

*   final members should not be used.

For example:
Use `int numberOfVms` instead of `final int numberOfVms`

*   Concrete collection classes should be used.

For example:
Use `ArrayList<DiskImage> getImages()` instead of `List<DiskImage> getImages()`
