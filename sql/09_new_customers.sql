/* ============================================================================
   09 | New Customers
   ----------------------------------------------------------------------------
   Description : Number of customers in the current year who weren't in the prior year.
   Source      : customer_year (one row per customer per year)
   Output      : order_year, new_customers
   Grain       : One row per year, excluding the first (no prior year)
   Notes       : Customers who skipped a year and returned count as new, 
                 per the case study definition.
   ============================================================================ */

WITH years AS (
    SELECT DISTINCT order_year
    FROM customer_year
    WHERE order_year > (SELECT MIN(order_year) FROM customer_year)
)

SELECT
    y.order_year,
    COUNT(c.customer_email) FILTER (WHERE p.customer_email IS NULL) AS new_customers
FROM years y
LEFT JOIN customer_year c
       ON c.order_year = y.order_year
LEFT JOIN customer_year p
       ON p.customer_email = c.customer_email
      AND p.order_year = c.order_year - 1
GROUP BY y.order_year
ORDER BY y.order_year;