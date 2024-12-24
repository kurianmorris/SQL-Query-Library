-- 1) Create the "movies" database
CREATE DATABASE movies;

-- 2) Create the "actors" table
CREATE TABLE actors (
    actor_id SERIAL PRIMARY KEY,
    first_name VARCHAR(150),
    last_name VARCHAR(150) NOT NULL,
    gender CHAR(1),
    date_of_birth DATE,
    add_date DATE,
    update_date DATE
);

-- 3) Create the "directors" table
CREATE TABLE directors (
    director_id SERIAL PRIMARY KEY,
    first_name VARCHAR(150),
    last_name VARCHAR(150),
    nationality VARCHAR(20),
    date_of_birth DATE,
    add_date DATE,
    update_date DATE
);

-- 4) Create the "movies" table
CREATE TABLE movies (
    movie_id SERIAL PRIMARY KEY,
    movie_name VARCHAR(150) NOT NULL,
    movie_length INTEGER,
    movie_lang VARCHAR(20),
    age_certificate VARCHAR(10),
    release_date DATE,
    director_id INTEGER,
    FOREIGN KEY (director_id) REFERENCES directors(director_id)
);

-- 5) Create the "movies_revenues" table
CREATE TABLE movies_revenues (
    revenue_id SERIAL PRIMARY KEY,
    movie_id INTEGER,
    revenues_domestic NUMERIC(10, 2),
    revenues_international NUMERIC(10, 2),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
);

-- 6) Insert data into the "directors" table (from directors.sql file)
-- SELECT * FROM directors LIMIT 4;

-- 7) Insert data into the "actors" table (from actors.sql file)
-- SELECT * FROM actors LIMIT 4;

-- 8) Insert data into the "movies" table (from movies.sql file)
-- SELECT * FROM movies LIMIT 4;

-- 9) Insert data into the "movies_revenues" table (from movies_revenues.sql file)
-- SELECT * FROM movies_revenues LIMIT 4;

-- 10) Create the "movies_total" table using INNER JOIN
CREATE TABLE movies_total AS
SELECT
    M.movie_id,
    movie_name,
    movie_lang,
    release_date,
    revenues_domestic,
    revenues_international
FROM movies AS M
INNER JOIN movies_revenues AS MR ON M.movie_id = MR.movie_id;

-- 11) Find the total domestic revenue for movies in English
SELECT
    SUM(revenues_domestic) AS total_domestic_revenue_for_english_movies
FROM movies_total
WHERE movie_lang = 'English';

-- 12) Replace NULL values in the revenues_domestic column with 30
UPDATE movies_total
SET revenues_domestic = 30
WHERE revenues_domestic IS NULL;

-- 13) Add a NOT NULL constraint to the revenues_domestic column
ALTER TABLE movies_total
ALTER COLUMN revenues_domestic SET NOT NULL;

-- 14) Add a DEFAULT value of 50 for revenues_international column
ALTER TABLE movies_total
ALTER COLUMN revenues_international SET DEFAULT 50;

-- Insert a record to verify the DEFAULT value
INSERT INTO movies_total (movie_id, movie_name, movie_lang, release_date, revenues_domestic)
VALUES (101, 'Test Movie', 'French', '2024-01-01', 100);

-- 15) Attempt to update the director_id from 27 to 44 and explanation
UPDATE directors SET director_id = 44 WHERE director_id = 27;

-- Explanation:
-- The above query violates referential integrity because the director_id is referenced as a foreign key in the movies table.
-- To avoid this error, use the ON UPDATE CASCADE constraint when creating the movies table:

ALTER TABLE movies
ADD CONSTRAINT fk_director
FOREIGN KEY (director_id) REFERENCES directors(director_id) ON UPDATE CASCADE;