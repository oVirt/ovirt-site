---
title: User-level-query-column-filtering
authors: emesika
---

<!-- TODO: Content review -->

# User-level-query-column-filtering

## Overview

Suppose you have a table T with columns c1 c2 c3 c4. (c1 is the PK)
Also, assume that c3 and c4 includes sensetive information that should be shown only to Administrators. How do you achieve that?

## Solution

Adding a table called object_column_white_list that holds for each relevant table/view for which columns we want to show, other columns are filtered vertically, the column names that should have NULL values in the returned result. The script adding this table and inserting its initial data is reentrant and run the in pre-upgrade step.

A second table object_column_white_list_sql stores the generated sql per object. This sql is cleaned upon upgrade to reflect schema changes since if a column was added to an object that is already participating in vertical filtering, this column will be automatically filtered out unless added specifically in the upgrade/pre_upgrade/add_object_column_white_list_table.sql script.

A function fn_db_mask_object that accepts the object to filter and returns the result with filtered column values.

A function to add new object columns to the white list fn_db_add_column_to_object_white_list

### So, how do I filter c3 & c4 columns from T ?

1) Open upgrade/pre_upgrade/add_object_column_white_list_table.sql script.
2) Look for "Initial white list settings" comment.
3) Add at the end of this section.

```sql
         if not exists (select 1 from object_column_white_list where object_name = 'T') then
           insert into object_column_white_list(object_name,column_name)
           (select 'T', column_name
            from information_schema.columns
            where table_name = 'T' and
            column_name in ('c1,'c2');
```

4) Assume you have a SP that selects from T by id (c1 column), it should now look like :

```sql
      Create or replace FUNCTION GetAllFromT(v_id UUID, v_user_id UUID, v_is_filtered BOOLEAN)   
      RETURNS SETOF T
        AS $procedure$
      DECLARE
      v_columns text[];
      BEGIN
         BEGIN
           if (v_is_filtered) then
               RETURN QUERY SELECT DISTINCT (rec).*
               FROM fn_db_mask_object('T') as q (rec T)
               WHERE (rec).c1 = v_id
               AND EXISTS (SELECT 1
                   FROM   user_vds_permissions_view
                   WHERE  user_id = v_user_id AND entity_id = v_id);
           else
               RETURN QUERY SELECT DISTINCT T.*
               FROM T
               WHERE c1 = v_id;
           end if;
         END;
        RETURN;
      END; $procedure$
      LANGUAGE plpgsql;
```

5) You should add the following to fixters.xml

```xml
<table name="object_column_white_list">
       <column>object_name</column>
       <column>column_name</column>
   <row>
       <value>T</value>
       <value>c1</value>
   </row>
   <row>
       <value>T</value>
       <value>c2</value>
   </row>
</table>
```

That's all, this insures that administrator will get all c1 to c4 columns while users will get only c1 and c2.
