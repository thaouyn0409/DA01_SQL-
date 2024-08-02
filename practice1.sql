--- bài tập 1

SELECT NAME FROM CITY
WHERE COUNTRYCODE = 'USA' AND POPULATION > 120000

--- bài tập 2
SELECT * FROM CITY 
WHERE COUNTRYCODE = 'JPN'

---bài tập 3 
SELECT CITY, STATE FROM STATION 

---bài tập 4
SELECT DISTINCT CITY FROM STATION 
WHERE CITY LIKE 'a%' OR CITY LIKE 'e%' OR CITY LIKE 'i%'OR CITY LIKE 'o%' OR CITY LIKE 'u%'

---bài tập 5 
SELECT DISTINCT CITY FROM STATION 
WHERE CITY LIKE '%a' OR CITY LIKE'%e' OR CITY LIKE '%i' OR CITY LIKE '%o' OR CITY LIKE '%u'

---bài tập 6
SELECT DISTINCT CITY FROM STATION 
WHERE NOT ( CITY LIKE 'a%' OR CITY LIKE 'e%' OR CITY LIKE 'u%' OR CITY LIKE 'o%' OR CITY LIKE 'i%')

--- bài tập 7
SELECT NAME FROM Employee
ORDER BY NAME 

---bài tập 8
SELECT NAME FROM Employee
WHERE salary > 2000 AND months < 10 
ORDER BY employee_id ASC

---bài tập 9
SELECT product_id from Products
WHERE low_fats = 'Y' AND recyclable = 'Y'

---bài tập 10
SELECT name FROM Customer 
WHERE NOT referee_id = 2 

---bài tập 11
SELECT name, population, area from World 
WHERE area >= 3000000 OR population >= 25000000 

---bài tập 12
SELECT DISTINCT author_id AS id from Views
WHERE author_id = viewer_id 
ORDER BY id 

---bài tập 13
SELECT part, assembly_step FROM parts_assembly
WHERE finish_date IS NULL

---bài tập 14
select * from lyft_drivers
WHERE yearly_salary <= 30000 OR yearly_salary >= 70000 

---bài tập 15
select advertising_channel from uber_advertising
WHERE money_spent > 100000 AND year = 2019 
