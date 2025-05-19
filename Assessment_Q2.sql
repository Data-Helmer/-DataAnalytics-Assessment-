-- Task 2 Calculate the average number of transactions per customer per month and categorize them:
-- "High Frequency" (≥10 transactions/month)
-- "Medium Frequency" (3-9 transactions/month)
-- "Low Frequency" (≤2 transactions/month)
WITH transaction_counts AS (
    SELECT 
        owner_id,
        COUNT(*) AS total_transactions,
        TIMESTAMPDIFF(MONTH, MIN(transaction_date), MAX(transaction_date)) + 1 AS active_months
    FROM savings_savingsaccount
    GROUP BY owner_id
),

customer_frequency AS (
    SELECT 
        owner_id,
        total_transactions,
        active_months,
        ROUND(total_transactions / active_months, 2) AS avg_txn_per_month,
        CASE 
            WHEN total_transactions / active_months >= 10 THEN 'High Frequency'
            WHEN total_transactions / active_months BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM transaction_counts
)

SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 2) AS avg_transactions_per_month
FROM customer_frequency
GROUP BY frequency_category
ORDER BY 
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');