-- students:

-- | id  | name     | email               |
-- |-----|----------|---------------------|
-- | 1   | John     | john@example.com    |
-- | 2   | Sarah    | sarah@example.com   |
-- | 3   | Robert   | robert@example.com  |

-- courses:

-- | id  | student_id | course_name | score |
-- |-----|------------|-------------|-------|
-- | 1   | 1          | Math        | 90    |
-- | 2   | 1          | Science     | 85    |
-- | 3   | 1          | Physics     | 92    |
-- | 4   | 1          | Literature  | 80    |

-- #The university is considering expelling students who either quit their studies or are consistently performing poorly in their courses. 
-- A student who quits is defined as a student with no records in the courses table. A student who is performing poorly is defined as a student with 3 or more courses with a grade less than 60.

-- #Write a SQL query that retrieves a list of students who qualify for expulsion based on the criteria described above.

-- The query should return the following columns:

-- student_id: The ID of the student

-- name: The name of the student

-- reason: The reason for expelling the student. It should say either "quit studying" if the student has no records in the courses table, 
-- or "failed in [List of Courses]" where [List of Courses] is a comma-separated list of the courses that the student has failed. 
-- Each course in the list should be followed by the grade in parentheses. Failed courses should be sorted in ascending alphabetical order.

-- The result should be ordered by the student ID in ascending order.

with join_and_concat_cte as (
  SELECT
    s.name,
    s.email,
    s.id as student_id,
    c.course_name,
    c.score,
    CONCAT(course_name,'(',score,')') as course_concat
  FROM students s
  LEFT JOIN courses c
  ON s.id = c.student_id
  WHERE score < 60 OR course_name IS NULL
)

SELECT
  student_id,
  name,
  CONCAT('failed in ', STRING_AGG(course_concat, ', ' ORDER BY course_concat)) as reason
FROM join_and_concat_cte
WHERE student_id IN (
      SELECT 
        student_id
      FROM join_and_concat_cte
      GROUP BY student_id
      HAVING count(*) FILTER (WHERE score < 60) >= 3
    )
GROUP BY student_id, name

UNION ALL

SELECT
  student_id,
  name,
  'quit studying' as reason
FROM join_and_concat_cte
WHERE course_name IS NULL
ORDER BY student_id