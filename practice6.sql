ex 1: 
With job_count AS 
(SELECT company_id,title, description, 
count(job_id) as jobcount 
from job_listings 
GROUP BY company_id,title, description ) 

SELECT COUNT(DISTINCT (company_id) ) from 
job_count as duplicate_companies
WHERE jobcount > 1 

ex 2: CÁCH EM SUY NGHĨ 
WITH toptwo_appliance as 
(SELECT category, product, 
sum(spend) as total_spend
from product_spend 
WHERE category = 'appliance'
AND EXTRACT(YEAR from transaction_date) = 2022 
GROUP BY product, category 
ORDER BY total_spend DESC 
LIMIT 2 ),    
toptwo_electronics as 
(SELECT category, product, 
sum(spend) as total_spend
from product_spend 
WHERE category = 'electronics'
AND EXTRACT(YEAR from transaction_date) = 2022 
GROUP BY product, category 
ORDER BY total_spend DESC 
LIMIT 2 )
SELECT category, product,total_spend from toptwo_appliance
UNION ALL 
SELECT category, product,total_spend from toptwo_electronics 

ex2: Cách em tham khảo cho ngắn hơn 
SELECT 
  category, 
  product, 
  total_spend 
FROM (
  SELECT 
    category, 
    product, 
    SUM(spend) AS total_spend,
    RANK() OVER (
      PARTITION BY category 
      ORDER BY SUM(spend) DESC) AS ranking 
  FROM product_spend
  WHERE EXTRACT(YEAR FROM transaction_date) = 2022
  GROUP BY category, product
) AS ranked_spending
WHERE ranking <= 2 
ORDER BY category, ranking

ex3: 
WITH morethan3 as 
(
SELECT 
policy_holder_id, count(case_id) 
from callers 
group by policy_holder_id 
having count(case_id) >= 3 ) 
select count(policy_holder_id)
from morethan3 

ex4
SELECT a.page_id

FROM pages as a   
LEFT JOIN page_likes as b 
ON a.page_id = b.page_id 
WHERE b.page_id IS NULL 

ex5
WITH july AS (
    SELECT EXTRACT(month FROM event_date) as month,
           user_id,
           event_id
    FROM user_actions
    WHERE EXTRACT(month FROM event_date) = 07),
june AS (
    SELECT EXTRACT(month FROM event_date) as month,
           user_id,
           event_id
    FROM user_actions
    WHERE EXTRACT(month FROM event_date) = 06)
SELECT month, COUNT(DISTINCT user_id) AS monthly_active_users
FROM july
WHERE user_id IN (SELECT DISTINCT user_id FROM june)
GROUP BY month

ex6
SELECT 
    TO_CHAR(trans_date, 'YYYY-MM') as month , 
    country,
    COUNT(id) AS trans_count,
    SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 END) AS approved_count,
    SUM(amount) AS trans_total_amount,
    SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM 
    Transactions
GROUP BY 
    month, country

ex7
With min_year as
(select product_id, MIN(year) as minyear from sales 
GROUP BY product_id )

SELECT sales.product_id, sales.year as first_year, sales.quantity, sales.price
from sales 
INNER JOIN min_year ON min_year.product_id = sales.product_id 
AND sales.year=min_year.minyear 

ex8
SELECT customer_id 
from Customer
GROUP BY customer_id 
HAVING  count(DISTINCT(product_key)) = (select count(DISTINCT(product_key)) from Product )

ex9 
select employee_id from Employees 
WHERE salary < 30000 
AND ( manager_id  NOT IN (
  SELECT employee_id FROM Employees ) or manager_id IS NULL ) 

ex10 
With job_count AS 
(SELECT company_id,title, description, 
count(job_id) as jobcount 
from job_listings 
GROUP BY company_id,title, description ) 

SELECT COUNT(DISTINCT (company_id) ) from 
job_count as duplicate_companies
WHERE jobcount > 1 

ex11: EM CHẠY KHÔNG RA Ạ 
( SELECT name as result  from Users 
WHERE user_id IN ( select user_id
from MovieRating
group by user_id 
ORDER BY count(movie_id)  
LIMIT 1 ) 
UNION ALL
( SELECT title as result from Movies 
WHERE movie_id IN (SELECT movie_id 
from MovieRating 
WHERE EXTRACT(MONTH FROM created_at) = 2
group by movie_id
ORDER BY avg(rating) DESC 
LIMIT 1 ) 

ex12: 
With all_ids as (select requester_id as id, 
COUNT(*) as count
from  RequestAccepted
group by requester_id 

UNION ALL 

select accepter_id as id, 
COUNT(*) as count
from  RequestAccepted
group by accepter_id ) 

select id, SUM(count) as num 
from all_ids
GROUP BY id
ORDER BY num DESC
LIMIT 1 
