A trigger is a block of code (PL/SQL in Oracle) that runs automatically when a specific event happens on a table or view.

### When do triggers fire?

Triggers execute on database events such as:

INSERT
UPDATE
DELETE
### Types of triggers
By timing:
BEFORE → runs before the operation
AFTER → runs after the operation
By scope:
FOR EACH ROW → runs once per affected row
Statement-level → runs once per SQL statement
### Key concepts
:NEW → new values (for INSERT/UPDATE)
:OLD → existing values (for UPDATE/DELETE)
USER → current database user
SYSDATE → current date/time
### Common uses
Enforcing business rules
Validating data
Automatically filling columns (audit fields)
Preventing unauthorized changes
### Example idea
BEFORE INSERT → set created_date automatically
BEFORE UPDATE → check permissions
BEFORE DELETE → restrict access
### Important notes
Triggers run automatically (no manual call)
Errors inside triggers can stop the operation
Overusing triggers can make systems harder to debug
### One-line takeaway

 A trigger is an automatic rule in the database that runs when data changes.