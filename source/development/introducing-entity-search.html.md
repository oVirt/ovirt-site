---
title: Introducing Entity Search
authors: lhornyak, mlipchuk, shireesh
wiki_title: Development/Introducing Entity Search
wiki_revision_count: 5
wiki_last_updated: 2012-03-04
---

# Introduction

This article intends to provide step by step instructions for introducing entity search in oVirt for a new entity.

# Introduce the Entity in Database

      - Database tables
      - Stored Procedures
      - DAO interface
      - DAO implementation
      - DAO JUnit tests

The DAO must have a method to fetch list of entities given a query e.g.

         public List`<GlusterVolumeEntity>` getAllWithQuery(String query);

# Add SearchType entry

Introduce an entry (say GlusterVolume) for the entity in org.ovirt.engine.core.common.interfaces.SearchType

# Handle the new search type in the SearchQuery command

*   Introduce a method to prepare the query and fetch list of entities by executing the same

         protected List`<GlusterVolumeEntity>` searchGlusterVolumes() {
             List`<GlusterVolumeEntity>` returnValue = null;
             QueryData2 data = InitQueryData(true);
             if (data == null) {
                 returnValue = new ArrayList`<GlusterVolumeEntity>`();
             } else {
                 returnValue = DbFacade.getInstance().getGlusterVolumeDAO().getAllWithQuery(data.getQuery());
             }
             return returnValue;
         }

Modify the source org.ovirt.engine.core.bll.SearchQuery as follows:

*   Add a switch case for the new search type in method executeQueryCommand and invoke the method created in above step

         case GlusterVolume: {
                 returnValue = searchGlusterVolumes();
                 break;
             }
