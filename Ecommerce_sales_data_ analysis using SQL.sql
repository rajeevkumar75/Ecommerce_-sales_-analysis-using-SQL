-- Creating Database:-
CREATE DATABASE Ecommerce_Data;
USE Ecommerce_Data;

-- Creating Table:--
CREATE TABLE Sales_Dataset (
	order_id VARCHAR(15) NOT NULL, 
	order_date DATE NOT NULL, 
	ship_date DATE NOT NULL, 
	ship_mode VARCHAR(14) NOT NULL, 
	customer_name VARCHAR(22) NOT NULL, 
	segment VARCHAR(11) NOT NULL, 
	state VARCHAR(36) NOT NULL, 
	country VARCHAR(32) NOT NULL, 
	market VARCHAR(6) NOT NULL, 
	region VARCHAR(14) NOT NULL, 
	product_id VARCHAR(16) NOT NULL, 
	category VARCHAR(15) NOT NULL, 
	sub_category VARCHAR(11) NOT NULL, 
	product_name VARCHAR(127) NOT NULL, 
	sales DECIMAL(38, 0) NOT NULL, 
	quantity DECIMAL(38, 0) NOT NULL, 
	discount DECIMAL(38, 3) NOT NULL, 
	profit DECIMAL(38, 5) NOT NULL, 
	shipping_cost DECIMAL(38, 2) NOT NULL, 
	order_priority VARCHAR(8) NOT NULL, 
	year DECIMAL(38, 0) NOT NULL
);

-- Load the data from local.
LOAD DATA INFILE "C:/Sales_Dataset.csv"
INTO TABLE Sales_Dataset
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM Sales_Dataset;


-- #Projects Questions:-

-- Q1. Which are the top 5 states with the highest shipping costs?
SELECT state, SUM(shipping_cost) 
as total_shipping_cost
FROM Sales_Dataset
GROUP BY state
ORDER BY total_shipping_cost 
DESC LIMIT 5;


-- Q2. Which products or categories are bestsellers and how have their sales 
-- chaged over time?
SELECT category, product_name, YEAR(order_date) 
as year_, SUM(sales) as total_sales
FROM Sales_Dataset
GROUP BY category, product_name, year_
ORDER BY total_sales DESC;

-- Q3. which customer groups spend the most money with us?
SELECT segment, sum(sales) as total_sales,
COUNT(DISTINCT customer_name) as customer_count
FROM Sales_Dataset
GROUP BY segment
ORDER BY total_sales DESC;

-- Q4. How do discounts affect our sales and profits?
SELECT discount, SUM(sales) As total_sales,
SUM(profit) as total_profit_$
FROM Sales_Dataset
GROUP BY discount
ORDER BY discount;

-- Q5. What are the shippping costs for different delivery methods and 
-- how do they affect our profits?
SELECT ship_mode, SUM(shipping_cost) as total_shipping_cost_$,
SUM(profit) as total_profit_$
FROM Sales_Dataset
GROUP By ship_mode;

-- Q6. Which regions are generating the most sales and profits for us?
SELECT region, SUM(sales) as total_sales, SUM(profit) as total_profit_$
FROM Sales_Dataset
GROUP BY region
ORDER BY total_sales DESC;

-- Q7.What is the average amount customers spend per order in different customer groups?
SELECT segment, AVG(sales) AS average_order_value
FROM Sales_Dataset
GROUP BY segment;

-- Q8. What are our monthly sales trends?
SELECT DATE_FORMAT(order_date, '%Y-%m-01') as month, 
SUM(sales) as total_sales
FROM Sales_Dataset
GROUP BY month
ORDER BY month;

-- Q9.How does prioritizing orders affect delivery times and customer happiness?
SELECT order_priority, AVG(DATEDIFF(ship_date, order_date))
as avg_delivery_time_Day
FROM Sales_Dataset
GROUP by order_priority;

-- Q10.How much money will we likely make from each customer over their lifetime?
SELECT customer_name, SUM(sales) AS total_sales, 
COUNT(order_id) as total_orders,
AVG(sales) as average_order_value_$
FROM Sales_Dataset
GROUP by customer_name;

-- Q11.Are there any signs that some customers might stop buying from us?
SELECT customer_name, 
COUNT(order_id) as order_count,
SUM(sales) as total_sales
FROM Sales_Dataset
WHERE order_date < DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
GROUP BY customer_name
HAVING SUM(sales) < 50;


-- 12. Are there seasonal trends in our sales?
SELECT MONTH(order_date) AS month, 
       SUM(sales) AS total_sales
FROM Sales_Dataset
GROUP BY month
ORDER BY month;

select * from Sales_Dataset;

-- Q13. which products are frequently bought together?
SELECT product_name,product_id, 
       COUNT(order_id) AS purchase_count
FROM Sales_Dataset
GROUP BY product_id, product_name
HAVING COUNT(order_id) > 1; 











































