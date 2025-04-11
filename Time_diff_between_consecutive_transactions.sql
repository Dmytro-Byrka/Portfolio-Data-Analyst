--  #Write a SQL query to calculate the time since the previous rental for each rental transaction made by customers with IDs 1 and 2. 
-- The result should include the rental ID, customer ID, rental date, and time since the previous rental in days, hours, and minutes.

-- Notes:
-- - The final result should be sorted by customer ID and rental date in ascending order.

-- Schema

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

-- Desired Output:
-- rental_id    | customer_id  | rental_date          | time_since_previous_rental
-- -------------+--------------+----------------------+----------------------------------------------
--    5851      | 1            | 2005-02-26 19:42:04  |  <null>
--    8399      | 1            | 2005-03-19 04:20:14  |  20 days 08:38:10

-- My solution

SELECT
  rental_id,
  customer_id,
  TO_CHAR(rental_date, 'YYYY-MM-DD HH24:MI:SS') as rental_date,
  CASE 
    WHEN LAG(customer_id, 1) OVER (ORDER BY customer_id, rental_date) = customer_id THEN 
    rental_date - LAG(rental_date, 1) OVER (ORDER BY customer_id, rental_date)
    ELSE NULL END as time_since_previous_rental
FROM rental
WHERE customer_id in (1, 2)
ORDER BY customer_id ASC, rental_date ASC