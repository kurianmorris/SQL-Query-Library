-- 1) Orders shipped after the required delivery date
SELECT
    order_id, 
    o.customer_id,
    first_name AS employee_first_name, 
    last_name AS employee_last_name
FROM orders AS O
INNER JOIN customers AS C
    ON O.customer_id = C.customer_id
INNER JOIN employees AS E
    ON O.employee_id = E.employee_id
WHERE required_date < shipped_date
ORDER BY order_id DESC;

-- 2) Categories with the most high-priced products
SELECT
    category_name,
    COUNT(*) AS count_of_products
FROM products AS P
INNER JOIN categories AS C 
    ON P.category_id = C.category_id
WHERE unit_price > 15
GROUP BY category_name
ORDER BY COUNT(*) DESC;

-- 3) Suppliers providing products in the 'Seafood' category
SELECT
    company_name AS supplier, 
    contact_name AS point_of_contact
FROM suppliers AS S
INNER JOIN products AS P
    ON S.supplier_id = P.supplier_id
INNER JOIN categories AS C 
    ON P.category_id = C.category_id
WHERE category_name = 'Seafood';

-- 4) Number of distinct actors in NC-17 films
SELECT
    COUNT(DISTINCT A.actor_id) AS no_of_actors_in_NC_17_films
FROM actor AS A
INNER JOIN film_actor AS FA 
    ON A.actor_id = FA.actor_id
INNER JOIN film AS F
    ON FA.film_id = F.film_id
WHERE rating = 'NC-17';

-- 5) Top 5 customers with the highest number of rentals
SELECT
    R.customer_id, 
    email
FROM rental AS R
INNER JOIN customer AS C
    ON R.customer_id = C.customer_id
GROUP BY R.customer_id, email
ORDER BY COUNT(*) DESC
LIMIT 5;

-- 6) Average film length and number of films by category
SELECT
    name AS category_name, 
    AVG(length) AS average_length,
    COUNT(*) AS number_of_films
FROM film AS F
INNER JOIN film_category AS FC 
    ON F.film_id = FC.film_id
INNER JOIN category AS C
    ON FC.category_id = C.category_id
GROUP BY name
ORDER BY name;

-- 7) Top 5 actors with the maximum number of movies
SELECT
    FA.actor_id, 
    COUNT(*) AS movie_count
FROM film_actor AS FA
INNER JOIN actor AS A
    ON A.actor_id = FA.actor_id
GROUP BY FA.actor_id
ORDER BY COUNT(*) DESC
LIMIT 5;

-- 8) Employees and their managers (self-join)
SELECT
    E1.employee_id,
    E1.first_name AS employee_first_name, 
    E2.first_name AS manager_first_name
FROM employees AS E1
LEFT JOIN employees AS E2
    ON E1.reports_to = E2.employee_id;

-- 9) Most rented film categories
SELECT
    name AS category
FROM category AS C
INNER JOIN film_category AS FC 
    ON C.category_id = FC.category_id
INNER JOIN film AS F
    ON FC.film_id = F.film_id
INNER JOIN inventory AS I 
    ON F.film_id = I.film_id
INNER JOIN rental AS R
    ON I.inventory_id = R.inventory_id
GROUP BY name
ORDER BY COUNT(*) DESC;

-- 10) Unique film titles starting with 'A' and rented
SELECT DISTINCT
    title
FROM film AS F
INNER JOIN inventory AS I 
    ON F.film_id = I.film_id
INNER JOIN rental AS R
    ON I.inventory_id = R.inventory_id
WHERE title LIKE 'A%';

-- 11) Actors sharing the same first name but different last names (self-join)
SELECT
    A1.first_name, 
    A1.last_name
FROM actor AS A1
INNER JOIN actor AS A2
    ON A2.first_name = A1.first_name
WHERE A1.actor_id <> A2.actor_id 
    AND A1.last_name <> A2.last_name
GROUP BY A1.actor_id, A1.first_name, A1.last_name
ORDER BY A1.first_name;
