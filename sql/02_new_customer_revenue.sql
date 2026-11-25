/* ============================================================================
   02 | New Customer Revenue
   ----------------------------------------------------------------------------
   Description : Revenue from new customers not present in previous year only.
   Source      : customer_year (one row per customer per year)
   Output      : order_year, new_customer_revenue
   Grain       : One row per year, excluding the first (no prior year)
   Notes       : Customers who skipped a year and returned count as new,
                 based on the case study definition.
   ============================================================================ */


-- Exclude first year since there is no prior year for comparison
WITH years AS (
    SELECT DISTINCT order_year
    FROM customer_year
    WHERE order_year > (SELECT MIN(order_year) FROM customer_year)
)

SELECT 
    y.order_year,
    COALESCE(SUM(c.revenue) FILTER (WHERE p.customer_email IS NULL), 0) AS new_customer_revenue
FROM years y 
LEFT JOIN customer_year c
    ON c.order_year = y.order_year
LEFT JOIN customer_year p
    ON p.customer_email = c.customer_email
    AND p.order_year = c.order_year - 1
GROUP BY y.order_year
ORDER BY y.order_year;
