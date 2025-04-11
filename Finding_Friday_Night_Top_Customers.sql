-- #Write a SQL query using the DVD rental database to find the top 50 customers who rented movies on Friday between 6 pm and midnight (i.e. 18:00 to 23:59). 
-- For each customer, the query should return their id, full name, the total number of rentals they made on a Friday evening, and a comma-separated list of the dates (including the time) of those rentals, sorted in descending order.

-- Schema:

-- customer table:
-- Column       | Type     | Modifiers
-- ------------ +----------+----------
-- customer_id  | integer  | not null
-- first_name   | varchar  | not null
-- last_name    | varchar  | not null

-- rental table:
-- Column       | Type      | Modifiers
-- -------------+-----------+----------
-- rental_id    | integer   | not null
-- customer_id  | integer   | not null
-- rental_date  | timestamp | not null
-- return_date  | timestamp | 

-- Desired Output
-- customer_id  | customer_name | friday_rentals | rental_dates
-- -------------+---------------+----------------+----------------------------------------------
--    32        | Marcia Dean   | 14             | 2005-08-19 21:12:37, 2005-07-08 19:13:50  ...
--    14        | Hosea Jacobi  | 10             | 2005-08-19 21:31:31, 2005-07-29 19:18:57 ... 

-- My solution

SELECT
  r.customer_id,
  count(r.rental_date) as friday_rentals,
  CONCAT_WS(' ', c.first_name, c.last_name) as customer_name,
  STRING_AGG(TO_CHAR(r.rental_date, 'YYYY-MM-DD HH24:MI:SS'), ', ' ORDER BY r.rental_date DESC) as rental_dates
FROM rental r
LEFT JOIN customer c
ON r.customer_id = c.customer_id
WHERE EXTRACT(DOW FROM r.rental_date) = 5 AND EXTRACT(HOUR FROM r.rental_date) >= 18
GROUP BY r.customer_id, CONCAT_WS(' ', c.first_name, c.last_name), c.last_name
ORDER BY friday_rentals DESC, c.last_name
LIMIT 50
