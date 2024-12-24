-- Query 1: Select the third-highest total amount from trips in September
SELECT *
FROM trips_sep
ORDER BY total_amount DESC OFFSET 2
LIMIT 1;

-- Query 2: Calculate rate per mile for trips in October and select the highest rate
SELECT *,
       total_amount / trip_distance AS rate_per_mile 
FROM trips_oct
WHERE trip_distance != 0 
ORDER BY rate_per_mile DESC
LIMIT 1;

-- Query 3: Select the highest tip amount from trips in September
SELECT *
FROM trips_sep
ORDER BY tip_amount DESC LIMIT 1;

-- Query 4: Calculate trip duration for trips in September
SELECT *,
       (lpep_dropoff_datetime - lpep_pickup_datetime) AS trip_duration 
FROM trips_sep
ORDER BY trip_duration DESC;

-- Query 5: Average tip amount grouped by hour of dropoff time for September trips
SELECT AVG(tip_amount),
       EXTRACT(HOUR FROM lpep_dropoff_datetime) as hour 
FROM trips_sep
GROUP BY EXTRACT(HOUR FROM lpep_dropoff_datetime) 
ORDER BY hour;

-- Query 6: Count trips by day of the week for October trips
SELECT COUNT(*) AS no_of_trips, 
       TO_CHAR(lpep_pickup_datetime, 'Day') AS day_of_week 
FROM trips_oct
GROUP BY TO_CHAR(lpep_pickup_datetime, 'Day');

-- Query 7: Average total amount grouped by hour for October trips
SELECT AVG(total_amount), 
       EXTRACT(HOUR FROM lpep_pickup_datetime) 
FROM trips_oct
GROUP BY EXTRACT(HOUR FROM lpep_pickup_datetime) 
ORDER BY EXTRACT(HOUR FROM lpep_pickup_datetime);

-- Query 8: Count trips by rate identifier for trips in September
SELECT COUNT(*), 
       CASE
           WHEN ratecodeid = 1 THEN 'Standard Rate' 
           WHEN ratecodeid = 2 THEN 'JFK'
           WHEN ratecodeid = 3 THEN 'Newark'
           WHEN ratecodeid = 4 THEN 'Nassau or Westchester' 
           WHEN ratecodeid = 5 THEN 'Negotiated Fare' 
           WHEN ratecodeid = 6 THEN 'Group ride'
       END AS rate_identifier 
FROM trips_sep
GROUP BY rate_identifier;

-- Query 9: Count trips for each driver by total amount range in September trips
WITH cte_1 AS (
    SELECT driver_id,
           CASE
               WHEN total_amount >= 0 AND total_amount < 10 THEN '0-9' 
               WHEN total_amount >= 10 AND total_amount < 20 THEN '10-19' 
               WHEN total_amount >= 20 AND total_amount < 30 THEN '20-29' 
               WHEN total_amount >= 30 AND total_amount < 40 THEN '30-39' 
               ELSE '40+'
           END AS total_amount_range 
    FROM trips_sep
)
SELECT driver_id, total_amount_range,
       COUNT(*) OVER (PARTITION BY driver_id, total_amount_range) AS trip_count 
FROM cte_1
GROUP BY driver_id, total_amount_range;

-- Query 10: Select top 3 trips by highest total amount for each driver in October
WITH cte_1 AS (
    SELECT driver_id, total_amount,
           RANK() OVER(PARTITION BY driver_id ORDER BY total_amount DESC) AS rnk 
    FROM trips_oct
)
SELECT driver_id, total_amount, rnk
FROM cte_1
WHERE rnk IN(1, 2, 3);

-- Query 11: Select the first 10 trips by lowest total amount for driver 1 in October
WITH cte_1 AS (
    SELECT driver_id, total_amount,
           ROW_NUMBER() OVER(PARTITION BY driver_id ORDER BY total_amount ASC) AS rnk 
    FROM trips_oct
)
SELECT driver_id, total_amount, rnk
FROM cte_1
WHERE (rnk BETWEEN 1 AND 10)
  AND driver_id = 1;

-- Query 12: Cumulative sum of total amount for driver 1 in October
SELECT driver_id, trip_id,
       SUM(total_amount) OVER (PARTITION BY driver_id ORDER BY lpep_pickup_datetime
       ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM trips_oct 
WHERE driver_id = 1;

-- Query 13: Find drivers in October who are not in September
SELECT DISTINCT driver_id 
FROM trips_oct
WHERE driver_id NOT IN (SELECT DISTINCT driver_id FROM trips_sep);

-- Query 14: Compare total revenue between September and October
WITH CTE_1 AS (
    SELECT SUM(total_amount) AS total_amount_sept
    FROM trips_sep
),
CTE_2 AS (
    SELECT SUM(total_amount) AS total_amount_oct
    FROM trips_oct
)
SELECT total_amount_sept, total_amount_oct,
       ROUND((total_amount_oct - total_amount_sept)::NUMERIC, 2) AS difference 
FROM CTE_1, CTE_2;

-- Query 15: Compare total revenue by driver between September and October
WITH cte_1 AS (
    SELECT SUM(total_amount) AS total_amount_sept, driver_id 
    FROM trips_sep
    GROUP BY driver_id
),
cte_2 AS (
    SELECT SUM(total_amount) AS total_amount_oct, driver_id 
    FROM trips_oct
    GROUP BY driver_id
)
SELECT oct.driver_id, total_amount_oct, total_amount_sept,
       ROUND((total_amount_oct - COALESCE(total_amount_sept, 0))::NUMERIC, 2) AS difference 
FROM cte_1 AS SEPT
FULL JOIN cte_2 AS OCT
ON OCT.driver_id = SEPT.driver_id 
ORDER BY OCT.driver_id;

-- Query 16: Compare total revenue by day of the week between September and October
WITH cte_1 AS (
    SELECT TO_CHAR(lpep_pickup_datetime, 'Day') AS day_of_week, 
           SUM(total_amount) AS total_revenue_sept
    FROM trips_sep
    GROUP BY TO_CHAR(lpep_pickup_datetime, 'Day')
),
cte_2 AS (
    SELECT TO_CHAR(lpep_pickup_datetime, 'Day') AS day_of_week, 
           SUM(total_amount) AS total_revenue_oct
    FROM trips_oct
    GROUP BY TO_CHAR(lpep_pickup_datetime, 'Day')
)
SELECT cte_1.day_of_week, total_revenue_sept, total_revenue_oct,
       total_revenue_oct - total_revenue_sept AS total_change_in_revenue 
FROM cte_1
INNER JOIN cte_2
ON cte_1.day_of_week = cte_2.day_of_week 
ORDER BY total_revenue_oct DESC;