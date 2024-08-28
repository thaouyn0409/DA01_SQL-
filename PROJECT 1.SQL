B1: 
ALTER TABLE SALES_DATASET_RFM_PRJ ALTER COLUMN ordernumber  
	TYPE integer 
	USING (orderlinenumber::integer )

ALTER TABLE SALES_DATASET_RFM_PRJ ALTER COLUMN quantityordered 
	TYPE smallint 
	USING ( quantityordered ::smallint )

ALTER TABLE SALES_DATASET_RFM_PRJ ALTER COLUMN priceeach 
	TYPE numeric 
	USING (trim(priceeach)::numeric) 

ALTER TABLE SALES_DATASET_RFM_PRJ ALTER COLUMN orderlinenumber  
	TYPE smallint 
	USING (orderlinenumber::smallint )

ALTER TABLE SALES_DATASET_RFM_PRJ ALTER COLUMN sales  
	TYPE numeric 
	USING (trim(sales)::numeric)  

ALTER TABLE SALES_DATASET_RFM_PRJ ALTER COLUMN orderdate  
	TYPE  timestamp without time zone
	USING (trim(orderdate )::timestamp without time zone  )  

ALTER TABLE SALES_DATASET_RFM_PRJ ALTER COLUMN status  
	TYPE  text 
	USING (trim(status)::text  )

ALTER TABLE SALES_DATASET_RFM_PRJ ALTER COLUMN productline   
	TYPE  text 
	USING (trim(productline )::text  )  

ALTER TABLE SALES_DATASET_RFM_PRJ ALTER COLUMN msrp    
	TYPE smallint 
	USING (trim(msrp )::smallint )

ALTER TABLE SALES_DATASET_RFM_PRJ ALTER COLUMN productcode     
	TYPE text 
	USING (trim(productcode )::text  ) 

ALTER TABLE SALES_DATASET_RFM_PRJ ALTER COLUMN customername     
	TYPE text 
	USING (trim(customername )::text  )  

ALTER TABLE SALES_DATASET_RFM_PRJ ALTER COLUMN phone     
	TYPE text 	USING (trim(phone )::text  )  

ALTER TABLE SALES_DATASET_RFM_PRJ ALTER COLUMN addressline1      	TYPE text  	USING (trim(addressline1 )::text  )  

ALTER TABLE SALES_DATASET_RFM_PRJ ALTER COLUMN addressline2     	TYPE text  	USING (trim(addressline2)::text  )

ALTER TABLE SALES_DATASET_RFM_PRJ ALTER COLUMN city   	TYPE text 	USING (trim(city)::text  )  

ALTER TABLE SALES_DATASET_RFM_PRJ ALTER COLUMN state     
	TYPE text 
	USING (trim( state )::text  ) 

ALTER TABLE SALES_DATASET_RFM_PRJ ALTER COLUMN country    
	TYPE text 
	USING (trim( country )::text  ) 
ALTER TABLE SALES_DATASET_RFM_PRJ ALTER COLUMN territory    
	TYPE text 
	USING (trim( territory)::text  )  
ALTER TABLE SALES_DATASET_RFM_PRJ ALTER COLUMN contactfullname  
	TYPE text 
	USING (trim( contactfullname	)::text  ) 
ALTER TABLE SALES_DATASET_RFM_PRJ ALTER COLUMN dealsize    
	TYPE text 
	USING (trim( dealsize 	)::text  ) 


BƯỚC 2: CHECK NULL/BLANK ở các trường: ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE.- em định check Blank bằng where column LIKE '' mà nó chạy lỗi 
SELECT ordernumber from sales_dataset_rfm_prj 
	WHERE ordernumber IS NULL 

SELECT quantityordered from sales_dataset_rfm_prj 
	WHERE quantityordered IS NULL 

SELECT priceeach from sales_dataset_rfm_prj 
	WHERE priceeach IS NULL 

SELECT orderlinenumber from sales_dataset_rfm_prj 
	WHERE orderlinenumber IS NULL 

SELECT sales from sales_dataset_rfm_prj 
	WHERE sales IS NULL 

SELECT orderdate from sales_dataset_rfm_prj 
	WHERE orderdate IS NULL 

BƯỚC 3: Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME . 
Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng chữ cái đầu tiên viết hoa, chữ cái tiếp theo viết thường. 

	ALTER TABLE  sales_dataset_rfm_prj 
ADD column contactlastname text 
	ALTER TABLE  sales_dataset_rfm_prj 
ADD column contactfirstname text 

UPDATE sales_dataset_rfm_prj 
	set contactlastname = 
	LEFT(contactfullname,POSITION ( '-' IN contactfullname)-1  )

UPDATE sales_dataset_rfm_prj 
	set contactfirstname = 
	RIGHT (contactfullname,
	length(contactfullname)
	- POSITION( '-' IN contactfullname)  )

UPDATE sales_dataset_rfm_prj 
	set contactfirstname = INITCAP (contactfirstname )

UPDATE sales_dataset_rfm_prj 
	set contactlastname = INITCAP (contactlastname )

BƯỚC 4: Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE 
ALTER TABLE  sales_dataset_rfm_prj 
ADD column QTR_ID  integer 
	ALTER TABLE  sales_dataset_rfm_prj 
ADD column MONTH_ID integer 
	ALTER TABLE  sales_dataset_rfm_prj 
ADD column YEAR_ID integer 


UPDATE sales_dataset_rfm_prj 
SET QTR_ID = 1 WHERE EXTRACT(MONTH from orderdate ) 
	IN (1,2,3)
UPDATE sales_dataset_rfm_prj 
SET QTR_ID = 2 WHERE EXTRACT(MONTH from orderdate ) 
	IN (4,5,6)
UPDATE sales_dataset_rfm_prj 
SET QTR_ID = 3 WHERE EXTRACT(MONTH from orderdate ) 
	IN (7,8,9)
UPDATE sales_dataset_rfm_prj 
SET QTR_ID = 4 WHERE EXTRACT(MONTH from orderdate ) 
	IN (10,11,12) 
*** có extract quarter 

UPDATE sales_dataset_rfm_prj 
SET MONTH_ID =  EXTRACT(MONTH from orderdate ) 

UPDATE sales_dataset_rfm_prj 
SET YEAR_ID =  EXTRACT(YEAR from orderdate )

BƯỚC 5: Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED và hãy chọn cách xử lý cho bản ghi đó (2 cách) ( Không chạy câu lệnh trước khi bài được review)

Tìm + xử lý theo TB


with TWT_outlier as 
	(with outlier as
(SELECT Q1 - 1.5*IQR as min_value,
	Q3 + 1.5*IQR as max_value from 
(select
percentile_cont(0.25) WITHIN GROUP (order by quantityordered) as Q1,
	percentile_cont(0.75) 
	WITHIN GROUP (order by quantityordered) as Q3,
	percentile_cont(0.75) 
	WITHIN GROUP (order by quantityordered) - 
	percentile_cont(0.25) 
	WITHIN GROUP (order by quantityordered) as IQR from 
	sales_dataset_rfm_prj  )
as a )
SELECT * from sales_dataset_rfm_prj 
where quantityordered < (select min_value from outlier)
or quantityordered > (select max_value from outlier ))
UPDATE sales_dataset_rfm_prj
SET quantityordered = (select avg(quantityordered) from
sales_dataset_rfm_prj	)
WHERE quantityordered IN (select quantityordered from TWT_outlier)

XỬ LÝ theo delete
DELETE from sales_dataset_rfm_prj
WHERE quantityordered IN (select quantityordered from TWT_outlier)

BƯỚC 6: Sau khi làm sạch dữ liệu, hãy lưu vào bảng mới  tên là SALES_DATASET_RFM_PRJ_CLEAN

SELECT * 
INTO SALES_DATASET_RFM_PRJ_CLEAN
FROM SALES_DATASET_RFM_PRJ
