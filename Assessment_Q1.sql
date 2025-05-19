-- Task 1 Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.
-- Step 1: Get funded savings
WITH funded_savings AS (
    SELECT 
        owner_id, 
        COUNT(*) AS savings_count, 
        SUM(amount) AS savings_total
    FROM savings_savingsaccount
    WHERE amount > 0
    GROUP BY owner_id
),

-- Step 2: Get funded investment plans
funded_plans AS (
    SELECT 
        owner_id, 
        COUNT(*) AS investment_count, 
        SUM(amount) AS investment_total
    FROM plans_plan
    WHERE amount > 0
    GROUP BY owner_id
)

-- Step 3: Join with users
SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    fs.savings_count,
    fp.investment_count,
    (fs.savings_total + fp.investment_total) AS total_deposits
FROM funded_savings fs
JOIN funded_plans fp ON fs.owner_id = fp.owner_id
JOIN users_customuser u ON u.id = fs.owner_id
ORDER BY total_deposits DESC;
