-- Grab wherever you have monthly revenue per user (or weekly, etc)
WITH monthly_total_revenue AS (
    SELECT month, user_id, revenue, MIN(month) OVER(PARTITION BY user_id) as cohort
    FROM {{however you track user revenue}}
),

-- Summarize data by cohort
total_cohort as (
   SELECT cohort, SUM(revenue) AS total_revenue, DATE_DIFF(month, cohort, MONTH) as age
   FROM monthly_total_revenue
   WHERE DATE_ADD(cohort, INTERVAL 1*DATE_DIFF(month, cohort, MONTH) MONTH) < DATE_TRUNC(CURRENT_DATE(), MONTH)
   -- Filter to avoid getting MTD months that might pollute the analyzis. Suggestion is to only look at full months
   GROUP BY cohort, age
),

-- Get age 0 value to be used to normalize the retention data to 100%
m0_volume as (
   SELECT cohort, total_revenue as new_total_revenue
   FROM total_cohort
   WHERE age = 0
),

-- Normalize cohort data by 100% to compare cohorts
SELECT cohort, age, SAFE_DIVIDE(total_revenue,new_total_revenue) as revenue
FROM total_cohort
JOIN m0_volume using(cohort)


-- If you want to pivot the data to display as a table, use this
-- SELECT * except(m_0)
-- FROM (
--     SELECT cohort, age, SAFE_DIVIDE(total_revenue,new_total_revenue) as revenue
--     FROM total_cohort
--     JOIN m0_volume using(cohort)
-- )
-- PIVOT (
--     AVG(revenue) as m
--     FOR age IN (0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15, etc)
-- )