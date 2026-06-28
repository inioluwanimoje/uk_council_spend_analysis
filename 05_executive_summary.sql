WITH flagged AS (
  SELECT
    department,
    amount,
    CASE
      WHEN supplier IS NULL      THEN 1
      WHEN amount < 0            THEN 1
      WHEN amount > 100000       THEN 1
      WHEN MOD(amount,1000) = 0  THEN 1
      ELSE 0
    END AS is_flagged
  FROM council_spend
)
SELECT
  department,
  COUNT(*)                    AS transaction_count,
  SUM(amount)                 AS total_spend,
  SUM(is_flagged)             AS flagged_transactions,
  ROUND(
    SUM(is_flagged) / COUNT(*) * 100, 1
  )                           AS flag_rate_pct,
  CASE
    WHEN SUM(amount) > 5000000  THEN 'High'
    WHEN SUM(amount) > 1000000  THEN 'Medium'
    ELSE                             'Low'
  END                         AS risk_tier
FROM flagged
GROUP BY department
ORDER BY total_spend DESC;