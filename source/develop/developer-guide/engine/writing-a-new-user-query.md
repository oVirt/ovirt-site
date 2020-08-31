---
title: Writing A New User Query
authors: amureini
---

# Writing a New User Query

## What Are User Queries?

[User queries](/develop/release-management/features/infra/user-portal-permissions.html) are, in a nutshell, queries that can be run a regular user, without requiring admin permissions.

## The General Case

In the general case, your query will call one of the DAOs, which, in turn, will call a stored procedure in the database. When writing a User Query, there are several aspects you must address.

### Permission View

Each entity with managed permissions has its own flattened view of user permissions called `user_OBJECT_NAME_permissions_view` (e.g., VM permissions are listed in `user_vm_permissions_view`).
Notes:

1.  The view only lists **user** permissions. A user that has administrator permissions on an object will not be represented here.
2.  The view flattens object hierarchies. E.g., if a user should be able to query a VM since he has permissions on the Storage Pool containing it, that user permission will appear in the VM view. You do not have to handle it yourself.
3.  The view flattens group hierarchies. E.g., if a user should be able to query a VM since a group he's contained in has permissions on the VM, that user permission will appear in the VM view. You do not have to handle it yourself.

### Stored Procedure

The stored procedure should, besides the parameters involved in the query's logic, contain two more parameters - a UUID `user_id` and a BOOLEAN `is_filtered` flag. If `is_filtered` is `TRUE` only the objects the user has permissions on should be returned. If it's `FALSE`, the `user_id` should be ignored.

The query inside the stored procedure should have a part of the where clause which represents this, as follows:

```sql
Create or replace FUNCTION GetImagesByVmGuid(v_vm_guid UUID, v_user_id UUID, v_is_filtered BOOLEAN)
RETURNS SETOF vm_images_view
   AS $procedure$
BEGIN
      RETURN QUERY SELECT *
      FROM vm_images_view
      WHERE
      vm_guid = v_vm_guid
      AND (NOT v_is_filtered OR EXISTS (SELECT 1
                                        FROM   user_vm_permissions_view
                                        WHERE  user_id = v_user_id AND entity_id = v_vm_guid));

END; $procedure$
LANGUAGE plpgsql;
```

### DAO

The DAO should contain two overloaded methods - one with the `userID` and `isFiltered` parameters and one without, which assumes its run as an administrator and passes `null` and `false`, respectively, to the first flavor.

E.g.:

```java
@Override
public List<DiskImage> getAllForVm(Guid id) {
    return getAllForVm(id, null, false);
}

@Override
public List<DiskImage> getAllForVm(Guid id, Guid userID, boolean isFiltered) {
    MapSqlParameterSource parameterSource = getCustomMapSqlParameterSource()
            .addValue("vm_guid", id).addValue("user_id", userID).addValue("is_filtered", isFiltered);

    return groupImagesStorage(getCallsHandler().executeReadList("GetImagesByVmGuid",
                fullDiskImageRowMapper,
                parameterSource));
}
```

### Query

The `userID` parameter is available by the `getUserID()` method. The `isFiltered` parameter is available from the query parameters by the `isFiltered()` method.

E.g.:

```java
@Override
protected void executeQueryCommand() {
    getQueryReturnValue().setReturnValue(
        getDbFacade().getDiskImageDAO().getAllForVm(getParameters().getVmId(), getUserID(), getParameters().isFiltered())
    );
}
```

### VdcQueryType

In order for your new query to be treated as a User Query, add a new entry for it in the VdcQueryType enum, with the optional parameter. E.g.:

```java
...
GetAllDisksByVmId(VdcQueryAuthType.User),
...
```

#### Testing your Query

A test case should be written for each new query. You can use the guidelines in the [Testing Queries](/develop/dev-process/unit-testing-utilities/testing-queries.html) article.
