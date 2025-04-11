-- Given a posts table that contains a created_at timestamp column. 
-- #Write a query that returns a first date of the month, a number of posts created in a given month and a month-over-month growth rate.

-- The resulting set should be ordered chronologically by date.

-- The resulting set should look similar to the following:

-- date       | count | percent_growth
-- -----------+-------+---------------
-- 2016-02-01 |   175 |           null
-- 2016-03-01 |   338 |          93.1%
-- 2016-04-01 |   345 |           2.1%
-- 2016-05-01 |   295 |         -14.5%
-- 2016-06-01 |   330 |          11.9%

-- My solution

with date_cte as (
  SELECT
    date_trunc('month', created_at) :: date as date,
    count(title) as count
  FROM posts
  GROUP BY 1
  ORDER BY 1
)
SELECT
*,
ROUND((count - LAG(count, 1) OVER (ORDER BY date)) * 100.0 / LAG(count, 1) OVER (ORDER BY date), 1) :: text || '%' as percent_growth
FROM date_cte