SELECT COUNTRY.CONTINENT,FLOOR(AVG(CITY.POPULATION))  FROM CITY 
INNER JOIN COUNTRY 
ON COUNTRY.CODE= CITY.COUNTRYCODE 
GROUP BY CONTINENT
ORDER BY CONTINENT 

ex2
SELECT 
ROUND(SUM(CASE WHEN t.signup_action = 'Confirmed' THEN 1 ELSE 0 END)*1.0 / 
COUNT(t.signup_action),2)
FROM emails as e LEFT JOIN texts as t  
ON e.email_id  = t.email_id
WHERE 
  e.email_id IS NOT NULL

ex3
SELECT 
    age.age_bucket, 
  ROUND(( 100.0 *  SUM(CASE WHEN a.activity_type = 'send' 
      THEN a.time_spent ELSE 0 END)  / SUM(a.time_spent) ),2) 
     send_perc, 
     
 ROUND(( 100.0 *  SUM(CASE WHEN a.activity_type = 'open' 
      THEN a.time_spent ELSE 0 END)  / SUM(a.time_spent) ),2) 
     open_perc
  FROM activities as a
  INNER JOIN age_breakdown AS age 
    ON a.user_id = age.user_id 
  WHERE a.activity_type IN ('send', 'open') 
  GROUP BY age.age_bucket 

ex4
SELECT a.customer_id  FROM customer_contracts as a  
INNER JOIN products as b 
ON a.product_id = b. product_id
GROUP BY customer_id 
HAVING
  COUNT(DISTINCT product_category) = 
  (SELECT COUNT(DISTINCT product_category) FROM products)

ex5
select a.employee_id,a.name,count(b.reports_to) as reports_count,round(avg(b.age*1.00),0) as  average_age
from employees as a 
  inner join employees as b on b.reports_to=a.employee_id
group by a.employee_id,a.name
order by a.employee_id

ex6
select a.product_name, sum(b.unit) as unit from Products as a
  INNER join Orders as b 
  on a.product_id=b.product_id 
  where b.order_date>='2020-02-01' and b.order_date<='2020-02-29'
group by b.product_id having unit>=100 

ex7 
SELECT a.page_id

FROM pages as a   
LEFT JOIN page_likes as b 
ON a.page_id = b.page_id 
WHERE b.page_id IS NULL
