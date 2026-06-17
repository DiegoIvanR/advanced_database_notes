CREATE TABLE tickets (
    ticket_id   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title       VARCHAR2(200) NOT NULL,
    status      VARCHAR2(20)  DEFAULT 'open' NOT NULL,
    priority    VARCHAR2(10)  DEFAULT 'medium' NOT NULL,
    created_at  TIMESTAMP     DEFAULT SYSTIMESTAMP,
    resolved_at TIMESTAMP,
    assigned_to NUMBER        NOT NULL
);

CREATE TABLE ticket_assignments (
    assignment_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ticket_id     NUMBER    NOT NULL REFERENCES tickets(ticket_id),
    assigned_to   NUMBER    NOT NULL,
    assigned_by   NUMBER,
    valid_from    TIMESTAMP NOT NULL,
    valid_to      TIMESTAMP
);

CREATE OR REPLACE TRIGGER trg_ticket_assignment_log
    AFTER INSERT OR UPDATE OF assigned_to ON tickets
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        -- Initial assignment
        INSERT INTO ticket_assignments (ticket_id, assigned_to, assigned_by, valid_from)
        VALUES (:NEW.ticket_id, :NEW.assigned_to, NULL, :NEW.created_at);
    ELSIF UPDATING THEN
        -- Close the previous active assignment
        UPDATE ticket_assignments
           SET valid_to = SYSTIMESTAMP
         WHERE ticket_id = :OLD.ticket_id
           AND valid_to IS NULL;

        -- Open the new assignment
        INSERT INTO ticket_assignments (ticket_id, assigned_to, assigned_by, valid_from)
        VALUES (:NEW.ticket_id, :NEW.assigned_to, NULL, SYSTIMESTAMP);
    END IF;
END;
/
-- Insert 5 initial tickets
INSERT INTO tickets (title, status, priority, assigned_to) VALUES ('DB connection timeout', 'open', 'high', 1);
INSERT INTO tickets (title, status, priority, assigned_to) VALUES ('Update billing page', 'open', 'medium', 2);
INSERT INTO tickets (title, status, priority, assigned_to) VALUES ('Fix CSS grid on mobile', 'open', 'low', 3);
INSERT INTO tickets (title, status, priority, assigned_to) VALUES ('Reset forgotten password', 'resolved', 'low', 1);
INSERT INTO tickets (title, status, priority, assigned_to) VALUES ('API 500 error', 'open', 'critical', 2);
COMMIT;

-- Reassign ticket 1 from agent 1 to agent 3
UPDATE tickets 
   SET assigned_to = 3 
 WHERE ticket_id = 1;
COMMIT;

-- Reassign ticket 5 from agent 2 to agent 1
UPDATE tickets 
   SET assigned_to = 1 
 WHERE ticket_id = 5;
COMMIT;

CREATE TABLE dim_agent (
    agent_key  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    agent_id   NUMBER NOT NULL, -- Source system ID
    agent_name VARCHAR2(100) NOT NULL,
    team       VARCHAR2(50) NOT NULL
);

CREATE TABLE fact_ticket_daily (
    fact_key         NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    date_key         NUMBER NOT NULL, -- Format: YYYYMMDD
    agent_key        NUMBER NOT NULL REFERENCES dim_agent(agent_key),
    status           VARCHAR2(20),
    priority         VARCHAR2(10),
    tickets_created  NUMBER DEFAULT 0,
    tickets_resolved NUMBER DEFAULT 0
);

INSERT INTO dim_agent (agent_id, agent_name, team) VALUES (1, 'Alice Support', 'Tier 1');
INSERT INTO dim_agent (agent_id, agent_name, team) VALUES (2, 'Bob Tech', 'Tier 2');
INSERT INTO dim_agent (agent_id, agent_name, team) VALUES (3, 'Charlie Ops', 'Tier 3');
COMMIT;