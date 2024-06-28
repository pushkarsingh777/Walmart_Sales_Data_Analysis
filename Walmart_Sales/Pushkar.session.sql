-- TO REMOVE SAFE MODE
SET SQL_SAFE_UPDATES = 0;

-- CREATING DATABASE
CREATE DATABASE walmart_sales;

-- SELECTING DATABASE
USE walmart_sales;

-- CREATING TABLE
CREATE TABLE sales(
      invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
      branch VARCHAR(5) NOT NULL,
      city VARCHAR(30) NOT NULL,
      customer_type VARCHAR(30) NOT NULL,
      gender VARCHAR(10) NOT NULL,
      product_line VARCHAR(100) NOT NULL,
      unit_price DECIMAL(10,2) NOT NULL,
      quantity INT NOT NULL,
      VAT FLOAT(6,4) NOT NULL,
      total DECIMAL(10,2) NOT NULL,
      date DATETIME NOT NULL,
      time TIME NOT NULL,
      payment_method VARCHAR(15) NOT NULL,
      cogs DECIMAL(10,2) NOT NULL,
      gross_margin_pct FLOAT(11,9),
      gross_income DECIMAL(12,4) NOT NULL,
      rating FLOAT(2,1)
);

-- CLEANING DATA
SELECT * FROM sales; 

-- ADDING time_of_day(Morning, Afternoon, Evening)
SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;               

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(30);

UPDATE sales
SET time_of_day = (
    CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
    );
 
--  ADDING day_name(Mon,Tue,Wed,Thu,Fri,Sat,Sun)
SELECT date, dayname(date)
FROM sales;    

ALTER TABLE sales 
ADD COLUMN day_name VARCHAR(30);

UPDATE sales
SET day_name = (dayname(date));

-- ADDING month_name(Jan,Feb,Mar,Apr,May,June,July,Aug,Sept,Oct,Nov,Dec)
SELECT date , monthname(date)
FROM sales;

ALTER TABLE sales 
ADD COLUMN month_name VARCHAR(30);

UPDATE sales
SET month_name = (monthname(date));

-- SELECTING CITY & THEIR BRANCHES
SELECT DISTINCT city, branch FROM sales;

-- COUNTING product_line & payment_method 
SELECT product_line 
FROM sales;

SELECT DISTINCT product_line 
FROM sales;

SELECT product_line, COUNT(product_line) AS pro_count 
FROM sales 
GROUP BY product_line 
ORDER BY pro_count DESC;


SELECT payment_method 
FROM sales;

SELECT DISTINCT payment_method 
FROM sales; 

SELECT payment_method, COUNT(payment_method) AS pay_count 
FROM sales 
GROUP BY payment_method 
ORDER BY pay_count DESC;
 
--  FINDING TOTAL REVENUE IN EACH MONTH
SELECT month_name 
FROM sales; 

SELECT DISTINCT month_name 
FROM sales;

SELECT month_name AS month, SUM(total) AS total_revenue 
FROM sales 
GROUP BY month_name 
ORDER BY total_revenue DESC;

-- LARGEST TOTAL cogs MONTH
SELECT month_name,cogs
FROM sales;

SELECT month_name AS month, SUM(cogs) AS largest_cogs 
FROM sales 
GROUP BY month_name 
ORDER BY largest_cogs DESC;

-- LARGEST TOTAL product_line MONTH
SELECT product_line 
FROM sales;

SELECT DISTINCT product_line 
FROM sales;

SELECT product_line AS product, SUM(total) AS largest_revenue 
FROM sales 
GROUP BY product_line 
ORDER BY largest_revenue DESC;

-- FINDING THE LARGEST REVENUE OF CITY & BRANCH
SELECT city 
FROM sales;

SELECT DISTINCT city
FROM sales;

SELECT city,branch , SUM(total) AS total_revenue 
FROM sales 
GROUP BY city,branch 
ORDER BY total_revenue DESC;

-- FINDING THE LARGEST VAT OF PRODUCT LINE
SELECT product_line, VAT 
FROM sales;

SELECT product_line , AVG(VAT) 
FROM sales 
GROUP BY product_line 
ORDER BY AVG(VAT) DESC;

-- FETCHING EACH PRODUCT LINE AND COMPARING ITS TOTAL SALES TO THE AVERAGE AND LABEL IT AS 'GOOD' OR 'BAD'
SELECT AVG(quantity) AS avg_sales 
FROM sales;

SELECT product_line, quantity, 
       CASE 
           WHEN quantity > (SELECT AVG(quantity) FROM sales) THEN 'Good'
           ELSE 'Bad'
       END AS performance
FROM sales;

-- BRANCH SOLD MORE PRODUCTS THAN AVERAGE PRODUCT SOLD
SELECT branch, SUM(quantity) AS quantity 
FROM sales 
GROUP BY branch 
HAVING SUM(quantity) > AVG(quantity) 
ORDER BY quantity DESC;

-- MOST COMMON product_line BY THE gender 
SELECT gender, product_line, COUNT(gender) AS male_female
FROM sales GROUP BY gender, product_line;

-- FINDING THE AVERAGE RATING OF ALL THE PRODUCTS
SELECT AVG(rating) AS avg_rating, product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- NUMBER OF SALES MADE IN EACH TIME OF THE DAY PER WEEKDAY
SELECT time_of_day, COUNT(*) AS total_sales 
FROM sales 
WHERE day_name = "Sunday"  
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- MOST REVENUE CUSTOMER TYPE
SELECT customer_type, SUM(total) AS max_revenue 
FROM sales 
GROUP BY customer_type 
ORDER BY max_revenue DESC;

-- LARGEST VAT CITY
SELECT city, AVG(VAT) AS max_tax 
FROM sales 
GROUP BY city 
ORDER BY max_tax DESC;

-- MOST TAX PAYER CUSTOMER TYPE
SELECT customer_type, AVG(VAT) AS VAT 
FROM sales
GROUP BY customer_type
ORDER BY VAT DESC;

-- UNIQUE CUSTOMER TYPES
SELECT DISTINCT customer_type
FROM sales;

-- UNIQUE PAYMENT METHOD
SELECT DISTINCT payment_method
FROM sales;

-- MOST COMMON CUSTOMER TYPE
SELECT customer_type, COUNT(customer_type) AS cust_cnt
FROM sales
GROUP BY customer_type
ORDER BY cust_cnt DESC;

-- MOST CUSTOMER TYPE BUYERS
SELECT customer_type, COUNT(*) AS qty_cnt
FROM sales
GROUP BY customer_type
ORDER BY qty_cnt DESC; 

-- FINDING THE GENDER OF MOST BUYERS OF THE CUSTOMER
SELECT gender, COUNT(*) AS most_buyers 
FROM sales
GROUP BY gender 
ORDER BY most_buyers DESC;

-- GENDER DISTRIBUTION PER BRANCH
SELECT gender, COUNT(*) AS gender_cnt 
FROM sales
WHERE branch = "B" 
GROUP BY gender
ORDER BY gender_cnt DESC;

-- FINDING WHICH TIME OF THE DAY DO CUSTOMER GIVE MOST RATING
SELECT time_of_day, AVG(rating) AS avg_rating_cnt
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating_cnt DESC;

-- FINDING WHICH DAY OF THE WEEK HAS THE BEST AVERAGE RATING
SELECT day_name, AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;

-- FINDING WHICH DAY OF THE WEEK HAS THE BEST AVERAGE RATINGS PER BRANCH
SELECT day_name, AVG(rating) AS avg_rating
FROM sales
WHERE branch = "B"
GROUP BY day_name
ORDER BY avg_rating DESC;