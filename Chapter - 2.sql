-- Dvdrental Database

-- 1) The management is running a promotion to reward the top 5 customers with coupons. 
-- What are the “customer_id” of the top 5 customers by total spend in the “payment” table?

SELECT
    customer_id,
    SUM(amount) AS total_spend
FROM payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 5;

-- The top 5 customers by total spend are 148, 526, 178, 137, and 144.

-- 2) Write an SQL query to determine the maximum payment for each customer from the “payment” table. 
-- The “customer_id” should be between 100 and 119. Return “customer_id” and maximum amount.

SELECT
    customer_id,
    MAX(amount) AS highest_amount
FROM payment
WHERE customer_id BETWEEN 100 AND 119
GROUP BY customer_id;

-- 3) Write a query to get the average replacement cost for each film rating from the “film” table, 
-- considering only films with a “rental_rate” greater than or equal to $4.99. 
-- Display the results with the highest average replacement cost at the top.

SELECT
    rating AS film_rating,
    AVG(replacement_cost) AS average_replacement_cost
FROM film
WHERE rental_rate >= 4.99
GROUP BY rating
ORDER BY average_replacement_cost DESC;

-- 4) Write a query to determine the maximum payment for 5 customers with customer_ids (314, 12, 123, 234, 456) 
-- from the “payment” table. Return “customer_id” and the maximum amount.

SELECT
    customer_id,
    MAX(amount) AS highest_payment
FROM payment
WHERE customer_id IN (314, 12, 123, 234, 456)
GROUP BY customer_id;

-- Northwind Database

-- 5) Write a query to find the distinct city names from the “ship_city” column in the “orders” table, 
-- along with the number of orders placed for each city, and return the top three cities with the highest number of orders.

SELECT
    DISTINCT ship_city AS shipped_to_cities,
    COUNT(*) AS no_of_orders
FROM orders
GROUP BY ship_city
ORDER BY no_of_orders DESC
LIMIT 3;

-- 6) The “orders” table has a column called “ship_via”, which stores company IDs (encoded as numerical digits). 
-- Write a query that uses the “ship_via” column to find which shipping company has the greatest number of orders. 
-- Then, manually look up the corresponding company name from the “shippers” table. 
-- Report the number of orders and company name.
-- Hint: First, find the “ship_via” value with the most orders, and then refer to the “shippers” table to match the “ship_via” ID with its company name.

SELECT
    COUNT(*) AS no_of_orders,
    ship_via AS shipping_company
FROM orders
GROUP BY ship_via
ORDER BY no_of_orders DESC
LIMIT 1;

-- The company with the most orders is Speedy Express with number of orders 24.

-- 7) List the categories (category_id) that have more than 3 products in the “products” table. 
-- Only include products with a unit price between $10 and $30. 
-- Then, refer to the “categories” table to match the category_id with category name and report the names of these categories.

SELECT
    category_id,
    COUNT(*) AS number_of_products
FROM products
WHERE unit_price BETWEEN 10 AND 30
GROUP BY category_id
HAVING COUNT(*) > 3;

-- The categories that have more than 3 products are Seafood, Beverages, Condiments, and Confections.