I. Ad-hoc tasks 
1. 
SELECT 
  
  SUBSTRING(CAST(created_at as string),1,7) as month_year,
  count(distinct(user_id)) as total_user,
  count(distinct(order_id)) as total_order   
  
FROM
  bigquery-public-data.thelook_ecommerce.orders
  Where status = 'Complete'
  GROUP BY month_year 
  ORDER BY month_year 
  LIMIT 40 
=> Insight:tăng theo thời gian
- Nhìn chung mỗi user mua 1 order(trừ vài TH số ít ) => do total user thường = total order  

2.
SELECT month_year,giatridonhangtb,total_user from (SELECT 
 SUBSTRING(CAST(created_at as string),1,7) as month_year,
 
  count(order_id) as total_order,
  count(distinct(user_id)) as total_user,
  sum(sale_price) as sum, 
  sum(sale_price) / count(order_id) as giatridonhangtb 
FROM
  bigquery-public-data.thelook_ecommerce.order_items
  Where status = 'Complete'
  GROUP BY month_year 
  ORDER BY month_year 
  LIMIT 40 )
=>
Insight:
Tổng KH nhìn chung tăng theo thờigian
Giá trị đơn hàng tb cũng tăng 
3.
with youngest_female as 
(
SELECT id, first_name, last_name, age, gender
FROM bigquery-public-data.thelook_ecommerce.users
WHERE gender = 'F' 
AND age = (SELECT MIN(age) FROM bigquery-public-data.thelook_ecommerce.users WHERE gender = 'F')),
oldest_female as 
(
SELECT id, first_name, last_name, age, gender
FROM bigquery-public-data.thelook_ecommerce.users
WHERE gender = 'F' 
AND age = (SELECT MAX(age) FROM bigquery-public-data.thelook_ecommerce.users WHERE gender = 'F')), 
youngest_male as 
(
SELECT id, first_name, last_name, age, gender
FROM bigquery-public-data.thelook_ecommerce.users
WHERE gender = 'M' 
AND age = (SELECT MIN(age) FROM bigquery-public-data.thelook_ecommerce.users WHERE gender = 'M')),
oldest_male as
(
SELECT id, first_name, last_name, age, gender
FROM bigquery-public-data.thelook_ecommerce.users
WHERE gender = 'M' 
AND age = (SELECT MAX(age) FROM bigquery-public-data.thelook_ecommerce.users WHERE gender = 'M')),

alltable as  (
select id,first_name, last_name, gender, age from youngest_female 
UNION ALL 
select id,first_name, last_name, gender, age from oldest_female
UNION ALL 
select id,first_name, last_name, gender, age from youngest_male
UNION ALL 
select id,first_name, last_name, gender, age from oldest_male ),
temptable as 
(

select first_name, last_name, gender, age,
CASE
WHEN id IN(select id from youngest_female) then 'youngest'
WHEN id IN(select id from oldest_female) then'oldest'
WHEN id IN(select id from youngest_male) then 'youngest'
WHEN id IN(select id from oldest_male) then'oldest'
END tags 
  from alltable )

  select gender, age,
  count(first_name) as soluong 
  from temptable 
  group by gender, age 
Insight: 
Female - Lớn nhất: 70- số lượng: 836
Female -Nhỏ nhất: 12 - số lượng: 849
Male - 70-859
Male-12-855

4.

with cte as
(SELECT 
  *,
  DENSE_RANK() OVER(PARTITION BY year_month ORDER BY total_sale_price) AS rank
FROM (
  SELECT 
    product_id,
    SUBSTRING(CAST(created_at AS STRING), 1, 7) AS year_month,
    SUM(sale_price) AS total_sale_price
  FROM bigquery-public-data.thelook_ecommerce.order_items
  GROUP BY product_id, year_month
) ) 
select * from cte 
where rank <= 5 
ORDER BY year_month 

5.
WITH cte AS (
  SELECT 
    product_category,
    DATE(sold_at) as dates,
    SUM(product_retail_price) as revenue 
  FROM 
    bigquery-public-data.thelook_ecommerce.inventory_items
  WHERE 
    sold_at IS NOT NULL
  GROUP BY 
    product_category, dates
)
SELECT * 
FROM cte
WHERE SUBSTRING(CAST(dates AS STRING), 1, 7) IN ('2022-04','2022-03','2022-02','2022-01')
ORDER BY dates DESC
