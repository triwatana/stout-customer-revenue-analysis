/* ============================================================================
   06 | Existing Customer Revenue (Prior Year)
   ----------------------------------------------------------------------------
   Description : Prior-year revenue from returning customers. 
   Source      : customer_year (one row per customer per year)
   Output      : order_year, existing_customer_revenue_prior
   Grain       : One row per year, excluding the first (no prior year)
   Notes       : 06 + 04 (Revenue Lost from Attrition) = prior year's Total
                 Revenue. 05 (Existing Revenue Current) - 06 = 03 (Existing Growth).
   ============================================================================ */

WITH years AS (
    SELECT DISTINCT order_year
    FROM customer_year
    WHERE order_year > (SELECT MIN(order_year) FROM customer_year)
)

SELECT
    y.order_year,
    COALESCE(SUM(p.revenue) FILTER (WHERE c.customer_email IS NOT NULL), 0) AS existing_customer_revenue_prior
FROM years y
LEFT JOIN customer_year p
       ON p.order_year = y.order_year - 1
LEFT JOIN customer_year c
       ON c.customer_email = p.customer_email
      AND c.order_year = y.order_year
GROUP BY y.order_year
ORDER BY y.order_year;

