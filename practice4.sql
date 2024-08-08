ex1
  SELECT 

SUM( CASE 
WHEN device_type = 'laptop' THEN 1 else 0 
END ) as laptop_views,

SUM( CASE WHEN device_type IN ('tablet', 'phone') THEN 1 else 0 END) 
as mobile_views 

FROM viewership

ex2
  SELECT *, 
CASE WHEN x+y>z AND x+z> y AND y+z> x THEN 'Yes' else 'No'
END as triangle 
from Triangle 

ex3
SELECT
ROUND( 100.0 * SUM(CASE WHEN call_category IS NULL OR call_category = 'n/a' THEN 1 else 0 END ) /  COUNT(*),1  ) --- phải là 100.0 
FROM callers 

ex 4
SELECT name
FROM Customer 
WHERE referee_id <> 2 OR referee_id IS NULL 

ex5
select 
CASE 
WHEN 
survived =1 THEN 1 ELSE 0 
END as survived , 
SUM(CASE WHEN pclass=1 THEN 1 else 0 END ) as first_class, 
SUM(CASE WHEN pclass=2 THEN 1 else 0 END ) as second_class,
SUM(CASE WHEN pclass=3 THEN 1 else 0 END ) as third_class 
from titanic
GROUP BY survived 


