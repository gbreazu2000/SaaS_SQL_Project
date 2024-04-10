--Taking the original CSV table and splitting the data into multiple sub-tables to create an organized ERD database

-- Create Orders table
CREATE TABLE Orders (
    row_id INT,
    order_id VARCHAR(255),
	order_date DATE,
	product VARCHAR(225)
	date_key VARCHAR(255),
	contact_name VARCHAR(255),
	customer_id VARCHAR(255)
);

--Insert the data from original table (saas_sales) to sub-table (orders)
INSERT INTO orders (row_id, order_id, order_date, product, date_key, contact_name, customer_id)
SELECT 
    row_id,
    order_id,
    order_date,
	product,
    date_key,
    contact_name,
	customer_id
FROM saas_sales;

Select *
FROM orders

-- Create Locations table
CREATE TABLE Locations (
    row_id INT,
	order_id VARCHAR(255),
	customer_id VARCHAR(255),
	country VARCHAR(255),
	city VARCHAR(255),
	region VARCHAR(255),
	subregion VARCHAR(255)
);

--Insert the data from original table (saas_sales) to sub-table (locations)
INSERT INTO locations (row_id, order_id, customer_id, country, city, region, subregion)
SELECT 
    row_id,
	order_id,
	customer_id,
	country,
	city,
	region,
	subregion
FROM saas_sales;

Select *
FROM locations

--Create Customers table
CREATE TABLE Customers (
    row_id INT,
	customer_id INT,
	customer VARCHAR(255),
	industry VARCHAR(255),
	segment VARCHAR(255),
	product VARCHAR(255),
	license VARCHAR(255)
);

--Insert the data from original table (saas_sales) to sub-table (customers)
INSERT INTO customers (row_id, customer_id, customer, industry, segment, product, license)
SELECT 
   row_id,
   customer_id,
   customer,
   industry,
   segment,
   product, 
   license
FROM saas_sales;

SELECT *
FROM customers

-- Create Sales table
CREATE TABLE Sales (
	row_id INT,
	customer_id VARCHAR(255),
	sales NUMERIC,
	quantity INT,
	discount NUMERIC,
	profit NUMERIC
);

--Insert the data from original table (saas_sales) to sub-table (sales)
INSERT INTO sales (row_id, customer_id, sales, quantity, discount, profit)
SELECT 
   row_id,
   customer_id,
   sales,
   quantity,
   discount,
   profit
FROM saas_sales;

Select *
FROM sales

--Revenue Analysis of AWS Saas Products

--Checking the customers providing the highest profit margins (Top 5)

SELECT Distinct(customers.customer), SUM(sales.profit) as total_profit
FROM customers
JOIN sales USING (row_id)
GROUP BY customers.customer
ORDER BY total_profit DESC
Limit 5

-- Check revenue by segment

SELECT Distinct(customers.segment), SUM(sales.profit) as total_profit
FROM customers
JOIN sales USING (row_id)
GROUP BY customers.segment
ORDER BY total_profit DESC
Limit 5

-- Check Revenue by Industry

SELECT Distinct(customers.industry), SUM(sales.profit) as total_profit
FROM customers
JOIN sales USING (row_id)
GROUP BY customers.industry
ORDER BY total_profit DESC
Limit 5

-- Check Revenue by Product (Top 5)

SELECT Distinct(customers.product), SUM(sales.profit) as total_profit
FROM customers
JOIN sales USING (row_id)
GROUP BY customers.product
ORDER BY total_profit DESC
Limit 5

-- Churn Analysis

--Checking Earliest and Latest order dates

SELECT order_date
FROM orders
ORDER BY order_date DESC

SELECT order_date
FROM orders
ORDER BY order_date ASC

--Checking to see all the companies that bought SaaS products in the 3 year period from AWS

SELECT COUNT(DISTINCT customer_id) AS customers_with_orders_in_all_years
FROM orders
WHERE order_date BETWEEN DATE '2020-01-01' AND DATE '2023-12-31'
GROUP BY EXTRACT(YEAR FROM order_date)
HAVING COUNT(DISTINCT customer_id) = (SELECT COUNT(DISTINCT customer_id) FROM orders WHERE EXTRACT(YEAR FROM order_date) BETWEEN EXTRACT(YEAR FROM DATE '2020-01-01') AND EXTRACT(YEAR FROM DATE '2023-12-31'));

--Churn analysis based on product quantity purchases compared to previous year

WITH ProductSales AS (
    SELECT product,
           EXTRACT(YEAR FROM order_date) AS order_year,
           SUM(quantity) AS total_quantity,
           LAG(SUM(quantity)) OVER (PARTITION BY product ORDER BY EXTRACT(YEAR FROM order_date)) AS previous_year_quantity
    FROM orders
    JOIN sales USING (row_id)
	JOIN customers USING (row_id)
    GROUP BY product, EXTRACT(YEAR FROM order_date)
)
SELECT product,
       order_year,
    CASE
        WHEN total_quantity < (0.90 * previous_year_quantity) THEN 'Churned'
        ELSE 'On Track'
    END AS churn_status
FROM ProductSales;

--Churn Analysis based on product profit numbers compared to previous years

WITH ProductSales AS (
    SELECT product,
           EXTRACT(YEAR FROM order_date) AS order_year,
           SUM(profit) AS total_profit,
           LAG(SUM(profit)) OVER (PARTITION BY product ORDER BY EXTRACT(YEAR FROM order_date)) AS previous_year_profit
    FROM orders
    JOIN sales USING (row_id)
	JOIN customers USING (row_id)
    GROUP BY product, EXTRACT(YEAR FROM order_date)
)
SELECT product,
       order_year,
    CASE
        WHEN total_profit < (0.75 * previous_year_profit) THEN 'Churned'
        ELSE 'On Track'
    END AS churn_status
FROM ProductSales;

--Checking percentage of yearly profit growth by product

WITH ProductProfit AS (
    SELECT product,
           EXTRACT(YEAR FROM order_date) AS order_year,
           SUM(profit) AS total_yearly_profit,
           LAG(SUM(profit)) OVER (PARTITION BY product ORDER BY EXTRACT(YEAR FROM order_date)) AS previous_year_profit
    FROM sales
	JOIN customers USING (row_id)
	JOIN orders USING (row_id)
    GROUP BY product, EXTRACT(YEAR FROM order_date)
)
SELECT product,
       order_year,
       total_yearly_profit,
       previous_year_profit,
    CASE
        WHEN previous_year_profit IS NULL THEN NULL
        ELSE ROUND(((total_yearly_profit - previous_year_profit) / NULLIF(ABS(previous_year_profit), 0)) * 100, 2)
    END AS profit_growth_percentage
FROM ProductProfit;

--Checking percentage of yearly profit growth by segment

WITH SegmentProfit AS (
    SELECT segment,
           EXTRACT(YEAR FROM order_date) AS order_year,
           SUM(profit) AS total_yearly_profit,
           LAG(SUM(profit)) OVER (PARTITION BY segment ORDER BY EXTRACT(YEAR FROM order_date)) AS previous_year_profit
    FROM sales
	JOIN customers USING (row_id)
	JOIN orders USING (row_id)
    GROUP BY segment, EXTRACT(YEAR FROM order_date)
)
SELECT segment,
       order_year,
       total_yearly_profit,
       previous_year_profit,
    CASE
        WHEN previous_year_profit IS NULL THEN NULL
        ELSE ROUND(((total_yearly_profit - previous_year_profit) / NULLIF(ABS(previous_year_profit), 0)) * 100, 2)
    END AS profit_growth_percentage
FROM SegmentProfit;

-- Checking percentage of yearly growth by industry

WITH IndustryProfit AS (
    SELECT industry,
           EXTRACT(YEAR FROM order_date) AS order_year,
           SUM(profit) AS total_yearly_profit,
           LAG(SUM(profit)) OVER (PARTITION BY industry ORDER BY EXTRACT(YEAR FROM order_date)) AS previous_year_profit
    FROM sales
	JOIN customers USING (row_id)
	JOIN orders USING (row_id)
    GROUP BY industry, EXTRACT(YEAR FROM order_date)
)
SELECT industry,
       order_year,
       total_yearly_profit,
       previous_year_profit,
    CASE
        WHEN previous_year_profit IS NULL THEN NULL
        ELSE ROUND(((total_yearly_profit - previous_year_profit) / NULLIF(ABS(previous_year_profit), 0)) * 100, 2)
    END AS profit_growth_percentage
FROM IndustryProfit;

-- Geographical analysis

-- Checking highest grossing product by country (Top 5)

WITH RankedProducts AS (
    SELECT Distinct(Country),
           Product,
		   Profit,
           ROW_NUMBER() OVER (PARTITION BY Product ORDER BY Profit DESC) AS product_rank
    FROM Customers
	JOIN sales USING (row_id)
	JOIN locations USING (row_id)
)
SELECT 
    Country,
    Product,
	Profit
FROM RankedProducts
WHERE product_rank = 1
ORDER BY product_rank DESC
LIMIT 5;

-- Profit margins by country (Top 5)

WITH CountryProfits AS (
    SELECT Country,
           SUM(Profit) AS Total_Profit
    FROM Sales
    JOIN Locations USING (row_id)
    GROUP BY Country
),
RankedCountries AS (
    SELECT Country,
           Total_Profit,
           ROW_NUMBER() OVER (ORDER BY Total_Profit DESC) AS country_rank
    FROM CountryProfits
)
SELECT 
    rc.Country,
    rc.Total_Profit
FROM RankedCountries rc
WHERE rc.country_rank <= 5;

-- Profit margins by city (Top 5)

WITH CityProfits AS (
    SELECT City,
           SUM(Profit) AS Total_Profit
    FROM Sales
    JOIN Locations USING (row_id)
    GROUP BY City
),
RankedCity AS (
    SELECT City,
           Total_Profit,
           ROW_NUMBER() OVER (ORDER BY Total_Profit DESC) AS city_rank
    FROM CityProfits
)
SELECT 
    rc.city,
    rc.Total_Profit
FROM RankedCountries rc
WHERE rc.city_rank <= 5;

	   
	   



