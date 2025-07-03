-- SQL Retail Sales Analysis - p1
CREATE DATABASE sql_project_P2;


-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
			(
				transactions_id	 INT PRIMARY KEY,
				sale_date	DATE,
				sale_time	TIME,
				customer_id	 INT,
				gender	VARCHAR(15),
				age	INT,
				category  VARCHAR(15),	
				quantiy	INT,
				price_per_unit FLOAT,	
				cogs	FLOAT,
				total_sale  FLOAT
			);


SELECT * FROM retail_sales
LIMIT 10;

--- updating the column name
ALTER TABLE retail_sales
RENAME COLUMN quantiy TO quantity;


--- checking the total number of data
SELECT 
	COUNT(*) 
FROM retail_sales;


-- Data Cleaning
-- To check for null values
SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

-- to chech for NULL at once
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
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR total_sale IS NULL;


-- deleting NULL values form the data
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
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR total_sale IS NULL;

-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales;

-- How many unique cutomers do we have
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales;

-- How many category sales do we have?
SELECT DISTINCT category as category FROM retail_sales;

SELECT * FROM retail_sales

-- Data Analysis & Business Problems

--- Q.1 Write a SQL query to retrieve all column for sales made on '2022-11-05'
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';


-- Q2 Write a SQL query to retrieve all transaction where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
SELECT 
	* 
FROM retail_sales
WHERE category = 'Clothing' 
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND quantity >= 3;

-- Q3. Write a SQL query to calculate the total sales (total_sale) for each category
SELECT
	category,
	SUM(total_sale),
	COUNT(*) as total_orders
FROM retail_sales
GROUP BY category;

-- Q4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
	ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

--Q5. Write a SQL query to find all transaction where the total_sale is greater than 1000.
SELECT * FROM retail_sales
WHERE total_sale > '1000';

-- Q6. Write a SQL query to find the total number of transaction made by each gender in each category.
SELECT 
	category,
	gender,
	COUNT(*) as total_transactions
FROM retail_sales
GROUP BY 
	category,
	gender
ORDER BY Category;

--- Q7 Write a SQL query to calculate the average sale for each month. Find out the best selling month in each year
SELECT 
		year,
		month,
		avg_sale
FROM                     -- create a CTE to wrap all as t1
(
SELECT 
	EXTRACT(YEAR FROM sale_date) as year,  --- using EXTRACT FUNCTION to get year and month (1)
	EXTRACT(MONTH FROM sale_date) as month,
	ROUND(AVG(total_sale):: numeric, 2) as avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY ROUND(AVG(total_sale)::numeric, 2) DESC) as rank -- use WINDOW function RANK to create a column to rank the data (2)
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1

-- ORDER BY 1, 3 DESC;


SELECT
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	ROUND (AVG(total_sale):: numeric, 2) as avg_sale
FROM retail_sales
GROUP BY 1, 2;


-- Q8  Write a SQL query to find the top 5 customers based on the highest total sales

SELECT 
	customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- Q9 Write the SQL query to find the number of unique customers who purchased items from each category
SELECT
	category,
	COUNT(DISTINCT customer_id) as cnt_uni_cs
FROM retail_sales
GROUP BY category;


-- Q10 Write the SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
SELECT 
	shift,
	COUNT(*) as total_orders 
FROM hourly_sale
GROUP BY shift;

-- End of Project