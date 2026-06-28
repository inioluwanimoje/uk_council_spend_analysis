WITH total AS (
  SELECT SUM(amount) AS grand_total
  FROM council_spend
)
SELECT
  supplier,
  COUNT(*)                                      AS transaction_count,
  SUM(amount)                                   AS total_spend,
  ROUND(AVG(amount), 2)                         AS avg_transaction,
  ROUND(SUM(amount) / t.grand_total * 100, 2)  AS pct_of_total_spend
FROM council_spend, total t
GROUP BY supplier, t.grand_total
ORDER BY total_spend DESC
LIMIT 100;