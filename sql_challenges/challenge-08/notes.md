1. Indexing Fundamentals

    Purpose: Speeds up data retrieval (SELECTs) at the cost of slower data modification (INSERT, UPDATE, DELETE).

    B-Tree Index: The default. Stores data in a balanced tree for logarithmic search time: O(logn).

    Selectivity: The ratio of unique values to total rows. High Selectivity (e.g., Email, ID) = Great for indexing. Low Selectivity (e.g., Gender, Status) = Poor for indexing.

2. Common Syntax (SQL/Oracle)
Task	SQL Syntax
Standard Index	CREATE INDEX idx_name ON table_name(column);
Unique Index	CREATE UNIQUE INDEX idx_name ON table_name(unique_col);
Composite Index	CREATE INDEX idx_name ON table_name(col1, col2);
Function-Based	CREATE INDEX idx_name ON table_name(UPPER(column));
Drop Index	DROP INDEX idx_name;
Rebuild (Oracle)	ALTER INDEX idx_name REBUILD;
3. The "Golden Rules" of Performance

    The Leading Edge Rule: A composite index (A, B, C) is used if your WHERE clause includes A. If you only query B and C, the index is usually ignored.

    Don't Wrap Columns: Applying a function to a column in a WHERE clause kills the index.

        Bad: WHERE TRUNC(create_date) = SYSDATE

        Good: WHERE create_date >= TRUNC(SYSDATE) AND create_date < TRUNC(SYSDATE) + 1

    Index the Foreign Keys: Always index columns used in JOIN conditions to prevent Full Table Scans on every join.

4. Understanding Scan Types

    Index Unique Scan: Best case scenario. Finding one row via a Unique/Primary Key.

    Index Range Scan: Finding multiple rows within a range (e.g., BETWEEN or >).

    Index Full Scan: Reading the entire index in order (cheaper than a table scan if the table is wide).

    Full Table Scan (FTS): Reading every block in the table. Oracle chooses this if your query returns >5−10% of the table.

5. Decision Matrix: When to Index?
Scenario	Index?	Why?
High Cardinality	Yes	Specific lookups are very fast.
Small Tables	No	Reading the whole table into memory is faster than an index lookup.
Frequently Updated	No/Rarely	Every UPDATE must also update the index, causing overhead.
Large Text (BLOB)	No	Use Full-Text Search engines instead of standard indexes.
Columns in ORDER BY	Yes	Indexes are pre-sorted; they can eliminate expensive SORT operations.
6. Maintenance & Troubleshooting

    Stale Stats: If the Optimizer isn't using a good index, check your statistics.

        Oracle: EXEC DBMS_STATS.GATHER_TABLE_STATS(USER, 'MY_TABLE');

    Unused Indexes: Use monitoring to find and drop indexes that aren't used but are slowing down DML.

        Oracle: ALTER INDEX idx_name MONITORING USAGE;

    Invisible Indexes (Oracle): ALTER INDEX idx_name INVISIBLE; (Test dropping an index without actually deleting it).