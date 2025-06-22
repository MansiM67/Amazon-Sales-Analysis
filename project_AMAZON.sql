-- AMAZON SALES REPORT ANALYSIS

create database Amazon_sales1;
use Amazon_sales1;
CREATE TABLE Amazon_sales1 (
    INDEX_ INT,
    order_id VARCHAR(50) not null,
    order_date_1 date,
    order_date DATE,
    STATUS_ VARCHAR(100),
    fulfillment VARCHAR(50),
    sales_channel VARCHAR(50),
    ship_service_level VARCHAR(50),
    category VARCHAR(100),
    size VARCHAR(20),
    courier_status VARCHAR(50),
    qty INT,
    currency VARCHAR(10),
    amount DECIMAL(10,2),
    ship_city VARCHAR(100),
    ship_state VARCHAR(100),
    ship_postal_code VARCHAR(20),
    ship_country VARCHAR(50),
    b2b BOOLEAN,
    fulfilled_by VARCHAR(50)
);
set global local_infile=ON;
load data local infile 'C:/Users/ASUS/OneDrive/Desktop/Amazon Sale Report(1).csv' into table amazon_sales1
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;



select*
from amazon_sales1;

-- Data Cleaning 

ALTER TABLE amazon_sales1
DROP COLUMN order_date;

SELECT 
    *
FROM
    amazon_sales1
WHERE
    qty IS NULL;



DELETE FROM amazon_sales1
WHERE INDEX_ NOT IN (
  SELECT * FROM (
    SELECT MIN(INDEX_) 
    FROM amazon_sales1 
    GROUP BY order_id
  ) AS temp
);

DELETE FROM amazon_sales1
WHERE order_date IS NULL OR YEAR(order_date) = 0;



SELECT order_id, order_date 
FROM amazon_sales1
WHERE STR_TO_DATE(order_date, '%m-%d-%y') IS NULL;

DELETE FROM amazon_sales1
WHERE qty <= 0 OR amount <= 0;


UPDATE amazon_sales1
SET category = TRIM(UPPER(category)),
    ship_state = TRIM(UPPER(ship_state));

UPDATE amazon_sales1
SET size = 'UNKNOWN'
WHERE size IS NULL OR TRIM(size) = '';

select*
from amazon_sales1;

SELECT *
FROM amazon_sales1
WHERE order_date IS NULL
   OR category IS NULL
   OR size IS NULL
   OR courier_status IS NULL
   OR amount IS NULL;

SELECT *
FROM amazon_sales1
WHERE TRIM(size) = ''
   OR size IS NULL;

SELECT
  SUM(CASE WHEN INDEX_ IS NULL THEN 1 ELSE 0 END) AS null_INDEX_,
  SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_id,
  SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS null_order_date,
  SUM(CASE WHEN STATUS_ IS NULL THEN 1 ELSE 0 END) AS null_STATUS_,
  SUM(CASE WHEN fulfillment IS NULL THEN 1 ELSE 0 END) AS null_fulfillment,
  SUM(CASE WHEN sales_channel IS NULL THEN 1 ELSE 0 END) AS null_sales_channel,
  SUM(CASE WHEN ship_service_level IS NULL THEN 1 ELSE 0 END) AS null_ship_service_level,
  SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END) AS null_category,
  SUM(CASE WHEN size IS NULL THEN 1 ELSE 0 END) AS null_size,
  SUM(CASE WHEN courier_status IS NULL THEN 1 ELSE 0 END) AS null_courier_status,
  SUM(CASE WHEN qty IS NULL THEN 1 ELSE 0 END) AS null_qty,
  SUM(CASE WHEN currency IS NULL THEN 1 ELSE 0 END) AS null_currency,
  SUM(CASE WHEN amount IS NULL THEN 1 ELSE 0 END) AS null_amount,
  SUM(CASE WHEN ship_city IS NULL THEN 1 ELSE 0 END) AS null_ship_city,
  SUM(CASE WHEN ship_state IS NULL THEN 1 ELSE 0 END) AS null_ship_state,
  SUM(CASE WHEN ship_postal_code IS NULL THEN 1 ELSE 0 END) AS null_ship_postal_code,
  SUM(CASE WHEN ship_country IS NULL THEN 1 ELSE 0 END) AS null_ship_country,
  SUM(CASE WHEN b2b IS NULL THEN 1 ELSE 0 END) AS null_b2b,
  SUM(CASE WHEN fulfilled_by IS NULL THEN 1 ELSE 0 END) AS null_fulfilled_by
FROM amazon_sales1;


-- SQL-Based Exploratory Analysis

--  Time-Based Trends

-- Q1 How have total sales changed over time (monthly or quarterly)?

select
DATE_FORMAT(order_date_1, '%Y-%m') AS month,
sum(amount) as total_sales
from amazon_sales1
where status_ like '%Shipped%'
group by month
order by month;

-- Q2 Which months/quarters had the highest and lowest sales volumes?

-- basic query
SELECT 
  DATE_FORMAT(order_date, '%Y-%m') AS month,
  SUM(amount) AS total_sales
FROM amazon_sales1
GROUP BY month
ORDER BY total_sales DESC;

-- advance query
select
month,
total_sales,
rank() over( order by total_sales desc) as sales_rank_desc,
rank() over( order by total_sales asc) as sales_rank_asc
from
(
select
DATE_FORMAT(order_date_1, '%Y-%m') AS month,
sum(amount) as total_sales 
from amazon_sales1
where status_ like '%Shipped%'
group by month
) as monthly_Sales
;


with ranked_sales as(
  select
		DATE_FORMAT(order_date_1, '%Y-%m') AS month,
		sum(amount) as total_sales,
		rank() over( order by sum(amount) desc) as sales_rank_desc,
		rank() over( order by sum(amount) asc) as sales_rank_asc 
		from amazon_sales1
		where status_ like '%Shipped%'
		group by month
)
select*
from ranked_sales
where sales_rank_desc=1 or sales_rank_asc=1;

--  Q3.Monthly Sales with Running Total

select
DATE_FORMAT(order_date_1, '%Y-%m') AS month,
sum(amount) as total_sales,
sum(sum(amount)) over (order by DATE_FORMAT(order_date_1, '%Y-%m')) as running_total
from amazon_sales1
where status_ = 'shipped'
group by month;


-- Product Analysis

-- Q1 Which product categories contribute most to revenue?
select
category,
sum(amount) as total_Sales
from amazon_sales1
group by category
order by total_sales desc;


-- Q2 Are there specific sizes or variants that sell more within a category?

select
size,
category,
sum(qty) as total_quantity_sold
from amazon_sales1
group by category,size
ORDER BY category, total_quantity_sold DESC;


-- Q3 Which products have high return or cancellation rates?

SELECT 
  category, STATUS_,
  COUNT(*) AS total_orders,
  SUM(amount) AS total_amount
FROM amazon_sales1
WHERE STATUS_ IN ('Cancelled', 'Returned')
GROUP BY category, STATUS_
ORDER BY total_orders DESC;

-- Q4. Most Popular Size by Product Category

select*
from (
select
size,
category,
count(*) as total_orders,
row_number() over(partition by category order by count(*) desc) as ranked
from amazon_sales1
group by size,category) as t_1
where ranked=1;

WITH size_ranked AS (
  SELECT 
    category,
    size,
    COUNT(*) AS total_orders,
    ROW_NUMBER() OVER (PARTITION BY category ORDER BY COUNT(*) DESC) AS ranked
  FROM amazon_sales1
  GROUP BY category, size
)
SELECT *
FROM size_ranked
WHERE ranked=1;

-- Q5 Product Categories with High Cancellation Rates

select
category,
count(*) as total_order,
sum(  case when status_ ='cancelled' then'1' else '0' end ) AS cancelled_orders,
round(100* sum(  case when status_ ='cancelled' then'1' else '0' end )/ count(*),2) as cancellation_rates
from amazon_sales1
group by category
order by cancellation_rates desc;


-- Fulfillment & Delivery
-- Q1 Which fulfillment method (FBA vs FBM) results in higher revenue or more orders?
SELECT
fulfillment,
sum(amount) as total_sales,
count(*) as total_orders
from amazon_sales1
group by fulfillment
order by total_Sales desc;


-- Q2 Is there a pattern in returns or delays by fulfillment type?

select
fulfillment,STATUS_,
count(*) as order_
from amazon_sales1
where STATUS_ in ('Cancelled', 'Returned')
group by fulfillment,STATUS_;


-- Customer Behavior

-- Q1 Who are the top 10 customers based on total spend?

select
order_id ,
sum(amount) as total_spend
from amazon_sales1
group by order_id
order by total_spend desc
limit 10;


-- Q2 What is the average order value (AOV) per customer segment or region?

select
avg(amount) as AOV_,
ship_state
from amazon_sales1
group by ship_state
order by AOV_ DESC;

-- Q3 How frequently do customers place repeat orders?

select
order_id,
count(distinct order_id) as orders 
from amazon_sales1
group by order_id
order by orders desc;

-- Q4 Rank Customers by Revenue and Frequency

select
order_id,
count(distinct order_id) as orders ,
sum(amount) as revenue,
rank() over( order by sum(amount) desc) as ranked_revenue,
rank() over( order by count(distinct order_id) desc) as frequent_orders
from amazon_sales1
group by order_id
order by orders,revenue desc;

-- Q5 Classify Orders by Tier (High, Medium, Low) -To categorize orders by how much money was spent.

select
order_id,
amount,
case
	when amount >= 1000 then 'high'
    when amount between 500 and 999 then 'medium'
    else 'low'
    end as order_tier
from amazon_sales1;


-- Geographical Trends

-- Q1 Which states or cities generate the highest revenue?
select
ship_city,ship_state,
sum(amount) as total_revenue
from amazon_sales1
group by ship_city,ship_state
order by total_revenue desc;


-- Q2 Are there underperforming regions that require strategy changes?

select
ship_city,ship_state,
sum(amount) as total_revenue
from amazon_sales1
group by ship_city,ship_state
order by total_revenue asc
limit 10;

-- Q3 Detect Revenue Drops by State (Month-over-Month)
WITH monthly_state_sales AS (
  SELECT 
    ship_state,
    DATE_FORMAT(order_date_1, '%Y-%m') AS month,
    SUM(amount) AS total_sales
  FROM amazon_sales1
  GROUP BY ship_state, month
),
with_lag AS (
  SELECT *,
    LAG(total_sales) OVER (PARTITION BY ship_state ORDER BY month) AS last_month_sales,
    total_sales - LAG(total_sales) OVER (PARTITION BY ship_state ORDER BY month) AS change_
  FROM monthly_state_sales
)
SELECT *
FROM with_lag
WHERE change_< 0;



-- Operational & Strategic Questions

-- Q1 What is the sales breakdown by channel (Online vs Retail)?

select
sales_channel,
sum(amount) as total_sales
from amazon_sales1
group by sales_channel;


-- Q2 Are there trends in order cancellations by time, region, or category?

SELECT 
ship_state,
  category, 
  COUNT(*) AS cancelled_orders
FROM amazon_sales1
WHERE status_= 'Cancelled'
GROUP BY category,ship_state
ORDER BY cancelled_orders DESC;

-- Q3 Identify Top 3 Selling Categories Per State

select*
from
(
select
category,
ship_state,
sum(amount) as total_sales,
rank() over(partition by ship_state order by sum(amount) desc) as rank_in_state
from amazon_sales1
group by category,ship_state
) as ranked
where rank_in_state <=3;















