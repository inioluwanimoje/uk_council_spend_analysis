select transaction_id,
		payment_date,
        department,
        supplier,
        amount,
case 		
	when supplier is null 		then 'Missing Supplier'
    when amount < 0 			then 'Refund/Negative'
    when amount > 100000 		then 'High Value'
    WHEN MOD(amount, 1000) = 0	then 'Round number'
    ELSE                                   'Clean'
  END AS flag
FROM council_spend
ORDER BY
  CASE
    WHEN supplier IS NULL  THEN 1
    WHEN amount < 0        THEN 2
    WHEN amount > 100000   THEN 3
    WHEN MOD(amount,1000)=0 THEN 4
    ELSE 5
  END,
  amount DESC;