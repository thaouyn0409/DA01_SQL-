---ex1
SELECT NAME
from STUDENTS
WHERE Marks > 75 
ORDER BY RIGHT(NAME,3) , ID

---ex2
SELECT user_id, 
UPPER(LEFT(NAME,1)) || LOWER(RIGHT(name,length(name)-1 )) AS name 
from Users 

---ex3
SELECT manufacturer, 
'$' || ROUND((SUM(total_sales)/1000000),0) || ' '|| 'million' as sale


FROM pharmacy_sales


GROUP BY manufacturer 
ORDER BY sale  DESC, 
manufacturer ASC 

---ex4
SELECT 
EXTRACT(month from submit_date) as mth,
product_id,
ROUND(AVG(stars),2) 

FROM reviews
GROUP BY EXTRACT(month from submit_date), product_id
ORDER BY mth, product_id 

---ex5
SELECT sender_id,
COUNT(message_id) as message_count

FROM messages
WHERE EXTRACT(MONTH from sent_date) = 8 AND EXTRACT(YEAR from sent_date) = 2022  
GROUP BY sender_id 
ORDER BY message_count DESC 
LIMIT 2

---ex6
Select tweet_id 
from Tweets 
WHERE length(content) > 15

---ex7
SELECT activity_date AS day, 
COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date BETWEEN '2019-06-27' AND '2019-07-27' 
GROUP BY activity_date 

---ex8
select 
COUNT(id) 
from employees
WHERE EXTRACT(MONTH FROM joining_date) BETWEEN 1 AND 7 
AND EXTRACT(YEAR FROM joining_date)=2022

---ex9
select 
POSITION ('a' in first_name)
from worker 
WHERE first_name = 'Amitah'

---ex10
select title, 
substring(title, length(winery)+2, 4)
from winemag_p2
WHERE country = 'Macedonia' 
