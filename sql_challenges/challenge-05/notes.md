# SQL Set Operators

Set operators combine the results of **two or more SELECT queries** into a single result set.

The queries must have:

* The **same number of columns**
* **Compatible data types**
* **Same column order**

Basic Syntax

```sql
SELECT column_list
FROM table1

SET_OPERATOR

SELECT column_list
FROM table2;
```

---

# UNION

Combines results of two queries **and removes duplicates**.

```sql
SELECT column
FROM table1

UNION

SELECT column
FROM table2;
```

Behavior

* Merges both result sets
* **Duplicate rows are removed**

Example

table1

| id |
| -- |
| 1  |
| 2  |
| 3  |

table2

| id |
| -- |
| 3  |
| 4  |

Result

| id |
| -- |
| 1  |
| 2  |
| 3  |
| 4  |

Use when
You want **distinct combined results**.

---

# UNION ALL

Combines results **without removing duplicates**.

```sql
SELECT column
FROM table1

UNION ALL

SELECT column
FROM table2;
```

Behavior

* Faster than UNION
* **Keeps duplicates**

Example result

| id |
| -- |
| 1  |
| 2  |
| 3  |
| 3  |
| 4  |

Use when
Duplicates are acceptable or performance matters.

---

# INTERSECT

Returns rows that exist **in both queries**.

```sql
SELECT column
FROM table1

INTERSECT

SELECT column
FROM table2;
```

Behavior

* Only **common rows**
* Duplicates removed

Example

Result

| id |
| -- |
| 3  |

Use when
Finding **common records between datasets**.

---

# MINUS / EXCEPT

Returns rows in the **first query but not the second**.

Note

* **MINUS** → Oracle
* **EXCEPT** → PostgreSQL / SQL Server

```sql
SELECT column
FROM table1

MINUS

SELECT column
FROM table2;
```

Behavior

* Removes rows that appear in the second query

Example

Result

| id |
| -- |
| 1  |
| 2  |

Use when
You need **records present in A but not B**.

---

# Symmetric Difference

Rows that exist **in one table but not both**.

SQL does not have a direct operator, but it can be simulated.

```sql
SELECT column FROM table1
EXCEPT
SELECT column FROM table2

UNION

SELECT column FROM table2
EXCEPT
SELECT column FROM table1;
```

Behavior

* Removes intersection
* Returns **non-overlapping rows**

Example

Result

| id |
| -- |
| 1  |
| 2  |
| 4  |

Use when
You want rows **unique to each dataset**.

---

# Visual Intuition (Set Theory)

If A and B are sets:

| Operator             | Meaning                 |
| -------------------- | ----------------------- |
| UNION                | A ∪ B                   |
| UNION ALL            | A ∪ B (with duplicates) |
| INTERSECT            | A ∩ B                   |
| MINUS / EXCEPT       | A − B                   |
| Symmetric Difference | (A − B) ∪ (B − A)       |

---
