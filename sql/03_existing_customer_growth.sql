/* ============================================================================
   03 | Existing Customer Growth
   ----------------------------------------------------------------------------
   Description : Change in revenue from returning customers: current-year
                 revenue minus prior-year revenue for customers present in
                 both years.
   Source      : customer_year (one row per customer per year; see 00_setup.sql)
   Output      : order_year, existing_customer_growth
   Grain       : One row per year, excluding the first (no prior year)
   Notes       : Existing Customer Revenue Current - Existing Customer Revenue Prior
                 A negative value means returning customers spent
                 less than the year before.
   ============================================================================ */

WITH years AS (
    SELECT DISTINCT order_year
    FROM customer_year
    WHERE order_year > (SELECT MIN(order_year) FROM customer_year)
),
existing AS (
    SELECT
        c.order_year,
        c.revenue AS revenue_current,
        p.revenue AS revenue_prior
    FROM customer_year c
    JOIN customer_year p
      ON p.customer_email = c.customer_email
     AND p.order_year = c.order_year - 1
)

SELECT
    y.order_year,
    COALESCE(SUM(e.revenue_current), 0) - COALESCE(SUM(e.revenue_prior), 0) AS existing_customer_growth
FROM years y
LEFT JOIN existing e
       ON e.order_year = y.order_year
GROUP BY y.order_year
ORDER BY y.order_year;