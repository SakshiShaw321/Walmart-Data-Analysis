show databases;

create database walmartsalesdata;

use walmartsalesdata; 

CREATE TABLE IF NOT EXISTS sales(
	invoice_id int(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating float(2, 1)
);
DESCRIBE sales;

select* from sales;

-- -------------------------------FEATURE ENGINEERING------------------------------------
-- ----------------------------------------------------------------------------------------- 

 select time 
	(case when time between'00:00:00' And '12:00:00' then 'Morning'
    when time between '12:01:00' And '16:00:00' then "Afternoon"
    else "Evening" end) as time_of_day from sales;
alter table sales add column time_of_day varchar(20);

update sales
SET time_of_day=(case 
	when time between'00:00:00' And '12:00:00' then 'Morning'
    when time between '12:01:0' And '16:00:00' then "Afternoon"
    else "Evening" 
    end);
    
-- Add day_name column------------------------------------------------- 
select date,dayname(date) from sales;
alter table sales add column Day_Name varchar(15);
update sales SET Day_Name = DAYNAME(date);

-- Add month_name column------------------------------------------------- 
select date,monthname(date) from sales;
alter table sales add column Month_Name varchar(15);
update sales SET Month_Name=monthname(date);

 -- EDA-------------------------------------------------   
 # 1.How many distinct cities are present in the dataset?  
 select distinct city,count(distinct city ) from sales group by city; 
 
 -- 2.In which city is each branch situated?
select distinct branch,city from sales;

-- 3.How many distinct product lines are there in the dataset?
select count(distinct product_line) from sales;

-- 4.What is the most common payment method?
select payment, count(payment) as payment_count from sales
group by payment order by payment_count  desc Limit 1;

-- 5.What is the most selling product line?
select product_line, count(product_line) as most_selling_product_line from sales
group by product_line order by most_selling_product_line desc limit 1;

-- 6.What is the total revenue by month?
select Month_Name,sum(total) from sales
group by Month_Name;

-- 7.Which month recorded the highest Cost of Goods Sold (COGS)?
select Month_Name, sum(cogs)as highest_cost_of_Goods_Sold from sales
group by Month_Name order by highest_cost_of_Goods_Sold desc limit 1;

-- 8.Which product line generated the highest revenue?
select product_line ,sum(total)as Revenue from sales
group by product_line order by Revenue desc limit 1;

-- 9.Which city has the highest revenue?
select city ,sum(total)as Revenue from sales
group by city order by Revenue desc limit 1;

-- 10.Retrieve each product line and add a column product_category,
 #indicating 'Good' or 'Bad,'based on whether its sales are above the average.--
 alter table sales add column product_category varchar(15);
SELECT AVG(total) FROM sales;
update sales
SET product_category=( 
	CASE 
      WHEN total>(SELECT AVG(total) FROM sales) THEN "good" 
	  ELSE "BAD"
   END ); 
SELECT * FROM sales;

-- 11.Which branch sold more products than average product sold?
select avg(quantity) from sales;
select branch,sum(quantity)as qt from sales
group by branch
order by qt desc ;

-- 12. what is the most common product by gender?--
select gender,product_line ,count(gender) from sales
group by gender,product_line 
order by count(gender)desc;

-- 13 what is the average rating of each product_line?--
select avg(rating)as rt ,product_line from sales
group by product_line
order by rt desc;

-- 14 number of sales made in each time of the day per weekday?--
select Day_Name,time_of_day,SUM(quantity) FROM sales
group by Day_Name,time_of_day
order by sum(quantity) desc;

-- 15 which of the customer types brings the most revenue
SELECT customer_type,SUM(total) FROM sales
GROUP BY customer_type
ORDER BY SUM(total) DESC;

-- 16 how many unique customer_types does the data have and its counts?
select distinct customer_type as cust_typ,count(customer_type) as count from sales
group by cust_typ
order by count ;

-- 17 how many unique payment methods does the data have?--
select distinct payment from sales

-- 18 what is the most customer type?--
select customer_type, count(customer_type)from sales
group by customer_type
order by count(customer_type);

 -- 19 which customer type buys the most?--
 SELECT customer_type,COUNT(*) FROM sales
 GROUP BY customer_type
 ORDER BY COUNT(*); 
 
  -- 20what is the gender of the most of the customers?--
  SELECT gender,COUNT(*) FROM sales
  GROUP BY gender
  ORDER BY COUNT(*);

-- 21 what is the gender distribution per  branch?--  
  SELECT branch,gender,COUNT(*) FROM sales
  GROUP BY gender,branch
  ORDER BY branch;
  
  
  -- 22.what time of the day do customers give most ratings?--
  SELECT COUNT(rating),time_of_day FROM sales
  GROUP BY time_of_day
  ORDER BY COUNT(rating) DESC;
  
  -- 23which day of the week has the best average ratings?--
  SELECT day_name,AVG(rating) FROM sales
  GROUP BY day_name
  ORDER BY AVG(rating) DESC;
  
  -- 24which day of the week has the best average ratings per branch?--
  SELECT day_name,branch,AVG(rating) FROM sales
  GROUP BY day_name,branch
  ORDER BY branch,AVG(rating) DESC;
  
  
 
 