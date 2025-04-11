-- #Write a query to find the top (most rented) five movie categories at each store. The result set should be sorted first by store ID, and then by number of rentals in descending order.

-- Notes:
-- Sometimes two or more categories within the store can be tied by (have the same) the number of rentals. Then a category which in alphabetical order occurs earlier gets a higher rank.
-- By top 5 is meant top five movie category at each store, not data of "top five move category across all stores" for each store.

-- Schema
-- store table:
-- Column           | Type          | Modifiers
-- -----------------+---------------+----------
-- store_id         | smallint      | not null
-- inventory table:
-- Column       | Type      | Modifiers
-- ------------ +-----------+----------
-- inventory_id | integer   | not null
-- film_id      | smallint  | not null
-- store_id     | smallint  | not null
-- rental table:
-- Column | Type | Modifiers
-- --------------+---------------+----------
-- rental_id    | integer   | not null
-- rental_date  | timestamp | not null
-- inventory_id | integer   | not null
-- film_category table:
-- Column      | Type      | Modifiers
-- ------------+---------- +----------
-- film_id     | smallint  | not null
-- category_id | smallint  | not null
-- category table:
-- Column      | Type      | Modifiers
-- ------------+-----------+----------
-- category_id | smallint  | not null
-- name        | text      | not null

-- Desired Output

-- store_id    | category  | num_rentals
-- ------------+-----------+----------
-- 1           | Sports    | 745
-- 1           | Drama     | 699 

-- My solution

with joins_cte as (
  SELECT
  i.store_id,
  cat.name as category,
  count(r.rental_id) as num_rentals
  FROM rental r
  INNER JOIN inventory i
  ON r.inventory_id = i.inventory_id
  INNER JOIN film_category fc
  ON i.film_id = fc.film_id
  INNER JOIN category cat
  ON fc.category_id = cat.category_id
  GROUP BY store_id, name
  ORDER BY store_id, num_rentals DESC
)
,
ranking_cte as (
  SELECT
    store_id,
    category,
    num_rentals,
    RANK() OVER (PARTITION BY store_id ORDER BY num_rentals DESC, category) as rank
  FROM joins_cte
)
SELECT
  store_id,
  category,
  num_rentals
FROM ranking_cte
WHERE rank <= 5
