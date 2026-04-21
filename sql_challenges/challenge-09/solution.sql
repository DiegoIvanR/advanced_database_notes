-- 1
BEGIN
    UPDATE accounts
    SET balance = Balance - 50
    WHERE account_id = 3;

    UPDATE accounts
    SET balance = Balance + 50
    WHERE account_id = 1;
END;
/

SELECT account_id, owner_name, balance
FROM accounts
ORDER BY account_id;

COMMIT;

SELECT account_id, owner_name, balance
FROM accounts
ORDER BY account_id;

-- 2
-- oracle begin and end are weird
SELECT * FROM accounts;

UPDATE accounts SET balance = balance - 10000 WHERE account_id = 2;
UPDATE accounts SET balance = balance + 10000 WHERE account_id = 3;

SELECT * FROM accounts;

ROLLBACK;

SELECT * FROM accounts;

-- 3

UPDATE accounts
SET balance = balance + 50
WHERE account_id = 1;
SAVEPOINT after_alice_balance;

UPDATE accounts
SET balance = balance - 25
WHERE account_id = 3;

ROLLBACK TO after_alice_balance;

UPDATE accounts
SET balance = balance - 25
WHERE account_id = 2;

COMMIT;

select * from accounts;


-- 4

CREATE OR REPLACE PROCEDURE deposit_funds(
    p_account_id IN NUMBER,
    p_amount IN NUMBER
)
IS
BEGIN
    IF p_amount <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Ammount must be greater than zero');
    END IF;
    UPDATE accounts
    SET balance = balance + p_amount
    WHERE account_id = p_account_id;
    COMMIT;

    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;

END;
/
SELECT * from accounts;

EXEC deposit_funds(3, 75);

SELECT * from accounts;

-- questions
-- Answer these in words (no SQL needed):

-- Q1: You're building a patient appointment booking system.
-- A booking requires:
--   a) Reserve the time slot
--   b) Create the appointment record
--   c) Send a confirmation notification
-- Which of these should be inside the transaction? Which should be outside? Why?

-- Reserve time slot and create the appointment record, because these need atomicity,
-- other it completes the transaction fully or not. Send a confirmation notification
-- can be outside since it can fail independently

-- Q2: Your stored procedure calls COMMIT at the end.
-- A developer calls your procedure from inside their own larger transaction.
-- What problem does this create?

-- it commits the changes before the dev's procedure is finished, violating the atomicity
-- of a transaction. 

-- Q3: You have a function called calculate_copay() and a procedure called post_payment().
-- A colleague wants to use calculate_copay() inside a SELECT statement.
-- Can they? Can they do the same with post_payment()? Why or why not?

-- calculate copay can be used in a select since its a function and returns a value
-- procedures do not return a value, soy they cant be used in a procedure, they are used to perform actions