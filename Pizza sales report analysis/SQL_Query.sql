use Pizza_Sales;

select count(distinct order_id)
from pizza_sales;


/*display all columns with their data types*/
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'pizza_sales';


-- Total Revenue
select
	round(sum(total_price),2) as Total_Revenue
from
	pizza_sales;


-- Average order value
select
	round((sum(total_price))/(COUNT(distinct order_id)),2) as Average_Order_Value
from
	pizza_sales;

-- Total pizzas sold
select
	sum(quantity) as Total_Pizzas_Sold
from
	pizza_sales;

-- Total orders
select
	count(distinct order_id) as Total_Orders
from
	pizza_sales;

-- Average pizzas per order
select
	cast(cast(sum(quantity) as decimal(10,2)) / cast(count(distinct order_id)as decimal(10,2)) as decimal(10,2)) as avg_pizzas_per_order
from
	pizza_sales;

-- Daily trend for total orders
ALTER TABLE pizza_sales
ADD weekday_name VARCHAR(20);

UPDATE pizza_sales
SET weekday_name = DATENAME(WEEKDAY, order_date);

select
	weekday_name,
	count(distinct order_id) as total_orders
from
	pizza_sales
group by
	weekday_name
order by
	total_orders;

-- Monthly trend for total orders
select
	datename(month,order_date) as months_name,
	count(distinct order_id) as total_orders
from
	pizza_sales
group by
	datename(month,order_date)
order by
	total_orders;


-- Percentage of sales by pizza category
select
	pizza_category,
	round(sum(total_price)*100/(select
									sum(total_price)
								from 
									pizza_sales
								where
									MONTH(order_date) = 1
			),2) as prct_of_sales
from
	pizza_sales
where
	MONTH(order_date) = 1    -- filter for the month January
group by
	pizza_category
order by
	prct_of_sales;



-- Percentage of sales by pizza size
select
	pizza_size,
	round(sum(total_price)*100/(select
									sum(total_price)
								from 
									pizza_sales
								where
									datepart(quarter,order_date) = 1
			),2) as prct_of_sales
from
	pizza_sales
where
	datepart(quarter,order_date) = 1    -- filter for the first quarter
group by
	pizza_size
order by
	prct_of_sales;



-- Top 5 best selling pizzas
select top 5
	pizza_name,
	round(sum(total_price),2) as total_revenue,
	sum(quantity) as total_quantity,
	count(distinct order_id) as total_orders

from
	pizza_sales
group by
	pizza_name
order by
	total_revenue desc,
	total_quantity desc,
	total_orders desc;