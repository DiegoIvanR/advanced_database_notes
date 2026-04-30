-- When migrating exported DDL from SCHEMA_OLD to SCHEMA_NEW, 
-- the main change is removing or updating schema-qualified 
-- names so the code works in the new environment. This includes 
-- modifying statements like CREATE TABLE "SCHEMA_OLD"."TABLE_NAME" 
-- to either omit the schema or replace it with the new one, and 
-- fixing foreign key references that point to the old schema 
-- (e.g., REFERENCES SCHEMA_OLD.TABLE). It’s also important to 
-- review views, procedures, and triggers for hardcoded schema 
-- references and update them accordingly.

-- Additionally, environment-specific details such as tablespace 
-- names, storage parameters, and segment attributes should be 
-- removed to ensure portability across databases. You must also 
-- verify that dependent objects are created in the correct order 
-- (tables first, then constraints, indexes, views, and code) and 
-- ensure sequences, triggers, and permissions are properly adjusted 
-- so they reference the correct schema and objects in the new database.

SELECT DBMS_METADATA.GET_DDL('TABLE', table_name)
FROM user_tables;

SELECT constraint_name, table_name, r_constraint_name
FROM user_constraints
WHERE constraint_type = 'R';

-- 3 no constraints found

-- 4
-- Export all DDL using EMIT_SCHEMA = false to remove hardcoded schema names
-- Review foreign key (FK) constraints for any references to the old schema
-- Update constraint references to point to the correct schema or local objects
-- Reload objects in the correct order: tables → constraints → indexes → views → code


-- excercise 5
SELECT referenced_name,
       name AS referencing_name,
       type AS referencing_type
FROM user_dependencies
ORDER BY referenced_name;

SELECT name AS referencing_name,
       type AS referencing_type
FROM user_dependencies
WHERE referenced_name IN (
  SELECT table_name FROM user_tables
)
ORDER BY type, name;

SELECT referenced_name,
       referenced_type
FROM user_dependencies
WHERE name = 'PROC_NAME';

SELECT name AS referencing_name,
       type AS referencing_type,
       LISTAGG(referenced_name, ', ') 
         WITHIN GROUP (ORDER BY referenced_name) AS dependencies
FROM user_dependencies
WHERE type IN ('PACKAGE', 'PROCEDURE', 'FUNCTION')
GROUP BY name, type
ORDER BY type, name;

-- excercise 6

-- To back up and migrate the schema without expdp, I would first 
-- document the current structure by querying user_objects and 
-- user_tables to understand the number and types of objects and 
-- their data volume. Then, I would use DBMS_METADATA.GET_DDL to 
-- extract the full DDL for all schema objects, including tables, 
-- indexes, views, sequences, constraints, and PL/SQL code. I would 
-- configure transform parameters to remove storage, tablespace, 
-- and schema-specific details so the DDL is portable, and save 
-- the output manually (spooling or copying).

-- Next, I would recreate the schema in the target database by 
-- executing the extracted DDL in the correct dependency order: 
-- tables first (without foreign keys), followed by sequences, 
-- indexes, constraints, views, and finally procedures, functions, 
-- packages, and triggers. After the migration, I would verify 
-- success by comparing object counts, checking table data, and 
-- ensuring indexes and dependencies are correctly created.
