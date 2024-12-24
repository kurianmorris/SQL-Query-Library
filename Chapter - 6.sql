-- 1) Assume that there was a problem in the email system with names where either the first name or the last name is more than 10 characters long.
-- Now, the management would like you to find these customers and output the list of these first, last names, and email in all lower case? (dvdrental database, customer table)
SELECT LOWER(first_name), LOWER(last_name), LOWER(email) 
FROM customer
WHERE LENGTH(first_name) > 10 OR LENGTH(last_name) > 10;

-- 2) Create an anonymized version of the email addresses, such as instead of ‘MARY.SMITH@sakilacustomer.org’, it should look like ‘M***@sakilacustomer.org’.
-- So, it should be the first character followed by three asterisks ‘***’ and then the last part starting with ‘@’.
-- Please note that the email address always ends with ‘@sakilacustomer.org’. (dvdrental database, customer table)
SELECT CONCAT(SUBSTRING(email, 1, 1), '***@sakilacustomer.org') AS anonymized_email 
FROM customer;

-- 3) Assume that you have only the ‘email’ and ‘last_name’ of the customers. So, you are allowed to use only these two columns from the table.
-- Now, extract the first name from the email address and concatenate it with the last name. 
-- And it should be in the form: “Last name, First name” with the first letters are capitalized. 
-- For example, given the columns email (e.g., "jared.ely@sakilacustomer.org") and last_name (e.g., "Ely"), write a query to extract the first name from the email address and format the output as "Ely, Jared". 
-- (dvdrental database, customer table).
SELECT CONCAT(INITCAP(last_name), ', ', INITCAP(SPLIT_PART(email, '.', 1))) AS formatted_name 
FROM customer;

-- 4) Create an anonymized form of the email addresses in the following way, ‘M***.S***@sakilacustomer.org’. 
-- (instead of MARY.SMITH@sakilacustomer.org). (dvdrental database, customer table)
SELECT CONCAT(
  UPPER(SUBSTRING(SPLIT_PART(email, '.', 1), 1, 1)), '***.',
  UPPER(SUBSTRING(SPLIT_PART(email, '.', 2), 1, 1)), '***@sakilacustomer.org'
) AS anonymized_email 
FROM customer;

-- 5) Write a query to return the initials of each customer’s name from the first_name and last_name columns of the customer table. 
-- For example, "John Smith" should return "J.S." (dvdrental database, customer table)
SELECT CONCAT(
  SUBSTRING(first_name, 1, 1), '.', SUBSTRING(last_name, 1, 1), '.'
) 
FROM customer;

-- 6) In the northwind database, from the customers table, retrieve the customer_id and area code (first three characters) from the phone column for each customer. 
-- (northwind database, customers table)
SELECT
  customer_id,
  SUBSTRING(phone, 1, 3) AS area_code 
FROM customers;

-- 7) Using the dvdrental database, assume customer emails follow the format first_name_last_name@dvdrental.com. 
-- Write a query to retrieve the following output: (dvdrental database, customer table)
SELECT
  CONCAT(first_name, '_', last_name, '@dvdrental.com') AS email 
FROM customer;

-- 8) Retrieve the first three characters of both the product_name and category_name, aliasing them as product_prefix and category_prefix. 
-- (northwind database, products & categories table)
SELECT
  SUBSTRING(product_name, 1, 3) AS product_prefix,
  SUBSTRING(category_name, 1, 3) AS category_prefix 
FROM products AS P
INNER JOIN categories AS C
ON P.category_id = C.category_id;