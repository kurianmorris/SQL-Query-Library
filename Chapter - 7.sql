-- 1) Find employees whose salary is higher than any employee in the 'IT' or 'Accounting' department. (HR database, employees & departments tables).
-- Use ANY operator.
SELECT *
FROM employees 
WHERE salary > ANY
  (SELECT salary FROM employees 
   WHERE department_id IN 
     (SELECT department_id 
      FROM departments 
      WHERE department_name IN ('IT', 'Accounting')));

-- 2) Find employees whose salary is higher than all employees in the 'Finance' department. (HR database, employees & departments tables).
-- Use ALL operator.
SELECT *
FROM employees 
WHERE salary > ALL 
  (SELECT salary FROM employees 
   WHERE department_id IN 
     (SELECT department_id 
      FROM departments 
      WHERE department_name IN ('Finance')));

-- 3) Find the film titles that have the highest rental rate in their respective rating categories.
-- Return film_id, title, rental rate and rating columns. Make sure rating is listed in descending order. (dvdrental database, film table)
SELECT 
  film_id, title, rental_rate, rating
FROM film AS f1 
WHERE rental_rate = 
  (SELECT MAX(rental_rate) FROM film AS f2 
   WHERE f1.rating = f2.rating)
ORDER BY rating DESC;

-- 4) Create a CTE that calculates the total number of rentals made by each customer.
-- Then, write a query using this CTE to find customers who have rented more than 35 times. (dvdrental database, customer & rental tables)
WITH cte_1 AS
  (SELECT customer_id, COUNT(*) AS rental_count FROM rental
   GROUP BY customer_id) 
SELECT 
  C.customer_id, first_name, last_name
FROM customer AS C 
INNER JOIN cte_1 ON C.customer_id = cte_1.customer_id 
WHERE rental_count > 35;

-- 5) Find all categories that have at least one product with a unit price greater than $80. (northwind database, categories & products tables)
SELECT *
FROM categories c 
WHERE EXISTS 
  (SELECT 1 
   FROM products p 
   WHERE p.category_id = c.category_id AND p.unit_price > 80);

-- 6) Write a SQL code that shows all the payments together with how much the payment amount is below the maximum payment amount. (dvdrental database, payment table)
SELECT *,
  ((SELECT MAX(amount) FROM payment) - amount) AS difference 
FROM payment;

-- 7) Find the number of films in “R”, “PG”, “PG-13” rating categories by using CASE-WHEN statement. (dvdrental database, film table).
-- Don’t use COUNT function.
SELECT 
  SUM(CASE WHEN rating = 'R' THEN 1 ELSE 0 END) AS R, 
  SUM(CASE WHEN rating = 'PG' THEN 1 ELSE 0 END) AS PG, 
  SUM(CASE WHEN rating = 'PG-13' THEN 1 ELSE 0 END) AS PG13
FROM film;

-- 8) Calculate the average unit price of the products categorized as Cheap, Medium, and Expensive.
-- Label the products as “Cheap”, “Medium”, and “Expensive” based on their unit price according to the following conditions:
-- If the unit price is less than 10, label it as “Cheap”
-- If the unit price is between 10 and 20, label it as “Medium”
-- Otherwise, label it as “Expensive”. (northwind database, products table)
SELECT AVG(unit_price), 
  CASE
    WHEN unit_price < 10 THEN 'Cheap'
    WHEN unit_price BETWEEN 10 AND 20 THEN 'Medium' 
    ELSE 'Expensive'
  END AS price_category 
FROM products
GROUP BY price_category;

-- 9) Write a query to retrieve customer’s name (first_name + last_name) as full name, total number of payments made by each customer,
-- and their corresponding category. (dvdrental database, customer & payment tables)
-- Determine the category based on the following criteria:
-- If a customer has made less than 15 payments, label them as “Regular” customer.
-- If a customer has made between 15 and 25 payments, label them as “Frequent” customer.
-- If a customer has made more than 25 payments, label them as “Premium” customer.
WITH cte_1 AS
  (SELECT customer_id, CONCAT(first_name, ' ', last_name) as full_name FROM customer),
  cte_2 AS
  (SELECT COUNT(*) AS no_of_payments, customer_id FROM payment
   GROUP BY customer_id)
SELECT 
  full_name as "full name", 
  no_of_payments, 
  CASE
    WHEN no_of_payments < 15 THEN 'Regular'
    WHEN no_of_payments BETWEEN 15 AND 25 THEN 'Frequent' 
    WHEN no_of_payments > 25 THEN 'Premium'
  END AS customer_category 
FROM cte_1 AS customer
INNER JOIN cte_2 AS payment
ON customer.customer_id = payment.customer_id;

-- 10) Write a query to display each product's name, category, and stock status as 'Out of Stock', 'Low Stock', or 'In Stock'. 
-- (northwind database, products & categories tables)
-- Determine the stock status based on the following criteria:
-- If the number of units in stock (units_in_stock column) is 0, then Out of Stock. 
-- If the number of units in stock is less than 20, then Low Stock
-- Otherwise, In Stock
SELECT 
  product_name, 
  C.category_name, 
  CASE
    WHEN units_in_stock = 0 THEN 'Out of Stock' 
    WHEN units_in_stock < 20 THEN 'Low Stock' 
    ELSE 'In Stock'
  END AS "stock status" 
FROM products AS P
INNER JOIN categories AS C ON P.category_id = C.category_id;