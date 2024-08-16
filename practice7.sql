With totalspend AS
(
SELECT 
EXTRACT(YEAR from transaction_date ) as year, 
product_id, 
spend as curr_year_spend,
LAG( spend) OVER (PARTITION BY product_id 
ORDER BY product_id,EXTRACT(YEAR from transaction_date ) ) as prev_year_spend
FROM user_transactions )

Select 
year, 
product_id, 
curr_year_spend, 
prev_year_spend, 
ROUND(100.00 * (curr_year_spend - prev_year_spend ) / prev_year_spend, 2 ) AS yoy_rate 
from totalspend 

ex2
SELECT DISTINCT card_name, 
first_value(issued_amount) OVER(PARTITION BY card_name ORDER BY make_date(issue_year,issue_month,'01')) as amount
FROM monthly_cards_issued
ORDER BY amount DESC

ex3
with cte AS
(select *, 
ROW_NUMBER () OVER
(PARTITION BY user_id ORDER BY transaction_date ) as rank 
from transactions )


SELECT user_id, spend, transaction_date  from cte 

WHERE rank = 3 

ex4
with cte AS
(SELECT *, 
RANK () OVER (PARTITION BY user_id ORDER BY transaction_date DESC) as rank 
from user_transactions ) 

SELECT  
transaction_date, user_id, 
COUNT(product_id) as purchase_count
from cte  
Where rank = 1 
GROUP BY transaction_date, user_id 
ORDER BY transaction_date

ex5
SELECT    
  user_id,    
  tweet_date,   
  ROUND(AVG(tweet_count) OVER (
    PARTITION BY user_id     
    ORDER BY tweet_date     
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
  ,2) AS rolling_avg_3d
FROM tweets

ex6
WITH payments AS (
  SELECT 
    merchant_id, 
   ---EPOCH: tính tổng số giây => /60: quy đổi về phút 
   EXTRACT(EPOCH FROM transaction_timestamp - 
      LAG(transaction_timestamp) OVER(
        PARTITION BY merchant_id, credit_card_id, amount 
        ORDER BY transaction_timestamp)
    )/60 AS minute_difference 
  FROM transactions) 

SELECT COUNT(merchant_id) AS payment_count
FROM payments 
WHERE minute_difference <= 10

ex7
With cte as 
( SELECT category, product, 
sum(spend) as total_spend, 
RANK() OVER (
      PARTITION BY category 
      ORDER BY SUM(spend) DESC) AS ranking 
from product_spend 

Where EXTRACT(YEAR from transaction_date) = 2022 
GROUP BY category, product 
ORDER BY total_spend DESC ) 

select category, product, total_spend
from cte 
where ranking <= 2 
ORDER BY category,ranking  

ex8
WITH top_10_cte AS (
  SELECT 
    a.artist_name,
    DENSE_RANK() OVER (
      ORDER BY COUNT(b.song_id) DESC) AS artist_rank
  FROM artists as a 
  INNER JOIN songs as b 
    ON a.artist_id = b.artist_id
  INNER JOIN global_song_rank AS ranking
    ON b.song_id = ranking.song_id
  WHERE ranking.rank <= 10
  GROUP BY a.artist_name
)

SELECT artist_name, artist_rank
FROM top_10_cte
WHERE artist_rank <= 5
