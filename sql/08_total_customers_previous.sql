/* ============================================================================
   08 | Total Customers (Previous Year)
   ----------------------------------------------------------------------------
   Description : Number of distinct customers in the previous year.
   Source      : customer_year (one row per customer per year)
   Output      : order_year, total_customers_previous
   Grain       : One row per year, excluding the first (no prior year)
   Notes       : The row for a given year shows the prior year's count.
                 08 = Existing customers + 10 (Lost Customers).
   ============================================================================ */

WITH years AS (
    SELECT DISTINCT order_year
    FROM customer_year
    WHERE order_year > (SELECT MIN(order_year) FROM customer_year)
)

SELECT
    y.order_year,
    COUNT(DISTINCT p.customer_email) AS total_customers_previous
FROM years y
LEFT JOIN customer_year p
       ON p.order_year = y.order_year - 1
GROUP BY y.order_year
ORDER BY y.order_year;
