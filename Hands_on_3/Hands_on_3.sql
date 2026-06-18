use college_db;
/*TASK1*/
SELECT s.student_id,CONCAT(s.first_name,' ',s.last_name) AS student_name FROM students s JOIN enrollments e ON s.student_id = e.student_id GROUP BY s.student_id, student_name HAVING COUNT(*) >(SELECT AVG(course_count) FROM(SELECT COUNT(*) AS course_count FROM enrollments GROUP BY student_id) avg_table);
SELECT c.course_id,c.course_name FROM courses c WHERE NOT EXISTS(SELECT * FROM enrollments e WHERE e.course_id = c.course_id AND e.grade <> 'A');
DESCRIBE professors;
SHOW COLUMNS FROM professors;
SELECT p.professor_id,p.prof_name,p.department_id,p.salary FROM professors p WHERE p.salary=(SELECT MAX(p2.salary)FROM professors p2 WHERE p2.department_id = p.department_id);
SELECT * FROM(SELECT d.department_id,d.dept_name,AVG(p.salary) AS avg_salary FROM departments d JOIN professors p ON d.department_id = p.department_id GROUP BY d.department_id, d.dept_name) dept_avg WHERE avg_salary > 85000;

/*TASK2*/

CREATE VIEW vw_student_enrollment_summary AS
SELECT s.student_id,
CONCAT(s.first_name,' ',s.last_name) AS student_name,
    d.dept_name,
    COUNT(e.course_id) AS total_courses,
    AVG(
        CASE
            WHEN e.grade='A' THEN 4
            WHEN e.grade='B' THEN 3
            WHEN e.grade='C' THEN 2
            WHEN e.grade='D' THEN 1
            ELSE 0
        END
    ) AS GPA
FROM students s
JOIN departments d
ON s.department_id = d.department_id
LEFT JOIN enrollments e
ON s.student_id = e.student_id
GROUP BY s.student_id,
         student_name,
         d.dept_name;
         
CREATE VIEW vw_course_stats AS
SELECT
    c.course_name,
    c.course_code,
    COUNT(e.student_id) AS total_enrollments,
    AVG(
        CASE
            WHEN e.grade='A' THEN 4
            WHEN e.grade='B' THEN 3
            WHEN e.grade='C' THEN 2
            WHEN e.grade='D' THEN 1
            ELSE 0
        END
    ) AS avg_gpa
FROM courses c
LEFT JOIN enrollments e
ON c.course_id = e.course_id
GROUP BY c.course_id,
         c.course_name,
         c.course_code;
SELECT * FROM vw_student_enrollment_summary WHERE GPA > 3.0;
UPDATE vw_student_enrollment_summary SET GPA = 4 WHERE student_id = 1;
DROP VIEW IF EXISTS vw_student_enrollment_summary;
DROP VIEW IF EXISTS vw_course_stats;
CREATE VIEW vw_student_enrollment_summary AS SELECT student_id,first_name,last_name,department_id FROM students WHERE department_id = 1 WITH CHECK OPTION;
INSERT INTO vw_student_enrollment_summary VALUES(20,'Test','Student',1);
INSERT INTO vw_student_enrollment_summary VALUES (21,'Wrong','Dept',2);

/*TASK3*/

DELIMITER $$
CREATE PROCEDURE sp_enroll_student(
    IN p_student_id INT,
    IN p_course_id INT,
    IN p_enrollment_date DATE
)
BEGIN

    IF EXISTS
    (
        SELECT *
        FROM enrollments
        WHERE student_id = p_student_id
        AND course_id = p_course_id
    )
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Student already enrolled in this course';
    ELSE
        INSERT INTO enrollments(student_id,course_id,enrollment_date)VALUES(p_student_id,p_course_id,p_enrollment_date);
    END IF;
END $$ DELIMITER ;
SELECT * FROM enrollments WHERE student_id = 1 AND course_id = 2;
SELECT * FROM courses;
CALL sp_enroll_student(1,5,'2026-06-18');
CREATE TABLE department_transfer_log
(
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    old_department INT,
    new_department INT,
    transfer_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
DELIMITER $$

CREATE PROCEDURE sp_transfer_student
(
    IN p_student_id INT,
    IN p_new_department INT
)
BEGIN

    DECLARE v_old_department INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    SELECT department_id
    INTO v_old_department
    FROM students
    WHERE student_id = p_student_id;

    UPDATE students
    SET department_id = p_new_department
    WHERE student_id = p_student_id;

    INSERT INTO department_transfer_log
    (student_id,old_department,new_department)
    VALUES
    (p_student_id,v_old_department,p_new_department);
    COMMIT;
END $$
DELIMITER ;
CALL sp_transfer_student(1,2);
CALL sp_transfer_student(1,999);
SELECT * FROM students WHERE student_id = 1;
START TRANSACTION;

INSERT INTO enrollments(student_id, course_id, enrollment_date)VALUES (1,4,CURDATE());
SAVEPOINT first_insert;
INSERT INTO enrollments (student_id, course_id, enrollment_date)VALUES(999,5,CURDATE());
ROLLBACK TO first_insert;
COMMIT;
SELECT * FROM enrollments WHERE student_id = 1 AND course_id = 4;
SELECT * FROM enrollments WHERE student_id = 999;