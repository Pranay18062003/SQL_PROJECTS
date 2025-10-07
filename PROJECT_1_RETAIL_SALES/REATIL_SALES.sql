DROP TABLE IF EXISTS SALES;
CREATE TABLE SALES
(
transactions_id INT,	
sale_date DATE,	
sale_time TIME,
customer_id	INT,
gender VARCHAR(6),
age	INT,
category VARCHAR(11),	
quantity	INT,
price_per_unit INT,
cogs NUMERIC(10, 2),
total_sale NUMERIC(10, 2)
);

SELECT * FROM SALES;
--Q-1--Determine the total number of records in the dataset.--
SELECT
COUNT(*) FROM SALES;
--Q-2--Find out how many unique customers are in the dataset.--
SELECT 
COUNT(DISTINCT CUSTOMER_ID) FROM SALES;
--Q-3--Identify all unique product categories in the dataset.--
SELECT
DISTINCT CATEGORY FROM SALES;
--Q-4--Check for any null values in the dataset and delete records with missing data.--
SELECT * FROM SALES
WHERE
TRANSACTIONS_ID IS NULL
OR 
sale_time IS NULL 
OR 
customer_id IS NULL 
OR 
gender IS NULL 
OR 
age IS NULL 
OR 
category IS NULL 
OR 
quantity IS NULL 
OR 
price_per_unit IS NULL 
OR 
cogs IS NULL
OR
total_sale IS NULL;
--Q-5--DELETE ALL THE NULL VALUE FROM DATABASE
DELETE FROM SALES
WHERE
TRANSACTIONS_ID IS NULL
OR 
sale_time IS NULL 
OR 
customer_id IS NULL 
OR 
gender IS NULL 
OR 
age IS NULL 
OR 
category IS NULL 
OR 
quantity IS NULL 
OR 
price_per_unit IS NULL 
OR 
cogs IS NULL
OR
total_sale IS NULL;
--Q-3(i)--Write a SQL query to retrieve all columns for sales made on '2022-11-05:--
SELECT * FROM SALES
WHERE SALE_DATE = '2022-11-05';
--Q-3(ii)--Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:--
SELECT * FROM SALES
WHERE
CATEGORY = 'CLOTHING'
AND
TO_CHAR(SALE_DATE, 'YYYY-MM') = '2022-11'
AND 
QUANTITY >= 4
--Q-3(iii)-Write a SQL query to calculate the total sales (total_sale) for each category.:--
SELECT 
	CATEGORY,
	SUM(TOTAL_SALE) AS NET_SALE,
	COUNT(*) as TOTAL_ORDERS
FROM SALES
GROUP BY 1
--Q-3(iv)--Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:--
SELECT
ROUND(AVG(AGE), 2) AS AVG_AGE
FROM SALES
WHERE CATEGORY = 'BEAUTY'
--Q-3(v)--Write a SQL query to find all transactions where the total_sale is greater than 1000.:--
SELECT * FROM SALES
WHERE
TOTAL_SALE > 1000;
--Q-3(vi)--Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:--
SELECT
	GENDER,
	CATEGORY,
	COUNT(DISTINCT TRANSACTIONS_ID) AS NET_TRANSACTIONS
FROM SALES
GROUP BY 1, 2
--Q-3(vii)--Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:--
SELECT 
YEAR,
MONTH,
AVG_SALE
FROM (
SELECT
TO_CHAR(SALE_DATE, 'YYYY') AS YEAR,
TO_CHAR(SALE-DATE, 'MM') AS MONTH,
AVG(TOTAL_SALE) AS AVG_SALE,
RANK() OVER (
PARTITION BY TO_CHAR(SALE_DATE, 'YYYY'))
ORDER BY AVG(TOTAL_SALE)
)AS RNK
FROM SALES
GROUP BY TO_CHAR(SALE_DATE, 'YYYY') AS YEAR,
TO_CHAR(SALE_DATE, 'MM') AS MONTH
)T
WHERE RNK = 1
--Q-3(viii)--Write a SQL query to find the top 5 customers based on the highest total sales **:--
SELECT
CUSTOMER_ID,
SUM(TOTAL_SALE) AS NET_SALE
FROM SALES
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
--Q-3(ix)--Write a SQL query to find the number of unique customers who purchased items from each category.:--
SELECT 
CATEGORY,
COUNT(DISTINCT CUSTOMER_ID) AS CUSTOMER
FROM SALES
GROUP BY 1
--Q-3(x)--Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):--
WITH HOURLY_SALES
AS
(
SELECT *,
CASE
 WHEN EXTRACT(HOUR FROM SALE_TIME) < 12 THEN 'MORNING'
 WHEN EXTRACT(HOUR FROM SALE_TIME) BETWEEN 12 AND 17 THEN 'AFTERNOON'
 ELSE 'EVENING'
 END AS SHIFT
 FROM SALES
 )
 SELECT
 SHIFT,
 COUNT(TRANSACTIONS_ID) AS NET_ORDERS
 FROM HOURLY_SALES
 GROUP BY SHIFT
 