---
title: Introducing Entity Search
authors:
  - lhornyak
  - mlipchuk
  - shireesh
---

<!-- TODO: Content review -->

# Introduction

This article intends to provide step by step instructions for introducing entity search in oVirt for a new entity.

# Introduce the Entity in Database

*   Database tables
*   Stored Procedures
*   DAO interface
*   DAO implementation
*   DAO JUnit tests

The DAO must have a method to fetch list of entities given a query e.g.

`   `*`public` `List`<GlusterVolumeEntity> `getAllWithQuery(String` `query);`*

You can use the org.ovirt.engine.core.dao.SearchDAO interface, that defines this method.

# Add SearchType entry

Introduce an entry (say *GlusterVolume*) for the entity in *org.ovirt.engine.core.common.interfaces.SearchType*

# Handle the new search type in the SearchQuery command

*   Introduce a method to prepare the query for fetching list of entities.

The genericSearch might be useful to use, as follow:
 '' genericSearch(DbFacade.getInstance().getGlusterVolumeDAO(), true, null); It should be the same as using the following code, but more generic:

        '' protected List`<GlusterVolumeEntity>` searchGlusterVolumes() {
        ''     List`<GlusterVolumeEntity>` returnValue = null;
        ''     QueryData2 data = InitQueryData(true);
        ''     if (data == null) {
        ''         returnValue = new ArrayList`<GlusterVolumeEntity>`();
        ''     } else {
        ''         returnValue = DbFacade.getInstance().getGlusterVolumeDAO().getAllWithQuery(data.getQuery());
        ''     }
        ''     return returnValue;
        '' }

*   Modify the source *org.ovirt.engine.core.bll.SearchQuery* by adding a switch case for the new search type in method *executeQueryCommand* and invoke the method created in above step

         ''case GlusterVolume: {
         ''        returnValue = searchGlusterVolumes();
         ''        break;
         ''    }

# Changes in SearchBackend project

This code is converted to JavaScript for rendering in browser. Following changes are required:

## Introduce a Search Object for your entity

Add an entry in *org.ovirt.engine.core.searchbackend.SearchObjects*

`   `*`public` `static` `final` `String` `GLUSTER_VOLUMES_OBJ_NAME` `=` `"VOLUMES";`*

Add entity name appended with : as a safe search expression in the init method

`   `*`SAFE_SEARCH_EXPR.add(GLUSTER_VOLUMES_OBJ_NAME.toLowerCase()` `+` `SEPERATOR);`*

## Search field Auto Completion

Add the entity (in plural) as a valid basic search verb in the constructor of *org.ovirt.engine.core.searchbackend.SearchObjectAutoCompleter*

`   `*`mVerbs.put(SearchObjects.GLUSTER_VOLUMES_OBJ_NAME,` `SearchObjects.GLUSTER_VOLUMES_OBJ_NAME);`*

In case you need to filter the entities based on other related entities e.g. Gluster Volumes that belong to a particular Cluster, introduce a Join with that entity in the same constructor.

`   `*`addJoin(SearchObjects.GLUSTER_VOLUMES_OBJ_NAME,` `"cluster_id",` `SearchObjects.VDC_CLUSTER_OBJ_NAME,` `"vds_group_id");`*

Modify method *getRelatedTableName* to return the correct table name for your entity.

         ''else if (StringHelper.EqOp(obj, SearchObjects.GLUSTER_VOLUMES_OBJ_NAME)) {
         ''        retval = "gluster_volumes";
         ''    }
             

Modify method *getPrimeryKeyName* to return the name of the primary key of your entity table

         ''else if (StringHelper.EqOp(obj, SearchObjects.GLUSTER_VOLUMES_OBJ_NAME)) {
         ''        retval = "id";
         ''    }

Modify method *getDefaultSort* to return the default ordering clause to be used in the SQL query while fetching your entity objects from the database.

         ''else if (StringHelper.EqOp(obj, SearchObjects.GLUSTER_VOLUMES_OBJ_NAME)) {
         ''        retval = "vol_name ASC ";
         ''    }
             

Modify method *getFieldAutoCompleter* and introduce an else if for your entity to return an object of the condition field auto completer that you will write for the entity.

         ''else if (StringHelper.EqOp(obj, SearchObjects.GLUSTER_VOLUMES_OBJ_NAME)) {
         ''        retval = new GlusterVolumeConditionFieldAutoCompleter();
         ''    }

If you have added a cross reference (join) with another object in the earlier step, modify the method *getCrossRefAutoCompleter* to return an object of the Cross Reference auto completer that you will write.

         ''} else if (StringHelper.EqOp(obj, SearchObjects.GLUSTER_VOLUMES_OBJ_NAME)) {
         ''        return new GlusterVolumeCrossRefAutoCompleter();
         ''    }

## Entity Condition Field Auto Completer

Write a new class that extends from *BaseConditionFieldAutoCompleter*. The job of this class is to provide information about auto completion to be provided for filtering the entities, based on attributes of the entity.

### The constructor

*   Add verbs for every attribute on which you want to support filtering
*   Invoke method buildCompletions after setting all verbs.
*   Define the types of every filtering attribute.
*   Add column name of every filtering attribute

      ''   public GlusterVolumeConditionFieldAutoCompleter() {
      ''       super();
      ''       // Building the basic verbs Dict
      ''       mVerbs.put("NAME", "NAME");
      ''       mVerbs.put("TYPE", "TYPE");
             ...
      ''       // Building the autoCompletion Dict
      ''       buildCompletions();
      ''       // Building the types dict
      ''       getTypeDictionary().put("NAME", String.class);
      ''       getTypeDictionary().put("TYPE", VOLUME_TYPE.class);
      ''       ...
      ''       // building the ColumnName Dict
      ''       mColumnNameDict.put("NAME", "vol_name");
      ''       mColumnNameDict.put("TYPE", "vol_type");
      ''       ...
      ''       // Building the validation dict
      ''       buildBasicValidationTable();
      ''   }

The "verbs" added here, are the first level of auto-completion. As soon as you type your entity name and press colon (e.g. "Volumes :") in the search text box in the UI, you will get a list of these verbs (along with verbs from the cross reference auto completer, if any), as auto-completion proposals.

The next step is to map every field with what kind of comparisons it supports.

### Method *getFieldRelationshipAutoCompleter*

Override this method to return appropriate "condition relation auto completer" for given field. e.g. Return *StringConditionRelationAutoCompleter* for string fields, *NumericConditionRelationAutoCompleter* for numeric fields, and so on. This reflects while typing the search string in the UI. As soon as you type the name of a numeric field and press the spacebar, you will see all numeric operators like <, >, =, !=, etc as auto-completion proposals.

The next step is to provide auto-completion for values of these fields. This can be useful if the values must be from a set of predefined values e.g. booleans, flags, enums.

### Method *getFieldValueAutoCompleter*

Override this method to return appropriate "condition value auto completer" for given field. e.g.

      ''   if (fieldName.equals("status")) {
      ''       return new EnumValueAutoCompleter(VOLUME_STATUS.class);
      ''   }

In case auto-completion is not required for values of the given field, return null

**Note:** If you use *EnumValueAutoCompleter*, the corresponding enum must provide following two methods:

      ''   public int getValue();
      ''   public static `<enum_name>` forValue(int value);

## Cross Reference Auto Completer

Write a new class that extends *SearchObjectsBaseAutoCompleter* and add required verbs in the constructor.

      ''   public GlusterVolumeCrossRefAutoCompleter() {
      ''       mVerbs.put(SearchObjects.VDC_CLUSTER_OBJ_NAME, 
      ''                           SearchObjects.VDC_CLUSTER_OBJ_NAME);
      ''       buildCompletions();
      ''   }

These verbs will also get added to the list of auto-completion proposals for the entity.

<<Other capabilities provided by the cross reference auto completer, if any, to be added>>

# GWT xml entries

Add entries for the newly created auto completer classes to frontend/webadmin/modules/sharedgwt/src/main/java/org/ovirt/engine/SharedGwt.gwt.xml

      ''   

     ''       ...
     ''       <include name="core/searchbackend/GlusterVolumeConditionFieldAutoCompleter.java" />
     ''       <include name="core/searchbackend/GlusterVolumeCrossRefAutoCompleter.java" />
     ''

# GWT Code

Following sources need changes in appropriate places to create node(s) for the entity in the system tree, add new tab(s) for the same and link it with the search text box

*   org.ovirt.engine.ui.uicommonweb.models.CommonModel
*   org.ovirt.engine.ui.uicommonweb.models.SystemTreeModel
*   New class(es) for the entity tab(s)

<<More details to be added if required>>
