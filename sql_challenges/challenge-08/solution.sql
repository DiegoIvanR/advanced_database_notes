-- Questions:
-- a) What scan type do you see? Why?
        Full table scan, because we haven't declared indexes
-- b) site_id has values 1–5. Is this high or low cardinality?
        low cardinality
-- c) Would adding an index on site_id help? Why or why not?
        not really since it can only hold like 5 values, doesn't really help


-- Step 1: Create it
-- (write the CREATE INDEX statement here)
    CREATE INDEX idx_pv_visit_date ON patient_visits(visit_date);
    
-- Questions:
-- a) Does Oracle use the index for this range?
    No
-- b) Change the range to the last 7 days. Does the plan change?
    No, still the same
-- c) Change to the last 700 days. What happens?
    Still the same
-- d) Why does the range size affect whether Oracle uses the index?
    It doesn't change because the optimizer doesn't deem it worth it of using index (to few values)
    but in an ideal world it would

-- Questions:
-- a) Does the plan use the composite index?
    Still not but i think it is a problem with freesql (not enough data?)
-- b) Now try querying ONLY on visit_date (no patient_id).
--    Does the composite index get used? Why not?
    Still not, but this time is because it doesnt have an index
-- c) What's the rule about column order in composite indexes?
    An index on (A, B) is useful for WHERE A = ... or WHERE A = ... AND B = .... It is generally not useful for WHERE B = ... because the index is sorted by A first, then B.


-- Questions:
-- a) What scan type did the second query use?
    Full Table Scan.
-- b) Why does wrapping a column in a function break index use?
    An index stores the original values of the column. When you apply TO_CHAR(patient_id), the result is a new value that doesn't exist in the index's sorted list. Oracle cant "know" which patient_id matches your string without calculating the function for every single row.
-- c) How would you rewrite the second query to allow index use?
    transform right side:
    SELECT * FROM patient_visits WHERE patient_id = TO_NUMBER('5432');


-- For each scenario below, decide:
A: 
--   a) Would you add an index?
    Yes
--   b) On which column(s)?
    date
--   c) Any concerns?
    drop the index before the nightly load and rebuild it after to make the data insertion faster. Indexes slow down INSERT operations.


B: 
--   a) Would you add an index?
    Yes
--   b) On which column(s)?
    Customer_id
--   c) Any concerns?
    Do not index order_status by itself. With only 4 values, it has poor selectivity.

C: 
--   a) Would you add an index?
    Yes
--   b) On which column(s)?
    Unique B-Tree Index on email.
--   c) Any concerns?
Email is highly unique (High Cardinality). A unique index is the "gold standard" for performance because Oracle stops searching the moment it finds the one matching row.