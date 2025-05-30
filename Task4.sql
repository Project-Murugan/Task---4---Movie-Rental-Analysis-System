-- Create Database and Table

-- Create the database

CREATE DATABASE MovieRental;

-- Connect to the database

USE MovieRental;

-- Create rental_data table
CREATE TABLE rental_data (
    MOVIE_ID INT,
    CUSTOMER_ID INT,
    GENRE VARCHAR(100),
    RENTAL_DATE DATE,
    RETURN_DATE DATE,
    RENTAL_FEE NUMERIC(10, 2)
);

--- Insert sample Data

INSERT INTO rental_data (MOVIE_ID, CUSTOMER_ID, GENRE, RENTAL_DATE, RETURN_DATE, RENTAL_FEE) VALUES
(1, 101, 'Action', '2024-04-01', '2024-04-05', 5.00),
(2, 102, 'Drama', '2024-04-03', '2024-04-06', 4.50),
(3, 103, 'Comedy', '2024-03-15', '2024-03-18', 3.00),
(4, 104, 'Action', '2024-02-20', '2024-02-25', 6.00),
(5, 101, 'Drama', '2024-01-30', '2024-02-03', 4.00),
(6, 105, 'Horror', '2024-04-10', '2024-04-12', 5.50),
(7, 106, 'Action', '2024-03-25', '2024-03-29', 5.00),
(8, 102, 'Comedy', '2024-04-12', '2024-04-15', 3.50),
(9, 107, 'Drama', '2024-02-05', '2024-02-10', 4.25),
(10, 108, 'Action', '2024-01-20', '2024-01-25', 6.00),
(11, 109, 'Comedy', '2024-03-01', '2024-03-05', 3.75),
(12, 110, 'Horror', '2024-02-28', '2024-03-04', 5.00),
(13, 111, 'Action', '2024-04-15', NULL, 6.00),
(14, 112, 'Drama', '2024-04-10', '2024-04-13', 4.50);

-- OLAP Operations
-- a) Drill Down: Analyze rentals from genre to individual movie level

-- Group by genre (higher level)

SELECT GENRE, COUNT(*) AS RENTAL_COUNT, SUM(RENTAL_FEE) AS TOTAL_FEES
FROM rental_data
GROUP BY GENRE
ORDER BY GENRE;

-- Drill down to individual movie

SELECT MOVIE_ID, GENRE, COUNT(*) AS RENTAL_COUNT, SUM(RENTAL_FEE) AS TOTAL_FEES
FROM rental_data
GROUP BY MOVIE_ID, GENRE
ORDER BY GENRE, MOVIE_ID;

-- Rollup: Summarize total rental fees by genre and then overall

SELECT GENRE, SUM(RENTAL_FEE) AS TOTAL_FEES
FROM rental_data
GROUP BY GENRE WITH ROLLUP;

-- Cube: Analyze total rental fees across combinations of genre, rental date (month), and customer

SELECT GENRE, DATE_FORMAT(RENTAL_DATE, '%Y-%m') AS RENTAL_MONTH, CUSTOMER_ID, SUM(RENTAL_FEE) AS TOTAL_FEES
FROM rental_data
GROUP BY GENRE, DATE_FORMAT(RENTAL_DATE, '%Y-%m'), CUSTOMER_ID
UNION ALL
SELECT GENRE, DATE_FORMAT(RENTAL_DATE, '%Y-%m') AS RENTAL_MONTH, NULL AS CUSTOMER_ID, SUM(RENTAL_FEE)
FROM rental_data
GROUP BY GENRE, DATE_FORMAT(RENTAL_DATE, '%Y-%m')
UNION ALL
SELECT GENRE, NULL AS RENTAL_MONTH, NULL AS CUSTOMER_ID, SUM(RENTAL_FEE)
FROM rental_data
GROUP BY GENRE
UNION ALL
SELECT 
  NULL AS GENRE,
  NULL AS RENTAL_MONTH,
  NULL AS CUSTOMER_ID,
  SUM(RENTAL_FEE)
FROM rental_data;

-- Slice: Extract rentals only from the ‘Action’ genre

SELECT *
FROM rental_data
WHERE GENRE = 'Action';

-- Dice: Extract rentals where GENRE = 'Action' or 'Drama' and RENTAL_DATE in last 3 months

SELECT *
FROM rental_data
WHERE GENRE IN ('Action', 'Drama')
AND RENTAL_DATE >= CURDATE() - INTERVAL 3 MONTH;




