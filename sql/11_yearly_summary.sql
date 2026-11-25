/* ============================================================================
   11 | Yearly Summary & Reconciliation
   ----------------------------------------------------------------------------
   Description : All 10 metrics in one table, including
                 additional KPIs and reconciliation checks.
   Source      : customer_year (one row per customer per year)
   Output      : order_year, has_prior_year, the 10 metrics,
                 revenue_per_customer, customer_retention_rate,
                 revenue_check, customer_check
   Grain       : One row per year (all years). 
                 Prior-year metrics are NULL for the first year.
   ============================================================================ */


WITH cur AS (
    SELECT
        c.order_year,
        SUM(c.revenue) AS total_revenue,
        COUNT(*) AS total_customers_current,
        SUM(c.revenue) FILTER (WHERE p.customer_email IS NULL) AS new_customer_revenue,
        COUNT(*) FILTER (WHERE p.customer_email IS NULL) AS new_customers,
        SUM(c.revenue) FILTER (WHERE p.customer_email IS NOT NULL) AS existing_customer_revenue_current
    FROM customer_year c
    LEFT JOIN customer_year p
           ON p.customer_email = c.customer_email
          AND p.order_year = c.order_year - 1
    GROUP BY c.order_year
),
prev AS (
    SELECT
        p.order_year + 1 AS order_year,
        COUNT(*) AS total_customers_previous,
        SUM(p.revenue) FILTER (WHERE c.customer_email IS NOT NULL) AS existing_customer_revenue_prior,
        SUM(p.revenue) FILTER (WHERE c.customer_email IS NULL) AS revenue_lost_attrition,
        COUNT(*)       FILTER (WHERE c.customer_email IS NULL) AS lost_customers,
        SUM(p.revenue) AS total_revenue_prior
    FROM customer_year p
    LEFT JOIN customer_year c
           ON c.customer_email = p.customer_email
          AND c.order_year = p.order_year + 1
    GROUP BY p.order_year
),
summary AS (
    SELECT
        cur.order_year,
        prev.order_year IS NOT NULL AS has_prior_year,
        cur.total_revenue,
        CASE WHEN prev.order_year IS NOT NULL
             THEN COALESCE(cur.new_customer_revenue, 0) END AS new_customer_revenue,
        CASE WHEN prev.order_year IS NOT NULL
             THEN COALESCE(cur.existing_customer_revenue_current, 0)
                - COALESCE(prev.existing_customer_revenue_prior, 0) END AS existing_customer_growth,
        CASE WHEN prev.order_year IS NOT NULL
             THEN COALESCE(prev.revenue_lost_attrition, 0) END AS revenue_lost_attrition,
        CASE WHEN prev.order_year IS NOT NULL
             THEN COALESCE(cur.existing_customer_revenue_current, 0) END AS existing_customer_revenue_current,
        CASE WHEN prev.order_year IS NOT NULL
             THEN COALESCE(prev.existing_customer_revenue_prior, 0) END AS existing_customer_revenue_prior,
        cur.total_customers_current,
        prev.total_customers_previous,
        CASE WHEN prev.order_year IS NOT NULL
             THEN cur.new_customers END AS new_customers,
        CASE WHEN prev.order_year IS NOT NULL
             THEN COALESCE(prev.lost_customers, 0) END AS lost_customers,
        prev.total_revenue_prior
    FROM cur
    LEFT JOIN prev USING (order_year)
)

SELECT
    order_year,
    has_prior_year,
    total_revenue,
    new_customer_revenue,
    existing_customer_growth,
    revenue_lost_attrition,
    existing_customer_revenue_current,
    existing_customer_revenue_prior,
    total_customers_current,
    total_customers_previous,
    new_customers,
    lost_customers,
    -- Additional KPIs
    ROUND(total_revenue / total_customers_current, 2) AS revenue_per_customer,
    ROUND(1 - lost_customers / total_customers_previous, 4) AS customer_retention_rate,
    -- Reconciliation checks (should both equal 0)
    total_revenue - (total_revenue_prior + new_customer_revenue
                     + existing_customer_growth
                     - revenue_lost_attrition) AS revenue_check,
    total_customers_current - (total_customers_previous
                               + new_customers
                               - lost_customers) AS customer_check
FROM summary
ORDER BY order_year;