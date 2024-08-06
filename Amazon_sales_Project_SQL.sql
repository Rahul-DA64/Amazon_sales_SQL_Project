-- Data Wrangling

CREATE DATABASE amazon1;
USE amazon1;

CREATE TABLE amazon_sales (
invoice_id VARCHAR(30) NOT NULL, branch VARCHAR(5) NOT NULL, city VARCHAR(30) NOT NULL, customer_type VARCHAR(30) NOT NULL,
gender VARCHAR(10) NOT NULL, product_line VARCHAR(100) NOT NULL, unit_price DECIMAL(10, 2) NOT NULL, quantity INT NOT NULL,
VAT DECIMAL(6, 4) NOT NULL, total DECIMAL(10, 2) NOT NULL, date DATE NOT NULL, time TIME NOT NULL, 
payment_method VARCHAR(50) NOT NULL, cogs DECIMAL(10, 2) NOT NULL, gross_margin_percentage DECIMAL(11, 9) NOT NULL,
gross_income DECIMAL(10, 2) NOT NULL, rating DECIMAL(2, 1) NOT NULL
); 
-- Imported the data from the amazon csv file.
SELECT * FROM amazon_sales;

-- Feature Engineering

ALTER TABLE amazon_sales 
ADD COLUMN time_of_day VARCHAR(20);

UPDATE amazon_sales
SET time_of_day =
CASE
WHEN HOUR(amazon_sales.time) >= 0 AND HOUR(amazon_sales.time) < 12 THEN "Morning"
WHEN HOUR(amazon_sales.time) >= 12 AND HOUR(amazon_sales.time) < 18 THEN "Afternoon"
ELSE "Evening"
END;

ALTER TABLE amazon_sales
ADD COLUMN day_name VARCHAR(30);

SELECT * FROM amazon_sales;

UPDATE amazon_sales
SET day_name = DATE_FORMAT(amazon_sales.date, '%a');

SELECT * FROM amazon_sales;

ALTER TABLE amazon_sales
ADD COLUMN month_name VARCHAR(30);

UPDATE amazon_sales
SET month_name = DATE_FORMAT(amazon_sales.date, '%b');

SELECT * FROM amazon_sales;

-- BUSINESS QUESTIONS:

-- 1. What is the count of distinct cities in the dataset?

SELECT DISTINCT(city) FROM amazon_sales;

-- 2. For each branch, what is the corresponding city?

SELECT branch, city FROM amazon_sales
GROUP BY branch, city;

-- 3. What is the count of distinct product lines in the dataset?

SELECT DISTINCT(product_line) FROM amazon_sales;

-- 4. Which payment method occurs most frequently?

SELECT payment_method, count(payment_method) FROM amazon_sales
GROUP BY payment_method;

-- 5. Which product line has the highest sales?

SELECT product_line, sum(total) AS tot FROM amazon_sales
GROUP BY product_line
ORDER BY sum(total) 
DESC LIMIT 1;

-- 6. How much revenue is generated each month?
-- SELECT * FROM amazon_sales;

SELECT month_name, sum(total) as Revenue_generated
FROM amazon_sales
GROUP BY month_name

-- 7. In which month did the cost of goods sold reach its peak?

SELECT month_name, sum(total) as Revenue_generated
FROM amazon_sales
GROUP BY month_name
ORDER BY sum(total)
DESC LIMIT 1;

-- 8. Which product line generated the highest revenue?

SELECT product_line, sum(total) as highest_revenue FROM amazon_sales
GROUP BY product_line
ORDER BY sum(total)
DESC LIMIT 1;

-- 9. In which city was the highest revenue recorded?
               -- SELECT * FROM amazon_sales;
SELECT city, sum(total) FROM amazon_sales 
GROUP BY city
ORDER BY sum(total)
DESC LIMIT 1;

-- 10. Which product line incurred the highest Value Added Tax?

SELECT product_line,sum(VAT) FROM amazon_sales
GROUP BY product_line
ORDER BY sum(VAT)
DESC LIMIT 1;

-- 11. For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."

SELECT product_line,
CASE                                                          -- SELECT * FROM amazon_sales;
WHEN sum(total) > (SELECT avg(total) FROM amazon_sales) THEN 'Good'
ELSE 'Bad'
END as Sales_status , sum(total) as Total_Revenue
FROM amazon_sales
GROUP BY product_line;

-- 12. Identify the branch that exceeded the average number of products sold.

SELECT branch, sum(cogs) FROM amazon_sales
GROUP BY branch
having sum(cogs) > (SELECT avg(cogs) FROM amazon_sales);

-- 13. Which product line is most frequently associated with each gender?

SELECT product_line, gender, count(gender) as gender_count FROM amazon_sales
GROUP BY product_line, gender
ORDER BY product_line, gender_count DESC;

-- 14. Calculate the average rating for each product line.     -- SELECT * FROM amazon_sales;

SELECT product_line, avg(rating) FROM amazon_sales
GROUP BY product_line;

-- 15. Count the sales occurrences for each time of day on every weekday.

SELECT day_name, time_of_day, count(*) as sales_occurrences FROM amazon_sales WHERE day_name NOT IN ("Sat", "Sun") 
GROUP BY day_name, time_of_day
ORDER BY day_name, sales_occurrences;

-- 16. Identify the customer type contributing the highest revenue.       -- SELECT * FROM amazon_sales;

SELECT customer_type, sum(total) FROM amazon_sales
GROUP BY customer_type
ORDER BY sum(total) DESC LIMIT 1 ;

-- 17. Determine the city with the highest VAT percentage.

SELECT city, avg(VAT) as highest_VAT, sum(VAT) FROM amazon_sales
GROUP BY city
ORDER BY Highest_VAT DESC;

-- 18. Identify the customer type with the highest VAT payments.        -- SELECT * FROM amazon_sales;

SELECT customer_type, sum(VAT) as highest_VAT_Pay FROM amazon_Sales
GROUP BY customer_type
ORDER BY highest_VAT_Pay DESC LIMIT 1;

-- 19. What is the count of distinct customer types in the dataset?

SELECT count(DISTINCT(customer_type)) as Distinct_customer_type FROM amazon_sales;

-- 20. What is the count of distinct payment methods in the dataset?

SELECT count(DISTINCT(payment_method)) FROM amazon_sales;

-- 21. Which customer type occurs most frequently?                        -- SELECT * FROM amazon_sales;

SELECT customer_type, count(customer_type) as Customer_Frequency FROM amazon_sales
GROUP BY customer_type
ORDER BY Customer_Frequency DESC Limit 1;

-- 22. Identify the customer type with the highest purchase frequency.

SELECT customer_type, count(invoice_id) as order_frequency, sum(quantity) as order_quantity FROM amazon_sales
GROUP BY customer_type
ORDER BY order_frequency
DESC LIMIT 1;

-- 23. Determine the predominant gender among customers.         -- SELECT * FROM amazon_sales;

SELECT gender, count(invoice_id) as order_frequency, sum(total) as order_revenue FROM amazon_sales
GROUP BY gender
ORDER BY order_frequency
DESC;                                 -- In terms of order frequency both the genders are almost equal but in terms of revenue female contribute more.

-- 24. Examine the distribution of genders within each branch.                 -- SELECT * FROM amazon_sales;

SELECT branch, gender, count(gender) as Gender_count FROM amazon_sales
GROUP BY branch, gender
ORDER BY branch;

-- 25. Identify the time of day when customers provide the most ratings.         -- SELECT * FROM amazon_sales;

SELECT time_of_day, count(rating) as Customers_rating FROM amazon_sales
GROUP BY time_of_day
ORDER BY Customers_rating
DESC LIMIT 1;

-- 26. Determine the time of day with the highest customer ratings for each branch.

SELECT branch, time_of_day, count(rating) as customer_ratings FROM amazon_sales
GROUP BY branch, time_of_day
ORDER BY customer_ratings
DESC;

-- 27. Identify the day of the week with the highest average ratings            -- SELECT * FROM amazon_sales;

SELECT day_name, avg(rating) as avg_ratings FROM amazon_sales
GROUP BY day_name
ORDER BY avg_ratings
DESC;

-- 28. Determine the day of the week with the highest average ratings for each branch.

SELECT day_name, branch, avg(rating) as avg_ratings FROM amazon_sales
GROUP BY day_name, branch
ORDER BY avg_ratings
DESC;






























