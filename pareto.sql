-- Dimension can be anything:
-- - Time to complete an action (time to subscriber, time to first purchase, etc)
-- - Number of actions per user (number of purchases, number of logins, etc)

WITH data AS (
    SELECT dimension, COUNT(*) as volume
    FROM <table>
    GROUP BY dimension
)

SELECT 
  dimension, 
  SUM(volume) OVER(ORDER BY dimension)/(SUM(volume) OVER (PARTITION BY true)) as cumulative
FROM data
[[WHERE dimension <= <some value to avoid overplotting if to reach 100% it would take forever>]]
ORDER BY dimension