-- ============================================================
-- Lesson 03: SQLAlchemy ORM + Alembic Migrations
-- File: 01_setup_schema.sql
-- Purpose: V1 Schema — teams, users, tasks
--
-- Run this in your FreeSQL worksheet to create the base tables.
-- ============================================================

-- Drop tables if they exist (clean start)
DROP TABLE IF EXISTS tasks;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS teams;

-- ============================================================
-- TEAMS
-- ============================================================
CREATE TABLE teams (
    id          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name        VARCHAR2(50)  NOT NULL UNIQUE,
    description VARCHAR2(200),
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- USERS
-- ============================================================
CREATE TABLE users (
    id          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username    VARCHAR2(50)  NOT NULL UNIQUE,
    email       VARCHAR2(100) NOT NULL,
    full_name   VARCHAR2(100),
    team_id     NUMBER,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_users_team
        FOREIGN KEY (team_id) REFERENCES teams(id)
);

-- ============================================================
-- TASKS
-- ============================================================
CREATE TABLE tasks (
    id           NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title        VARCHAR2(200) NOT NULL,
    description  VARCHAR2(1000),
    status       VARCHAR2(20)  DEFAULT 'open',
    assigned_to  NUMBER,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP,
    CONSTRAINT fk_tasks_user
        FOREIGN KEY (assigned_to) REFERENCES users(id)
);

-- ============================================================
-- SEED DATA
-- ============================================================

-- Teams
INSERT INTO teams (name, description) VALUES ('Engineering', 'Software development team');
INSERT INTO teams (name, description) VALUES ('Product', 'Product management team');

-- Users
INSERT INTO users (username, email, full_name, team_id)
    VALUES ('alice_dev', 'alice@example.com', 'Alice Smith', 1);
INSERT INTO users (username, email, full_name, team_id)
    VALUES ('bob_dev', 'bob@example.com', 'Bob Jones', 1);
INSERT INTO users (username, email, full_name, team_id)
    VALUES ('carol_pm', 'carol@example.com', 'Carol White', 2);

-- Tasks
INSERT INTO tasks (title, description, status, assigned_to)
    VALUES ('Fix login bug', 'Users cannot log in with SSO', 'open', 1);
INSERT INTO tasks (title, description, status, assigned_to)
    VALUES ('Design new dashboard', 'Create mockups for analytics page', 'in_progress', 3);
INSERT INTO tasks (title, description, status, assigned_to)
    VALUES ('Update dependencies', 'Upgrade numpy and pandas', 'open', 2);

COMMIT;

-- ============================================================
-- VERIFY
-- ============================================================
SELECT 'Teams:' AS section, name FROM teams
UNION ALL
SELECT 'Users:' AS section, username FROM users
UNION ALL
SELECT 'Tasks:' AS section, title FROM tasks;

 

-----

 

 

---

# Lesson Exercises

---

# Exercise 1 — Model Design (10 min)

## Scenario

Your task system needs a `comments` table.

Each comment belongs to:
- one task
- one user

---

## Task

Create a new Colab cell and write the `Comment` model.

### Required Fields

- `id`
- `task_id`
- `user_id`
- `content`
- `created_at`

---

## Questions

1. What relationships should `Comment` have?
- Foreign key to task.id, foreign key to user.id
2. Should `Task` have a `comments` relationship?
- Not needed, a task can have many comments
3. What should happen to comments when a task is deleted?
- Also be deleted

---

# Exercise 2 — Migration Creation (10 min)

## Scenario

You added the `Comment` model.

Now generate a migration programmatically.

---

## Task

Run:

```python
command.revision(
    alembic_cfg,
    autogenerate=True,
    message="add comments table"
)
```

---

## Then Inspect the Migration

```python
import glob

migration_files = sorted(
    glob.glob('/content/project/alembic/versions/*.py')
)

for f in migration_files:
    print(f)
```

---

## Open the Generated Migration

```python
latest = migration_files[-1]

with open(latest) as f:
    print(f.read())
```

---

## Questions

1. What does `upgrade()` do?
create and execute the queries needed to match the models.
def upgrade():
    op.create_table('comments',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('comment', sa.Text(), nullable=True),
    sa.Column('task_id', sa.Integer(), nullable=True),
    sa.Column('user_id', sa.Integer(), nullable=True),
    sa.Column('content', sa.Text(), nullable=True),
    sa.Column('created_at', sa.DateTime(), server_default=sa.text('CURRENT_TIMESTAMP'), nullable=True),
    sa.ForeignKeyConstraint(['task_id'], ['tasks.id'], ),
    sa.ForeignKeyConstraint(['user_id'], ['users.id'], ),
    sa.PrimaryKeyConstraint('id')
    )
    op.alter_column('tasks', 'created_at',
               existing_type=oracle.TIMESTAMP(),
               type_=sa.DateTime(),
               existing_nullable=True,
               existing_server_default=sa.text('CURRENT_TIMESTAMP'))
    op.alter_column('tasks', 'updated_at',
               existing_type=oracle.TIMESTAMP(),
               type_=sa.DateTime(),
               existing_nullable=True)
    op.alter_column('teams', 'created_at',
               existing_type=oracle.TIMESTAMP(),
               type_=sa.DateTime(),
               existing_nullable=True,
               existing_server_default=sa.text('CURRENT_TIMESTAMP\n'))
    op.alter_column('users', 'created_at',
               existing_type=oracle.TIMESTAMP(),
               type_=sa.DateTime(),
               existing_nullable=True,
               existing_server_default=sa.text('CURRENT_TIMESTAMP'))

2. What does `downgrade()` do?
reverse the changes made by upgrade
def downgrade():
    op.alter_column('users', 'created_at',
               existing_type=sa.DateTime(),
               type_=oracle.TIMESTAMP(),
               existing_nullable=True,
               existing_server_default=sa.text('CURRENT_TIMESTAMP'))
    op.alter_column('teams', 'created_at',
               existing_type=sa.DateTime(),
               type_=oracle.TIMESTAMP(),
               existing_nullable=True,
               existing_server_default=sa.text('CURRENT_TIMESTAMP\n'))
    op.alter_column('tasks', 'updated_at',
               existing_type=sa.DateTime(),
               type_=oracle.TIMESTAMP(),
               existing_nullable=True)
    op.alter_column('tasks', 'created_at',
               existing_type=sa.DateTime(),
               type_=oracle.TIMESTAMP(),
               existing_nullable=True,
               existing_server_default=sa.text('CURRENT_TIMESTAMP'))
    op.drop_table('comments')
3. What happens if you downgrade this migration?
the database changes made in upgrade() are reversed. if upgrade is not executed before, migration fails

---

## Bonus

Add a CHECK constraint so `content != ''`

---

# Exercise 3 — CRUD Challenge (10 min)

## Scenario

Write a script that:

1. Creates a team called `"DevOps"`
2. Creates a user `"diana_ops"`
3. Creates 3 tasks with different priorities
4. Prints task count
5. Closes one task
6. Deletes the lowest priority task

---

## Requirements

- Use ORM only
- Use relationships
- Print output clearly

---

# Exercise 4 — Migration Rollback (5 min)

## Scenario

You added a bad column:
`estimated_hours`

The migration has already been applied.

---

## Task

Rollback the migration programmatically.

### Example

```python
command.downgrade(alembic_cfg, "-1")
```

---

## Questions

1. What happens to the column?
i mean it was deleted with no problem
2. What happens to the data?
also gone

---

# Exercise 5 — Concept Check (5 min)

Answer briefly:

1. Why use ORM instead of raw SQL?
Easier to understand, version control
2. Why use migrations?
To make repeatable and downgradable changes to the db
3. When would you rollback?
When a feature breaks the production environment, when a feature wasn't needed
4. Difference between `add()` and `commit()`?
add() places an object into the SQLAlchemy session so it is tracked for insertion/update.
commit() permanently saves all pending changes in the session to the database.
5. Why are relationships useful?
makes it easier to work with related database records using Python objects instead of manual SQL joins.
---