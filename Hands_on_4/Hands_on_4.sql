use college_db;

DESCRIBE students;
EXPLAIN FORMAT=JSON SELECT s.first_name,s.last_name,c.course_name FROM enrollments e JOIN students s ON s.student_id = e.student_id JOIN courses c ON c.course_id = e.course_id WHERE s.enrollment_year = 2022;
-- Before indexing:
-- students table uses Full Table Scan (type=ALL)
-- Rows examined:
-- students = 10 rows
-- enrollments = 15 rows
-- courses = 5 rows

/*TASK2*/
-- MySQL indexes are B-Tree by defaultpython 
CREATE INDEX idx_students_enrollment_year ON students(enrollment_year);
CREATE UNIQUE INDEX idx_enrollments_student_course ON enrollments(student_id, course_id);
-- If Duplicates records exists
SELECT student_id,course_id,COUNT(*) FROM enrollments GROUP BY student_id, course_id HAVING COUNT(*) > 1;
CREATE INDEX idx_course_code ON courses(course_code);
EXPLAIN FORMAT=JSON
SELECT s.first_name,s.last_name,c.course_name FROM enrollments e JOIN students s ON s.student_id = e.student_id JOIN courses c ON c.course_id = e.course_id WHERE s.enrollment_year = 2022;
-- MySQL does not support partial indexes.
-- Equivalent optimization can be achieved using a composite index.
CREATE INDEX idx_enrollment_grade ON enrollments(student_id, grade);

SELECT e.enrollment_id,
       s.first_name,
       s.last_name,
       e.course_id,
       e.grade
FROM enrollments e
JOIN students s
ON e.student_id = s.student_id;
DESCRIBE students;