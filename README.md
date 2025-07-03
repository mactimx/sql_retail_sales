# Retail Sales Analysis SQL Project

## 📌 Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `sql_project_p2`

This project demonstrates core SQL skills used by data analysts to explore, clean, and derive actionable insights from retail sales data. It simulates real-world tasks such as building a retail data model, performing exploratory data analysis (EDA), and answering key business questions through SQL.

Ideal for aspiring analysts, this project lays the foundation for mastering SQL through hands-on, business-oriented scenarios.

## 🎯 Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to generate business intelligence from raw sales transactional data.

## 🛠️ Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_retail_p2`.
- **Table Creation**: A table named `retail_sales` wass created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql

CREATE DATABASE sql_project_P2;

-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
	(
        transactions_id	 INT PRIMARY KEY,
        sale_date DATE,
		sale_time TIME,
		customer_id	INT,
		gender VARCHAR(15),
		age INT,
		category VARCHAR(15),	
		quantity INT,
		price_per_unit FLOAT,	
		cogs FLOAT,
		total_sale  FLOAT
	);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*)
FROM retail_sales;

SELECT COUNT(DISTINCT customer_id)
FROM retail_sales;

SELECT DISTINCT category
FROM retail_sales;

SELECT *
FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022**:
```sql
SELECT 
  *
FROM retail_sales
WHERE category = 'Clothing'
    AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND quantity >= 3;
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP BY category, gender
ORDER BY 1;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
SELECT 
    year,
    month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1;
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales**:
```sql
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_uni_cs
FROM retail_sales
GROUP BY category;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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
```

11. **Which customer segments (age/gender) are the most valuable? Identify which groups drive the highest revenue.**
```sql
SELECT 
	gender, 
	CASE 
		WHEN age BETWEEN 18 AND 34 THEN 'Young Adult' 
		WHEN age BETWEEN 24 AND 54 THEN 'Adult'
		WHEN age >= 55 THEN 'Senior'
		ELSE 'Unknown'
	END AS age_group, 
	COUNT(*) AS customer_count,
    ROUND(SUM(total_sale)::numeric, 2) AS total_revenue
FROM retail_sales
GROUP BY gender, age_group
ORDER BY gender, customer_count DESC;
```

12. **What are the peak sales period (by day or period of day i.e morning, afternoon and evening)?**
```sql
SELECT
  TO_CHAR(sale_date, 'FMDay') AS weekday,
  	SUM(CASE WHEN DATE_PART('hour', sale_time) < 12 THEN total_sale ELSE 0 END) AS Morning_Sales,
	SUM(CASE WHEN DATE_PART('hour', sale_time) BETWEEN 12 AND 17 THEN total_sale ELSE 0 END) AS Afternoon_Sales,
	SUM(CASE WHEN DATE_PART('hour', sale_time) >17 THEN total_sale ELSE 0 END) AS Evening_Sales
FROM retail_sales
GROUP BY weekday, EXTRACT(DOW FROM sale_date)
ORDER BY EXTRACT(DOW FROM sale_date)
```

## 🔍 Key Insights

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty. Adult contribute the hightes revenue across categories.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, with peak sales season recorded on Sunday evenings.
- **Customer Insights**: The analysis identifies adult females as top-spending customers and clothing as the top selling product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## 🚀 How to Use

1. **Clone the Repository**: Clone this repository.
2. **Set Up the Database**: - Import the dataset into a PostgreSQL (or your preferred tool) database.
3. **Run the Queries**: - Run the SQL scripts provided in /sql_queries file to perform your analysis.
4. **Explore and Modify**: Explore insights or modify queries for further business questions exploration.

## 🙌 Acknowledgments
Big thanks to [ZeroAnalyst](https://github.com/najirh/Retail-Sales-Analysis-SQL-Project--P1/commits?author=najirh), open-source community and data practitioners whose shared knowledge inspired this project. This project was created as part of my data analytics learning journey. 

Let me know if you want a LICENSE, CONTRIBUTING.md, badges, or query file links included too! Happy to polish it up even more. ✨


## Author - Timothy Ukeje

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

Thank you for your support, and I look forward to connecting with you!
