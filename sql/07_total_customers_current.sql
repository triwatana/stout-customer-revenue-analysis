/* ============================================================================
   07 | Total Customers (Current Year)
   ----------------------------------------------------------------------------
   Description : Number of distinct customers in each year.
   Source      : customer_year (one row per customer per year)
   Output      : order_year, total_customers_current
   Grain       : One row per year (all years, including the first)
   Notes       : Emails were trimmed and lowercased in setup, so there is
                 no double counting for the same customer due to formatting.
                 07 = 08 (Customers Previous) + 09 (New) - 10 (Lost).
   ============================================================================ */

SELECT
    order_year,
    COUNT(DISTINCT customer_email) AS total_customers_current
FROM customer_year
GROUP BY order_year
ORDER BY order_year;


