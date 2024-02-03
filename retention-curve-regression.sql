-- Using 12-month data from https://demo.profitwell.com/app/trends/cohorts and with minor adjustments to m9+ data for educational purpose
-- When using your data, make sure to summarize it with just 3 columns in the data temp table: cohort, age, revenue (as percent of age 0 revenue)
-- Adapted algorithm from page 17 in https://www.scribd.com/doc/14674814/Regressions-et-equations-integrales

WITH data AS (
    SELECT *
    FROM UNNEST([struct('2023-01-01' as cohort, 0 as age, 1 as revenue),struct('2023-01-01' as cohort, 1 as age, 0.921 as revenue),struct('2023-01-01' as cohort, 2 as age, 0.883 as revenue),struct('2023-01-01' as cohort, 3 as age, 0.663 as revenue),struct('2023-01-01' as cohort, 4 as age, 0.601 as revenue),struct('2023-01-01' as cohort, 5 as age, 0.599 as revenue),struct('2023-01-01' as cohort, 6 as age, 0.51 as revenue),struct('2023-01-01' as cohort, 7 as age, 0.479 as revenue),struct('2023-01-01' as cohort, 8 as age, 0.442 as revenue),struct('2023-01-01' as cohort, 9 as age, 0.421 as revenue),struct('2023-01-01' as cohort, 10 as age, 0.432 as revenue),struct('2023-01-01' as cohort, 11 as age, 0.413 as revenue),struct('2023-01-01' as cohort, 12 as age, 0.392 as revenue),struct('2023-02-01' as cohort, 0 as age, 1 as revenue),struct('2023-02-01' as cohort, 1 as age, 0.943 as revenue),struct('2023-02-01' as cohort, 2 as age, 0.711 as revenue),struct('2023-02-01' as cohort, 3 as age, 0.577 as revenue),struct('2023-02-01' as cohort, 4 as age, 0.568 as revenue),struct('2023-02-01' as cohort, 5 as age, 0.548 as revenue),struct('2023-02-01' as cohort, 6 as age, 0.499 as revenue),struct('2023-02-01' as cohort, 7 as age, 0.467 as revenue),struct('2023-02-01' as cohort, 8 as age, 0.452 as revenue),struct('2023-02-01' as cohort, 9 as age, 0.431 as revenue),struct('2023-02-01' as cohort, 10 as age, 0.442 as revenue),struct('2023-02-01' as cohort, 11 as age, 0.423 as revenue),struct('2023-03-01' as cohort, 0 as age, 1 as revenue),struct('2023-03-01' as cohort, 1 as age, 0.777 as revenue),struct('2023-03-01' as cohort, 2 as age, 0.711 as revenue),struct('2023-03-01' as cohort, 3 as age, 0.71 as revenue),struct('2023-03-01' as cohort, 4 as age, 0.664 as revenue),struct('2023-03-01' as cohort, 5 as age, 0.61 as revenue),struct('2023-03-01' as cohort, 6 as age, 0.573 as revenue),struct('2023-03-01' as cohort, 7 as age, 0.465 as revenue),struct('2023-03-01' as cohort, 8 as age, 0.473 as revenue),struct('2023-03-01' as cohort, 9 as age, 0.451 as revenue),struct('2023-03-01' as cohort, 10 as age, 0.463 as revenue),struct('2023-04-01' as cohort, 0 as age, 1 as revenue),struct('2023-04-01' as cohort, 1 as age, 0.798 as revenue),struct('2023-04-01' as cohort, 2 as age, 0.725 as revenue),struct('2023-04-01' as cohort, 3 as age, 0.672 as revenue),struct('2023-04-01' as cohort, 4 as age, 0.649 as revenue),struct('2023-04-01' as cohort, 5 as age, 0.638 as revenue),struct('2023-04-01' as cohort, 6 as age, 0.578 as revenue),struct('2023-04-01' as cohort, 7 as age, 0.545 as revenue),struct('2023-04-01' as cohort, 8 as age, 0.483 as revenue),struct('2023-04-01' as cohort, 9 as age, 0.461 as revenue),struct('2023-05-01' as cohort, 0 as age, 1 as revenue),struct('2023-05-01' as cohort, 1 as age, 0.995 as revenue),struct('2023-05-01' as cohort, 2 as age, 0.765 as revenue),struct('2023-05-01' as cohort, 3 as age, 0.703 as revenue),struct('2023-05-01' as cohort, 4 as age, 0.608 as revenue),struct('2023-05-01' as cohort, 5 as age, 0.598 as revenue),struct('2023-05-01' as cohort, 6 as age, 0.552 as revenue),struct('2023-05-01' as cohort, 7 as age, 0.544 as revenue),struct('2023-05-01' as cohort, 8 as age, 0.476 as revenue),struct('2023-06-01' as cohort, 0 as age, 1 as revenue),struct('2023-06-01' as cohort, 1 as age, 0.903 as revenue),struct('2023-06-01' as cohort, 2 as age, 0.885 as revenue),struct('2023-06-01' as cohort, 3 as age, 0.785 as revenue),struct('2023-06-01' as cohort, 4 as age, 0.752 as revenue),struct('2023-06-01' as cohort, 5 as age, 0.717 as revenue),struct('2023-06-01' as cohort, 6 as age, 0.649 as revenue),struct('2023-06-01' as cohort, 7 as age, 0.615 as revenue),struct('2023-07-01' as cohort, 0 as age, 1 as revenue),struct('2023-07-01' as cohort, 1 as age, 0.978 as revenue),struct('2023-07-01' as cohort, 2 as age, 0.946 as revenue),struct('2023-07-01' as cohort, 3 as age, 0.841 as revenue),struct('2023-07-01' as cohort, 4 as age, 0.658 as revenue),struct('2023-07-01' as cohort, 5 as age, 0.564 as revenue),struct('2023-07-01' as cohort, 6 as age, 0.472 as revenue),struct('2023-08-01' as cohort, 0 as age, 1 as revenue),struct('2023-08-01' as cohort, 1 as age, 0.855 as revenue),struct('2023-08-01' as cohort, 2 as age, 0.821 as revenue),struct('2023-08-01' as cohort, 3 as age, 0.806 as revenue),struct('2023-08-01' as cohort, 4 as age, 0.715 as revenue),struct('2023-08-01' as cohort, 5 as age, 0.709 as revenue),struct('2023-09-01' as cohort, 0 as age, 1 as revenue),struct('2023-09-01' as cohort, 1 as age, 0.92 as revenue),struct('2023-09-01' as cohort, 2 as age, 0.885 as revenue),struct('2023-09-01' as cohort, 3 as age, 0.814 as revenue),struct('2023-09-01' as cohort, 4 as age, 0.724 as revenue),struct('2023-10-01' as cohort, 0 as age, 1 as revenue),struct('2023-10-01' as cohort, 1 as age, 0.864 as revenue),struct('2023-10-01' as cohort, 2 as age, 0.78 as revenue),struct('2023-10-01' as cohort, 3 as age, 0.755 as revenue),struct('2023-11-01' as cohort, 0 as age, 1 as revenue),struct('2023-11-01' as cohort, 1 as age, 0.968 as revenue),struct('2023-11-01' as cohort, 2 as age, 0.951 as revenue),struct('2023-12-01' as cohort, 0 as age, 1 as revenue),struct('2023-12-01' as cohort, 1 as age, 0.968 as revenue)])
),

first_data AS (
    SELECT age as first_age, revenue as first_revenue
    FROM data
    ORDER BY age, revenue
    LIMIT 1
),

aux_sk AS (
    SELECT age, revenue, 
        CASE 
            WHEN ROW_NUMBER() OVER(ORDER BY age, revenue) = 1 THEN 0 
            ELSE 1/2*(revenue + LAG(revenue) OVER(ORDER BY age, revenue))*(age - LAG(age) OVER(ORDER BY age, revenue)) 
        END as first_part
    FROM data
),

sks AS (
    SELECT 
        a.age, 
        a.revenue, 
        SUM(first_part) OVER(ORDER BY a.age, a.revenue) as sk, 
        first_age, 
        first_revenue
    FROM aux_sk a, first_data f
),

aux_calcs as (
    SELECT 
        SUM((age - first_age)*(age - first_age)) as delta_age_squared, 
        SUM((age - first_age)*sk) as delta_age_sk, 
        SUM(sk*sk) as sk_squared,
        SUM((revenue - first_revenue)*(age - first_age)) as delta_revenue_delta_age,
        SUM((revenue - first_revenue)*sk) as delta_revenue_sk,
        1/(SUM((age - first_age)*(age - first_age))*SUM(sk*sk) - SUM((age - first_age)*sk)*SUM((age - first_age)*sk)) as determinant
    FROM sks
),

aux_theta AS (
    SELECT 
        determinant * (sk_squared*delta_revenue_delta_age - delta_age_sk*delta_revenue_sk) as A1,
        determinant * (delta_age_squared*delta_revenue_sk - delta_age_sk*delta_revenue_delta_age) as c2
    FROM aux_calcs
),

aux_theta_k AS (
    SELECT EXP(c2*age) as theta, revenue, A1, c2
    FROM data, aux_theta
),

theta_data AS (
    SELECT 
        SUM(theta) as sum_theta, 
        SUM(theta*theta) as sum_squared_theta, 
        SUM(revenue) as sum_revenue,
        AVG(revenue) as avg_revenue,
        SUM(revenue*theta) as theta_revenue, 
        COUNT(*) as n, 
        AVG(c2) as c2
    FROM aux_theta_k
),

coefficients AS (
    SELECT 
        (1/(n*sum_squared_theta - sum_theta*sum_theta))*(sum_squared_theta*sum_revenue - sum_theta*theta_revenue) as a2, 
        (1/(n*sum_squared_theta - sum_theta*sum_theta))*(-sum_theta*sum_revenue + n*theta_revenue) as b2,
        c2,
        avg_revenue
    FROM theta_data
),

analysis AS (
    SELECT 
        1 - SUM((revenue - (a2 + b2*EXP(c2*age)))*(revenue - (a2 + b2*EXP(c2*age))))/SUM((revenue-avg_revenue)*(revenue-avg_revenue)) as r_squared
    FROM data, coefficients
)

SELECT a2, b2, c2, CONCAT(a2, ' + ', b2, '*exp(', c2, '*age)') as curve, r_squared
FROM coefficients, analysis
