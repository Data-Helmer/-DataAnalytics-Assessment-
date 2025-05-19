# High-Value Customers with Multiple Products
## Approach:
- Identify customers who have both:
   - At least one funded savings account (amount > 0 in savings_savingsaccount)
   - At least one funded investment plan (amount > 0 in plans_plan)
- Join both sets on owner_id, group by customer.
- Calculate total_deposits = savings_total + investment_total
- Sort by total_deposits in descending order.
## Challenges:
- Some accounts might not have recent transactions.
- Matching savings and plans by owner_id needed clarity.
- Solved by using JOIN and proper aggregation in CTEs (Common Table Expressions) for performance and clarity.

# Transaction Frequency Analysis
## Approach:
- Count all savings transactions per customer.
- Calculate their active duration in months using MIN(transaction_date) to MAX(transaction_date).
- Derive average monthly transactions.
- Categorize users:
  - High: ≥10/month
  - Medium: 3–9/month
  - Low: ≤2/month
- Aggregate counts and average per category.
## Challenges:
- Handling users with only one transaction (to avoid divide-by-zero).
- Used +1 when calculating months to ensure at least 1 month of tenure.
- Validated with HAVING clauses to ensure only meaningful results.

# Account Inactivity Alert
## Approach:
- Identify accounts with no inflow transactions in the last 365 days.
- For savings: Use transaction_date and amount > 0.
- For investment plans: Use created_on (as a proxy for inflow).
- Calculate inactivity_days = DATEDIFF(CURRENT_DATE, last_transaction_date)
- Filter for inactivity_days > 365 only.
## Challenges:
- Plans table lacks a dedicated transaction history; assumed created_on as a proxy.
- Ensured only active records were used with is_archived = 0 and is_deleted = 0

# Customer Lifetime Value (CLV) Estimation
## Approach:
- Use formula: CLV = (total_txn / tenure_months) * 12 * avg_profit_per_txn
- avg_profit_per_txn = 0.1% of average transaction value
- Joined transaction summary with user signup info (date_joined)
- Excluded users with 0-month tenure to avoid division by zero.

# General Difficulties Encountered:
1. Large Joins or Slow Queries:
   - Solved by breaking into CTEs or staging data before final joins.
2. Ambiguous Fields (e.g., created_on as a transaction proxy):
   - Clarified assumptions and documented them clearly in queries.
3. MySQL Server Error 2013 (Lost connection):
   - Solved by rewriting complex query into CTE steps to reduce memory load.
