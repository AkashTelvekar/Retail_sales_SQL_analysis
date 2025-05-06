-- Retail Sales Analysis SQL-Project-1

-- Create the table 
CREATE TABLE retail_sales
		(
			transactions_id INT,
			sale_date DATE,
			sale_time TIME,	
			customer_id INT,	
			gender VARCHAR(7),	
			age INT,
			category VARCHAR(10),	
			quantity INT,
			price_per_unit INT,	
			cogs FLOAT,
			total_sale INT
		);

SELECT * FROM retail_sales;
-- Changing data type int to float
ALTER TABLE retail_sales
ALTER COLUMN price_per_unit
SET DATA TYPE FLOAT;

-- Changing data type int to float
ALTER TABLE retail_sales
ALTER COLUMN total_sale
SET DATA TYPE FLOAT;

-- Changing data type int to float
ALTER TABLE retail_sales
ALTER COLUMN category
SET DATA TYPE VARCHAR(15);

-- assigning column transactions_id as a PRIMARY KEY
ALTER TABLE retail_sales 
ADD CONSTRAINT retail_sales_pkey PRIMARY KEY (transactions_id);

SELECT * FROM retail_sales;

-- data imported , lets view first 5 rows of data 
SELECT * FROM retail_sales
LIMIT 5;

-- Count the no. of rows
SELECT 
COUNT(*)
FROM retail_sales;

-- Data Cleaning 
-- Check for the NULL value in column 
SELECT * FROM retail_sales
WHERE transactions_id IS NULL;

-- OR you can write
SELECT * FROM retail_sales
WHERE 
  	transactions_id IS NULL 
OR 
	sale_date IS NULL
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
	cogs IS NULL;

	
-- Delete the NULL records 
DELETE FROM retail_sales 
WHERE 
  	transactions_id IS NULL 
OR 
	sale_date IS NULL
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
	cogs IS NULL;

-- Count the no. of rows
SELECT 
COUNT(*)
FROM retail_sales;

-- Data Exploration
-- How much is the total sale?
SELECT COUNT(*) AS Total_sale FROM retail_sales;

--  How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) AS customer_count FROM retail_sales;

-- How many unique categories we have?
SELECT COUNT(DISTINCT category) AS categories FROM retail_sales;

-- Print unique categories.
SELECT DISTINCT category FROM retail_sales;

-- Data analysis & Business Key Problems 
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * 
FROM retail_sales 
WHERE sale_date='2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT 
	*
FROM 
	retail_sales
WHERE 
	category='Clothing'
	AND 
	TO_CHAR(sale_date,'YYYY-MM')='2022-11'
	AND 
	quantity >=4

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
	category ,
	SUM(total_sale) AS total_sale
FROM 
	retail_sales
GROUP BY 1


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
	category,
	AVG(age)
FROM retail_sales
WHERE 
	category='Beauty'
GROUP BY 1;

-- OR 

SELECT 
	ROUND(AVG(age),2) AS avg_age_for_Beauty_category
FROM 
	retail_sales
WHERE 
	category='Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT 
	*
FROM 	
	retail_sales 
WHERE 
	total_sale>1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
	category,
	gender,
	COUNT(*) AS total_transactions
FROM 
	retail_sales
GROUP BY 
	2,1
ORDER BY 
	1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
	*
FROM 
(
	SELECT 
		EXTRACT(YEAR FROM sale_date) AS year,
		EXTRACT(MONTH FROM sale_date) AS month,
		AVG(total_sale) AS avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale)DESC) AS rank
	FROM 
		retail_sales
	GROUP BY 
		1,2
) as t1
WHERE rank=1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT 
	customer_id,
	SUM(total_sale) AS total_sale
FROM 
	retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
	category,
	COUNT(DISTINCT customer_id) AS unique_customer
FROM 
	retail_sales
GROUP BY 1;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS 
(
	SELECT *, 
		CASE
			WHEN EXTRACT (HOUR FROM sale_time) < 12 THEN 'Morning' 
			WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END AS Shift
	FROM retail_sales
)

SELECT 
	shift,
	COUNT(*) AS Order_count
FROM 
	hourly_sale
GROUP BY 
	shift
ORDER BY 
	2 DESC;


-- END OF THE PROJECT












