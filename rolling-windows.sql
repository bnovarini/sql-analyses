-- Rolling 30-day window
SELECT *
FROM 
   UNNEST(GENERATE_DATE_ARRAY(DATE_SUB(CURRENT_DATE(), INTERVAL 6 MONTH), CURRENT_DATE(), INTERVAL 1 DAY)) as day, 
   your_table t
WHERE day >= CAST(t.created_at AS DATE) AND DATE_DIFF(day, CAST(t.created_at AS DATE), DAY) <= 30


-- Rolling 7-day window
SELECT *
FROM 
   UNNEST(GENERATE_DATE_ARRAY(DATE_SUB(CURRENT_DATE(), INTERVAL 6 MONTH), CURRENT_DATE(), INTERVAL 1 DAY)) as day, 
   your_table t
WHERE day >= CAST(t.created_at AS DATE) AND DATE_DIFF(day, CAST(t.created_at AS DATE), DAY) <= 7