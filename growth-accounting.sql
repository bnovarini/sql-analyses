-- This SQL analysis helps you break down the MRR movements for your SaaS business to calculate your growth accounting metrics
-- For more information on growth accounting, check out this article: https://tribecap.co/a-quantitative-approach-to-product-market-fit/

WITH monthly_subscription AS (
-- It is assumed you have some table with month, user_id, subscription_revenue    
),

-- This will help populate dormant months of subscribers (for instance, if they churned for a few months then came back)
distinct_monthly_subscription_businesses AS (
    SELECT month, user_id
    FROM (
        SELECT *
        FROM UNNEST(GENERATE_DATE_ARRAY(DATE_SUB(DATE_TRUNC(CURRENT_DATE(), MONTH), INTERVAL 36 MONTH), CURRENT_DATE(), INTERVAL 1 MONTH)) as month
    ), 
    (SELECT DISTINCT user_id FROM {{monthly-subscription-revenue-per-business-table}})
),

-- Combine previous tables to get the subscription revenue for each business for each month, also considering dormant months
populated_monthly_subscription_revenue_per_business AS (
    SELECT *
    FROM (
        SELECT m.month, s.month as sub_month, user_id,
            CASE WHEN m.month = s.month THEN subscription_revenue ELSE 0 END as subscription_revenue,
            CASE WHEN m.month = s.month THEN type ELSE null END as type,
            MIN(s.month) OVER(PARTITION BY user_id) as first_month,
            LAG(subscription_revenue) OVER(PARTITION BY user_id ORDER BY month) as previous_month_sub_revenue
        FROM distinct_monthly_subscription_businesses m
        LEFT JOIN monthly_subscription s using(month, user_id)
    )
    WHERE month >= first_month
),

-- Calculate the type of MRR movements for each business for each month
mrr_movements_per_business_per_month AS (
    SELECT 
        month, 
        user_id, 
        subscription_revenue,
        CASE 
            WHEN month = first_month THEN '1. new_mrr'
            WHEN previous_month_sub_revenue > 0 AND subscription_revenue = previous_month_sub_revenue THEN '2. renewed_mrr'
            WHEN previous_month_sub_revenue = 0 AND subscription_revenue > 0 THEN '3. recovered_mrr'
            WHEN previous_month_sub_revenue > 0 AND subscription_revenue > previous_month_sub_revenue THEN '4. upsell_mrr'
            WHEN previous_month_sub_revenue > 0 AND subscription_revenue < previous_month_sub_revenue THEN '5. downsell_mrr'
            WHEN previous_month_sub_revenue > 0 AND subscription_revenue = 0 THEN '6. churned_mrr'
        END as type,
        CASE WHEN month = first_month THEN subscription_revenue ELSE subscription_revenue - previous_month_sub_revenue END as delta_revenue
    FROM populated_monthly_subscription_revenue_per_business
)

-- Example of usage for a pivoted table of MRR movements for your SaaS business
-- This will show results in a shareable and readable format, similar to seen in spreadsheets
-- I recommend using the previous table for additional calculations on growth accounting unit metrics and this pivot for reporting
SELECT *
FROM (
    SELECT 
        month, 
        type,
        SUM(delta_revenue) as delta_revenue
    FROM mrr_movements_per_business_per_month
    WHERE type IS NOT NULL AND type <> '2. renewed_mrr'
    GROUP BY month, type
)
PIVOT (
    AVG(delta_revenue) as delta
    -- There are ways to dynamically generate the months, but I recommend hardcoding them
    FOR month IN (
        '2024-01-01',
        '2024-02-01',
        '2024-03-01',
        '2024-04-01',
        '2024-05-01',
        '2024-06-01',
        '2024-07-01',
        '2024-08-01',
        '2024-09-01',
        '2024-10-01',
        '2024-11-01',
        '2024-12-01',
        '2025-01-01',
        '2025-02-01',
        '2025-03-01',
        '2025-04-01',
        '2025-05-01',
        '2025-06-01',
        '2025-07-01',
        '2025-08-01',
        '2025-09-01',
        '2025-10-01',
        '2025-11-01',
        '2025-12-01'
    )
)
ORDER BY type
