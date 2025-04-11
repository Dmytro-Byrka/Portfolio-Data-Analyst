-- Description:
    -- Business sells only three unique products: "Product 1," "Product 2," and "Product 3."

    -- Schema:

    -- customers:

    -- customer_id (integer) - primary key
    -- name (varchar) - Name of the customer.
    -- orders:

    -- order_id (integer) - primary key
    -- customer_id (integer) - Identifier for the customer who placed the order.
    -- product_name (varchar) - Name of the ordered product. It can only be one of the three values: "Product 1," "Product 2," or "Product 3."
    -- Write a query that returns the following columns:

    -- customer_id: The unique identifier of the customer.
    -- name: The name of the customer.
    -- product_summary: A string that describes how many times the customer has ordered "Product 1" and "Product 2," formatted as "Product 1: {N} times || Product 2: {N} times."
    -- The results should be ordered by customer_id in descending order.

-- Desired Output
/*
customer_id	name	product_summary
92	Jeri Auer	    Product 1: 25 times || Product 2: 25 times
83	Chang Sporer	Product 1: 8 times || Product 2: 8 times
82	Regan Schimmel	Product 1: 15 times || Product 2: 15 times
*/
-- # Write an SQL query to find customers who have ordered "Product 1" and "Product 2" but not "Product 3." Additionally, provide a summary of how many times they have ordered the first two products.    
-- My solution

    with prod_summ_all_cte as (
  SELECT
    concat_cte.customer_id,
    c.name,
    STRING_AGG(concat, ' || ' ORDER BY concat) as product_summary
  FROM (
      SELECT
      customer_id,
      CONCAT(product_name, ': ', count(product_name), ' times') as concat
    FROM orders
    GROUP BY customer_id, product_name
  ) as concat_cte
  LEFT JOIN customers c
  ON concat_cte.customer_id = c.customer_id
  GROUP BY concat_cte.customer_id, c.name
  ORDER BY customer_id DESC
)
SELECT
  *
FROM prod_summ_all_cte
WHERE product_summary NOT LIKE '%Product 3%' AND product_summary LIKE 'Product 1%Product 2%'

