with monthly as (
SELECT
    substring(payment_date,1,7)   AS `month`,
    COUNT(*)                            AS transaction_count,
    SUM(amount)                         AS total_spend,
    ROUND(AVG(amount), 2)              AS avg_transaction
  FROM council_spend
  group by `month`
  order by 1
  )	
  select `month`,
		transaction_count,
        total_spend,
        avg_transaction,
        total_spend - LAG(total_spend) OVER (ORDER BY month) AS mom_change
from monthly
order by `month`;