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
)SELECT * 
FROM cte
WHERE SUBSTRING(CAST(dates AS STRING), 1, 7) IN ('2022-04','2022-03','2022-02','2022-01')
ORDER BY dates DESC

II. 

- Phân tích các bảng: 
+ Bảng Order: order_id, user_id, status,gender, created_at, num_of_items: 125375 bảng ghi 
+ Bảng Orderitems:id,order_id,user_id,product_id,status,created_at,sales_price 181717 bảng ghi
+ Bảng product: id, cost, retail_price 29120 bảng ghi

- OUTPUT METRICS: 

with cte1 as (SELECT 
    SUBSTRING(CAST(o.created_at as string),1,7)  AS month,
    SUM(oi.sale_price) AS TPV,
    COUNT(oi.order_id) AS TPO,
    SUM(p.cost) AS total_cost,
    SUM(oi.sale_price) - SUM(p.cost) AS total_profit,
FROM 
 bigquery-public-data.thelook_ecommerce.orders AS o
JOIN 
bigquery-public-data.thelook_ecommerce.order_items AS oi ON o.order_id = oi.order_id
JOIN 
bigquery-public-data.thelook_ecommerce.products AS p ON oi.id = p.id
GROUP BY 
  SUBSTRING(CAST(o.created_at as string),1,7) ),
  cte2 as 
--- do cái bảng một em ko lấy category được do bị dính group by, ko biết còn cách nào khác nhanh hơn không ạ --- 
(
  SELECT *,
    SUBSTRING(CAST(a.created_at as string),1,7)  AS month,
    c.category as product_category 
from bigquery-public-data.thelook_ecommerce.orders AS a 
JOIN 
bigquery-public-data.thelook_ecommerce.order_items AS b ON a.order_id = b.order_id
JOIN 
bigquery-public-data.thelook_ecommerce.products AS c ON b.id = c.id
),
cte3 as 
(
select month,
SUBSTRING(month,1,4) as year,TPV,TPO,
 round((100.00* ( TPV - lag(TPV) OVER( ORDER BY month)) /lag(TPV) OVER( ORDER BY month)),2) || '%' as revenue_growth, 
 round((100.00* ( TPO - lag(TPO) OVER( ORDER BY month)) /lag(TPO) OVER( ORDER BY month)),2) || '%' as order_growth,
 total_cost,total_profit,
 total_profit/total_cost as Profit_to_cost_ratio
from cte1 
ORDER BY month)
select table3.month,table3.year,table2.product_category,table3.TPV,table3.TPO,table3.revenue_growth,
table3.order_growth,table3.total_cost,table3.total_profit,table3.Profit_to_cost_ratio from cte3 as table3 
JOIN cte2 as table2 
ON table2.month = table3.month 
ORDER BY table3.month 

Tạo view
CREATE VIEW bigquery-public-data.thelook_ecommerce.vw_ecommerce_analyst as
(
with cte1 as (SELECT 
    SUBSTRING(CAST(o.created_at as string),1,7)  AS month,
    SUM(oi.sale_price) AS TPV,
    COUNT(oi.order_id) AS TPO,
    SUM(p.cost) AS total_cost,
    SUM(oi.sale_price) - SUM(p.cost) AS total_profit,
FROM 
 bigquery-public-data.thelook_ecommerce.orders AS o
JOIN 
bigquery-public-data.thelook_ecommerce.order_items AS oi ON o.order_id = oi.order_id
JOIN 
bigquery-public-data.thelook_ecommerce.products AS p ON oi.id = p.id
GROUP BY 
  SUBSTRING(CAST(o.created_at as string),1,7) ),
  cte2 as 
(
  SELECT *,
    SUBSTRING(CAST(a.created_at as string),1,7)  AS month,
    c.category as product_category 
from bigquery-public-data.thelook_ecommerce.orders AS a 
JOIN 
bigquery-public-data.thelook_ecommerce.order_items AS b ON a.order_id = b.order_id
JOIN 
bigquery-public-data.thelook_ecommerce.products AS c ON b.id = c.id
),
cte3 as 
(
select month,
SUBSTRING(month,1,4) as year,TPV,TPO,
 round((100.00* ( TPV - lag(TPV) OVER( ORDER BY month)) /lag(TPV) OVER( ORDER BY month)),2) || '%' as revenue_growth, 
 round((100.00* ( TPO - lag(TPO) OVER( ORDER BY month)) /lag(TPO) OVER( ORDER BY month)),2) || '%' as order_growth,
 total_cost,total_profit,
 total_profit/total_cost as Profit_to_cost_ratio
from cte1 
ORDER BY month)
 
select table3.month,table3.year,table2.product_category,table3.TPV,table3.TPO,table3.revenue_growth,
table3.order_growth,table3.total_cost,table3.total_profit,table3.Profit_to_cost_ratio from cte3 as table3 
JOIN cte2 as table2 
ON table2.month = table3.month 
ORDER BY table3.month )
Nó để lỗi là:
Access Denied: Dataset bigquery-public-data:thelook_ecommerce: Permission bigquery.tables.create denied on dataset bigquery-public-data:thelook_ecommerce (or it may not exist).

----


