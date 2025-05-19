-- Task: Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days) 
-- Set today's date for calculation
SET @today = CURDATE();

-- Step 1: Savings accounts with last transaction > 365 days ago
SELECT 
    s.id AS plan_id,
    s.owner_id,
    'Savings' AS type,
    MAX(s.transaction_date) AS last_transaction_date,
    DATEDIFF(@today, MAX(s.transaction_date)) AS inactivity_days
FROM savings_savingsaccount s
WHERE s.amount > 0
  AND s.transaction_date IS NOT NULL
GROUP BY s.id, s.owner_id
HAVING inactivity_days > 365

UNION ALL

-- Step 2: Investment plans with last known inflow > 365 days ago
SELECT 
    p.id AS plan_id,
    p.owner_id,
    'Investment' AS type,
    MAX(p.created_on) AS last_transaction_date,
    DATEDIFF(@today, MAX(p.created_on)) AS inactivity_days
FROM plans_plan p
WHERE p.amount > 0
  AND p.is_archived = 0
  AND p.is_deleted = 0
  AND p.created_on IS NOT NULL
GROUP BY p.id, p.owner_id
HAVING inactivity_days > 365;
