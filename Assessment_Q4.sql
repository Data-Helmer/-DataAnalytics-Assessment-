-- Task: For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:
-- Account tenure (months since signup)
-- Total transactions
-- Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
-- Order by estimated CLV from highest to lowest
-- Set today's date
SET @today = CURDATE();

WITH txn_summary AS (
    SELECT 
        s.owner_id,
        COUNT(*) AS total_transactions,
        SUM(s.amount) AS total_value
    FROM savings_savingsaccount s
    WHERE s.amount > 0
    GROUP BY s.owner_id
),

user_tenure AS (
    SELECT 
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        TIMESTAMPDIFF(MONTH, u.date_joined, @today) AS tenure_months
    FROM users_customuser u
)

SELECT 
    u.customer_id,
    u.name,
    u.tenure_months,
    t.total_transactions,
    ROUND(
        (t.total_transactions / u.tenure_months) * 12 * ((t.total_value * 0.001) / t.total_transactions),
        2
    ) AS estimated_clv
FROM user_tenure u
JOIN txn_summary t ON u.customer_id = t.owner_id
WHERE u.tenure_months > 0
ORDER BY estimated_clv DESC;

