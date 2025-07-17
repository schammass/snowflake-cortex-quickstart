CREATE VIEW revenue_by_region AS
    SELECT 
    rd.SALES_REGION,
    DATE_TRUNC('month', dr.DATE) as month,
    SUM(dr.REVENUE) as total_revenue,
    SUM(dr.COGS) as total_costs,
    SUM(dr.REVENUE - dr.COGS) as gross_profit,
    ROUND(AVG(dr.FORECASTED_REVENUE), 2) as avg_forecasted_revenue,
    COUNT(*) as transaction_count
FROM daily_revenue dr
JOIN region_dim rd ON dr.REGION_ID = rd.REGION_ID
GROUP BY rd.SALES_REGION, DATE_TRUNC('month', dr.DATE)
ORDER BY rd.SALES_REGION, month;


CREATE OR REPLACE CORTEX SEARCH SERVICE revenue_search_service
ON description_column
ATTRIBUTES sales_region, month, total_revenue, gross_profit
WAREHOUSE = cortex_analyst_wh
TARGET_LAG = '1 day'
EMBEDDING_MODEL = 'snowflake-arctic-embed-l-v2.0'
AS (
  SELECT 
    sales_region,
    month,
    total_revenue,
    gross_profit,
    CONCAT('Region: ', sales_region, ', Month: ', month, ', Revenue: ', total_revenue, ', Profit: ', gross_profit) AS description_column
  FROM revenue_by_region
);