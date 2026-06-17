CREATE DATABASE college_db;
use college_db;
CREATE TABLE departments (dept_id INT AUTO_INCREMENT PRIMARY KEY,dept_name VARCHAR(100) NOT NULL UNIQUE,hod_name VARCHAR(100) NOT NULL);
DESC departments;
CREATE TABLE students (student_id INT AUTO_INCREMENT PRIMARY KEY,student_name VARCHAR(100) NOT NULL,email VARCHAR(100) NOT NULL UNIQUE,dept_id INT NOT NULL,FOREIGN KEY (dept_id)
    REFERENCES departments(dept_id));
DESC students;
CREATE TABLE courses(course_id INT AUTO_INCREMENT PRIMARY KEY,course_name VARCHAR(100) NOT NULL,credits INT NOT NULL,dept_id INT NOT NULL,FOREIGN KEY (dept_id) REFERENCES departments(dept_id));
DESC courses;
CREATE TABLE enrollments(enrollment_id INT AUTO_INCREMENT PRIMARY KEY,student_id INT NOT NULL,course_id INT NOT NULL,grade CHAR(1),FOREIGN KEY (student_id) REFERENCES students(student_id),FOREIGN KEY (course_id) REFERENCES courses(course_id));
DESC enrollments;
CREATE TABLE professors(professor_id INT AUTO_INCREMENT PRIMARY KEY,professor_name VARCHAR(100) NOT NULL,dept_id INT NOT NULL,FOREIGN KEY (dept_id) REFERENCES departments(dept_id));
DESC professors;
-- 1NF:
-- Every column stores atomic values.
-- Example violation: storing multiple phone numbers
-- like '9876543210,9876543211' in one column.

-- 2NF:
-- Every non-key attribute depends on the full primary key.
-- In enrollments, grade depends on the combination
-- of student_id and course_id.

-- 3NF:
-- No transitive dependencies exist.
-- dept_name is stored only in departments.
-- Storing dept_name in students would create
-- student_id -> dept_id -> dept_name dependency.
ALTER TABLE students ADD phone_number VARCHAR(15);
DESC students;
ALTER TABLE courses ADD max_seats INT DEFAULT 60;
DESC courses;
ALTER TABLE enrollments ADD CONSTRAINT chk_grade CHECK(grade IN ('A','B','C','D','F') OR grade IS NULL);
ALTER TABLE departments RENAME COLUMN hod_name TO head_of_dept;
DESC departments;
ALTER TABLE students DROP COLUMN phone_number;
DESC students;
DESC departments;
DESC students;
DESC courses;
DESC enrollments;
DESC professors;
SHOW DATABASES;
SHOW TABLES;

