
/* ============================================================================
   05 | Existing Customer Revenue (Current Year)
   ----------------------------------------------------------------------------
   Description : Current-year revenue from returning customers.
   Source      : customer_year (one row per customer per year)
   Output      : order_year, existing_customer_revenue_current
   Grain       : One row per year, excluding the first (no prior year)
   Notes       : 05 + 02 (New Customer Revenue) = 01 (Total Revenue).
                 05 - 06 (Existing Revenue Prior) = 03 (Existing Growth).
   ============================================================================ */

WITH years AS (
    SELECT DISTINCT order_year
    FROM customer_year
    WHERE order_year > (SELECT MIN(order_year) FROM customer_year)
)

SELECT
    y.order_year,
    COALESCE(SUM(c.revenue) FILTER (WHERE p.customer_email IS NOT NULL), 0) AS existing_customer_revenue_current
FROM years y
LEFT JOIN customer_year c
       ON c.order_year = y.order_year
LEFT JOIN customer_year p
       ON p.customer_email = c.customer_email
      AND p.order_year = c.order_year - 1
GROUP BY y.order_year
ORDER BY y.order_year;