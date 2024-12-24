-- 1) Find monthly order totals in 1997. Calculate order totals as (unit_price * quantity) * (1 - discount).
SELECT
    DATE_TRUNC('month', order_date) AS month,
    SUM((unit_price * quantity) * (1 - discount)) AS monthly_order_totals
FROM orders AS O
INNER JOIN order_details AS OD ON OD.order_id = O.order_id
WHERE DATE_PART('year', order_date) = 1997
GROUP BY month
ORDER BY month;

-- 2) Find employees who have been hired more than 32 years ago.
SELECT *
FROM employees
WHERE hire_date < CURRENT_DATE - INTERVAL '32 year';

-- 3) Find the average order processing days (order processing day = shipped_date - order_date).
SELECT
    AVG(shipped_date - order_date) AS avg_processing_days
FROM orders;

-- 4) Find out the number of times movie “King Evolution” rented in each month of 2005.
SELECT
    DATE_TRUNC('month', rental_date) AS month,
    COUNT(*) AS rental_count
FROM film AS F
INNER JOIN inventory AS I ON F.film_id = I.film_id
INNER JOIN rental AS R ON I.inventory_id = R.inventory_id
WHERE title = 'King Evolution' AND DATE_PART('year', rental_date) = 2005
GROUP BY DATE_TRUNC('month', rental_date);

-- 5) Find the monthly number of orders by truncating the order date to the start of each month.
SELECT
    DATE_TRUNC('month', order_date) AS month,
    COUNT(*) AS monthly_order_count
FROM orders
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;

-- 6) Find the number of rentals on an hourly basis to understand the peak rental times.
SELECT
    DATE_PART('hour', rental_date) AS hour,
    COUNT(*) AS rental_count
FROM rental
GROUP BY DATE_PART('hour', rental_date)
ORDER BY hour;

-- 7) Retrieve the list of unique film titles that were rented more than 19 years, 1 month, and 8 days ago based on the most recent rental date.
SELECT
    title,
    MAX(rental_date) AS most_recent_rental
FROM film AS F
INNER JOIN inventory AS I ON F.film_id = I.film_id
INNER JOIN rental AS R ON I.inventory_id = R.inventory_id
GROUP BY F.film_id
HAVING MAX(rental_date) < (CURRENT_DATE - INTERVAL '19 year 1 month 8 days');

-- 8) Retrieve the number of employees hired in each year, but only include years where more than 5 employees were hired. Sort the years in descending way.
SELECT
    DATE_PART('year', hire_date) AS year,
    COUNT(*) AS hire_count
FROM employees
GROUP BY DATE_PART('year', hire_date)
HAVING COUNT(*) > 5
ORDER BY year DESC;

-- 9) Calculate the exact tenure of each employee (in years and months) since their hire date and display the result along with employee_id, first_name, last_name, and department names.
SELECT
    employee_id,
    first_name,
    last_name,
    department_name,
    AGE(CURRENT_DATE, hire_date) AS tenure
FROM employees AS E
INNER JOIN departments AS D ON E.department_id = D.department_id;

-- 10) Display each employee’s hire date as shown below in the formatted_hire_date column, along with how many years they’ve been with the company, employee_id, first_name, and last_name.
SELECT
    employee_id,
    first_name,
    last_name,
    TO_CHAR(hire_date, 'Day, DD Month YYYY') AS formatted_hire_date,
    EXTRACT('year' FROM AGE(CURRENT_DATE, hire_date)) AS years_with_company
FROM employees;