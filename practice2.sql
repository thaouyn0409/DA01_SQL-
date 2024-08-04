--- EX 1-
SELECT DISTINCT CITY from STATION 
WHERE ID%2=0 

---EX2---
SELECT COUNT(CITY) - COUNT(DISTINCT CITY) FROM STATION

---EX3
KHÔNG BIẾT TÍNH CÁI XÓA SỐ 0 đi sao ạ 

---EX4
SELECT  

ROUND(CAST(SUM(item_count * order_occurrences) / sum(order_occurrences)AS DECIMAL ),1) AS mean 
FROM items_per_order
(Note: dùng hàm cast chuyển interger về số thập phân mới round đc) 

---EX5
SELECT candidate_id
FROM candidates
WHERE SKILL IN ('Python','Tableau','PostgreSQL') 
GROUP BY candidate_id
HAVING COUNT(skill)=3

ORDER BY candidate_id

---ex6
SELECT user_id,

DATE(MAX(post_date)) - DATE(MIN(post_date)) as days_betwebetween

FROM posts
WHERE post_date BETWEEN '01/01/2021' AND '01/01/2022'
GROUP BY user_id 
HAVING DATE(MAX(post_date)) - DATE(MIN(post_date)) > 0

---ex7
SELECT card_name,
MAX(issued_amount) - MIN(issued_amount)  
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY MAX(issued_amount) - MIN(issued_amount) DESC 

---ex8
SELECT manufacturer,
COUNT(drug),
ABS(SUM(cogs-total_sales)) as total_loss : chú ý 
FROM pharmacy_sales 
WHERE total_sales-cogs <0 

GROUP BY manufacturer
ORDER BY total_loss DESC

---ex9
Select * from Cinema 
WHERE id IN (1,3,5,7,9) AND description <> 'boring'
ORDER BY rating DESC

---ex10
SELECT teacher_id, 
COUNT(DISTINCT subject_id) AS cnt : chỗ DISTINCT ko có ngoặc, nhớ phải có AS ...
FROM Teacher 
GROUP BY teacher_id

---ex11
SELECT user_id, 
COUNT(follower_id) AS followers_count
FROM Followers
GROUP BY user_id
ORDER BY user_id 

---ex12
SELECT class

FROM Courses
GROUP BY class
HAVING COUNT(student) >= 5
