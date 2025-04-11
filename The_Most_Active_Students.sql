-- As part of a yearly review, the university's administration wants to identify the most active students in the first term in the academic year 2022, which is called the "Michaelmas term". 
-- They're interested not just in the students' highest scores, but primarily in the total number of unique courses a student has taken during the term.

-- Schema

-- students:

-- | id  | name     | email               |
-- |-----|----------|---------------------|
-- | 1   | John     | john@example.com    |
-- | 2   | Sarah    | sarah@example.com   |
-- | 3   | Robert   | robert@example.com  |

-- courses:

-- | id  | student_id | course_name | score |  course_date |
-- |-----|------------|-------------|-------|--------------|
-- | 1   | 1          | Math        | 90    | 2022-10-01   |
-- | 2   | 1          | Science     | 85    | 2022-10-15   |
-- | 3   | 1          | Physics     | 92    | 2023-01-10   | 
-- | 4   | 1          | Literature  | 80    | 2023-04-05   |

-- The students table has records of the students' id, name, and email. 
-- The courses table keeps a record of each course's id, the student_id of the student who took the course, the course name, the student's score in the course, and the date when the course was completed.

-- #The output of the query should return the following columns:

-- student_id: The ID of the student.

-- name: The name of the student.

-- num_courses: The total count of unique courses that the student has taken during the term.
-- highest_scored_course: The course name and its score where the student achieved their highest score. It should be in the format "Course name (Score)". 
-- In the event of a tie (same score), choose the course with the latest date. If there's still a tie, choose the course that comes first alphabetically.

-- course_list: A string that consists of all the courses taken by the student with their respective dates and scores, separated by commas. 
-- The list of all courses should be in the format "Course name (Date - Score)", ordered by course date (from earlier to later) and then course name (in ascending order) in case of ties.

-- Order the result first by num_courses in descending order, then by the highest score in descending order, and, the the case of a tie even by the number of courses and the highest score - by student_id in ascending order.

-- Only the top 20 students based on the order criteria should be returned, consider courses completed between 1st October 2022 and 31st December 2022.

-- Desired Output:

-- student_id	name	        num_courses	 highest_scored_course	    course_list
-- 10	    Zackary Nader	        7	        Course 7 (90)	    Course 2 (2022-12-15 - 65), Course 4 (2022-12-15 - 75)...
-- 12	    Gov. Reginald Boyle	    7	        Course 7 (90)	    Course 1 (2022-12-15 - 60), Course 5 (2022-12-15 - 80)...
-- 15	    Fr. Ileana Will	        7	        Course 7 (90)	    Course 1 (2022-12-15 - 60), Course 5 (2022-12-15 - 80)...


with unique_courses_cte as (
  SELECT
  student_id,
  count(distinct course_name) as num_courses
  FROM courses
  WHERE course_date between '2022-10-01' AND '2022-12-31'
  GROUP BY student_id
  ORDER BY student_id
)
,
course_w_max_cte as (
  SELECT
    student_id,
    highest_scored_course,
    score
  FROM (SELECT
    student_id,
    score,
    course_name,
     CONCAT(course_name, ' (', score :: text, ')') as highest_scored_course,
    course_date,
    RANK() OVER (PARTITION BY student_id ORDER BY score DESC, course_date DESC, course_name)
  FROM courses
  WHERE course_date between '2022-10-01' AND '2022-12-31'
  GROUP BY student_id, score, course_name, course_date) as ranking
  WHERE rank = 1
)
,
course_list_cte as (
  SELECT
  student_id,
  STRING_AGG(course_concat, ', ' ORDER BY course_date ASC, course_name ASC) as course_list
FROM (SELECT
    student_id,
    course_name,
    score,
    course_date,
    CONCAT(course_name, ' (', course_date, ' - ', score, ')') as course_concat
  FROM courses
  WHERE course_date between '2022-10-01' AND '2022-12-31'
  ORDER BY course_date, course_name) as concat
GROUP BY student_id
)
SELECT
  nc.student_id,
  s.name,
  nc.num_courses,
  hsc.highest_scored_course,
  cl.course_list
FROM students s
LEFT JOIN unique_courses_cte nc
ON s.id = nc.student_id
LEFT JOIN course_w_max_cte hsc
ON nc.student_id = hsc.student_id
LEFT JOIN course_list_cte cl
ON nc.student_id = cl.student_id
ORDER BY num_courses DESC, hsc.score DESC, nc.student_id
LIMIT 20