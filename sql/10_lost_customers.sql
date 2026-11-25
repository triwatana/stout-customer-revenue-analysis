/* ============================================================================
   10 | Lost Customers
   ----------------------------------------------------------------------------
   Description : Number of customers in the prior year who didn't return.
   Source      : customer_year (one row per customer per year)
   Output      : order_year, lost_customers
   Grain       : One row per year, excluding the first (no prior year)
   Notes       : Reported against the year the customer was lost.
   ============================================================================ */

WITH years AS (
    SELECT DISTINCT order_year
    FROM customer_year
    WHERE order_year > (SELECT MIN(order_year) FROM customer_year)
)

SELECT
    y.order_year,
    COUNT(p.customer_email) FILTER (WHERE c.customer_email IS NULL) AS lost_customers
FROM years y
LEFT JOIN customer_year p
       ON p.order_year = y.order_year - 1
LEFT JOIN customer_year c
       ON c.customer_email = p.customer_email
      AND c.order_year = y.order_year
GROUP BY y.order_year
ORDER BY y.order_year;

