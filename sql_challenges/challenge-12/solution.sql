WITH team_stats AS (
    SELECT 
        t.id AS team_id,
        t.name AS team_name,
        COUNT(DISTINCT u.id) AS member_count,
        COUNT(CASE WHEN ts.status = 'completed' THEN ts.id END) AS completed_tasks
    FROM teams t
    LEFT JOIN users u ON u.team_id = t.id
    LEFT JOIN tasks ts ON ts.assigned_to = u.id
    GROUP BY t.id, t.name
),
velocity_calc AS (
    SELECT 
        team_name,
        completed_tasks,
        member_count,
        ROUND(completed_tasks / NULLIF(member_count, 0), 2) AS team_velocity
    FROM team_stats
)
SELECT 
    team_name,
    completed_tasks,
    member_count,
    team_velocity,
    AVG(team_velocity) OVER () AS overall_avg_velocity,
    CASE 
        WHEN team_velocity < AVG(team_velocity) OVER () THEN 'Below Average'
        ELSE 'On Track / Above'
    END AS performance_flag
FROM velocity_calc
ORDER BY team_velocity DESC;


WITH task_lateness AS (
    SELECT 
        priority,
        id,
        CASE 
            WHEN TRUNC(completed_at) <= due_date THEN 1 
            ELSE 0 
        END AS is_on_time,
        CASE 
            WHEN completed_at > due_date THEN
                EXTRACT(DAY FROM (completed_at - CAST(due_date AS TIMESTAMP))) * 24 +
                EXTRACT(HOUR FROM (completed_at - CAST(due_date AS TIMESTAMP)))
            ELSE 0 
        END AS lateness_hours
    FROM tasks
    WHERE status = 'completed' AND due_date IS NOT NULL
)
SELECT 
    priority,
    COUNT(*) AS total_completed_with_due,
    ROUND((SUM(is_on_time) / COUNT(*)) * 100, 2) AS on_time_delivery_rate_pct,
    ROUND(AVG(CASE WHEN lateness_hours > 0 THEN lateness_hours END), 1) AS avg_lateness_hours
FROM task_lateness
GROUP BY priority
ORDER BY on_time_delivery_rate_pct DESC;

SELECT 
    t.name AS team_name,
    COUNT(ts.id) AS total_tasks,
    COUNT(CASE WHEN ts.status IN ('open', 'in_progress', 'blocked') THEN 1 END) AS active_tasks,
    ROUND(
        (COUNT(CASE WHEN ts.status = 'completed' THEN 1 END) / 
        NULLIF(COUNT(CASE WHEN ts.status != 'cancelled' THEN 1 END), 0)) * 100, 2
    ) AS completion_rate_pct,
    CASE 
        WHEN COUNT(CASE WHEN ts.status IN ('open', 'in_progress', 'blocked') THEN 1 END) > 10 THEN 'Overloaded'
        WHEN COUNT(CASE WHEN ts.status IN ('open', 'in_progress', 'blocked') THEN 1 END) BETWEEN 5 AND 10 THEN 'Healthy'
        ELSE 'Underutilized'
    END AS health_score
FROM teams t
LEFT JOIN users u ON u.team_id = t.id
LEFT JOIN tasks ts ON ts.assigned_to = u.id
GROUP BY t.id, t.name
ORDER BY active_tasks DESC;

WITH raw_durations AS (
    SELECT 
        priority,
        (EXTRACT(DAY FROM (completed_at - created_at)) * 24 +
         EXTRACT(HOUR FROM (completed_at - created_at)) +
         EXTRACT(MINUTE FROM (completed_at - created_at)) / 60) AS resolution_hours
    FROM tasks
    WHERE status = 'completed' AND completed_at IS NOT NULL
)
SELECT 
    priority,
    COUNT(*) AS completed_task_count,
    ROUND(AVG(resolution_hours), 1) AS avg_resolution_hours,
    -- Median calculation using Oracle's PERCENTILE_CONT
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY resolution_hours), 1) AS median_resolution_hours,
    ROUND(MIN(resolution_hours), 1) AS fastest_resolution_hours,
    ROUND(MAX(resolution_hours), 1) AS slowest_resolution_hours,
    CASE 
        WHEN priority = 'critical' AND AVG(resolution_hours) <= 24 THEN 'MET'
        WHEN priority = 'high'     AND AVG(resolution_hours) <= 72 THEN 'MET'
        WHEN priority = 'medium'   AND AVG(resolution_hours) <= 168 THEN 'MET'
        WHEN priority = 'low'      AND AVG(resolution_hours) <= 336 THEN 'MET'
        ELSE 'BREACHED'
    END AS sla_target_status
FROM raw_durations
GROUP BY priority
ORDER BY avg_resolution_hours ASC;

WITH base_overdue AS (
    SELECT 
        ts.title,
        u.full_name AS assignee,
        tm.name AS team_name,
        ts.priority,
        ts.due_date,
        -- Oracle syntax to find days between today and due_date
        TRUNC(SYSDATE) - TRUNC(ts.due_date) AS days_overdue,
        CASE 
            WHEN ts.priority = 'critical' AND (TRUNC(SYSDATE) - TRUNC(ts.due_date)) > 0 THEN 'CRITICAL'
            WHEN ts.priority = 'high'     AND (TRUNC(SYSDATE) - TRUNC(ts.due_date)) > 2 THEN 'HIGH'
            WHEN ts.priority = 'medium'   AND (TRUNC(SYSDATE) - TRUNC(ts.due_date)) > 5 THEN 'MEDIUM'
            ELSE 'LOW'
        END AS severity
    FROM tasks ts
    LEFT JOIN users u ON ts.assigned_to = u.id
    LEFT JOIN teams tm ON u.team_id = tm.id
    WHERE ts.due_date < TRUNC(SYSDATE)
      AND ts.status NOT IN ('completed', 'cancelled')
      AND ts.due_date IS NOT NULL
)
SELECT title, assignee, team_name, priority, due_date, days_overdue, severity
FROM base_overdue
UNION ALL
-- Summary Rows using UNION ALL to mimic custom Rollup behavior neatly
SELECT 
    '=== SUMMARY: ' || severity || ' ===' AS title,
    NULL AS assignee,
    NULL AS team_name,
    NULL AS priority,
    NULL AS due_date,
    ROUND(AVG(days_overdue), 1) AS days_overdue,
    severity
FROM base_overdue
GROUP BY severity
ORDER BY 
    CASE severity 
        WHEN 'CRITICAL' THEN 1 
        WHEN 'HIGH' THEN 2 
        WHEN 'MEDIUM' THEN 3 
        WHEN 'LOW' THEN 4 
    END ASC, 
    days_overdue DESC;


    SELECT 
    u.full_name,
    COUNT(CASE WHEN ts.status = 'completed' THEN 1 END) AS completed_task_count,
    SUM(CASE WHEN ts.status = 'completed' THEN
            CASE ts.priority 
                WHEN 'critical' THEN 4
                WHEN 'high'     THEN 3
                WHEN 'medium'   THEN 2
                WHEN 'low'      THEN 1
                ELSE 0 
            END
        ELSE 0 
    END) AS weighted_productivity_score
FROM users u
LEFT JOIN tasks ts ON ts.assigned_to = u.id
GROUP BY u.id, u.full_name
ORDER BY weighted_productivity_score DESC;

SELECT 
    t.name AS team_name,
    COUNT(CASE WHEN ts.status = 'completed' THEN 1 END) AS completed_tasks,
    COUNT(CASE WHEN ts.status != 'cancelled' THEN 1 END) AS total_valid_tasks,
    ROUND(
        (COUNT(CASE WHEN ts.status = 'completed' THEN 1 END) / 
        NULLIF(COUNT(CASE WHEN ts.status != 'cancelled' THEN 1 END), 0)) * 100, 2
    ) AS team_efficiency_pct
FROM teams t
LEFT JOIN users u ON u.team_id = t.id
LEFT JOIN tasks ts ON ts.assigned_to = u.id
GROUP BY t.id, t.name
ORDER BY team_efficiency_pct DESC;

EXERCISE 8: Fix the "Urgency Index"
SQL


SELECT 
    title,
    priority,
    due_date,
    CASE 
        WHEN due_date IS NULL THEN 0
        ELSE (TRUNC(SYSDATE) - TRUNC(due_date)) -- Positive if overdue
    END AS days_overdue,
    (CASE priority 
        WHEN 'critical' THEN 40
        WHEN 'high'     THEN 30
        WHEN 'medium'   THEN 20
        WHEN 'low'      THEN 10
        ELSE 0 
     END + 
     CASE 
        WHEN due_date IS NULL THEN 0
        ELSE (TRUNC(SYSDATE) - TRUNC(due_date)) * 2 -- Amplify overdue impact
     END) AS true_urgency_score
FROM tasks
WHERE status NOT IN ('completed', 'cancelled')
ORDER BY true_urgency_score DESC;z