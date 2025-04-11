-- #Given film_actor and film tables from the DVD Rental sample database find all movies both Sidney Crowe (actor_id = 105) and Salma Nolte (actor_id = 122) cast in together and order the result set alphabetically.

-- Schema

-- film 
--  Column     | Type                        | Modifiers
-- ------------+-----------------------------+----------
-- title       | character varying(255)      | not null
-- film_id     | smallint                    | not null

-- film_actor
--  Column     | Type                        | Modifiers
-- ------------+-----------------------------+----------
-- actor_id    | smallint                    | not null
-- film_id     | smallint                    | not null
-- last_update | timestamp without time zone | not null

-- actor
--  Column     | Type                        | Modifiers
-- ------------+-----------------------------+----------
-- actor_id    | integer                     | not null 
-- first_name  | character varying(45)       | not null
-- last_name   | character varying(45)       | not null
-- last_update | timestamp without time zone | not null

-- My solution

with actor_selection as (
  SELECT
    *
  FROM film_actor f1
  WHERE f1.actor_id in (105, 122) 
  ORDER BY film_id asc
)
,
film_casted_together as (
  SELECT
    distinct a1.film_id
  FROM actor_selection a1
  INNER JOIN actor_selection a2
  ON a1.film_id = a2.film_id
  WHERE a1.actor_id != a2.actor_id
)
SELECT
f.title
FROM film_casted_together fct
LEFT JOIN film f
ON fct.film_id = f.film_id